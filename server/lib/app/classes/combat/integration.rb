module Combat::Integration
  OUTCOME_WIN = 0
  OUTCOME_LOSE = 1
  OUTCOME_TIE = 2

  # Returns {player_id => notification_id} hash.
  def create_notifications(response, client_location, leveled_up_units,
      combat_log, wreckages)
    Hash[response['alliances'].map do |alliance_id, alliance|
      alliance['players'].map do |player|
        if player.nil?
          nil
        else
          player_id = player[0]

          notification = Notification.create_for_combat(
            player_id,
            alliance_id,
            response['classified_alliances'][player_id],
            combat_log.sha1_id,
            client_location.as_json,
            response['outcomes'][player_id],
            response['yane'][player_id],
            leveled_up_units[player_id],
            response['statistics'][player_id],
            wreckages
          )

          [player_id, notification.id]
        end
      end.compact
    end.flatten(1)]
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
      Cooldown.create_unless_exists(location, ends_at)
    end
  end

  # Give players their points ;)
  def save_players(players, statistics)
    players.each do |player|
      unless player.nil?
        player.war_points += statistics[player.id][Combat::STATS_WAR_PTS_ATTR]
        player.victory_points += statistics[player.id][Combat::STATS_VPS_ATTR]
        player.creds += statistics[player.id][Combat::STATS_CREDS_ATTR]
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
