# Use development database
ENV['db_environment'] = 'development'
require File.dirname(__FILE__) + "/development.rb"

LOGGER.level = GameLogger::LEVEL_INFO
