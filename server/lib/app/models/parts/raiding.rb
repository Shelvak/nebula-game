module Parts::Raiding
  def self.included(receiver)
    receiver.extend ClassMethods
    receiver.send :include, InstanceMethods
  end
  
  module ClassMethods  
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
  end

  module InstanceMethods
    # Return array of built (but not saved) units
    def npc_raid_units
      raise GameLogicError.new("Cannot raid planet which has no player!") \
        if player.nil?

      definitions = self.class.npc_raid_unit_count(player.planets_count)
      galaxy_id = solar_system.galaxy_id

      units = []
      definitions.each do |type, count, flank|
        klass = "Unit::#{type.camelcase}".constantize
        count.times do
          unit = klass.new(
            :level => 1,
            :hp => klass.hit_points,
            :location => self,
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
    def npc_raid!
      raiders = npc_raid_units
      Unit.save_all_units(raiders, nil, EventBroker::CREATED)
      Combat::LocationChecker.check_location(location_point)

      # Check if planet was taken away and if it should be raided again.
      reload
      should_raid? ? register_raid! : clear_raid!
    end

    # Should NPC raiders raid player if he has _planets_count_?
    def should_raid?
      # Non-NPC
      ! player_id.nil? && 
        (
          # Battleground / pulsar
          solar_system.battleground? ||
          # Player already have 2 non bg/pulsar non-raidable planets
          player.planets.accept do |planet|
            planet.solar_system.normal? && ! planet.raid_registered?
          end.size >= CONFIG['raiding.planet.threshold'] - 1
        )
    end
  end
end
