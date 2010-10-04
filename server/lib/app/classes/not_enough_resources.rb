class NotEnoughResources < GameError
  attr_reader :constructable

  def initialize(message, constructable)
    super(message)
    @constructable = constructable
  end
end
