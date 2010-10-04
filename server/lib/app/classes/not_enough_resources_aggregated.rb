class NotEnoughResourcesAggregated < GameNotifiableError
  attr_reader :constructor, :constructables

  def initialize(constructor, constructables)
    super(
      "There was not enough resources to build following " +
      "items with %s:\n%s" % [
        constructor.to_s,
        constructables.map(&:to_s).join(", ")
      ]
    )
    @constructor = constructor
    @constructables = constructables
  end
end