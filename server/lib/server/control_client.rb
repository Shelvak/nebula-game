require 'rubygems'
require 'socket'
require 'yaml'
require 'json'

# Control client for usage in scripts.
class ControlClient
  class ConnectionError < RuntimeError; end
  
  CONFIG_FILE = File.join(File.dirname(__FILE__), '..', '..', 'config',
    'application.yml')
  CONFIG = YAML.load(File.read(CONFIG_FILE))
  
  def initialize
    @connection = GameServerConnector.new(
      Logger.new(stderr), "127.0.0.1",
      CONFIG['control']['port'],
      CONFIG['control']['token']
    )
  end
  
  def message(action, params={})
    @connection.request(action, params)
  rescue GameServerConnector::RemoteError => e
    raise ConnectionError, e
  end
end