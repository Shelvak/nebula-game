# Invokes SpaceMule pathfinder.
module SpaceMule::Pathfinder
  # Scala constants
  Coords = SpaceMule::Pmg.classes.geom.Coords

  Pf = SpaceMule::SmModules.pathfinder
  PfO = Pf.objects

  def self.invoke(source, target, avoid_npc)
    avoidable_points = []

    source_solar_system = source.solar_system
    sm_source_solar_system = None
    if source_solar_system
      sm_source_solar_system = to_pf_solar_system(source_solar_system)

      if avoid_npc
        avoidable_points += source_solar_system.npc_unit_locations.map do
          |solar_system_point|

          PfO.SolarSystemPoint.new(
            sm_source_solar_system,
            Coords.new(solar_system_point.x, solar_system_point.y)
          )
        end
      end
    end

    target_solar_system = target.solar_system
    sm_target_solar_system = None
    if target_solar_system
      sm_target_solar_system = to_pf_solar_system(target_solar_system)

      if avoid_npc && source_solar_system != target_solar_system
        avoidable_points += target_solar_system.npc_unit_locations.map do
          |solar_system_point|

          PfO.SolarSystemPoint.new(
            sm_target_solar_system,
            Coords.new(solar_system_point.x, solar_system_point.y)
          )
        end
      end
    end

    # Add avoidable points if we have something to avoid.
    sm_avoidable_points = avoidable_points.blank? \
      ? None : Some(avoidable_points.to_scala)

    sm_source_jumpgates = Set.new.to_scala
    sm_target_jumpgates = Set.new.to_scala
    sm_source_ss_galaxy_coords = None
    sm_target_ss_galaxy_coords = None

    if source_solar_system && target.is_a?(GalaxyPoint)
      # SS -> Galaxy hop, only source JGs needed.
      sm_source_jumpgates = jumpgates_for(sm_source_solar_system)
      sm_source_ss_galaxy_coords =
        Some(jump_coords(target.id, target, source_solar_system))
    elsif source.is_a?(GalaxyPoint) && target_solar_system
      # Galaxy -> SS hop, only target JGs needed
      sm_target_jumpgates = jumpgates_for(sm_target_solar_system)
      sm_target_ss_galaxy_coords =
        Some(jump_coords(source.id, source, target_solar_system))
    elsif source_solar_system && target_solar_system && (
      source_solar_system.id != target_solar_system.id
    )
      # Different SS -> SS hop, we need all jumpgates
      sm_source_jumpgates = jumpgates_for(sm_source_solar_system)
      sm_target_jumpgates = jumpgates_for(sm_target_solar_system)

      sm_source_ss_galaxy_coords = Some(jump_coords(
        target_solar_system.galaxy_id, target_solar_system,
        source_solar_system
      ))
      sm_target_ss_galaxy_coords = Some(jump_coords(
        source_solar_system.galaxy_id, source_solar_system,
        target_solar_system
      ))
    else
      # No jumpgates needed.
    end

    sm_source = to_pf_locatable(source, sm_source_solar_system)
    sm_target = to_pf_locatable(target, sm_target_solar_system)

    PfO.Finder.find(
      sm_source, sm_source_jumpgates, sm_source_solar_system,
      sm_source_ss_galaxy_coords,

      sm_target, sm_target_jumpgates, sm_target_solar_system,
      sm_target_ss_galaxy_coords,

      sm_avoidable_points
    ).from_scala
  end

  # Converts Ruby +SolarSystem+ to SpaceMule +SolarSystem+ used in pathfinder.
  def self.to_pf_solar_system(solar_system)
    PfO.SolarSystem.new(
      solar_system.id,
      solar_system.x.nil? || solar_system.y.nil? \
        ? None \
        : Some(Coords.new(solar_system.x, solar_system.y)),
      solar_system.galaxy_id
    )
  end

  # Converts Ruby +Location+ to SpaceMule pathfinders +Locatable+.
  # _sm_solar_system_ is used if _location_ is in solar system.
  def self.to_pf_locatable(location, sm_solar_system)
    coords = Coords.new(location.x, location.y)
    case location
    when GalaxyPoint
      PfO.GalaxyPoint.new(location.id, coords, 1.0)
    when SolarSystemPoint
      PfO.SolarSystemPoint.new(sm_solar_system, coords)
    when SsObject
      PfO.Planet.new(location.id, sm_solar_system, coords)
    else
      raise ArgumentError.new(
        "Cannot convert #{location.inspect} to pathfinder Locatable!"
      )
    end
  end

  # Checks if _solar_system_ is a battleground. If so - links entry/exit
  # point to closest wormhole in the galaxy.
  #
  # Otherwise travels as expected.
  def self.jump_coords(galaxy_id, wormhole_proximity_point, solar_system)
    if solar_system.main_battleground?
      wormhole = Galaxy.closest_wormhole(galaxy_id,
        wormhole_proximity_point.x, wormhole_proximity_point.y)
      Coords.new(wormhole.x, wormhole.y)
    else
      Coords.new(solar_system.x, solar_system.y)
    end
  end

  # Given PmO.SolarSystem returns Set of +PmO.SolarSystemPoint+s.
  def self.jumpgates_for(sm_solar_system)
    points = SsObject::Jumpgate.where(:solar_system_id => sm_solar_system.id).
      all.map do |jumpgate|
        PfO.SolarSystemPoint.new(
          sm_solar_system,
          Coords.new(jumpgate.x, jumpgate.y)
        )
      end
    Set.new(points).to_scala
  end
end