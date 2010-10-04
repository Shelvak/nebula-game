# Wrapper around +SolarSystem+ metadata. Needed because we need to push
# metadata to client via ObjectController.
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