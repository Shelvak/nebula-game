#!/usr/bin/env ruby
require File.expand_path(
  File.join(File.dirname(__FILE__), 'initializer.rb')
)

LOGGER.info "Starting server..."

callback_manager = proc { CallbackManager.tick }

irb_loaded = false
unless ENV["environment"] == "production" || defined?(DAEMONIZED)
  # Initialize IRB support for drop-in development console.
  require File.expand_path(File.join(ROOT_DIR, 'lib', 'server',
      'irb_session.rb'))
  root_binding = binding
  irb_running = false
  irb_loaded = true
end

LOGGER.info "Running EventMachine..."
EventMachine::run do
  stop_server = proc do
    LOGGER.info "Caught interrupt, shutting down..."
    EventMachine::stop_event_loop
  end
  trap("INT") do
    if ! irb_loaded
      stop_server.call
    else
      unless irb_running
        irb_running = true
        puts "\n\nDropping into IRB shell. Server operation suspended."
        puts "Press CTRL+C again to stop the server.\n\n"
        IRB.start_session(root_binding)
        puts "\nIRB done. Server operation resumed.\n\n"
        irb_running = false
      else
        puts "\n\n"
        stop_server.call
        throw :IRB_EXIT
      end
    end
  end
  trap("TERM", &stop_server)

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

  LOGGER.info "Server initialized."
  if RUBY_PLATFORM =~ /mingw/
    puts "Server initialized."
    puts
    puts "Console is log closed for performance reasons."
    puts "Everything is logged to file."
  end

#  if defined?(DAEMONIZED)
#    # Close standard IO because otherwise net/ssh hangs forever on server
#    # startup waiting for some mystical thing when deploying via rake
#    # tasks.
#    STDIN.close
#    STDOUT.close
#    STDERR.close
#  end
end

LOGGER.info "Server stopped."
