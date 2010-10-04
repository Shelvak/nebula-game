#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), 'initializer.rb')

LOGGER.info "Starting server..."

callback_manager = proc do
  time = Benchmark.realtime { CallbackManager.tick }
  if time > 0.5
    LOGGER.warn "CallbackManager took more than 0.5 second! (%4.3f)" % time
  end
end

EventMachine::run {
  unless ARGV.include?("--no-policy-server")
    EventMachine::start_server "0.0.0.0", 843, FlashPolicyServer
  end

  unless ARGV.include?("--only-policy-server")
    EventMachine::start_server "0.0.0.0", CONFIG['game']['port'], GameServer
    EventMachine::start_server "0.0.0.0", CONFIG['control']['port'],
      ControlServer

    EventMachine::PeriodicTimer.new(1, &callback_manager)
    callback_manager.call
  end

  LOGGER.info "Server initialized."
}
