require 'rubygems'
require 'socket'
require 'yaml'
require 'json'
require File.dirname(__FILE__) +
  "/../../vendor/plugins/game_server_connector/init.rb"
require 'logger'
require 'stringio'
# Control client for usage in scripts.
class ControlClient
  class ConnectionError < RuntimeError; end
  
  CONFIG_FILE = File.join(File.dirname(__FILE__), '..', '..', 'config',
    'application.yml')
  CONFIG = YAML.load(File.read(CONFIG_FILE))
  
  def initialize
    logger = Logger.new(STDERR)
    logger.level = Logger::WARN
    @connection = GameServerConnector.new(
      logger, "127.0.0.1", CONFIG['server']['port'],
      CONFIG['control']['token']
    )
  end
  
  def message(action, params={})
    @connection.request(action, params)
  rescue GameServerConnector::RemoteError => e
    raise ConnectionError, e
  end
end
