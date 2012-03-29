class SpaceMule::PlayerCreator
  # @param galaxy_id [Fixnum]
  # @param ruleset [String]
  # @return [Hash] {Player#web_user_id => Player#id}
  def self.invoke(galaxy_id, ruleset, players)
    # {Player#web_user_id => Player#id} of already created players.
    already_created_players = without_locking do
      Player.select("id, web_user_id").where(
        :galaxy_id => galaxy_id, :web_user_id => players.keys
      ).c_select_all
    end.each_with_object({}) do |row, hash|
      hash[row['web_user_id']] = row['id']
    end

    # Filter already created players.
    to_create = players.reject do |web_user_id, _|
      already_created_players.has_key?(web_user_id)
    end

    if to_create.size > 0
      # If we have anything to create.
      save_result = LOGGER.block("Calling SpaceMule") do
        SpaceMule::Pmg.Runner.create_players(
          ruleset, galaxy_id, to_create.to_scala
        )
      end
      # Iterate over Scala collection.
      player_ids = {}
      save_result.playerRows.foreach do |player_row|
        player_ids[player_row.player.webUserId] = player_row.id
      end

      LOGGER.block("Dispatching newly created solar systems") do
        dispatch_new_solar_systems(save_result.fsesForExisting)
      end

      already_created_players.merge(player_ids)
    else
      # Fake creation and just return ids of created players.
      already_created_players
    end
  end

  def self.create_zone(galaxy_id, ruleset, slot, quarter)
    save_result = SpaceMule::Pmg.Runner.
      create_zone(ruleset, galaxy_id, quarter, slot)

    dispatch_new_solar_systems(save_result.fsesForExisting)

    true
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