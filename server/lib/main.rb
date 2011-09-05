#!/usr/bin/env jruby
require File.expand_path(
  File.join(File.dirname(__FILE__), 'initializer.rb')
)

LOGGER.info "Starting server..."

if ENV["environment"] == "development"
  # Initialize IRB support for drop-in development console.
  require File.expand_path(File.join(ROOT_DIR, 'lib', 'server',
      'irb_session.rb'))
  root_binding = binding
  irb_running = false
  
  # This evil thing is needed because ctrl+c kills subprocesses too.
  # fucking lame.
  Thread.new {
    loop do
      if irb_running
        sleep 0.1
      else
        input = gets.strip
        irb_running = true if input == "con" || input == "cc"
      end
    end
  }
end

LOGGER.info "Running EventMachine..."
EventMachine::run do
  stop_server = proc do
    LOGGER.info "Caught interrupt, shutting down..."
    EventMachine::stop_event_loop
  end
  trap("INT", &stop_server)
  trap("TERM", &stop_server)

  # Initialize space mule.
  SpaceMule.instance

  LOGGER.info "Starting game server..."
  EventMachine::start_server "0.0.0.0", CONFIG['game']['port'], GameServer

  LOGGER.info "Starting control server..."
  EventMachine::start_server "0.0.0.0", CONFIG['control']['port'],
    ControlServer

  LOGGER.info "Starting callback manager..."
  EventMachine::PeriodicTimer.new(1) { CallbackManager.tick }

  if ENV["environment"] == "development"
    EventMachine::PeriodicTimer.new(0.1) do
      if irb_running
        puts "\n\nDropping into IRB shell. Server operation suspended."
        puts "Press CTRL+C to exit the shell.\n\n"
        old_handler = trap("INT") { throw :IRB_EXIT }
        
        IRB.start_session(root_binding)
        puts "\nIRB done. Server operation resumed.\n\n"
        irb_running = false
        trap("INT", &old_handler)
      end
    end
  end
  
  LOGGER.info "Running callback manager..."
  CallbackManager.tick(true)

  LOGGER.info "Server initialized."
  if RUBY_PLATFORM =~ /mingw/
    puts "Server initialized."
    puts
    puts "Console is log closed for performance reasons."
    puts "Everything is logged to file."
  end
end

LOGGER.info "Server stopped."
