module NamedLogMessages
  Logging::Writer::TYPE_TO_LEVEL.each do |type, level|
    define_method(type) do |message, component=nil|
      LOGGER.send(type, message, component || to_s)
    end
  end
end
