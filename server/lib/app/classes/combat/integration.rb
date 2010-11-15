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
            statistics
          )
          notification_ids[player.id] = notification.id
        end
      end
    end
    
    notification_ids
  end

  def save_updated_participants(report)
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
  end

  def create_cooldown
    # Create cooldown if needed
    Cooldown.create_or_update!(
      @location,
      Time.now + CONFIG.evalproperty('combat.cooldown.duration')
    )
  end
end
