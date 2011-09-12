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
    begin
      @socket = TCPSocket.open("127.0.0.1", CONFIG['control']['port'])
    rescue Errno::ECONNREFUSED, Errno::ECONNRESET
      raise ConnectionError
    end
  end
  
  def message(action, params={})
    message = JSON.generate(params.merge(
      :token => CONFIG['control']['token'],
      :action => action
    ))
    @socket.write message
    JSON.parse(@socket.gets)
  end
end