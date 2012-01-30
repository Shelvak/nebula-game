module NamedLogMessages
  Logging::Writer::TYPE_TO_LEVEL.each do |type, level|
    define_method(type) do |message|
      LOGGER.send(type, message, to_s)
    end
  end
end
