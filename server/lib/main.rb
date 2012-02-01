#!/usr/bin/env jruby
require File.expand_path(
  File.join(File.dirname(__FILE__), 'initializer.rb')
)

LOGGER.info "Starting server..."

if App.in_development?
  # Initialize IRB support for drop-in development console.
  require File.expand_path(File.join(ROOT_DIR, 'lib', 'server',
      'irb_session.rb'))
  root_binding = binding
end

#LOGGER.info "Running EventMachine..."
#EventMachine.run do
#  stop_server = proc do
#    LOGGER.info "Caught interrupt, shutting down..."
#    App.server_state = App::SERVER_STATE_SHUTDOWNING
#    EventMachine.stop_event_loop
#  end
#  if App.in_development?
#    trap("INT") do
#      if $IRB_RUNNING
#        stop_server.call
#        throw :IRB_EXIT
#      else
#       puts "\n\nDropping into IRB shell. Server operation suspended."
#       puts "Press CTRL+C again to exit the server.\n\n"
#
#       IRB.start_session(root_binding)
#       puts "\nIRB done. Server operation resumed.\n\n"
#      end
#    end
#  else
#    trap("INT", &stop_server)
#  end
#  trap("TERM", &stop_server)
#
#  # Initialize space mule.
#  SpaceMule.instance
#
#  LOGGER.info "Starting game server..."
#  EventMachine.start_server "0.0.0.0", CONFIG['game']['port'], GameServer
#
#  LOGGER.info "Starting control server..."
#  EventMachine.start_server "0.0.0.0", CONFIG['control']['port'],
#    ControlServer
#
#  LOGGER.info "Starting callback manager..."
#  EventMachine::PeriodicTimer.new(1) { CallbackManager.tick }
#
#  LOGGER.info "Running callback manager..."
#  CallbackManager.tick(true)
#
#  App.server_state = App::SERVER_STATE_RUNNING
#  LOGGER.info "Server initialized."
#end
#
#LOGGER.info "Server stopped."

Celluloid::Actor[:server] = ServerActor.new(CONFIG['game']['port'])
CallbackManager.supervise_as(:callback_manager)
sleep
