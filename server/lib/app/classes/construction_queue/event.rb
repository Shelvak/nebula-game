class ConstructionQueue::Event
  attr_reader :constructor_id

  def initialize(constructor_id)
    @constructor_id = constructor_id
  end

  # Retrieves constructor building.
  def constructor; Building.find(@constructor_id); end

  # For testing equality in specs.
  def ==(other)
    other.is_a?(self.class) && @constructor_id == other.constructor_id
  end
end