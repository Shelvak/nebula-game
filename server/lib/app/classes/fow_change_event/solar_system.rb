# FOW change event when single solar system is changed.
class FowChangeEvent::SolarSystem < FowChangeEvent
  attr_reader :solar_system_id

  def initialize(solar_system_id)
    @solar_system_id = solar_system_id
    @player_ids = calc_player_ids(
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
  # Calculates player ids that should be notified from given
  # _fow_ss_entries_.
  def calc_player_ids(fow_ss_entries)
    player_ids = Set.new
    fow_ss_entries.each do |fse|
      if fse.alliance_id
        fse.alliance.member_ids.each do |player_id|
          player_ids.add(player_id)
        end
      else
        player_ids.add(fse.player_id)
      end
    end

    player_ids.to_a
  end
end