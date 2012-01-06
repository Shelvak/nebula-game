class SpaceMule::PlayerCreator
  # @param galaxy_id [Fixnum]
  # @param ruleset [String]
  # @return [Hash] {Player#web_user_id => Player#id}
  def self.invoke(galaxy_id, ruleset, players)
    # {Player#web_user_id => Player#id} of already created players.
    already_created_players = Player.select("id, web_user_id").where(
      :galaxy_id => galaxy_id, :web_user_id => players.keys
    ).c_select_all.inject({}) do |hash, row|
      hash[row['web_user_id']] = row['id']
      hash
    end

    # Filter already created players.
    to_create = players.reject do |web_user_id, _|
      already_created_players.has_key?(web_user_id)
    end

    if to_create.size > 0
      # If we have anything to create.
      save_result = SpaceMule::Pmg.Runner.
        create_players(ruleset, galaxy_id, to_create.to_scala)
      # Iterate over Scala collection.
      player_ids = {}
      save_result.playerRows.foreach do |player_row|
        player_ids[player_row.player.webUserId] = player_row.id
      end

      # Dispatch newly created solar systems to existing players/alliances.
      #
      # This design is an ASS to test. Much because all data is consumed right
      # here. Probably should only transform the data and do something with it
      # later, but eh... Its too hard for my brains today.
      save_result.fsesForExisting.foreach do |tuple|
        ss_row = tuple._1
        player = ss_row.playerRow.isDefined \
          ? Player.minimal(ss_row.playerRow.get.id) : nil

        entries = []
        tuple._2.foreach do |entry_row|
          fse = FowSsEntry.new(
            :solar_system_id => ss_row.id,
            :counter => entry_row.counter,
            :player_id =>
              entry_row.playerId.isDefined ? entry_row.playerId.get : nil,
            :alliance_id =>
              entry_row.allianceId.isDefined ? entry_row.allianceId.get : nil,
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

      already_created_players.merge(player_ids)
    else
      # Fake creation and just return ids of created players.
      already_created_players
    end
  end
end