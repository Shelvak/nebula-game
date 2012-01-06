# Wrapper around +SolarSystem+ metadata. Needed because we need to push
# metadata to client via ObjectController.
#
# #as_json returns:
# {
#   # Solar system ID.
#   :id => +Fixnum+,
#   # Creation properties.
#   :x => +Fixnum+ | nil,
#   :y => +Fixnum+ | nil,
#   :kind => +Fixnum+ | nil,
#   :player => Player#minimal | nil,
#   # Metadata flags - only on create/update, otherwise nil.
#   :player_planets => +Boolean+,
#   :player_ships => +Boolean+,
#   :enemy_planets => +Boolean+,
#   :enemy_ships => +Boolean+,
#   :alliance_planets => +Boolean+,
#   :alliance_ships => +Boolean+,
#   :nap_planets => +Boolean+,
#   :nap_ships => +Boolean+,
# }
#
# _id_ is solar system id.
#
class SolarSystemMetadata
  include Parts::Object

  # Initialize _metadata_ (Hash).
  def initialize(metadata)
    metadata.ensure_options!(
      :required => {
        :id => Fixnum, :x => [Fixnum, NilClass], :y => [Fixnum, NilClass],
        :kind => [Fixnum, NilClass], :player => [Hash, NilClass],
        :player_planets => Boolean, :player_ships => Boolean,
        :enemy_planets => Boolean, :enemy_ships => Boolean,
        :alliance_planets => Boolean, :alliance_ships => Boolean,
        :nap_planets => Boolean, :nap_ships => Boolean
      }
    )

    @metadata = metadata
  end

  def self.destroyed(solar_system_id)
    new(
      :id => solar_system_id, :x => nil, :y => nil, :kind => nil,
      :player => nil,
      :player_planets => false, :player_ships => false,
      :enemy_planets => false, :enemy_ships => false,
      :alliance_planets => false, :alliance_ships => false,
      :nap_planets => false, :nap_ships => false
    )
  end

  def to_s
    "<#{self.class} metadata=#{@metadata.inspect}>"
  end

  def id; @metadata[:id]; end
  def kind; @metadata[:kind]; end
  def x; @metadata[:x]; end
  def y; @metadata[:y]; end

  def ==(other); eql?(other); end

  def eql?(other)
    other.is_a?(self.class) && as_json == other.as_json
  end

  def [](key)
    @metadata[key]
  end

  def []=(key, value)
    @metadata[key] = value
  end

  def as_json(options=nil)
    @metadata
  end
end