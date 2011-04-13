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
    LOGGER.block("Running combat simulation in #{@location.to_s}") do
      options.reverse_merge!(:cooldown => true)

      # Prepare arguments for SpaceMule.
      mule_location, planet_owner_id, alliance_names, mule_players, troops,
        unloaded_units, unloaded_troops, mule_buildings = prepare_arguments(
        location, players, units, buildings)

      # Invoke simulation.
      response = SpaceMule.instance.combat(
        mule_location.as_json, planet_owner_id,
        nap_rules, alliance_names, mule_players, troops, unloaded_troops,
        mule_buildings)

      if response['no_combat']
        nil
      else
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
    end

    Combat::Assets.new(response, combat_log, notification_ids, cooldown)
  end

  # Troop representation for SoaceMule.
  def troop(troop)
    {:id => troop.id, :type => troop.type, :level => troop.level,
      :hp => troop.hp, :flank => troop.flank, :player_id => troop.player_id,
      :stance => troop.stance, :xp => troop.stance}
  end

  # Returns two +Hash+es (damage and armor) with {class_name => mod} pairs.
  #
  # _mod_ is a +Float+.
  def technologies_for(player)
    damage_mods = {}
    armor_mods = {}

    add_mod = lambda do |store, technology, formula|
      technology.applies_to.each do |class_name|
        store[class_name] ||= 0
        store[class_name] += CONFIG.safe_eval(
          formula, 'level' => technology.level
        ).to_f / 100
      end
    end

    Technology.where("level >= 1 AND player_id = ?", player.id).each do
      |technology|

      add_mod.call(damage_mods, technology,
        technology.damage_mod_formula) if technology.damage_mod?
      add_mod.call(armor_mods, technology,
        technology.armor_mod_formula) if technology.armor_mod?
    end

    [damage_mods, armor_mods]
  end

  # Unloads loaded units from _units_ and sets their _location_. Transporter
  # #stored attributes are also reduced.
  def loaded_units(location, units, unload)
    loaded_units = {}

    units.each do |unit|
      if unit.stored > 0
        unit.units.each do |loaded_unit|
          loaded_units[unit.id] ||= []
          loaded_units[unit.id].push loaded_unit
          if unload
            unit.stored -= loaded_unit.volume
            loaded_unit.location = location
          end
        end
      end
    end

    loaded_units
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
      type = string_key[0]
      id = string_key[1..-1].to_i

      [type == "t" ? hashed_units[id] : hashed_buildings[id], player_id]
    end]
  end

  # Filters units leaving only those that can level up.
  #
  # Example output:
  # [
  #   {:type => "Unit::Trooper", :hp => 10, :level => 3,
  #     :stance => Combat::STANCE_*},
  #   ...
  # ]
  #
  def filter_leveled_up(units)
    units.map do |unit|
      if unit.dead?
        nil
      else
        level_count = unit.can_upgrade_by
        if level_count == 0
          nil
        else
          {
            :type => unit.class.to_s,
            :hp => unit.hp,
            :level => unit.level + level_count,
            :stance => unit.stance
          }
        end
      end
    end.compact
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
    loaded_units = loaded_units(location, units,
      location.is_a?(SsObject::Planet))
    loaded_troops = Hash[
      loaded_units.map do |transporter_id, unloaded|
        [transporter_id, unloaded.map { |u| troop(u) }]
      end
    ]

    mule_buildings = buildings.map do |building|
      {:id => building.id, :type => building.type, :level => building.level,
        :hp => building.hp}
    end

    [mule_location, planet_owner_id, alliance_names, mule_players,
      troops, loaded_units, loaded_troops, mule_buildings]
  end
end
