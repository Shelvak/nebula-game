# Notifies about created solar system.
class Event::FowChange::SsCreated < Event::FowChange::SolarSystem
  # @param solar_system_id [Fixnum] SolarSystem#id
  # @param x [Fixnum] SolarSystem#x
  # @param y [Fixnum] SolarSystem#y
  # @param kind [Fixnum] SolarSystem#kind
  # @param player_minimal [Hash] Player#minimal | nil
  # @param fow_ss_entries [Array]
  def initialize(solar_system_id, x, y, kind, player_minimal, fow_ss_entries)
    @solar_system_id = solar_system_id
    process_changes(fow_ss_entries, [x, y], kind, player_minimal)
  end

  def ==(other); super(other); end
  def eql?(other); super(other); end
end