#!/usr/bin/env jruby
require File.expand_path(
  File.join(File.dirname(__FILE__), 'initializer.rb')
)

LOGGER.info "Starting server..."

# Initialize IRB support for drop-in development console.
require File.expand_path(
  File.join(ROOT_DIR, 'lib', 'server', 'irb_session.rb')
) if App.in_development?

# Preload all classes - require/autoload in threaded environment is fucked up.
# Class can be used even before it is fully loaded.

LOGGER.block("Preloading all code") do
  APP_MODULES.each { |filename| require(filename) }
end

# Initialize space mule.
LOGGER.info "Initializing SpaceMule."
SpaceMule.instance

# Ensure server and callback manager are restarted if they crash.
#LOGGER.info "Starting server actor..."
#Celluloid::Actor[:server] = ServerActor.new(CONFIG['server']['port'])

LOGGER.info "Starting pooler actor..."
Celluloid::Actor[:pooler] = Pooler.new

LOGGER.info "Starting callback manager actor..."
Celluloid::Actor[:callback_manager] = CallbackManager.new

# Set up signals.
stop_server = proc do
  LOGGER.info "Caught interrupt, shutting down..."
  App.server_state = App::SERVER_STATE_SHUTDOWNING
end
trap("INT", &stop_server)
trap("TERM", &stop_server)

if App.in_development?
  # Console drop-out thread.
  Thread.new do
    loop do
      if $IRB_RUNNING
        sleep 1
      else
        input = gets.chomp
        case input
        when "cc"
          puts "\n\nDropping into IRB shell. Server operation suspended."
          puts "Press CTRL+C again to exit the server.\n\n"

          puts "Pausing callback manager..."
          Celluloid::Actor[:callback_manager].pause
          puts "Starting IRB session..."
          IRB.start_session(ROOT_BINDING)
          puts "\nIRB done. Server operation resumed.\n\n"
        end
      end
    end
  end
end

## Sleep forever while other threads do the dirty work.
#App.server_state = App::SERVER_STATE_RUNNING
#LOGGER.info "Server initialized."
#sleep 1 until (
#  # Normal server shutdown.
#  App.server_state == App::SERVER_STATE_SHUTDOWNING ||
#  # Server crashed.
#  ! Celluloid::Actor[:server].alive?
#)

LOGGER.info "Starting EventMachine."
EventMachine::run {
  EventMachine::start_server "0.0.0.0", CONFIG['server']['port'], ServerMachine
  EventMachine::add_periodic_timer(1) do
    if \
        # Normal server shutdown.
        App.server_state == App::SERVER_STATE_SHUTDOWNING ||
        # Dispatcher crashed.
        ! Celluloid::Actor[:dispatcher].alive?
      LOGGER.info "EventMachine shutting down."
      EventMachine.stop_event_loop
    end
  end

  App.server_state = App::SERVER_STATE_RUNNING
  LOGGER.info "EventMachine started. Server ready."
}

LOGGER.info "Server stopped."
sleep 1 # Allow last messages to be written to the logfile.