# Notifies about created solar system.
class Event::FowChange::SsCreated < Event::FowChange::SolarSystem
  def initialize(solar_system_id, x, y, kind, fow_ss_entries)
    @solar_system_id = solar_system_id
    process_changes(fow_ss_entries, [x, y], kind)
  end

  def ==(other); super(other); end
  def eql?(other); super(other); end
end