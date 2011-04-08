# Class for combat simulation
class Combat
  extend Combat::Raiding
  extend Combat::Simulation
  include Combat::Integration

  # Run combat in a +SsObject+ between +Player+ and NPC building.
  # Don't create cooldown.
  #
  def self.run_npc!(planet, player_units, target)
    npc_units = Unit.in_location(target.location_attrs).all
    combat = new(
      planet,
      {
        -1 => [planet.player],
        -2 => [NPC]
      },
      {},
      npc_units + player_units,
      []
    )
    combat.run(:cooldown => false)
  end

  ### Various helpers used by outer classes ###

  # Check location for opposing forces and initiate combat if needed.
  #
  # At first check cooldowns table - if the cooldown is still on we cannot
  # initiate any battles there.
  #
  # If there is no cooldown - check for any opposing forces. If there are any
  # - initiate combat in given location.
  #
  def self.check_location(location_point)
    location_attrs = location_point.location_attrs
    cooldown = Cooldown.in_location(location_attrs).first
    return false if cooldown

    check_report = check_for_enemies(location_point)
    assets = nil
    return_status = false
    if check_report.status == Combat::CheckReport::CONFLICT
      location = location_point.object
      buildings = location.is_a?(SsObject) \
        ? location.buildings.shooting.where(
          :state => Building::STATE_ACTIVE).all \
        : []

      assets = new(
        location,
        check_report.alliances.values.flatten,
        check_report.nap_rules,
        Unit.in_location(location_attrs).where("level > 0").all,
        buildings
      )

      FowSsEntry.recalculate(location_point.id, true) \
        if ! assets.nil? && location_point.type == Location::SOLAR_SYSTEM

      return_status = true
    end

    case location_point.type
    when Location::SS_OBJECT
      Combat::Annexer.annex!(
        location_point.object,
        check_report.status,
        check_report.alliances,
        # Pass nils if no combat was run.
        assets ? assets.report.outcomes : nil,
        assets ? assets.report.statistics[:points_earned] : nil
      )
    end

    return_status
  end

  # Check +Location+ for opposing forces. If there are none, return false,
  # else - return Combat::CheckReport.
  #
  # Opposing forces are different players (when they are in different
  # alliances and those alliances don't have a +Nap+ between them) with
  # units in same location.
  #
  def self.check_for_enemies(location_attrs)
    player_ids = Location.fighting_player_ids(location_attrs)
    alliances = Player.grouped_by_alliance(player_ids)
    nap_rules = {}

    if alliances.size < 2
      status = Combat::CheckReport::NO_CONFLICT
    else
      # Reject single players that don't belong to alliance.
      alliance_ids = alliances.keys.reject { |alliance_id| alliance_id < 0 }

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