# Wrapper around +SolarSystem+ metadata. Needed because we need to push
# metadata to client via ObjectController.
#
# #as_json returns:
# {
#   :id => +Fixnum+,
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
  # Initialize _metadata_ (Hash).
  def initialize(metadata)
    @metadata = metadata
  end

  def ==(other)
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