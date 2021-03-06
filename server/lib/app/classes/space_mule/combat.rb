module SpaceMule::Combat
  # Scala constants
  Combat = SpaceMule::SmModules.combat
  CO = Combat.objects
  Location = SpaceMule::SmModules.combat.objects.Location

  # See SpaceMule#combat for options.
  def self.invoke(
    location, players, nap_rules, units, loaded_units, unloaded_unit_ids,
    buildings
  )
    typesig binding,
      [LocationPoint, SsObject::Planet],
      [Array, Set], Hash, [Array, Set], Hash, [Array, Set], [Array, Set]

    LOGGER.block("Issuing combat to SpaceMule") do
      # Convert location
      sm_location = convert_location(location)

      # Convert players
      hashed_sm_players = convert_players(players)
      sm_players = Set.new(hashed_sm_players.values).to_scala

      # Figure out planet owner
      sm_planet_owner = None
      if location.is_a?(SsObject::Planet)
        # If we find one it's already Some(Player) or None.
        _, sm_planet_owner = hashed_sm_players.find do |player_id, _|
          location.player_id == player_id
        end
        raise ArgumentError.new("No planet owner in given players! Players: #{
          players.inspect}, planet owner id: #{location.player_id.inspect}") \
          if sm_planet_owner.nil?
      end

      # Figure out alliance names
      alliance_ids = players.map do |player|
        player.nil? ? nil : player.alliance_id
      end.compact.uniq
      sm_alliance_names = without_locking do
        Alliance.names_for(alliance_ids)
      end.to_scala

      # Convert and partition troops.

      sm_troops = units.each_with_object(Set.new) do |unit, set|
        set.add convert_unit(hashed_sm_players, unit)
      end.to_scala

      # Units which are loaded into transporters.
      sm_loaded_units = loaded_units.each_with_object({}) do
        |(transporter_id, loaded), hash|

        hash[transporter_id] = Set.new
        loaded.each do |loaded_unit|
          hash[transporter_id].add convert_unit(hashed_sm_players, loaded_unit)
        end

        hash
      end.to_scala

      # Convert buildings
      sm_buildings = buildings.each_with_object(Set.new) do |building, set|
        set.add convert_building(sm_planet_owner, building)
      end.to_scala

      sm_battleground = battleground?(location).to_java
      sm_nap_rules = nap_rules.to_scala
      sm_unloaded_unit_ids = unloaded_unit_ids.to_scala

      Combat.Runner.run(
        sm_location,
        sm_battleground,
        sm_planet_owner,
        sm_players,
        sm_alliance_names,
        sm_nap_rules,
        sm_troops,
        sm_loaded_units,
        sm_unloaded_unit_ids,
        sm_buildings
      )
    end
  end

  # Converts Ruby +Location+ to SpaceMule +Location+.
  def self.convert_location(location)
    location_point = location.is_a?(SsObject::Planet) \
      ? location.location_point : location

    kind = case location_point.type
    when ::Location::GALAXY then Location.Galaxy
    when ::Location::SOLAR_SYSTEM then Location.SolarSystem
    when ::Location::SS_OBJECT then Location.SsObject
    when ::Location::UNIT then Location.Unit
    when ::Location::BUILDING then Location.Building
    end
    x = location_point.x.nil? ? None : Some(location_point.x)
    y = location_point.y.nil? ? None : Some(location_point.y)

    Location.new(location_point.id, kind, x, y)
  end

  # Only calculate victory points in main battleground planets and solar system
  def self.battleground?(location)
    without_locking do
      if location.is_a?(SsObject::Planet)
        location.solar_system.main_battleground?
      elsif location.type == ::Location::SOLAR_SYSTEM
        location.solar_system.main_battleground?
      else
        false
      end
    end
  end

  # Returns Ruby +Hash+ of {player_id => Scala +Player+} pairs.
  def self.convert_players(players)
    sm_players = players.each_with_object({}) do |player, hash|
      if player.nil?
        hash[nil] = None
      else
        hash[player.id] = Some(CO.Player.new(
          player.id,
          player.name,
          player.alliance_id.nil? ? None : Some(player.alliance_id),
          points_for(player),
          technologies_for(player),
          player.overpopulation_mod
        ))
      end
    end
    
    sm_players
  end

  # Returns Scala Points object.
  def self.points_for(player)
    CO.Player::Points.new(
      player.economy_points, player.science_points, player.army_points,
      player.war_points, player.victory_points
    )
  end

  # Returns Scala Technologies object.
  def self.technologies_for(player)
    without_locking do
      technologies = TechTracker.query_active(
        player.id, TechTracker::DAMAGE, TechTracker::ARMOR,
        TechTracker::CRITICAL, TechTracker::ABSORPTION
      ).all
      damage = TechModApplier.apply(technologies, TechTracker::DAMAGE)
      armor = TechModApplier.apply(technologies, TechTracker::ARMOR)
      critical = TechModApplier.apply(technologies, TechTracker::CRITICAL)
      absorption = TechModApplier.apply(technologies, TechTracker::ABSORPTION)

      CO.Player::Technologies.new(
        damage.to_scala, armor.to_scala, critical.to_scala, absorption.to_scala
      )
    end
  end

  # Converts Ruby +Unit+ to Scala +Troop+.
  def self.convert_unit(hashed_sm_players, unit)
    stance = case unit.stance
    when ::Combat::STANCE_NEUTRAL then CO.Stance.Normal
    when ::Combat::STANCE_DEFENSIVE then CO.Stance.Defensive
    when ::Combat::STANCE_AGGRESSIVE then CO.Stance.Aggressive
    end

    player = hashed_sm_players[unit.player_id]
    raise "Cannot find player #{unit.player_id.inspect} for #{unit.inspect
      } in sm_players (#{hashed_sm_players.inspect}!" if player.nil?

    CO.Troop.new(
      unit.id,
      unit.type,
      unit.level,
      unit.hp,
      player,
      unit.flank,
      stance,
      unit.xp
    )
  end

  # Converts Ruby +Building+ to Scala +Building+.
  def self.convert_building(sm_player, building)
    CO.Building.new(
      building.id,
      sm_player,
      building.type,
      building.hp,
      building.level
    )
  end
end