class SsObject::Asteroid < SsObject
  def to_s
    super + "Asteroid " +
      "  metal: #{metal_rate}/#{metal_storage}\n" +
      "  energy: #{energy_rate}/#{energy_storage}\n" +
      "  zetium: #{zetium_rate}/#{zetium_storage}\n" +
      ">"
  end

  # Attributes which are also included for Asteroid subtype.
  RESOURCE_ATTRIBUTES = %w{metal_rate metal_storage
    energy_rate energy_storage zetium_rate zetium_storage}

  # Returns Asteroid JSON representation. It's basically same as
  # SsObject#as_json but includes additional fields.
  #
  # Options:
  # - :resources - includes resources attributes.
  #
  def as_json(options=nil)
    additional = {}
    if options && options[:resources]
      read_attributes(RESOURCE_ATTRIBUTES, additional)
    end

    super(options).merge(additional)
  end
end