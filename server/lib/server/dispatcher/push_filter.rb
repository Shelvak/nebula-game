# Filter used for deciding if messages should be pushed to client or not.
#
# They should not be pushed to client if it would be useless, e.g. player is
# not looking into that map and doesn't know about pushed object.
#
class Dispatcher::PushFilter
  SOLAR_SYSTEM = :solar_system
  SS_OBJECT = :planet
  
  attr_reader :scope, :id

  def initialize(scope, id)
    @scope = scope
    @id = id
  end

  def self.solar_system(id)
    new(SOLAR_SYSTEM, id)
  end

  def self.ss_object(id)
    new(SS_OBJECT, id)
  end

  def to_s
    "<PushFilter scope=#{@scope} id=#{@id}>"
  end

  def as_json(options=nil)
    {:scope => @scope, :id => @id}
  end

  def ==(other); eql?(other); end

  def eql?(other)
    other.is_a?(self.class) && @scope == other.scope && @id == other.id
  end
end