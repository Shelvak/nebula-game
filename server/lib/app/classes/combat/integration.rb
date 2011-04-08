module Combat::Integration
  OUTCOME_WIN = 0
  OUTCOME_LOSE = 1
  OUTCOME_TIE = 2

  # Returns {player_id => notification_id} hash.
  def create_notifications(response, client_location, leveled_up_units,
      combat_log)
    Hash[response['alliances'].map do |alliance_id, alliance|
      alliance['players'].map do |player|
        if player.nil?
          nil
        else
          player_id = player[0]

          notification = Notification.create_for_combat(
            player_id,
            alliance_id,
            response['classified_alliances'][player_id.to_s],
            combat_log.id,
            client_location.as_json,
            response['outcomes'][player_id.to_s],
            response['yane'][player_id.to_s],
            leveled_up_units,
            response['statistics'][player_id.to_s],
            response['wreckages']
          )

          [player_id, notification.id]
        end
      end.compact
    end.flatten(1)]
  end

  def save_updated_participants(location, units, buildings, killed_by,
      wreckages)
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
    unless dead.blank?
      Wreckage.add(location, wreckages['metal'], wreckages['energy'],
        wreckages['zetium'])
      Unit.delete_all_units(dead, killed_by, EventBroker::REASON_COMBAT)
    end

    # Save updated buildings
    buildings.each do |building|
      if building.dead?
        building.destroy
      else
        building.save!
      end
    end
  end

  def create_cooldown(outcomes)
    # Create cooldown if needed
    if Combat::Integration.has_tie?(outcomes)
      ends_at = CONFIG.evalproperty(
        @location.is_a?(SsObject::Planet) \
          ? 'combat.cooldown.planet.duration' \
          : 'combat.cooldown.duration'
      ).from_now
      Cooldown.create_or_update!(@location, ends_at)
    end
  end

  # Give players their points ;)
  def save_players(players, statistics)
    stats = statistics['points_earned']

    players.each do |player|
      player.war_points += stats[player.id.to_s]
      player.save!
    end
  end

  def self.has_tie?(outcomes)
    outcomes.each do |player_id, outcome|
      return true if outcome == Combat::Integration::OUTCOME_TIE
    end

    false
  end
end
