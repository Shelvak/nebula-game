#!/usr/bin/env ruby
require File.expand_path(
  File.join(File.dirname(__FILE__), 'initializer.rb')
)

LOGGER.info "Starting server (argv: #{ARGV.inspect})..."

callback_manager = proc { CallbackManager.tick }

allowed_options = ["--no-policy-server", "-nps", "--only-policy-server",
  "-ops"]
ARGV.each do |arg|
  unless allowed_options.include?(arg)
    $stderr.write "Unknown option #{arg}!\nAllowed options: #{
      allowed_options.inspect}"
    exit
  end
end

LOGGER.info "Running EventMachine..."
EventMachine::run do
  stop_server = proc do
    LOGGER.info "Caught interrupt, shutting down..."
    EventMachine::stop_event_loop
  end
  trap("INT", &stop_server)
  trap("TERM", &stop_server)

  unless ARGV.include?("--no-policy-server") || ARGV.include?("-nps")
    LOGGER.info "Starting policy server..."
    EventMachine::start_server "0.0.0.0", 843, FlashPolicyServer
  end

  unless ARGV.include?("--only-policy-server") || ARGV.include?("-ops")
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
  if RUBY_PLATFORM =~ /mingw/
    puts "Server initialized."
    puts
    puts "Console is log closed for performance reasons."
    puts "Everything is logged to file."
  end
end

LOGGER.info "Server stopped."
