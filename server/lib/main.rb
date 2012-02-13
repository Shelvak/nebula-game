#!/usr/bin/env jruby
require File.expand_path(
  File.join(File.dirname(__FILE__), 'initializer.rb')
)

LOGGER.info "Starting server..."

if App.in_development?
  # Initialize IRB support for drop-in development console.
  require File.expand_path(
    File.join(ROOT_DIR, 'lib', 'server', 'irb_session.rb')
  )
  root_binding = binding
end

# Initialize space mule.
LOGGER.info "Initializing SpaceMule."
SpaceMule.instance

# Ensure server and callback manager are restarted if they crash.
LOGGER.info "Starting server actor..."
ServerActor.supervise_as(:server, CONFIG['server']['port'])

#LOGGER.info "Starting callback manager actor..."
#CallbackManager.supervise_as(:callback_manager)

# Set up signals.
stop_server = proc do
  LOGGER.info "Caught interrupt, shutting down..."
  App.server_state = App::SERVER_STATE_SHUTDOWNING
end
if App.in_development?
  trap("INT") do
    if $IRB_RUNNING
      begin
        stop_server.call
        throw :IRB_EXIT
      ensure
        Celluloid::Actor[:callback_manager].resume!
      end
    else
     puts "\n\nDropping into IRB shell. Server operation suspended."
     puts "Press CTRL+C again to exit the server.\n\n"

     puts "Pausing callback manager..."
     Celluloid::Actor[:callback_manager].pause
     puts "Starting IRB session..."
     IRB.start_session(root_binding)
     puts "\nIRB done. Server operation resumed.\n\n"
    end
  end
else
  trap("INT", &stop_server)
end
trap("TERM", &stop_server)

# Sleep forever while other threads do the dirty work.
App.server_state = App::SERVER_STATE_RUNNING
LOGGER.info "Server initialized."
sleep 1 until App.server_state == App::SERVER_STATE_SHUTDOWNING

LOGGER.info "Server stopped."
sleep 1 # Allow last messages to be written to the logfile.