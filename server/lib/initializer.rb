ROOT_DIR = File.expand_path(File.join(File.dirname(__FILE__), '..')) \
  unless defined?(ROOT_DIR)

Thread.current[:name] = "main"

class App
  SERVER_STATE_INITIALIZING = :initializing
  SERVER_STATE_RUNNING = :running
  SERVER_STATE_SHUTDOWNING = :shutdowning

  class << self
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
      @@server_state ||= SERVER_STATE_INITIALIZING
    end

    def server_state=(value)
      @@server_state = value
    end

    def server_initializing?; server_state == SERVER_STATE_INITIALIZING; end
    def server_running?; server_state == SERVER_STATE_RUNNING; end
    def server_shutdowning?; server_state == SERVER_STATE_SHUTDOWNING; end
  end
end

class Exception
  def to_log_str
    "Exception: %s (%s)\n\nBacktrace:\n%s" % [
      message, self.class.to_s, self.backtrace.try(:join, "\n") || "No backtrace"
    ]
  end
end

def rake?; File.basename($0) == 'rake'; end

require 'rubygems'
require 'bundler'

require "timeout"
require "socket"
require "erb"
require "pp"

setup_groups = [:default, :setup, :"#{App.env}_setup"]
setup_groups.push :run_setup unless App.in_test?
require_groups = [:default, :require, :"#{App.env}_require"]
require_groups.push :run_require unless App.in_test?

# We need to setup both groups, because bundler only does setup one time.
Bundler.setup(*(setup_groups | require_groups))
Bundler.require(*require_groups)

require 'active_support/dependencies'

# We don't need our #destroy, #save and #save! automatically wrapped under
# transaction because we wrap whole request in one and can't use nested
# transactions due to BulkSql.
module ActiveRecord::Transactions
  def destroy; super; end
  def save(*); super; end
  def save!(*); super; end
end

if RUBY_VERSION.to_f < 1.9
  $KCODE = 'u'
  Range.send(:alias_method, :cover?, :include?)
  class Integer
    alias :precisionless_round :round
    private :precisionless_round

    # Rounds the integer with the specified precision.
    #
    # x = 1233
    # x.round # => 1233
    # x.round(1) # => 1233
    # x.round(-1) # => 1230
    # x.round(-5) # => 0
    def round(precision = nil)
      if precision
        magnitude = 10 ** precision
        ((self * magnitude).round / magnitude).to_i
      else
        precisionless_round
      end
    end
  end

  class Complex
    def initialize
      raise "I'm not a real class! I just pretend to exist to give " +
              "an illusion of 1.9 compat!"
    end
  end
else
  # Unshift current directory for factory girl (ruby 1.9)
  $LOAD_PATH.unshift File.expand_path(ROOT_DIR) if App.in_test?
end

# Require plugins so all their functionality is present during
# initialization
Dir[File.join(ROOT_DIR, 'vendor', 'plugins', '*')].each do |plugin_dir|
  plugin = File.join(plugin_dir, 'init.rb')
  raise "Cannot find plugin initializer #{plugin.inspect}!" \
    unless File.exists?(plugin)
  require plugin
end

ENV['db_environment'] ||= App.env
ENV['configuration'] ||= App.env

# Set up Rails autoloader
(
  ["#{ROOT_DIR}/lib/server"] + Dir["#{ROOT_DIR}/lib/app/**"]
).each do |file_name|
  if File.directory?(file_name)
    ActiveSupport::Dependencies.autoload_paths <<
      File.expand_path(file_name)
  end
end

email_from = "server-#{Socket.gethostname}@nebula44.com"
email_to = 'arturas@nebula44.com'

MAILER = lambda do |short, long|
  lambda do |error|
    Mail.deliver do
      from email_from
      to email_to
      subject "[#{short}] #{error.split("\n")[0]}"
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
end

Logging::Writer.supervise_as :log_writer, log_writer_config.freeze
LOGGER = Logging::ThreadRouter.instance

def read_config(*path)
  filename = File.expand_path(File.join(*path))
  template = ERB.new(File.read(filename))
  contents = template.result(binding)
  YAML.load(contents)
rescue Exception => e
  STDERR.write "Error while reading config #{filename}!\n\n"
  STDERR.write "File contents: \n#{
    defined?(contents) ? contents : "not read yet"
  }"
  raise e
end

def load_config
  LOGGER.info "Loading configuration for '#{App.env}' environment..."

  # Load custom environment configuration file if it exists
  sets_dir = File.expand_path(File.join(CONFIG_DIR, 'sets'))

  # Merge server-level config
  CONFIG.merge!(read_config(CONFIG_DIR, 'application.yml'))

  Dir["#{sets_dir}/*"].each do |dir_name|
    set_name, fallback_name = File.basename(dir_name).split("-")

    CONFIG.add_set(set_name, fallback_name) \
      unless set_name == CONFIG.class::DEFAULT_SET
    CONFIG.merge!(read_config(dir_name, 'application.yml'), set_name)

    Dir[File.join(dir_name, 'sections', '**', '*.yml')].each do |file|
      section = File.basename(file, ".yml")

      #LOGGER.debug("Loading config section #{section.inspect} from #{
      #  file.inspect}")
      CONFIG.with_scope(section) do |config|
        contents = read_config(file)
        config.merge!(contents, set_name)
      end
    end

    # ENV config is great for overrides (i.e. in test)
    env_config_file = File.join(dir_name, "#{ENV['configuration']}.yml")
    env_config = File.exists?(env_config_file) \
      ? read_config(env_config_file) : {}
    
    if env_config.is_a?(Hash)
      CONFIG.merge!(env_config, set_name)
    elsif ! env_config.nil?
      $stderr.write(
        "Warning! Config file #{env_config_file} empty or unreadable.\n"
      )
    end
  end
end

# Set up config object
CONFIG_DIR = File.expand_path(File.join(ROOT_DIR, 'config'))
CONFIG = GameConfig.new
load_config

# Establish database connection
DB_CONFIG = read_config(CONFIG_DIR, 'database.yml')
DB_CONFIG.each { |env, config| config["adapter"] = "jdbcmysql" }
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
  ActiveRecord::Base.connection.execute "SET NAMES UTF8"

  unless App.in_test?
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

# Set up autoloader for troublesome classes.
#
# This fixes scenarios when there is Alliance and Combat::Alliance and
# referencing Combat::Alliance actually loads ::Alliance.
#
[
  "#{ROOT_DIR}/lib/server",
  "#{ROOT_DIR}/lib/app/classes",
  "#{ROOT_DIR}/lib/app/models",
  "#{ROOT_DIR}/lib/app/controllers",
].each do |dir|
  Dir["#{dir}/**/*.rb"].each do |filename|
    class_name = filename.sub(File.join(dir, ''), '').sub(
      '.rb', '').camelcase

    parts = class_name.split("::")
    base_module = parts[0..-2]

    # Don't register on Kernel, Rails autoloader handles those fine.
    unless base_module.blank?
      # Determine base module to register autoload on.
      base_module = base_module.join("::").constantize
      mod = parts[-1].to_sym

      base_module.autoload mod, filename
    end
  end
end

ActiveRecord::Base.include_root_in_json = false
ActiveRecord::Base.store_full_sti_class = false
ActiveRecord::Base.logger = LOGGER

class ActiveRecord::Relation
  # Add c_select_* methods.
  #
  # Usage:
  #   planet_ids = SsObject::Planet.where(:player_id => player).
  #     select("id").c_select_values
  %w{all one rows value values}.each do |method|
    define_method(:"c_select_#{method}") do
      connection.send(:"select_#{method}", to_sql)
    end
  end
end

ActiveSupport::JSON.backend = 'JSONGem'
ActiveSupport.use_standard_json_time_format = true
ActiveSupport::LogSubscriber.colorize_logging = false

# Extract some constants
ROUNDING_PRECISION = CONFIG['buildings.resources.rounding_precision']

# Finally load config generation initializers.
initializers_dir = File.join(ROOT_DIR, 'config', 'initializers')
raise "#{initializers_dir} must be a directory!" \
  unless File.directory?(initializers_dir)

Dir[File.join(initializers_dir, '*.rb')].each { |file| require file }

# Initialize event handlers
QUEST_EVENT_HANDLER = QuestEventHandler.new

# Load SpaceMule.
lambda do
  jar_path = File.join(ROOT_DIR, 'vendor', 'SpaceMule', 'dist', 'SpaceMule.jar')

  # Win32 requires us to manually require all the jars before requiring
  # main jar.
  Dir[File.dirname(jar_path) + "/lib/*.jar"].each { |jar| require jar }
  require jar_path

  # Scala <-> Ruby interoperability.
  class Object
    # TODO: upon upgrade to 1.6.6 replace $plus and $plus$eq to + and +=
    def to_scala
      case self
      when Hash
        scala_hash = Java::scala.collection.immutable.HashMap.new
        each do |key, value|
          scala_hash = scala_hash.updated(key.to_scala, value.to_scala)
        end
        scala_hash
      when Set
        scala_set = Java::scala.collection.immutable.HashSet.new
        each { |item| scala_set = scala_set.send(:"$plus", item.to_scala) }
        scala_set
      when Array
        scala_array = Java::scala.collection.mutable.ArrayBuffer.new
        each { |value| scala_array.send(:"$plus$eq", value.to_scala) }
        scala_array.to_indexed_seq
      when Symbol
        to_s
      else
        self
      end
    end

    def from_scala
      case self
      when Java::scala.collection.Map, Java::scala.collection.immutable.Map,
          Java::scala.collection.mutable.Map
        ruby_hash = {}
        foreach { |tuple| ruby_hash[tuple._1.from_scala] = tuple._2.from_scala }
        ruby_hash
      when Java::scala.collection.Set, Java::scala.collection.immutable.Set,
          Java::scala.collection.mutable.Set
        ruby_set = Set.new
        foreach { |item| ruby_set.add item.from_scala }
        ruby_set
      when Java::scala.collection.Seq
        ruby_array = []
        foreach { |item| ruby_array.push item.from_scala }
        ruby_array
      when Java::scala.Product
        if self.class.to_s.match /Tuple\d+$/
          # Conversion from scala Tuples.
          ruby_array = []
          productIterator.foreach { |item| ruby_array.push item.from_scala }
          ruby_array
        else
          self
        end
      else
        self
      end
    end
  end

  module Kernel
    def Some(value); Java::scala.Some.new(value); end
    None = Java::spacemule.helpers.JRuby.None
  end

  SpaceMule.instance
end.call