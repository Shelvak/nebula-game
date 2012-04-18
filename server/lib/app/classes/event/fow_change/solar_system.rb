# FOW change event when single solar system is changed.
class Event::FowChange::SolarSystem < Event::FowChange
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

  protected
  # Calculates player ids that should be notified and +SolarSystemMetadata+s
  # for those players from given _fow_ss_entries_.
  #
  # Sets:
  # * #player_ids (Fixnum[]): Array of players that should be notified
  # * #metadatas (+Hash+ of _player_id_ => +SolarSystemMetadata+)
  #
  def process_changes(fow_ss_entries, coords=nil, kind=nil, player_minimal=nil)
    metadatas = {}
    player_ids = Set.new

    alliance_ids = fow_ss_entries.map(&:alliance_id).compact
    alliance_players = alliance_ids.blank? \
      ? {} \
      : without_locking do
        Player.select("id, alliance_id").
          where(:alliance_id => alliance_ids).
          c_select_all
        end.each_with_object({}) do |row, hash|
          hash[row['alliance_id']] ||= []
          hash[row['alliance_id']] << row['id']
        end

    fow_ss_entries.each do |fse|
      if fse.alliance_id
        alliance_player_ids = alliance_players[fse.alliance_id]
        if alliance_player_ids.nil?
          LOGGER.error dump_environment(
            binding, "alliance_player_ids is not supposed to be nil!"
          )
        end
        alliance_player_ids.each do |player_id|
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
        data[:player], data[:alliance], coords, kind, player_minimal
      )
    end

    @player_ids = player_ids.to_a

    true
  end
end