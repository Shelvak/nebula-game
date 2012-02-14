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

      # Units which are loaded into transporters.
      loaded_units, unloaded_unit_ids = loaded_units(
        location, units, location.is_a?(SsObject::Planet)
      )
      # Invoke simulation.
      response = Celluloid::Actor[:space_mule].
        combat(location, players, nap_rules, units, loaded_units,
               unloaded_unit_ids, buildings)

      if response.nil?
        nil
      else
        # Transform scala response to legacy Ruby Hash.
        ruby_response = {
          'log' => response.log.from_scala,
          'killed_by' => response.killedBy.from_scala,
          'statistics' => transform_statistics(response.statistics),
          'outcomes' => transform_outcomes(response.outcomes),
          'alliances' => response.alliances.from_scala,
          'classified_alliances' => response.classifiedAlliances.from_scala,
          'troop_changes' => response.troopChanges.from_scala,
          'building_changes' => response.buildingChanges.from_scala,
          'yane' => response.yane.from_scala
        }

        # Apply XP/HP changes.
        all_units = units + loaded_units.values.map(&:to_a).flatten
        hashed_units = all_units.hash_by(&:id)
        hashed_buildings = buildings.hash_by(&:id)
        apply_changes(hashed_units, ruby_response['troop_changes'])
        apply_changes(hashed_buildings, ruby_response['building_changes'])
        killed_by = parse_killed_by(hashed_units, hashed_buildings,
          ruby_response['killed_by'])

        generate_assets(players, location, nap_rules, all_units, buildings,
          killed_by, ruby_response, options)
      end
    end
  end

  # Transforms Scala statistics to Ruby statistics +Hash+
  def transform_statistics(scala_statistics)
    statistics = {}
    scala_statistics.foreach do |tuple|
      player, player_data = tuple._1, tuple._2
      statistics[player.empty? ? nil : player.get.id] =
        player_data.to_map.from_scala
    end
    statistics
  end

  # Transforms Scala outcomes to Ruby outcomes +Hash+
  def transform_outcomes(scala_outcomes)
    outcomes = {}
    scala_outcomes.foreach do |tuple|
      player, outcome = tuple._1, tuple._2
      outcomes[player.empty? ? nil : player.get.id] = outcome.id
    end
    outcomes
  end

  def generate_assets(players, location, nap_rules, units, buildings,
      killed_by, response, options)
    client_location = location.client_location

    # Create combat log
    replay_info = CombatLog.replay_info(
      client_location,
      response['alliances'],
      nap_rules,
      response['outcomes'],
      response['log']
    )
    combat_log = CombatLog.create_from_combat!(replay_info)

    wreckages = add_wreckages(location, buildings, units)
    notification_ids = create_notifications(
      response, client_location, filter_leveled_up(units), combat_log,
      wreckages
    )
    save_players(players, response['statistics'])
    save_updated_participants(units, buildings, killed_by)
    cooldown = options[:cooldown] \
      ? create_cooldown(location, response['outcomes']) \
      : nil
    Objective::Battle.progress(response['outcomes'])

    Combat::Assets.new(response, combat_log, notification_ids, cooldown)
  end

  # Returns loaded units which are inside _transporters_
  # (Hash of {transporter_id => Set[Unit]}) and +Set+ of
  # unloaded unit ids.
  #
  # If _unload_ is true, then also unloads them to _location_. In such case
  # transporter #stored attributes are also reduced.
  #
  def loaded_units(location, transporters, unload)
    loaded_units = {}
    unloaded_unit_ids = Set.new
    non_combat_types = Unit.non_combat_types

    transporters.each do |transporter|
      if transporter.stored > 0
        transporter.units.each do |unit|
          loaded_units[transporter.id] ||= Set.new
          loaded_units[transporter.id].add unit

          if unload && ! non_combat_types.include?(unit[:type])
            # Don't unload non-combat types.
            unloaded_unit_ids.add unit.id
            transporter.stored -= unit.volume
            unit.location = location
          end
        end
      end
    end

    [loaded_units, unloaded_unit_ids]
  end

  # Applies _changes_ to items hashed by id.
  def apply_changes(hashed_items, changes)
    changes.each do |id, attributes|
      item = hashed_items[id]
      attributes.each do |attribute, value|
        item.send(:"#{attribute}=", value)
      end
    end
  end

  # Parses _killed_by_ from SpaceMule and returns
  # {unit/building => player_id} hash.
  def parse_killed_by(hashed_units, hashed_buildings, killed_by)
    Hash[killed_by.map do |sm_combatant, sm_player_opt|
      combatant = case sm_combatant
      when SpaceMule::Combat::CO::Troop
        hashed_units[sm_combatant.id]
      when SpaceMule::Combat::CO::Building
        hashed_buildings[sm_combatant.id]
      end

      player_id = sm_player_opt.empty? ? nil : sm_player_opt.get.id

      [combatant, player_id]
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
end
