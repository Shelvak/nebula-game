module Trait::Radar
  # Return +Rectangle+ from given zone, which is obtained from #radar_zone.
  def self.rectangle_from_zone(zone)
    Rectangle.new(
      zone[0].first, zone[1].first,
      zone[0].last, zone[1].last
    )
  end

  def self.increase_vision(zone, player)
    # Order matters here, FowGalaxyEntry emits event!
    FowSsEntry.increase_for_zone(zone, player, 1, false)
    FowGalaxyEntry.increase(rectangle_from_zone(zone), player)
  end

  def self.decrease_vision(zone, player)
    # Order matters here, FowGalaxyEntry emits event!
    FowSsEntry.decrease_for_zone(zone, player, 1, false)
    FowGalaxyEntry.decrease(rectangle_from_zone(zone), player)
  end

	module ClassMethods
	end

	module InstanceMethods
    def radar_strength
      evalproperty('radar.strength')
    end

    # Returns inclusive zone ([x_range, y_range]) of this radar reach.
    def radar_zone
      strength = radar_strength
      solar_system = planet.solar_system
      [
        (solar_system.x - strength)..(solar_system.x + strength),
        (solar_system.y - strength)..(solar_system.y + strength)
      ]
    end

    def on_activation
      super
      Trait::Radar.increase_vision(radar_zone, planet.player)
    end

    def on_deactivation
      super
      Trait::Radar.decrease_vision(radar_zone, planet.player)
    end
	end

	def self.included(receiver)
    Trait.child_included(self, receiver)
	end
end