module Combat::Integration
  OUTCOME_WIN = 0
  OUTCOME_LOSE = 1
  OUTCOME_TIE = 2

  # Returns {player_id => notification_id} hash.
  def create_notifications(args)
    typesig binding, Hash
    args.ensure_options!(required: {
      response: Hash,
      client_location: ClientLocation,
      building_type: [String, NilClass],
      building_attacker_id: [Fixnum, NilClass],
      leveled_up_units: Hash,
      combat_log: CombatLog,
      wreckages: Hash,
      skip_push_notifications_for: Array
    })

    response = args[:response]
    client_location_as_json = args[:client_location].as_json
    leveled_up_units = args[:leveled_up_units]
    skip_push_notifications_for = args[:skip_push_notifications_for]

    response['alliances'].each_with_object({}) do
      |(alliance_id, alliance), hash|

      alliance['players'].each do |player|
        if player.nil?
          nil
        else
          player_id = player[0]

          notification = Notification.create_for_combat(
            player_id,
            alliance_id: alliance_id,
            alliances: response['classified_alliances'][player_id],
            combat_log_id: args[:combat_log].sha1_id,
            location_attrs: client_location_as_json,
            building_type: args[:building_type],
            building_attacker_id: args[:building_attacker_id],
            outcome: response['outcomes'][player_id],
            yane_units: response['yane'][player_id],
            leveled_up_units: leveled_up_units[player_id],
            statistics: response['statistics'][player_id],
            wreckages: args[:wreckages],
            push_notification: ! skip_push_notifications_for.include?(player_id)
          )

          hash[player_id] = notification.id
        end
      end
    end
  end

  def add_wreckages(location, units, buildings)
    metal, energy, zetium = Wreckage.calculate(
      (units + buildings).reject { |i| i.alive? }
    )
    Wreckage.add(location, metal, energy, zetium)
    {'metal' => metal.round(4), 'energy' => energy.round(4),
      'zetium' => zetium.round(4)}
  end

  def save_updated_participants(units, buildings, killed_by)
    # Save updated units. We add COMBAT reason to this because there might
    # be updated/destroyed units which were unloaded from transporter and
    # client does not know about them so it needs this reason to act
    # accordingly.
    dead, alive = units.partition { |unit| unit.dead? }
    # Save units first, so that location of them would be changed if they
    # got unloaded. Otherwise deletion would first remove them (because DB
    # still thinks they are in a transporter) and save would have nothing
    # to save (and update fails silently because there is no record with
    # those particular ids).
    Unit.save_all_units(alive, EventBroker::REASON_COMBAT) \
      unless alive.blank?

    Unit.delete_all_units(dead, killed_by, EventBroker::REASON_COMBAT) \
      unless dead.blank?

    # Save updated buildings
    dead, alive = buildings.partition { |building| building.dead? }
    # This dispatches event via Parts::Notifier
    dead.each { |building| building.destroy! }
    # This does not dispatch event so we need to dispatch those manually. 
    # Blargh, stupid me.
    unless alive.blank?
      BulkSql::Building.save(alive)
      EventBroker.fire(alive, EventBroker::CHANGED)
    end
  end

  def create_cooldown(location, outcomes)
    # Create cooldown if needed
    if Combat::Integration.has_tie?(outcomes)
      ends_at = CONFIG.evalproperty(
        location.is_a?(SsObject::Planet) \
          ? 'combat.cooldown.planet.duration' \
          : 'combat.cooldown.duration'
      ).from_now
      Cooldown.create_or_update!(location, ends_at)
    end
  end

  # Give players their points ;)
  def save_players(players, statistics)
    players.each do |player|
      unless player.nil?
        player.war_points += statistics[player.id][Combat::STATS_WAR_PTS_ATTR]
        player.victory_points += statistics[player.id][Combat::STATS_VPS_ATTR]
        player.free_creds += statistics[player.id][Combat::STATS_CREDS_ATTR]
        player.save!
      end
    end
  end

  def self.has_tie?(outcomes)
    outcomes.each do |player_id, outcome|
      return true if outcome == Combat::Integration::OUTCOME_TIE
    end

    false
  end
end
