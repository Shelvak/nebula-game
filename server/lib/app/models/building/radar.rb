class Building::Radar < Building
  include Trait::Radar

  def self.for_player(player_id)
    planet_ids = SsObject::Planet.select("id").where(:player_id => player_id).
      c_select_values
    where(:planet_id => planet_ids)
  end

  # Do not activate radars if they are in detached solar system, because SS
  # coordinates are null.
  def activate
    return false if planet.solar_system.detached?
    super
  end
end