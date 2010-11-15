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

  KIND_GROUND = Parts::Shooting::KIND_GROUND
  KIND_SPACE = Parts::Shooting::KIND_SPACE

  include Combat::Integration

  attr_writer :debug

  # #initialize +Combat+ and #run it.
  def self.run(*args)
    combat = new(*args)
    combat.run
  end

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

  # Create +Combat+ object.
  #
  # _location_ is an object that includes +Location+.
  # _alliances_ is +Hash+ as gotten from Player#grouped_by_alliance
  # _nap_rules_ is +Hash+ as gotten from Nap#get_rules.
  # _units_ is +Array+ of +Unit+ objects.
  # _buildings_ is +Array+ of +Building+ objects in +SsObject+ owner side.
  #
  def initialize(location, alliances, nap_rules, units, buildings=[])
    @location = location
    @alliances = alliances
    @nap_rules = nap_rules
    @units = units
    @buildings = buildings
  end
  
  # Runs combat, creates notifications for players and creates cooldown if
  # required.
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
      if report
        # Create combat log
        log = CombatLog.create_from_combat!(report.replay_info)

        notification_ids = nil
        cooldown = nil
        ActiveRecord::Base.transaction do
          notification_ids = create_notifications(report, log)
          save_updated_participants(report)
          cooldown = create_cooldown if options[:cooldown]
        end

        Assets.new(report, log, notification_ids, cooldown)
      else
        # No combat can be initiated because nobody can shoot anyone.
        nil
      end
    end
  end

  # Returns if combat can carry on. If nobody can shoot anyone and no units
  # can be unloaded - this will return false. This can happen if one side
  # only has space units and other side only has ground units.
  def can_combat?
    # What kinds of units alliance has.
    alliance_kinds = {}
    # What kinds of units alliance can attack.
    alliance_reaches = {}
    # Can alliance unload units?
    can_unload = {}

    @alliances_list.each do |alliance_id, alliance|
      alliance_kinds[alliance_id] = {
        KIND_GROUND => false, KIND_SPACE => false}
      alliance_reaches[alliance_id] = {
        KIND_GROUND => false, KIND_SPACE => false}
      
      kinds = alliance_kinds[alliance_id]
      reaches = alliance_reaches[alliance_id]

      catch :next_alliance do
        alliance.each do |flank_index, flank|
          # Check flank for unit kinds
          kinds[KIND_GROUND] = true if flank.has?(KIND_GROUND)
          kinds[KIND_SPACE] = true if flank.has?(KIND_SPACE)

          # Check flank units for guns and their reaches
          flank.each do |participant|
            can_unload[alliance_id] = true if participant.is_a?(Unit) &&
              participant.stored > 0

            participant.guns.each do |gun|
              reaches[KIND_GROUND] = true if gun.ground?
              reaches[KIND_SPACE] = true if gun.space?

              # There cannot be anything more to make true, so just skip to
              # next alliance.
              throw :next_alliance if kinds[KIND_GROUND] &&
                kinds[KIND_SPACE] && reaches[KIND_GROUND] &&
                reaches[KIND_SPACE] && can_unload[alliance_id]
            end
          end
        end
      end
    end

    # Check if ANYONE can hit someone.
    @alliances_list.enemy_ids.each do |alliance_id, enemy_alliance_ids|
      your_reaches = alliance_reaches[alliance_id]

      enemy_alliance_ids.each do |enemy_alliance_id|
        enemy_kinds = alliance_kinds[enemy_alliance_id]
        if (enemy_kinds[KIND_GROUND] && your_reaches[KIND_GROUND]) ||
            (enemy_kinds[KIND_SPACE] && your_reaches[KIND_SPACE]) ||
            can_unload[alliance_id]
          LOGGER.debug "Combat can begin."
          return true
        end
      end
    end

    LOGGER.debug "Combat cannot begin because no one can shoot anyone."
    false
  end

  # Runs combat and returns +Combat::Report+.
  def run_combat
    create_alliances_list

    if can_combat?
      retrieve_technologies

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
    else
      nil
    end
  end

  protected
  # Create +AlliancesList+ object.
  # 
  # All units from one alliance and one flank goes to one Combat::Flank.
  #
  # Also creates @stored_units hash:
  # {
  #   transporter.id => [
  #     [unit, unit, unit], # Flank 1
  #     [unit, unit, unit], # Flank 2
  #   ]
  # }
  #
  def create_alliances_list
    @alliances_list = Combat::AlliancesList.new(@nap_rules)
    @stored_units = {}

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

      alliance.add_unit(unit)

      # Check if this is a transported and has something stored there.
      if unit.stored > 0
        @stored_units[unit.id] = []

        # Find all units that are stored in that transported and group them
        # by flanks
        flanks = {}
        unit.units.each do |transportable|
          flanks[transportable.flank] ||= []
          flanks[transportable.flank].push transportable
        end

        # Add flanks to stored units list in sorted fashion (1, 2, 3...)
        flanks.keys.sort.each do |flank_index|
          @stored_units[unit.id].push flanks[flank_index]
        end
      end
    end

    unless @buildings.blank?
      if @location.is_a?(SsObject)
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

  def retrieve_technologies
    player_ids = []
    @tech_damage_mods = {}
    @tech_armor_mods = {}

    @alliances.each do |alliance_id, alliance|
      alliance.each do |player|
        # NPC's don't have technologies.
        unless player.nil?
          player_ids.push player.id
          @tech_damage_mods[player.id] = {}
          @tech_armor_mods[player.id] = {}
        end
      end
    end

    add_mod = lambda do |store, technology, formula|
      player_id = technology.player_id

      technology.applies_to.each do |class_name|
        store[player_id][class_name] ||= 0
        store[player_id][class_name] += CONFIG.safe_eval(formula,
          'level' => technology.level)
      end
    end

    # Look up all damage and armor mods.
    Technology.where("level >= 1 AND player_id IN (?)", player_ids).each do
      |technology|

      add_mod.call(@tech_damage_mods, technology,
        technology.damage_mod_formula) if technology.damage_mod?
      add_mod.call(@tech_armor_mods, technology,
        technology.armor_mod_formula) if technology.armor_mod?
    end
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
  # Marks that tick has started:
  #   log_item = [:tick, :start]
  #
  # Marks that tick has ended:
  #   log_item = [:tick, :end]
  #
  # Marks unit firing:
  #   log_item = [:fire, unit_id, hits]
  #     unit_id = [id, unit_type]
  #       unit_type =
  #         0 - unit
  #         1 - building (shooting)
  #         2 - building (passive)
  #     hits = [hit, hit, hit, ...]
  #       hit = [gun_index, target_id, evaded, damage]
  #         gun_index - index of the gun shooting (from 0)
  #         target_id - same as unit_id
  #         evaded - has unit evaded the shot?
  #         damage - how much damage has target received
  #
  # Marks unit teleportation:
  #   log_item = [:appear, transporter_id, unit, flank_index]
  #     transporter_id - id of the transporter unit
  #     unit - Combat::Participant#as_json
  #     flank_index - Unit#flank
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

    @initiative_list = Combat::InitiativeList.new
    @initiative_list.add_units(@alliances_list)

    # Temporary waiting list for units waiting to join initiative list.
    @teleported_units = []

    # Do a certain number of ticks
    TICK_COUNT.times do |tick_index|
      # Add teleported units to initiative list for the next tick.
      @teleported_units.each do |alliance_id, unit|
        # Add unit to units list so it would get updated/deleted.
        @units.push unit

        # Dead units shouldn't join our ranks. It might have been killed
        # whilst it was waiting to shoot.
        if unit.dead?
          debug "Not adding dead unit to initiative list", :unit => unit
        else
          debug "Addind unit to initiative list", :unit => unit
          @initiative_list.add(alliance_id, unit)
        end
      end
      @teleported_units.clear

      log.push [:tick, :start]
      debug ">>> Tick #{tick_index + 1} started."

      # Go over all units in one tick
      @initiative_list.each do |initiative, parallel_units_group|
        paralel_group = []

        debug "> Parallel group started", :initiative => initiative
        # Go over each unit in alliance.
        parallel_units_group.each do |alliance_id, unit|
          debug "\nUnit activation:", {
            :alliance_id => alliance_id,
            :unit => unit.to_s
          }

          if @location.is_a?(SsObject) && has_stored_units?(unit)
            # Try to teleport unit out of transporter.
            unloaded_unit = unload_unit_from(unit)
            paralel_group.push [:appear, unit.id,
              Combat::Participant.as_json(unloaded_unit), unit.flank]
          else
            # Just a regular shot
            enemy_alliance_id = @alliances_list.enemy_id_for(alliance_id)

            if enemy_alliance_id.nil?
              debug "No more enemies."
            else
              # One unit can shoot from multiple guns.
              debug "Selected enemy alliance id: #{enemy_alliance_id}"

              shots = shoot_guns(unit, @alliances_list[enemy_alliance_id])
              paralel_group.push [
                :fire, Combat::Participant.pair(unit), shots
              ] unless shots.blank?
            end
          end
        end
        debug "> Parallel group ended."

        log.push [:group, paralel_group] unless paralel_group.blank?
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
  
  def has_stored_units?(transporter)
    ! @stored_units[transporter.id].blank?
  end

  # Teleports unit from _transporter_ into _location_.
  def unload_unit_from(transporter)
    # Always add things from flank which is in front.
    flank = @stored_units[transporter.id][0]
    unit = flank.random_element
    flank.delete(unit)
    # Remove flanks upon depletion.
    @stored_units[transporter.id].shift if flank.blank?

    volume = unit.volume
    transporter.stored -= volume

    unit.location = @location
    alliance_id = @alliances_list.alliance_id_for(unit.player_id)
    @alliances_list[alliance_id].add_unit(unit)
    # Add unit to waiting list, it be added to initiative list in next turn.
    @teleported_units.push [alliance_id, unit]

    debug "Teleportation", :unit => unit, :volume => volume

    unit
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

  # Returns calculated damage mod (damage - armor) for given unit. Returns
  # percentage (e.g. 10).
  def calc_technologies_damage_mod(unit)
    player_id = unit.player_id
    # NPC's don't have technologies
    return 0 if player_id.nil?
    
    damage_mod = @tech_damage_mods[player_id][unit.class.to_s] || 0
    armor_mod = @tech_armor_mods[player_id][unit.class.to_s] || 0

    damage_mod - armor_mod
  end

  def hit_enemy_unit(gun, enemy_unit)
    damage = 0

    evaded = false
    evasiveness = enemy_unit.evasiveness
    if evasiveness == 0 or rand > evasiveness
      gun_owner = gun.owner
      player_id = gun_owner.player_id

      damage = gun.shoot(enemy_unit,
        calc_technologies_damage_mod(gun_owner))

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
      buildings = location.is_a?(SsObject) \
        ? location.buildings.shooting.all \
        : []

      assets = run(
        location,
        check_report.alliances,
        check_report.nap_rules,
        Unit.in_location(location_attrs).all,
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