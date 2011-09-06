module Combat::Simulation  
  # Runs combat, creates notifications for players and creates cooldown if
  # required.
  #
  # Options:
  # :cooldown (true) - should we create cooldown for that location after
  # combat?
  #
  # Returns +Combat::Assets+ object or nil if no combat happened.
  def run(location, players, nap_rules, units, buildings, options={})
    LOGGER.block("Running combat simulation in #{location.to_s}") do
      options.reverse_merge!(:cooldown => true)

      # Prepare arguments for SpaceMule.
      mule_location, planet_owner_id, alliance_names, mule_players, troops,
        unloaded_units, unloaded_unit_ids, unloaded_troops, 
        mule_buildings = 
        prepare_arguments(location, players, units, buildings)

      # Invoke simulation.
      response = SpaceMule.instance.combat(
        mule_location.as_json, planet_owner_id,
        nap_rules, alliance_names, mule_players, troops, unloaded_troops, 
        unloaded_unit_ids, mule_buildings)

      if response['no_combat']
        nil
      else
        # Unwrap JSON'ified hash keys to normal ruby hashes.
        %w{outcomes classified_alliances yane statistics}.each do |attr|
          response[attr] = unwrap_json_hash(response[attr])
        end
        
        # Apply XP/HP changes.
        all_units = units + unloaded_units.values.flatten
        hashed_units = all_units.hash_by(&:id)
        hashed_buildings = buildings.hash_by(&:id)
        apply_changes(hashed_units, response['troop_changes'])
        apply_changes(hashed_buildings, response['building_changes'])
        killed_by = parse_killed_by(hashed_units, hashed_buildings,
          response['killed_by'])

        generate_assets(players, location, nap_rules, all_units, buildings,
          killed_by, response, options)
      end
    end
  end
  
  # Unwraps keys from strings in _source_.
  #      
  # Example:
  #    Combat.unwrap_json_hash('1' => 'foo', Combat::NPC_SM => 'bar').
  #      should == {1 => 'foo', Combat::NPC => 'bar'}
  #
  def unwrap_json_hash(source)
    source.inject({}) do |hash, pair|
      string_player_id, value = pair
      player_id = string_player_id == Combat::NPC_SM \
        ? Combat::NPC : string_player_id.to_i
      hash[player_id] = value
      hash
    end
  end

  def generate_assets(players, location, nap_rules, units, buildings,
      killed_by, response, options)
    client_location = location.client_location
    replay_info = CombatLog.replay_info(client_location,
      response['alliances'], nap_rules, response['outcomes'],
      response['log'])

    # Create combat log
    combat_log = CombatLog.create_from_combat!(replay_info)

    notification_ids = nil
    cooldown = nil

    ActiveRecord::Base.transaction do
      wreckages = add_wreckages(location, buildings, units)
      notification_ids = create_notifications(response, client_location,
        filter_leveled_up(units), combat_log, wreckages)
      save_players(players, response['statistics'])
      save_updated_participants(units, buildings, killed_by)
      cooldown = create_cooldown(location, response['outcomes']) \
        if options[:cooldown]
      Objective::Battle.progress(response['outcomes'])
    end

    Combat::Assets.new(response, combat_log, notification_ids, cooldown)
  end

  # Troop representation for SpaceMule.
  def troop(troop)
    {:id => troop.id, :type => troop.type, :level => troop.level,
      :hp => troop.hp, :flank => troop.flank, :player_id => troop.player_id,
      :stance => troop.stance, :xp => troop.xp}
  end
  
  # Special value for overpopulation mod.
  # Defined in SpaceMule: 
  # spacemule.modules.combat.objects.Player.Technologies.ModsMap.Overpopulation
  OVERPOPULATION_TECH_MOD = 'overpopulation'

  # Returns two +Hash+es (damage and armor) with {class_name => mod} pairs.
  #
  # _mod_ is a +Float+.
  def technologies_for(player)
    technologies = TechTracker.query_active(player.id, 'damage', 'armor').all
    damage_mods = TechModApplier.apply(technologies, 'damage')
    armor_mods = TechModApplier.apply(technologies, 'armor')
    
    # Player#overpopulation_mod returns (0..1], and we need (-1..1) in 
    # SpaceMule.
    overpopulation_mod = player.overpopulation_mod - 1
    damage_mods[OVERPOPULATION_TECH_MOD] = overpopulation_mod
    armor_mods[OVERPOPULATION_TECH_MOD] = overpopulation_mod

    [damage_mods, armor_mods]
  end

  # Returns loaded units which are inside _transporters_ and +Set+ of 
  # unloaded unit ids. If _unload_ is true, then also unloads them to 
  # _location_. In such case transporter #stored attributes are also 
  # reduced.
  #
  def loaded_units(location, transporters, unload)
    loaded_units = {}
    unloaded_unit_ids = Set.new
    non_combat_types = Unit.non_combat_types

    transporters.each do |unit|
      if unit.stored > 0
        unit.units.each do |loaded_unit|
          loaded_units[unit.id] ||= []
          loaded_units[unit.id].push loaded_unit
          if unload && ! non_combat_types.include?(loaded_unit[:type])
            # Don't unload non-combat types.
            unloaded_unit_ids.add loaded_unit.id
            unit.stored -= loaded_unit.volume
            loaded_unit.location = location
          end
        end
      end
    end

    [loaded_units, unloaded_unit_ids]
  end

  # Applies _changes_ to items hashed by id.
  def apply_changes(hashed_items, changes)
    changes.each do |id, attributes|
      # JSON only allows strings in hash keys.
      item = hashed_items[id.to_i]
      attributes.each do |attribute, value|
        item.send(:"#{attribute}=", value)
      end
    end
  end

  # Parses _killed_by_ from SpaceMule and returns
  # {unit/building => player_id} hash.
  def parse_killed_by(hashed_units, hashed_buildings, killed_by)
    Hash[killed_by.map do |string_key, player_id|
      type = string_key[0..0] # Ruby 1.8 compatibility
      id = string_key[1..-1].to_i

      [type == "t" ? hashed_units[id] : hashed_buildings[id], player_id]
    end]
  end

  # Filters units leaving only those that can level up, grouping by player 
  # id.
  #
  # Example output:
  # {
  #   10 => [
  #     {:type => "Unit::Trooper", :hp => 10, :level => 3,
  #       :stance => Combat::STANCE_*},
  #     ...
  #   ],
  #   ...
  # }
  #
  def filter_leveled_up(units)
    units.inject({}) do |hash, unit|
      hash[unit.player_id] ||= []
      unless unit.dead? or (level_count = unit.can_upgrade_by).zero?
        hash[unit.player_id] << {
          :type => unit.class.to_s,
          :hp => unit.hp,
          :level => unit.level + level_count,
          :stance => unit.stance
        }
      end
      hash
    end
  end

  # Prepares arguments for SpaceMule.
  def prepare_arguments(location, players, units, buildings)
    if location.is_a?(SsObject::Planet)
      mule_location = location.location_point
      planet_owner_id = location.player_id
    else
      mule_location = location
      planet_owner_id = nil
    end

    alliance_ids = players.map(&:alliance_id).compact.uniq
    alliance_names = Alliance.names_for(alliance_ids)
    mule_players = players.map_into_hash do |player|
      damage_tech_mods, armor_tech_mods = technologies_for(player)

      hash = {
        :alliance_id => player.alliance_id,
        :name => player.name,
        :damage_tech_mods => damage_tech_mods,
        :armor_tech_mods => armor_tech_mods
      }

      [player.id, hash]
    end

    troops = units.map { |u| troop(u) }
    # Units which are loaded into transporters.
    loaded_units, unloaded_unit_ids = loaded_units(location, units,
      location.is_a?(SsObject::Planet))
    loaded_troops = loaded_units.inject({}) do |hash, entry|
      transporter_id, unloaded = entry
      hash[transporter_id] = unloaded.map { |u| troop(u) }
      hash
    end

    mule_buildings = buildings.map do |building|
      {:id => building.id, :type => building.type, :level => building.level,
        :hp => building.hp}
    end

    [mule_location, planet_owner_id, alliance_names, mule_players,
      troops, loaded_units, unloaded_unit_ids, loaded_troops, 
      mule_buildings]
  end
end
