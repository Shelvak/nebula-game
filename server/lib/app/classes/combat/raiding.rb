module Combat::Raiding
  # Return what units will raid player if he has _planets_ planets.
  #
  # Returns Array:
  # [
  #   [type, count, flank],
  #   ...
  # ]
  #
  def npc_raid_unit_count(planets)
    units = {}
    CONFIG['raiding.raiders'].each do |min_planets, type, count, flank|
      if planets >= min_planets
        units[type] ||= {}
        units[type][flank] ||= 0
        # Each additional planet multiplies count by 1.
        units[type][flank] += (planets - min_planets + 1) * count
      end
    end

    raiders = []
    units.each do |type, flanks|
      flanks.each do |index, count|
        raiders.push [type, count, index]
      end
    end

    raiders
  end

  # Return array of built (but not saved) units
  def npc_raid_units(planet)
    player = planet.player
    raise GameLogicError.new("Cannot raid planet which has no player!") \
      if player.nil?

    definitions = npc_raid_unit_count(player.planets_count)
    galaxy_id = planet.solar_system.galaxy_id

    units = []
    definitions.each do |type, count, flank|
      klass = "Unit::#{type.camelcase}".constantize
      count.times do
        unit = klass.new(
          :level => 1,
          :hp => klass.hit_points(1),
          :location => planet,
          :galaxy_id => galaxy_id,
          :flank => flank
        )
        unit.skip_validate_technologies = true

        units.push unit
      end
    end

    units
  end

  # Creates raiders and raids _planet_.
  def npc_raid!(planet)
    raiders = npc_raid_units(planet)
    Unit.save_all_units(raiders, nil, EventBroker::CREATED)
    Combat::LocationChecker.check_location(planet.location_point)

    # Check if planet was taken away and if it should be raided again.
    planet.reload
    if ! planet.player_id.nil? && should_raid?(planet.player.planets_count)
      planet.register_raid!
    else
      planet.clear_raid!
    end
  end

  # Should NPC raiders raid player if he has _planets_count_?
  def should_raid?(planets_count)
    planets_count >= CONFIG['raiding.planet.threshold']
  end
end
