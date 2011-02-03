$KCODE = 'u' # UTF8 support
ROOT_DIR = File.expand_path(File.join(File.dirname(__FILE__), '..')) \
  unless defined?(ROOT_DIR)

# Unshift current directory for factory girl (ruby 1.9)
$LOAD_PATH.unshift File.expand_path(ROOT_DIR) \
  if RUBY_VERSION.include?("1.9")

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
require 'benchmark'

# Require plugins so all their functionality is present during
# initialization
Dir[File.join(ROOT_DIR, 'vendor', 'plugins', '*', 'init.rb')].each do |file|
  require file
end

require 'yaml'
ENV['environment'] ||= 'development'
ENV['db_environment'] ||= ENV['environment']
ENV['configuration'] ||= ENV['environment']

# Set up Rails autoloader
(
  ["#{ROOT_DIR}/lib/server"] +
  Dir["#{ROOT_DIR}/lib/app/**"]
).each do |file_name|
  if File.directory?(file_name)
    ActiveSupport::Dependencies.autoload_paths << File.expand_path(file_name)
  end
end

LOGGER = GameLogger.new(
  File.new(
    File.expand_path(
      File.join(ROOT_DIR, 'log', "#{ENV['environment']}.log")
    ),
    'a'
  )
)
LOGGER.level = GameLogger::LEVEL_INFO
require File.join(ROOT_DIR, 'config', 'environments', ENV['environment'])
LOGGER.info "Initializing in '#{ENV['environment']}' environment..."

# Set up config object
CONFIG = GameConfig.new

def read_config(*path)
  template = ERB.new(File.read(File.expand_path(File.join(*path))))
  YAML.load(template.result(binding))
end

# Load custom environment configuration file if it exists
config_dir = File.expand_path(File.join(File.dirname(__FILE__), '..',
    'config'))
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

def rake?
  File.basename($0) == 'rake'
end

# Establish database connection
DB_CONFIG = read_config(config_dir, 'database.yml')
USED_DB_CONFIG = DB_CONFIG[ENV['db_environment']]

if USED_DB_CONFIG.nil?
  puts "Unable to retrieve db configuration!"
  puts "  DB environment: #{ENV['db_environment'].inspect}"
  puts "  Config: #{DB_CONFIG.inspect}"
  exit
end

unless rake?
  ActiveRecord::Base.establish_connection(USED_DB_CONFIG)
  ActiveRecord::Base.connection.execute "SET NAMES UTF8"
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

class ActiveRecord::Migration
  def self.add_fk(target_table, source_table, type="CASCADE")
    ActiveRecord::Base.connection.execute "ALTER TABLE `#{
      source_table}` ADD FOREIGN KEY (`#{
      target_table.to_s.singularize}_id`) REFERENCES `#{
      target_table}` (`id`) ON DELETE #{type}"
  end
end

ActiveSupport::JSON.backend = 'JSONGem'
ActiveSupport.use_standard_json_time_format = true
ActiveSupport::LogSubscriber.colorize_logging = false

# Preloader - for traits to function correctly buildings ant units must be
# preloaded
#
# This must be ran after config
Dir[
  File.join(ROOT_DIR, 'lib', 'app', 'models', '{building,unit}', '*.rb')
].each { |file| require file }

# Extract some constants
ROUNDING_PRECISION = CONFIG['buildings.resources.rounding_precision']

# Finally load config generation initializers.
initializers_dir = File.join(ROOT_DIR, 'config', 'initializers')
raise "#{initializers_dir} must be a directory!" \
  unless File.directory?(initializers_dir)

Dir[File.join(initializers_dir, '*.rb')].each { |file| require file }

# Initialize event handlers
QUEST_EVENT_HANDLER = QuestEventHandler.new

# Reload all files, useful in console mode.
def reload!
  # To stop complaining about defined constants.
  silence_warnings do
    ActiveSupport::Dependencies.autoload_paths.each do |dir|
      Dir["#{dir}/**/*.rb"].each do |file|
        load file
      end
    end
  end
  true
end