# FOW change event when single solar system is changed.
class Event::FowChange::SolarSystem < Event::FowChange
  attr_reader :solar_system_id
  # Hash of _player_id_ => [+SolarSystemMetadata+, ...]
  attr_reader :metadatas

  def initialize
    raise NotImplementedError, "This class is abstract!"
  end

  def to_s
    "<#{self.class} solar_system_id=#{@solar_system_id}, player_ids=#{
      @player_ids.inspect}, metadatas=#{@metadatas.inspect}>"
  end

  def ==(other); eql?(other); end

  def eql?(other)
    other.is_a?(self.class) && super(other) &&
      @solar_system_id == other.solar_system_id &&
      @metadatas == other.metadatas
  end
end