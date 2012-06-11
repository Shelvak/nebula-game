class SpaceMule::PlayerCreator
  # @param galaxy_id [Fixnum]
  # @param ruleset [String]
  # @param web_user_id [Fixnum]
  # @param player_name [String]
  # @param trial [Boolean]
  # @return Fixnum player id
  def self.invoke(galaxy_id, ruleset, web_user_id, player_name, trial)
    typesig binding, Fixnum, String, Fixnum, String, Boolean

    CONFIG.with_set_scope(ruleset) do
      existing_player_id = without_locking do
        Player.select("id").where(
          :galaxy_id => galaxy_id, :web_user_id => web_user_id
        ).c_select_one
      end
      return existing_player_id unless existing_player_id.nil?

      # If we have anything to create.
      save_result = LOGGER.block("Calling SpaceMule") do
        SpaceMule::Pmg.Runner.create_player(
          ruleset, galaxy_id, web_user_id, player_name
        )
      end

      # Update Player#trial state.
      Player.where(:id => save_result.player_id).
        update_all(Player.set_flag_sql(:trial, trial))

      LOGGER.block("Dispatching newly created solar systems") do
        dispatch_new_solar_systems(save_result.fsesForExisting)
      end

      save_result.player_id
    end
  end

  def self.create_zone(galaxy_id, ruleset, slot, quarter)
    CONFIG.with_set_scope(ruleset) do
      save_result = SpaceMule::Pmg.Runner.
        create_zone(ruleset, galaxy_id, quarter, slot)

      dispatch_new_solar_systems(save_result.fsesForExisting)

      true
    end
  end

  # Dispatch newly created solar systems to existing players/alliances.
  #
  # This design is an ASS to test. Much because all data is consumed right
  # here. Probably should only transform the data and do something with it
  # later, but eh... Its too hard for my brains today.
  def self.dispatch_new_solar_systems(fses_for_existing)
    fses_for_existing.foreach do |tuple|
      ss_row = tuple._1
      player = ss_row.playerRow.isDefined \
        ? Player.minimal(ss_row.playerRow.get.id) : nil

      entries = []
      tuple._2.foreach do |entry_row|
        fse = FowSsEntry.new(
          :solar_system_id => ss_row.id,
          :counter => entry_row.counter,
          :player_id => entry_row.playerId,
          :alliance_id => entry_row.allianceId,
          :player_planets => entry_row.playerPlanets,
          :enemy_planets => entry_row.enemyPlanets
        )
        fse.id = entry_row.id
        entries << fse
      end

      EventBroker.fire(
        Event::FowChange::SsCreated.
          new(ss_row.id, ss_row.x, ss_row.y, ss_row.kind, player, entries),
        EventBroker::FOW_CHANGE,
        EventBroker::REASON_SS_ENTRY
      )
    end
  end
end