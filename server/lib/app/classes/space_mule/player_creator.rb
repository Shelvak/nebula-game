class SpaceMule::PlayerCreator
  # player_ids: {Player#web_user_id => Player#id}
  # updated_player_ids: Array[Fixnum]
  # updated_alliance_ids: Array[Fixnum]
  CreatePlayersResult = Struct.new(:player_ids, :updated_player_ids,
                                   :updated_alliance_ids)

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

      CreatePlayersResult.new(
        already_created_players.merge(player_ids),
        save_result.updatedPlayerIds.from_scala,
        save_result.updatedAllianceIds.from_scala
      )
    else
      # Fake creation and just return ids of created players.
      CreatePlayersResult.new(already_created_players, {}, {})
    end
  end
end