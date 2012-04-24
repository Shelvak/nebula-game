# Thread-local buffer for buffering pushes to dispatcher from event handler.
#
# This allows us to safely restart deadlocked transactions, as pushes will never
# happen if transaction does not complete successfully.
class DispatcherEventHandler::Buffer < BasicObject
  include ::Singleton

  HANDLE = :dispatcher_event_handler_buffer
  TAG = "deh_buffer"

  def method_missing(*args)
    dispatcher.send(*args)
  end

  def push_to_player(*args)
    ::LOGGER.debug "Pushing entry, current size: #{buffer.size} entries.", TAG
    buffer << args
  end

  # For Dispatcher interchangeability.
  alias :push_to_player! :push_to_player

  def wrap
    ::LOGGER.debug "Entering wrapped block.", TAG
    buffer.clear

    ret_val = yield

    ::LOGGER.debug "Commiting buffer of #{buffer.size} entries.", TAG

    buffer.each do |args|
      dispatcher.push_to_player!(*args)
    end

    ret_val
  end

  private
  def dispatcher
    ::Celluloid::Actor[:dispatcher]
  end

  def buffer
    ::Thread.current[HANDLE] ||= []
  end
end