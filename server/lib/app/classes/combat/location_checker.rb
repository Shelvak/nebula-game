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
      if check_report.status == Combat::CheckReport::CONFLICT
        assets = on_conflict(location_point, check_report)
        return_status = true
      end

      try_to_annex(location_point, check_report, assets)

      return_status
    end
    
    protected
    # Try to annex location point if it is SS_OBJECT.
    def try_to_annex(location_point, check_report, assets)
      case location_point.type
      when Location::SS_OBJECT
        Combat::Annexer.annex!(
          location_point.object,
          check_report.status,
          check_report.alliances,
          # Pass nils if no combat was run.
          assets ? assets.response['outcomes'] : nil,
          assets ? assets.response['statistics'] : nil
        )
      end
    end
    
    def on_conflict(location_point, check_report)
      location = location_point.object

      units = Unit.in_location(location_point.location_attrs).where(
        "level > 0").all

      if location.is_a?(SsObject)
        units += Building::DefensivePortal.portal_units_for(location)
        buildings = location.buildings.shooting.active.all

        # Gather players from included units. We use same nap rules because
        # defensive portal players are from same alliance.
        players = Player.find(units.map(&:player_id).uniq.compact)
      else
        buildings = []
        # Do not include NPCs in players listing.
        players = check_report.alliances.values.flatten.compact
      end

      assets = Combat.run(location, players, check_report.nap_rules,
        units, buildings)

      FowSsEntry.recalculate(location_point.id, true) \
        if ! assets.nil? && location_point.type == Location::SOLAR_SYSTEM
      
      assets
    end

    # Check +Location+ for opposing forces. If there are none, return false,
    # else - return Combat::CheckReport.
    #
    # Opposing forces are different players (when they are in different
    # alliances and those alliances don't have a +Nap+ between them) with
    # units in same location.
    #
    def check_for_enemies(location_attrs)
      player_ids = Location.fighting_player_ids(location_attrs)
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
          status = Combat::CheckReport::CONFLICT
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
            ! alliance_ids.detect do |alliance_id|
              (
                Set.new(nap_rules[alliance_id]) ^ alliance_ids
              ) != Set[alliance_id]
            end.nil?

          status = conflicts \
            ? Combat::CheckReport::CONFLICT \
            : Combat::CheckReport::NO_CONFLICT
        end
      end

      Combat::CheckReport.new(status, alliances, nap_rules)
    end
  end
end

