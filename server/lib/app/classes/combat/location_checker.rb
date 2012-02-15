class Combat::LocationChecker  
  class << self
    # Check location for opposing forces and initiate combat if needed.
    #
    # At first check cooldowns table - if the cooldown is still on we cannot
    # initiate any battles there.
    #
    # If there is no cooldown - check for any opposing forces. 
    #
    def check_location(location_point)
      cooldown = Cooldown.in_location(location_point.location_attrs).first
      return false if cooldown

      check_report = check_for_enemies(location_point)
      assets = nil
      return_status = false
      if check_report.status == Combat::CheckReport::COMBAT
        # _assets_ can be nil if nobody can shoot anyone. E.g. 
        # in only-ground vs only-space combat.
        assets = on_conflict(location_point, check_report)
        return_status = !! assets
      end

      annex_planet(location_point, check_report, assets) \
        if location_point.type == Location::SS_OBJECT

      return_status
    end

    # Check each location which player owns/has units on.
    def check_player_locations(player)
      planet_ids = SsObject::Planet.where(:player_id => player.id).
        select("id").c_select_values
      
      location_columns = "location_id, location_type, location_x, location_y"
      unit_locations = Unit.where(:player_id => player.id).
        select(location_columns).group(location_columns).c_select_all

      locations = Set.new
      planet_ids.each { |id| locations.add(PlanetPoint.new(id)) }
      unit_locations.each do |row|
        locations.add(
          LocationPoint.new(row["location_id"], row["location_type"],
            row["location_x"], row["location_y"])
        )
      end

      locations.each do |location_point|
        check_location(location_point)
      end
    end

    # Check +Location+ for opposing forces. Return Combat::CheckReport.
    #
    # Opposing forces are different players (when they are in different
    # alliances and those alliances don't have a +Nap+ between them) with
    # units in same location.
    #
    def check_for_enemies(location_point)
      player_ids = Location.combat_player_ids(location_point)
      alliances = Player.grouped_by_alliance(player_ids)
      nap_rules = {}

      if alliances.size < 2
        status = Combat::CheckReport::NO_CONFLICT
      else
        # Reject single players that don't belong to alliance.
        alliance_ids = alliances.keys.reject { |alliance_id| 
          alliance_id < 0 }

        # No alliances means war between players, so no nap rules to check.
        if alliance_ids.blank?
          status = Combat::CheckReport::COMBAT
        else
          # Even canceled naps still count as naps in combat.
          nap_rules = Nap.get_rules(
            alliance_ids,
            [Nap::STATUS_ESTABLISHED, Nap::STATUS_CANCELED]
          )

          # Check if there are any not allied players. They will most
          # definitely cause conflicts.
          # OR
          # Check if any of the alliances do not have naps between them.
          conflicts = alliances.keys.size > alliance_ids.size ||
            ! alliance_ids.detect { |alliance_id|
              (
                Set.new(nap_rules[alliance_id]) ^ alliance_ids
              ) != Set[alliance_id]
            }.nil?

          status = conflicts \
            ? Combat::CheckReport::COMBAT \
            : Combat::CheckReport::NO_CONFLICT
        end
      end

      Combat::CheckReport.new(status, alliances, nap_rules)
    end
    
    protected    
    def on_conflict(location_point, check_report)
      location = location_point.object

      units = Unit.in_location(location_point.location_attrs).combat.all

      # Get players from alliances.
      players = check_report.alliances.values.flatten
      
      if location.is_a?(SsObject::Planet)
        dp_units = Building::DefensivePortal.portal_units_for(location)
        units += dp_units
        buildings = location.buildings.combat.active.all

        # Add players that have units from defensive portal. Also add planet
        # owner event if he has no assets, because other players might be
        # fighting in an empty planet.
        players = players | Player.find(dp_units.map(&:player_id)) |
          [location.player]
      else
        buildings = []
      end
      
      # Create a set from our players array.
      players = Set.new(players)
      units = Set.new(units)
      buildings = Set.new(buildings)

      assets = Combat.run(
        location, players, check_report.nap_rules, units, buildings
      )

      FowSsEntry.recalculate(location_point.id, true) \
        if ! assets.nil? && location_point.type == Location::SOLAR_SYSTEM
      
      assets
    end
    
    def annex_planet(location_point, check_report, assets)
      Combat::Annexer.annex!(
        location_point.object, check_report, 
        assets ? assets.response['outcomes'] : nil
      )
    end
  end
end

