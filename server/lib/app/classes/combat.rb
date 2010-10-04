# Class for combat simulation
class Combat
  # Special ID for NPC units
  NPC = nil

  # How much ticks does combat last?
  TICK_COUNT = CONFIG['combat.round.ticks']
  # Ratio (0..1) that defines how often shots hit the line that they are
  # targeting
  LINE_HIT_RATIO = CONFIG['combat.line_hit_ratio']

  # Neutral stance doesn't give any bonuses.
  STANCE_NEUTRAL = 0
  # Defensive stance increases defense at the expense of attack.
  STANCE_DEFENSIVE = 1
  # Aggressive stance increases attack at the expense of defense.
  STANCE_AGGRESSIVE = 2

  attr_writer :debug

  # #initialize +Combat+ and #run it.
  def self.run(*args)
    combat = new(*args)
    combat.run
  end

  # Run combat in a +Planet+ between +Player+ and NPC building.
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

  # Create +Combat+ object.
  #
  # _location_ is an object that includes +Location+.
  # _alliances_ is +Hash+ as gotten from Player#grouped_by_alliance
  # _nap_rules_ is +Hash+ as gotten from Nap#get_rules.
  # _units_ is +Array+ of +Unit+ objects.
  # _buildings_ is +Array+ of +Building+ objects in +Planet+ owner side.
  #
  def initialize(location, alliances, nap_rules, units, buildings=[])
    @location = location
    @alliances = alliances
    @nap_rules = nap_rules
    @units = units
    @buildings = buildings
  end
  
  # Runs combat, creates notifications for players, creates cooldown if
  # required and returns [combat_log, notification_ids]
  #
  # Options:
  # :cooldown (true) - should we create cooldown for that location after
  # combat?
  #
  # Returns +Combat::Assets+ object.
  def run(options={})
    LOGGER.block "Running combat simulation", :level => :info do
      options.reverse_merge!(:cooldown => true)
      report = run_combat

      # Create combat log
      log = CombatLog.create_from_combat!(report.replay_info)

      # Filter alliances for notifications.
      alliances = Combat::NotificationHelpers.alliances(report.alliances)

      # Group units
      grouped_by_player_id = \
        Combat::NotificationHelpers.group_units_by_player_id(@units)
      grouped_unit_counts = Combat::NotificationHelpers.report_unit_counts(
        grouped_by_player_id
      )

      # Create notifications
      notification_ids = {}
      cooldown = nil
      ActiveRecord::Base.transaction do
        @alliances.each do |alliance_id, alliance|
          alliance.each do |player|
            unless player == NPC
              leveled_up_units = Combat::NotificationHelpers.leveled_up_units(
                grouped_by_player_id[player.id]
              )
              yane_units = Combat::NotificationHelpers.group_to_yane(
                player.id,
                grouped_unit_counts,
                @alliances_list.player_id_to_alliance_id,
                @nap_rules
              )
              statistics = Combat::NotificationHelpers.statistics_for_player(
                report.statistics, player.id, alliance_id
              )

              notification = Notification.create_for_combat(
                player,
                alliance_id,
                Combat::NotificationHelpers.classify_alliances(
                  alliances,
                  player.id,
                  @alliances_list.player_id_to_alliance_id[player.id],
                  @nap_rules
                ),
                log.id,
                report.location,
                report.outcomes[player.id],
                yane_units,
                leveled_up_units,
                statistics
              )
              notification_ids[player.id] = notification.id
            end
          end
        end

        # Save updated units
        dead, alive = @units.partition { |unit| unit.dead? }
        Unit.save_all_units(alive) unless alive.blank?
        Unit.delete_all_units(dead, report.killed_by) unless dead.blank?

        # Save updated buildings
        @buildings.each do |building|
          if building.dead?
            building.destroy
          else
            building.save!
          end
        end

        # Create cooldown if needed
        cooldown = Cooldown.create_or_update!(
          @location,
          Time.now + CONFIG.evalproperty('combat.cooldown.duration')
        ) if options[:cooldown]
      end

      Assets.new(report, log, notification_ids, cooldown)
    end
  end

  # Runs combat and returns +Combat::Report+.
  def run_combat
    create_alliances_list
    # Copy alliances list hash now, because later, after round simulations,
    # much info will be gone.
    alliances_list = @alliances_list.as_json

    log, statistics, outcomes, killed_by = simulate_round

    Report.new(
      @location.client_location,
      alliances_list,
      @nap_rules,
      log,
      statistics,
      outcomes,
      killed_by
    )
  end

  protected
  # Create +AlliancesList+ object.
  # 
  # All units from one alliance and one flank goes to one Combat::Flank.
  #
  def create_alliances_list
    @alliances_list = Combat::AlliancesList.new(@nap_rules)

    @alliances.each do |alliance_id, alliance|
      @alliances_list[alliance_id] = Combat::Alliance.new(
        @alliances_list, alliance_id
      )

      alliance.each do |player|
        @alliances_list.register_player(alliance_id, player)
      end
    end

    @units.each do |unit|
      player_id = unit.player_id
      alliance = @alliances_list.alliance_for(player_id)
      if alliance.nil?
        raise GameLogicError.new(
          "Player with id #{player_id.inspect} not found in alliances: #{
            @alliances.inspect}"
        )
      end

      alliance[unit.flank] ||= Combat::Flank.new(alliance, unit.flank)
      alliance[unit.flank].push unit
    end

    unless @buildings.blank?
      if @location.is_a?(Planet)
        alliance = @alliances_list.alliance_for(@location[:player_id])
        if alliance.nil?

        end

        flank_index = alliance.next_flank_index
        alliance[flank_index] = Combat::Flank.new(alliance, flank_index,
          @buildings)
      else
        raise GameLogicError.new("There cannot be any buildings in space!")
      end
    end

    # Remove alliances that do not have flanks
    @alliances_list.cleanup!
  end

  # Simulates round and returns: [combat_log, statistics, outcomes]
  #
  def simulate_round
    player_ids = @alliances_list.player_ids

    # Initialize statistics data
    @damage_dealt_player = {}
    @damage_taken_player = {}
    @damage_dealt_alliance = {}
    @damage_taken_alliance = {}
    @xp_with_dead = {}
    @xp_earned = {}
    player_ids.each do |player_id|
      alliance_id = @alliances_list.alliance_id_for(player_id)
      @damage_dealt_player[player_id] = 0
      @damage_dealt_alliance[alliance_id] = 0
      @damage_taken_player[player_id] = 0
      @damage_taken_alliance[alliance_id] = 0
      @xp_with_dead[player_id] = 0
      @xp_earned[player_id] = 0
    end
    @killed_by = {}

    log = run_ticks
    calculate_unit_xp
    statistics = calculate_statistics(player_ids)
    outcomes = calculate_outcomes(player_ids)

    [log, statistics, outcomes, @killed_by]
  end
  
  private
  # Is this battle one alliance versus one alliance?
  def one_vs_one?
    @alliances_list.size == 2
  end

  # Runs ticks of one round.
  #
  # Returns +Array+ with combat log.
  #
  # Log format:
  #
  # log = [
  #   log_item,
  #   ...
  # ]
  #
  # log_item = [name, argument1, argument2, ...]
  #
  # Marks that tick has started:
  #   name = :tick
  #   arguments = :start
  #
  # Marks that tick has ended:
  #   name = :tick
  #   arguments = :end
  #
  # Marks unit firing:
  #   name = :fire
  #   arguments = unit_id, hits
  #   unit_id = [id, unit_type]
  #   unit_type =
  #     0 - unit
  #     1 - building (shooting)
  #     2 - building (passive)
  #   hits = [hit1, hit2, hit3, ...]
  #   hit = [gun_index, target_id, evaded, damage]
  #
  #   gun_index - index of the gun shooting (from 0)
  #   target_id - same as unit_id
  #   evaded - has unit evaded the shot?
  #   damage - how much damage has target received
  #
  # So it looks like this:
  #
  #  [
  #    [:tick, :start],
  #    [:fire, [1, 1], [
  #      [0, [4, 0], false, 120],
  #      [1, [5, 0], false, 120]
  #    ]],
  #    [:fire, [1, 0], [
  #      [0, [6, 0], false, 23]
  #    ]],
  #    [:tick, :end]
  #  ]
  def run_ticks
    log = []

    initiative_list = Combat::InitiativeList.new
    initiative_list.add_units(@alliances_list)

    # Do a certain number of ticks
    TICK_COUNT.times do |tick_index|
      log.push [:tick, :start]
      debug ">>> Tick #{tick_index + 1} started."

      # Go over all units in one tick
      initiative_list.each do |initiative, parallel_units_group|
        shooting_group = []

        debug "Shooting group started."
        # Go over each unit in alliance.
        parallel_units_group.each do |alliance_id, unit|
          debug "Unit activation:", {
            :initiative => initiative,
            :alliance_id => alliance_id,
            :unit => unit.to_s
          }

          enemy_alliance_id = @alliances_list.enemy_id_for(alliance_id)

          if enemy_alliance_id.nil?
            debug "No more enemies."
          else
            # One unit can shoot from multiple guns.
            debug "Selected enemy alliance id: #{enemy_alliance_id}"

            shots = shoot_guns(unit, @alliances_list[enemy_alliance_id])
            shooting_group.push [
              :fire, Combat::Participant.pair(unit), shots
            ] unless shots.blank?
          end
        end
        debug "Shooting group ended."

        log.push [:group, shooting_group] unless shooting_group.blank?
        @alliances_list.commit_deletes
      end

      debug ">>> Tick #{tick_index + 1} finished."
      debug

      # TODO: perhaps this can be removed?
      log.push [:tick, :end]

      # No one has anywhere to shoot so combat sort-of ended.
      break unless @alliances_list.enemies_left?
    end

    log
  end

  def calculate_unit_xp
    # Calculate how much XP in total we earned.
    @units.each do |unit|
      # NPC units don't accumulate XP. Stupid things.
      unless unit.npc?
        from, to = unit.xp_change
        unit_xp_earned = (to || 0) - (from || 0)
        # Dead units don't earn XP in this counter
        @xp_earned[unit.player_id] += unit_xp_earned unless unit.dead?
        # But they do in this one
        @xp_with_dead[unit.player_id] += unit_xp_earned
      end
    end
  end

  def calculate_statistics(player_ids)
    points_earned = calculate_points(player_ids)

    {
      :damage_dealt_player => @damage_dealt_player,
      :damage_dealt_alliance => @damage_dealt_alliance,
      :damage_taken_player => @damage_taken_player,
      :damage_taken_alliance => @damage_taken_alliance,
      :xp_earned => @xp_earned,
      :points_earned => points_earned
    }
  end

  # Calculate points earned from earned XP (including dead units)
  def calculate_points(player_ids)

    points_earned = {}
    player_ids.each do |player_id|
      points_earned[player_id] = CONFIG.calculate(
        "ranking.points.war",
        {
          'xp_with_dead' => @xp_with_dead[player_id],
          'xp' => @xp_earned[player_id]
        }
      ).round
    end
    points_earned
  end

  # Calculate player outcomes
  def calculate_outcomes(player_ids)
    outcomes = {}
    player_ids.each do |player_id|
      if @alliances_list.player_alive?(player_id)
        if @alliances_list.player_has_enemies?(player_id)
          outcomes[player_id] = Report::OUTCOME_TIE
        else
          outcomes[player_id] = Report::OUTCOME_WIN
        end
      else
        outcomes[player_id] = Report::OUTCOME_LOSE
      end
    end
    outcomes
  end

  def shoot_guns(unit, enemy)
    shots = []
    unit.guns.each do |gun|
      if gun.cooling_down?
        debug "  #{gun} cooling down..."
        gun.cool_down
      else
        debug "  #{gun} ready."
        shot = shoot_gun(gun, enemy)
        # shot can be nil if we couldn't hit anything with this weapon
        shots.push shot unless shot.nil?
      end
    end

    shots
  end

  def shoot_gun(gun, enemy)
    # Filter flanks by reach, we can only shoot those ones that we reach.
    reachable_flanks = []
    enemy.each do |flank_index, flank|
      reachable_flanks.push(flank) if flank.has?(gun.reach)
    end
    reachable_count = reachable_flanks.size
    debug "    Gun can reach #{reachable_count}/#{enemy.size} flanks."

    return nil if reachable_count == 0

    enemy_flank = nil
    if one_vs_one?
      flank_index = 0
      # Try to hit any flank.
      while flank_index < reachable_count and enemy_flank.nil?
        # If we have hit something (last reachable line or
        # random was successful)
        # <= because 0.7 means that will be 70% chance it will hit.
        if flank_index == reachable_count - 1 or rand <= LINE_HIT_RATIO
          enemy_flank = reachable_flanks[flank_index]        
        else
          # Skip to next flank
          debug "    Miss at flank #{flank_index}!"
        end

        flank_index += 1
      end
    else
      # In FFA just select a random flank.
      enemy_flank = reachable_flanks.random_element
    end

    enemy_unit = enemy_flank.rand(gun.reach)

    debug "    Selected enemy:", {
      :flank => flank_index,
      :enemy_unit => enemy_unit
    }

    shot = hit_enemy_unit(gun, enemy_unit)

    # he's dead jim
    if enemy_unit.dead?
      debug "      Enemy dead: #{enemy_unit}"
      @killed_by[enemy_unit] = gun.owner.player_id
      enemy_flank.delete(enemy_unit)
    end

    shot
  end

  def hit_enemy_unit(gun, enemy_unit)
    damage = 0

    evaded = false
    evasiveness = enemy_unit.evasiveness
    if evasiveness == 0 or rand > evasiveness
      gun_owner = gun.owner
      player_id = gun_owner.player_id

      damage = gun.shoot(enemy_unit)

      # Record statistics
      @damage_dealt_player[player_id] += damage
      @damage_dealt_alliance[
        @alliances_list.alliance_id_for(player_id)
      ] += damage
      @damage_taken_player[enemy_unit.player_id] += damage
      @damage_taken_alliance[
        @alliances_list.alliance_id_for(enemy_unit.player_id)
      ] += damage

      # Increase experience
      unit_xp, enemy_xp = self.class.get_xp(enemy_unit, damage)
      gun_owner.xp += unit_xp
      enemy_unit.xp += enemy_xp

      debug "    Hit:", {
        :damage => damage,
        :experience => unit_xp,
        :enemy_experience => enemy_xp,
        :target => enemy_unit
      }
    else
      evaded = true
      debug "    Whoops, missed (evasiveness: #{evasiveness})!"
    end

    [gun.index, Combat::Participant.pair(enemy_unit), evaded, damage]
  end

  def debug(message="", properties={})
    if @debug
      # 32 is space: " "
      indent = (message[0] == 32) \
        ? message.split(/\b/)[0].length \
        : 0
      puts message
      properties.keys.each do |key|
        puts " " * (indent + 4) + "#{key}: #{properties[key].to_s}"
      end
    end
  end

  def self.get_xp(target, damage)
    params = {'damage' => damage}
    attacker_xp = CONFIG.calculate("combat.xp.fire", params)
    target_xp = CONFIG.calculate("combat.xp.hit", params)
    [(attacker_xp * target.xp_modifier).round, target_xp]
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
      buildings = location.is_a?(Planet) \
        ? location.buildings.shooting.all \
        : []

      assets = run(
        location,
        check_report.alliances,
        check_report.nap_rules,
        Unit.in_location(location_attrs).all,
        buildings
      )
      return_status = true
    end

    if location_point.type == Location::PLANET
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
        nap_rules = Nap.get_rules(alliance_ids)

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