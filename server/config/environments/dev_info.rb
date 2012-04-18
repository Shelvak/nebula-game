# Use development database
ENV['db_environment'] = 'development'
require File.dirname(__FILE__) + "/development.rb"

log_writer_config.level = :info
