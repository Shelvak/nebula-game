class Dispatcher::Atomizer < BasicObject
  def initialize
    @buffer = []
  end

  TAG = "atomizer"

  def method_missing(method_name, *args)
    sync_method_name = method_name.to_s.sub(/!$/, '').to_sym
    ::LOGGER.debug "Buffering: ##{method_name} -> ##{sync_method_name}.", TAG
    @buffer << [sync_method_name] + args
    nil
  end

  def implode(dispatcher)
    ::LOGGER.debug "Imploding #{@buffer.size} calls.", TAG
    @buffer.each do |method_name, *args|
      ::LOGGER.debug "Imploding: ##{method_name}.", TAG
      dispatcher.send(method_name, *args)
    end

    true
  end
end