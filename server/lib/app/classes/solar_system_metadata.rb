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
#   :enemies_with_planets => +[Player#minimal, ...]+,
#   :enemies_with_ships => +[Player#minimal, ...]+,
#   :allies_with_planets => +[Player#minimal, ...]+,
#   :allies_with_ships => +[Player#minimal, ...]+,
#   :naps_with_planets => +[Player#minimal, ...]+,
#   :naps_with_ships => +[Player#minimal, ...]+,
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
        :enemies_with_planets => Array, :enemies_with_ships => Array,
        :allies_with_planets => Array, :allies_with_ships => Array,
        :naps_with_planets => Array, :naps_with_ships => Array
      }
    )

    @metadata = metadata
  end

  def self.existing(solar_system_id, metadata)
    new({
      id: solar_system_id, x: nil, y: nil, kind: nil, player: nil
    }.merge(metadata))
  end

  def self.destroyed(solar_system_id)
    new(
      id: solar_system_id, x: nil, y: nil, kind: nil, player: nil,
      player_planets: false, player_ships: false,
      enemies_with_planets: [], enemies_with_ships: [],
      allies_with_planets: [], allies_with_ships: [],
      naps_with_planets: [], naps_with_ships: []
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
    @metadata.merge(
      enemy_planets: true, enemy_ships: true,
      alliance_planets: true, alliance_ships: true,
      nap_planets: true, nap_ships: true
    )
  end
end