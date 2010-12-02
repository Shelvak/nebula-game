# Same as FowChangeEvent::SolarSystem but uses _changes_ obtained from
# FowSsEntry#recalculate to determine which players need to
# be notified.
class FowChangeEvent::Recalculate < FowChangeEvent::SolarSystem
  def initialize(changes, solar_system_id)
    @player_ids = calc_player_ids(changes)
    @solar_system_id = solar_system_id
  end
end
