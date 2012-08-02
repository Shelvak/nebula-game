# Thread-local buffer for buffering pushes to dispatcher from event handler.
#
# This allows us to safely restart deadlocked transactions, as pushes will never
# happen if transaction does not complete successfully.
class DispatcherEventHandler::Buffer < BasicObject
  include ::Singleton

  HANDLE_BUFFER = :dispatcher_event_handler_buffer
  HANDLE_WRAPPED = :dispatcher_event_handler_buffer_wrapped
  TAG = "deh_buffer"

  def method_missing(*args)
    dispatcher.send(*args)
  end

  def push_to_player(*args)
    if wrapped?
      ::LOGGER.debug "Pushing entry, current size: #{buffer.size} entries.", TAG
      buffer << args
    else
      dispatcher.push_to_player!(*args)
    end
  end

  # For Dispatcher interchangeability.
  alias :push_to_player! :push_to_player

  def wrap
    if wrapped?
      first_wrap = false
      ::LOGGER.debug "Already in wrapped block, dive in.", TAG
    else
      ::LOGGER.debug "Entering wrapped block.", TAG
      buffer.clear
      first_wrap = true
      self.wrapped = true
    end

    yield

    # Commit buffer only if it is first wrap and there are no exceptions.
    if first_wrap
      ::LOGGER.debug "Commiting buffer of #{buffer.size} entries.", TAG
      ::LOGGER.debug "BUFFER: #{buffer.inspect}.", TAG

      buffer.each do |args|
        dispatcher.push_to_player!(*args)
      end
    end
  ensure
    if first_wrap
      self.wrapped = nil
    else
      ::LOGGER.debug "Still in wrapped block, dive out.", TAG
    end
  end

private

  def dispatcher
    ::Celluloid::Actor[:dispatcher]
  end

  def buffer
    ::Thread.current[HANDLE_BUFFER] ||= []
  end

  def wrapped=(value)
    ::Thread.current[HANDLE_WRAPPED] = value
  end

  def wrapped?
    ::Thread.current[HANDLE_WRAPPED]
  end
end