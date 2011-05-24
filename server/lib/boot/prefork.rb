ROOT_DIR = File.expand_path(File.join(File.dirname(__FILE__), '..', '..')) \
  unless defined?(ROOT_DIR)

# Unshift current directory for factory girl (ruby 1.9)
$LOAD_PATH.unshift File.expand_path(ROOT_DIR) \
  if RUBY_VERSION.include?("1.9")

def rake?; File.basename($0) == 'rake'; end

benchmark :gems do
  require 'rubygems'
  require File.join(ROOT_DIR, 'lib', 'gem_config.rb')

  REQUIRED_GEMS.each do |gem|
    gem = {:name => gem} unless gem.is_a?(Hash)
    unless gem[:skip]
      gem_name = gem[:lib].nil? ? gem[:name] : gem[:lib]
      gem gem[:name], gem[:version] if gem[:version]
      require gem_name
    end
  end

  require 'timeout'
  require 'socket'
  require 'erb'
  require 'pp'
end

# Require plugins so all their functionality is present during
# initialization
benchmark :plugins do
  Dir[File.join(ROOT_DIR, 'vendor', 'plugins', '*', 'init.rb')].each do |file|
    require file
  end
end

ENV['environment'] ||= 'development'
ENV['db_environment'] ||= ENV['environment']
ENV['configuration'] ||= ENV['environment']

# Set up Rails autoloader
benchmark :autoloader do
  (
    ["#{ROOT_DIR}/lib/server"] + Dir["#{ROOT_DIR}/lib/app/**"]
  ).each do |file_name|
    if File.directory?(file_name)
      ActiveSupport::Dependencies.autoload_paths << File.expand_path(file_name)
    end
  end
end

benchmark :logger do
  LOGGER = GameLogger.new(
    File.expand_path(
      File.join(ROOT_DIR, 'log', "#{ENV['environment']}.log")
    )
  )
  LOGGER.level = GameLogger::LEVEL_INFO
  # Error reporting by mail.
  if ENV['environment'] == 'production'
    LOGGER.on_fatal = lambda do |fatal|
      begin
        Mail.deliver do
          from 'server@nebula44.com'
          to 'arturas@nebula44.com'
          subject "[FATAL] #{fatal.split("\n")[0]}"
          body "Server has encountered an FATAL error!\n\n#{fatal}"
        end
      rescue Errno::ENETUNREACH
        # Well, what can we do...
      end
    end
    LOGGER.on_error = lambda do |error|
      begin
        Mail.deliver do
          from 'server@nebula44.com'
          to 'arturas@nebula44.com'
          subject "[ERROR] #{error.split("\n")[0]}"
          body "Server has encountered an error!\n\n#{error}"
        end
      rescue Errno::ENETUNREACH
        # Well, what can we do...
      end
    end
    LOGGER.on_warn = lambda do |warn|
      begin
        Mail.deliver do
          from 'server@nebula44.com'
          to 'arturas@nebula44.com'
          subject "[WARN] #{warn.split("\n")[0]}"
          body "Server has issued a warning!\n\n#{warn}"
        end
      rescue Errno::ENETUNREACH
        # Well, what can we do...
      end
    end
  end
end

benchmark :signals do
  begin
    trap("HUP") do
      LOGGER.info "Got HUP, reopening log outputs."
      LOGGER.reopen!
    end
  rescue ArgumentError
    LOGGER.warn "HUP signal not supported, no way to reopen log outputs!"
  end
end

config_dir = nil
benchmark :game_config do
  require File.join(ROOT_DIR, 'config', 'environments', ENV['environment'])
  LOGGER.info "Initializing in '#{ENV['environment']}' environment..."

  # Set up config object
  CONFIG = GameConfig.new

  def read_config(*path)
    template = ERB.new(File.read(File.expand_path(File.join(*path))))
    YAML.load(template.result(binding))
  end

  # Load custom environment configuration file if it exists
  config_dir = File.expand_path(File.join(ROOT_DIR, 'config'))
  sets_dir = File.expand_path(File.join(config_dir, 'sets'))

  # Merge server-level config
  CONFIG.merge!(read_config(config_dir, 'application.yml'))

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
        config.merge!(read_config(file), set_name)
      end
    end

    # ENV config is great for overrides (i.e. in test)
    env_config_file = File.join(dir_name, "#{ENV['configuration']}.yml")
    env_config = File.exists?(env_config_file) ? read_config(env_config_file) : {}
    if env_config.is_a?(Hash)
      CONFIG.merge!(env_config, set_name)
    elsif ! env_config.nil?
      $stderr.write(
        "Warning! Config file #{env_config_file} empty or unreadable.\n"
      )
    end
  end
end

benchmark :db do
  # Establish database connection
  DB_CONFIG = read_config(config_dir, 'database.yml')
  DB_CONFIG.each do |env, config|
    config["adapter"] = RUBY_PLATFORM == "java" ? "jdbcmysql" : "mysql2"
  end
  USED_DB_CONFIG = DB_CONFIG[ENV['db_environment']]

  if USED_DB_CONFIG.nil?
    puts "Unable to retrieve db configuration!"
    puts "  DB environment: #{ENV['db_environment'].inspect}"
    puts "  Config: #{DB_CONFIG.inspect}"
    exit
  end
end

# Set up autoloader for troublesome classes.
#
# This fixes scenarios when there is Alliance and Combat::Alliance and
# referencing Combat::Alliance actually loads ::Alliance.
#
benchmark :autoloader_files do
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
end

benchmark :activerecord_config do
  ActiveRecord::Base.include_root_in_json = false
  ActiveRecord::Base.store_full_sti_class = false
  ActiveRecord::Base.logger = LOGGER

  class ActiveRecord::Migration
    def self.add_fk(source_table, target_table, type=nil,
        source_key=nil, target_key=nil)
      type ||= "CASCADE"
      source_key ||= "id"
      target_key ||= "#{source_table.to_s.singularize}_id"
      puts "-- FK #{source_table}[#{source_key}] -> #{target_table}[#{
        target_key}] (#{type})"
      ActiveRecord::Base.connection.execute "ALTER TABLE `#{
        target_table}` ADD FOREIGN KEY (`#{target_key}`) REFERENCES `#{
        source_table}` (`#{source_key}`) ON DELETE #{type}"
    end
  end

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
end

# Extract some constants
ROUNDING_PRECISION = CONFIG['buildings.resources.rounding_precision']

# Finally load config generation initializers.
benchmark :config_initializers do
  initializers_dir = File.join(ROOT_DIR, 'config', 'initializers')
  raise "#{initializers_dir} must be a directory!" \
    unless File.directory?(initializers_dir)

  Dir[File.join(initializers_dir, '*.rb')].each { |file| require file }
end

# Initialize event handlers
benchmark :event_handlers do
  QUEST_EVENT_HANDLER = QuestEventHandler.new
end