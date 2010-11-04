# Filter used for deciding if messages should be pushed to client or not.
#
# They should not be pushed to client if it would useless, e.g. player is
# not looking into that map and doesn't know about pushed object.
#
class DispatcherPushFilter
  SOLAR_SYSTEM = :solar_system
  SS_OBJECT = :planet
  
  attr_reader :scope, :id

  def initialize(scope, id)
    @scope = scope
    @id = id
  end

  def as_json(options=nil)
    {:scope => @scope, :id => @id}
  end

  def ==(other)
    if other.is_a?(self.class)
      scope == other.scope && id == other.id
    else
      false
    end
  end
end