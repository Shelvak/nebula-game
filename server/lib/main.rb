#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), 'initializer.rb')

LOGGER.info "Starting server (argv: #{ARGV.inspect})..."

callback_manager = proc do
  time = Benchmark.realtime { CallbackManager.tick }
  if time > 0.5
    LOGGER.warn "CallbackManager took more than 0.5 second! (%4.3f)" % time
  end
end

allowed_options = ["--no-policy-server", "--only-policy-server"]
ARGV.each do |arg|
  unless allowed_options.include?(arg)
    $stderr.write "Unknown option #{arg}!\nAllowed options: #{
      allowed_options.inspect}"
    exit
  end
end

LOGGER.info "Running EventMachine..."
EventMachine::run do
  unless ARGV.include?("--no-policy-server")
    LOGGER.info "Starting policy server..."
    EventMachine::start_server "0.0.0.0", 843, FlashPolicyServer
  end

  unless ARGV.include?("--only-policy-server")
    # Initialize space mule.
    SpaceMule.instance

    LOGGER.info "Starting game server..."
    EventMachine::start_server "0.0.0.0", CONFIG['game']['port'], GameServer

    LOGGER.info "Starting control server..."
    EventMachine::start_server "0.0.0.0", CONFIG['control']['port'],
      ControlServer

    LOGGER.info "Starting callback manager..."
    EventMachine::PeriodicTimer.new(1, &callback_manager)

    LOGGER.info "Running callback manager..."
    callback_manager.call
  end

  LOGGER.info "Server initialized."
end
