# FOW change event when single solar system is changed.
class FowChangeEvent::SolarSystem < FowChangeEvent
  attr_reader :solar_system_id
  # Hash of _player_id_ => [+SolarSystemMetadata+, ...]
  attr_reader :metadatas

  def initialize(solar_system_id)
    @solar_system_id = solar_system_id
    process_changes(
      FowSsEntry.where(:solar_system_id => solar_system_id)
    )
  end

  def solar_system
    SolarSystem.find(@solar_system_id)
  end

  def ==(other)
    other.is_a?(self.class) && super(other) &&
      @solar_system_id == other.solar_system_id
  end

  protected
  # Calculates player ids that should be notified and +SolarSystemMetadata+s
  # for those players from given _fow_ss_entries_.
  #
  # Sets:
  # * #player_ids (Fixnum[]): Array of players that should be notified
  # * #metadatas (+Hash+ of _player_id_ => +SolarSystemMetadata+)
  #
  def process_changes(fow_ss_entries)
    metadatas = {}
    player_ids = Set.new
    fow_ss_entries.each do |fse|
      if fse.alliance_id
        fse.alliance.member_ids.each do |player_id|
          player_ids.add(player_id)
          metadatas[player_id] ||= {}
          metadatas[player_id][:alliance] = fse
        end
      else
        player_ids.add(fse.player_id)
        metadatas[fse.player_id] ||= {}
        metadatas[fse.player_id][:player] = fse
      end
    end

    @metadatas = {}
    metadatas.each do |player_id, data|
      @metadatas[player_id] = FowSsEntry.merge_metadata(
        data[:player], data[:alliance])
    end

    @player_ids = player_ids.to_a

    true
  end
end