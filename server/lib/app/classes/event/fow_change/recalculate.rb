# Same as Event::FowChange::SolarSystem but uses _changes_ obtained from
# FowSsEntry#recalculate to determine which players need to
# be notified.
class Event::FowChange::Recalculate < Event::FowChange::SolarSystem
  def initialize(changes, solar_system_id)
    process_changes(changes)
    @solar_system_id = solar_system_id
  end
end
