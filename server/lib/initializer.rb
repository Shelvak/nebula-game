ROOT_DIR = File.expand_path(File.join(File.dirname(__FILE__), '..')) \
  unless defined?(ROOT_DIR)

def rake?; File.basename($0) == 'rake'; end

require 'time'

# Do JRuby version check.
lambda do
  ruby_version = '1.9.2'
  jruby_version = '1.6.8'
  if RUBY_VERSION < ruby_version || JRUBY_VERSION < jruby_version
    w = 80
    puts "#" * w
    puts "We require JRuby #{jruby_version} in 1.9 mode!".center(w)
    puts
    puts "To install JRuby #{jruby_version}:".center(w)
    puts "`rbenv install jruby-#{jruby-version}`".center(w)
    puts
    puts "To trigger it into 1.9 mode, add this to your `~/.bashrc`:".center(w)
    puts "`export JRUBY_OPTS='--1.9'`".center(w)
    puts
    puts "Aborting!".center(w)
    puts "#" * w
    exit 1
  end
end.call

require 'bundler'

require "timeout"
require "tempfile"
require "socket"
require "erb"
require "pp"
require "thread"

# Load Scala support.
lambda do
  jar_path = File.join(ROOT_DIR, 'vendor', 'SpaceMule', 'dist', 'SpaceMule.jar')

  # Win32 requires us to manually require all the jars before requiring
  # main jar.
  Dir[File.dirname(jar_path) + "/lib/*.jar"].each { |jar| require jar }
  require jar_path
end.call

class App
  SERVER_STATE_INITIALIZING = :initializing
  SERVER_STATE_RUNNING = :running
  SERVER_STATE_SHUTDOWNING = :shutdowning

  class << self
    @@mutex = Mutex.new

    def env
      @@environment ||= ENV['environment'] || 'development'
    end

    def env=(value)
      @@environment = value
    end

    def in_production?; env == 'production'; end
    def in_development?; env == 'development'; end
    def in_test?; env == 'test'; end

    def server_state
      synchronized { @@server_state ||= SERVER_STATE_INITIALIZING }
    end

    def server_state=(value)
      synchronized { @@server_state = value }
    end

    def server_initializing?; server_state == SERVER_STATE_INITIALIZING; end
    def server_running?; server_state == SERVER_STATE_RUNNING; end
    def server_shutdowning?; server_state == SERVER_STATE_SHUTDOWNING; end

    private
    def synchronized
      @@mutex.synchronize { yield }
    end
  end
end

class Exception
  def self.to_log_str(exception)
    "Exception: %s (%s)\n\nBacktrace:\n%s" % [
      exception.message, exception.class.to_s,
      exception.backtrace.try(:join, "\n") || "No backtrace"
    ]
  end
end

# Create a string with local variables and message.
def dump_environment(binding, message)
  vars = binding.eval %Q{
    (local_variables + instance_variables).map do |var_name|
      [var_name, eval(var_name.to_s)]
    end
  }, __FILE__, __LINE__

  message += "\n\nVariables:\n"
  vars.each do |var_name, value|
    message += "  #{var_name.inspect} => #{value.inspect}\n"
  end

  message
end

setup_groups = [:default, :setup, :"#{App.env}_setup"]
setup_groups.push :run_setup unless App.in_test?
require_groups = [:default, :require, :"#{App.env}_require"]
require_groups.push :run_require unless App.in_test?

# We need to setup both groups, because bundler only does setup one time.
Bundler.setup(*(setup_groups | require_groups))
Bundler.require(*require_groups)

require 'active_support/dependencies'
require "#{ROOT_DIR}/lib/server/monkey_squad"

# Unshift current directory for factory girl (ruby 1.9)
$LOAD_PATH.unshift File.expand_path(ROOT_DIR) if App.in_test?

# Require plugins so all their functionality is present during
# initialization
Dir[File.join(ROOT_DIR, 'vendor', 'plugins', '*')].each do |plugin_dir|
  plugin = File.join(plugin_dir, 'init.rb')
  raise "Cannot find plugin initializer #{plugin.inspect}!" \
    unless File.exists?(plugin)
  require plugin
end

# Dispatcher directors.
DIRECTORS = {
  chat: 1,     # Not much to do, one worker is enough.
  enroll: 1,   # Sequential, otherwise db locks kick in.
  control: 1,  # For control tasks that should be responsive even if other
               # workers are busy.
  world: 6,    # Main workhorse, not too concurrent because of DB locks.
  low_prio: 3, # For low priority tasks, such as cleaning up old notifications
               # or combat logs.
  # Highly IO-bound, so can be very concurrent.
  login: App.in_development? ? 1 : 20,
}
# Connections:
# - callback manager
# - pooler
# - workers
DB_POOL_SIZE = DIRECTORS.values.sum + 2

ENV['db_environment'] ||= App.env
ENV['configuration'] ||= App.env

email_from = "server-#{Socket.gethostname}@nebula44.com"
email_to = 'arturas@nebula44.com'

MAILER = lambda do |short, long|
  lambda do |error|
    Mail.deliver do
      from email_from
      to email_to
      subject = error.split("\n")[0]
      subject = "#{subject[0..120]}..." if subject.length > 120
      subject "[#{short}] #{subject}"
      body "#{long}\n\n#{error}"
    end
  end
end

require "#{ROOT_DIR}/lib/server/logging.rb"
log_writer_config = Logging::Writer::Config.new(:info)
log_writer_config.outputs << File.new(
  File.expand_path(File.join(ROOT_DIR, 'log', "#{App.env}.log")),
  'a'
)
# Need to eval to pass local variables to loaded file.
eval(
  File.read(File.join(ROOT_DIR, 'config', 'environments', App.env + ".rb")),
  binding
)

# Error reporting by mail.
if App.in_production?
  Mail.defaults do
    # -i means ".\n" does not terminate mail.
    # -t is skipped because it fucks up delivery on some MTAs
    delivery_method :sendmail, :arguments => "-i"
  end
  log_writer_config.callbacks[:fatal] = MAILER[
    "FATAL", "Server has encountered a FATAL error!"
  ]
  log_writer_config.callbacks[:error] = MAILER[
    "ERROR", "Server has encountered an error!"
  ]
  log_writer_config.callbacks[:warn] = MAILER[
    "WARN", "Server has issued a warning!"
  ]
else
  # Quit on failure in development mode.
  handler = proc do |arg|
    STDERR.puts "ERROR HANDLER STRUCK:"
    STDERR.puts arg
    if App.server_state == App::SERVER_STATE_RUNNING
      App.server_state = App::SERVER_STATE_SHUTDOWNING
    end
  end

  log_writer_config.callbacks[:fatal] =
    log_writer_config.callbacks[:error] =
      handler

  Celluloid.exception_handler(&handler)
end

Logging::Writer.instance.config = log_writer_config
LOGGER = Logging::ThreadRouter.instance
ActiveRecord::Base.logger = LOGGER
ActiveSupport::LogSubscriber.colorize_logging = false
Celluloid.logger = LOGGER
Java::spacemule.logging.Log.logger = Logging::Scala.new(LOGGER)

# Set up config object
require "#{ROOT_DIR}/lib/app/classes/game_config.rb"
config_dir = File.expand_path(File.join(ROOT_DIR, 'config'))
global_config = GameConfig.new
global_config.setup!(config_dir, File.join(ROOT_DIR, 'run'))
CONFIG = GameConfig::ThreadRouter.new(global_config)
require "#{ROOT_DIR}/lib/app/classes/cfg.rb"

# Establish database connection
DB_CONFIG = GameConfig.read_file(config_dir, 'database.yml')
DB_CONFIG.each do |env, config|
  config["adapter"] = "jdbcmysql"
  config["pool"] = DB_POOL_SIZE
  config["encoding"] = "utf8"
end
USED_DB_CONFIG = DB_CONFIG[ENV['db_environment']]
DB_MIGRATIONS_DIR = File.expand_path(
  File.dirname(__FILE__) + '/../db/migrate'
)

if USED_DB_CONFIG.nil?
  puts "Unable to retrieve db configuration!"
  puts "  DB environment: #{ENV['db_environment'].inspect}"
  puts "  Config: #{DB_CONFIG.inspect}"
  exit
end

# Establish connection before setting up autoloader, because some plugins depend
# on working DB connection.
unless rake?
  ActiveRecord::Base.establish_connection(USED_DB_CONFIG)
  require 'jruby/synchronized'
  ActiveRecord::Base.connection_pool.extend JRuby::Synchronized

  unless App.in_test?
    ActiveRecord::Base.connection_pool.with_new_connection do
      migrator = ActiveRecord::Migrator.new(:up, DB_MIGRATIONS_DIR)
      pending = migrator.pending_migrations
      unless pending.blank?
        puts "You still have pending migrations!"
        puts
        pending.each do |migration|
          puts " * #{migration.name}"
        end
        puts
        puts "Please run `rake db:migrate` before you proceed."
        puts
        exit 1
      end
    end
  end
end

# Set up autoloader.
#
# This fixes scenarios when there is Alliance and Combat::Alliance and
# referencing Combat::Alliance actually loads ::Alliance.
#
APP_MODULES = [] # This is used for preloading.
LOGGER.block("Setting up autoload") do
  # First register base classes for autoload. Then go deeper.
  [
    "#{ROOT_DIR}/lib/server",
    "#{ROOT_DIR}/lib/app/classes",
    "#{ROOT_DIR}/lib/app/models",
    "#{ROOT_DIR}/lib/app/controllers",
  ].flat_map do |dir|
    Dir["#{dir}/**/*.rb"].map do |filename|
      class_name = filename.
        sub(File.join(dir, ''), '').
        sub(/\.rb$/, '').
        camelcase

      parts = class_name.split("::")

      [class_name, parts, filename]
    end
  end.sort do |(a_cn, a_p, a_fn), (b_cn, b_p, b_fn)|
    # Sort by nesting (increasing) to make sure parents are registered before
    # children.
    [a_p.size, a_cn] <=> [b_p.size, b_cn]
  end.each do |class_name, parts, filename|
    base_module = parts[0..-2]
    mod = parts[-1].to_sym

    if base_module.blank?
      #puts "Autoloading #{mod} -> #{filename}"
      autoload mod, filename
    else
      # Determine base module to register autoload on.
      base_module = base_module.join("::")
      #puts "Autoloading on #{base_module} #{mod} -> #{filename}"
      base_module.constantize.autoload mod, filename
    end

    APP_MODULES << filename
  end
end

ActiveRecord::Base.include_root_in_json = false
ActiveRecord::Base.store_full_sti_class = false

class ActiveRecord::Relation
  # Add c_select_* methods.
  #
  # Usage:
  #   planet_ids = SsObject::Planet.where(:player_id => player).
  #     select("id").c_select_values
  %w{all rows values}.each do |method|
    define_method(:"c_select_#{method}") do
      connection.send(:"select_#{method}", to_sql)
    end
  end
  %w{one value}.each do |method|
    define_method(:"c_select_#{method}") do
      sql = (limit_value.nil? ? limit(1) : self).to_sql
      connection.send(:"select_#{method}", sql)
    end
  end
end

ActiveSupport::JSON.backend = :json_gem
ActiveSupport.use_standard_json_time_format = true

LOGGER.info "Creating dispatcher."
Celluloid::Actor[:dispatcher] = Dispatcher.new

# Initialize event handlers
LOGGER.info "Creating quest event handler."
QUEST_EVENT_HANDLER = QuestEventHandler.new
LOGGER.info "Creating dispatcher event handler."
DISPATCHER_EVENT_HANDLER = DispatcherEventHandler.new

# Used for hotfix evaluation and IRB sessions.
ROOT_BINDING = binding
