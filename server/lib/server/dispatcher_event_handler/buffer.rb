module DispatcherEventHandler::Buffer
  HANDLE = :dispatcher_event_handler_buffer
  TAG = "deh_buffer"

  class << self
    def push_to_player(*args)
      LOGGER.debug "Pushing entry, current size: #{buffer.size} entries.", TAG
      buffer << args
    end

    # For Dispatcher interchangeability.
    alias :push_to_player! :push_to_player

    def commit!
      LOGGER.debug "Commiting buffer of #{buffer.size} entries.", TAG
      dispatcher = Celluloid::Actor[:dispatcher]
      buffer.each do |args|
        dispatcher.push_to_player!(*args)
      end
      LOGGER.debug "Clearing #{buffer.size} entries.", TAG
      buffer.clear
    end

    private
    def buffer
      Thread.current[HANDLE] ||= []
    end
  end
end