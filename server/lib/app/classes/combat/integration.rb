module Combat::Integration
  def create_notifications(report, log)
    # Filter alliances for notifications.
    alliances = Combat::NotificationHelpers.alliances(report.alliances)

    # Group units
    grouped_by_player_id = Combat::NotificationHelpers.
      group_participants_by_player_id(@units + @buildings)
    grouped_unit_counts = Combat::NotificationHelpers.
      report_participant_counts(grouped_by_player_id)

    # Create notifications
    notification_ids = {}
    @alliances.each do |alliance_id, alliance|
      alliance.each do |player|
        unless player == Combat::NPC
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
            report.location.as_json,
            report.outcomes[player.id],
            yane_units,
            leveled_up_units,
            statistics,
            Combat::NotificationHelpers.resources(report)
          )
          notification_ids[player.id] = notification.id
        end
      end
    end
    
    notification_ids
  end

  def save_updated_participants(report)
    # Save updated units. We add COMBAT reason to this because there might
    # be updated/destroyed units which were unloaded from transporter and
    # client does not know about them so it needs this reason to act
    # accordingly.
    dead, alive = @units.partition { |unit| unit.dead? }
    unless dead.blank?
      Wreckage.add(@location, report.metal, report.energy, report.zetium)
      Unit.delete_all_units(dead, report.killed_by,
        EventBroker::REASON_COMBAT)
    end
    Unit.save_all_units(alive, EventBroker::REASON_COMBAT) \
      unless alive.blank?

    # Save updated buildings
    @buildings.each do |building|
      if building.dead?
        building.destroy
      else
        building.save!
      end
    end
  end

  def create_cooldown(report)
    # Create cooldown if needed
    Cooldown.create_or_update!(
      @location,
      Time.now + CONFIG.evalproperty('combat.cooldown.duration')
    ) if Combat::Integration.has_tie?(report)
  end

  # Give players their points ;)
  def save_players(report)
    stats = report.statistics[:points_earned]

    @alliances.each do |alliance_id, players|
      players.each do |player|
        unless player == Combat::NPC
          player.war_points += stats[player.id]
          player.save!
        end
      end
    end
  end

  def self.has_tie?(report)
    report.outcomes.each do |player_id, outcome|
      return true if outcome == Combat::Report::OUTCOME_TIE
    end

    false
  end
end
