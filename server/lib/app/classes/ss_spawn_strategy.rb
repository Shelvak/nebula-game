# Class that picks location for NPC unit spawning in solar system.
#
# This would be better named as SolarSystem::SpawnStrategies, however autoloader
# freaks out, because it needs SolarSystem, and that one requires database
# connectivity.
class SsSpawnStrategy
  STRATEGY_OUTER_CIRCLE = 'outer_circle'
  STRATEGY_RANDOM = 'random'

  def initialize(solar_system, excluded_points=nil)
    @solar_system = solar_system
    @excluded_points = excluded_points || Set.new
  end

  def pick
    strategy = Cfg.solar_system_spawn_strategy(@solar_system.kind)

    case strategy
    when STRATEGY_OUTER_CIRCLE
      outer_circle
    when STRATEGY_RANDOM
      random
    else
      raise ArgumentError.new("Unknown spawn strategy: #{strategy}!")
    end
  end

  private

  # Return a random, non excluded, non jumpgate point in the outer circle.
  def outer_circle
    all_points = SolarSystemPoint.orbit_points(
      @solar_system.id, Cfg.solar_system_orbit_count
    )
    jumpgate_points = lambda do
      fields = "position, angle"
      SsObject::Jumpgate.in_solar_system(@solar_system).
        select(fields).group(fields).c_select_all
    end.call.inject(Set.new) do |set, row|
      set.add SolarSystemPoint.new(@solar_system.id,
                                   row['position'], row['angle'])
      set
    end

    (all_points - @excluded_points - jumpgate_points).to_a.random_element
  end

  # Return a random, non excluded taken point.
  def random
    all_points = SolarSystemPoint.all_orbit_points(@solar_system.id)
    (all_points - @excluded_points).to_a.random_element
  end
end