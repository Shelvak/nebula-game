class Combat::Annexer
  # Annexes a +SsObject+ if:
  # 1. It was without an owner - assign player randomly.
  # 2. It was owned - only change planet ownership to enemy player.
  #
  # If there was a combat, then calculate winners from _outcomes_ and
  # random weights from _statistics_. Otherwise these two can be nil.
  #
  def self.annex!(planet, status, alliances, outcomes, statistics)
    winner = false
    players = alliances.values.flatten
    old_player = planet.player

    if status == Combat::CheckReport::CONFLICT
      if outcomes.nil? || statistics.nil?
        # If no combat was ran, don't do anything
      else
        winners, weights = winners_with_weights(planet.player, players,
          outcomes, statistics)
        winner = winners.weighted_random(weights) unless winners.blank?
      end
    else
      unless old_player.nil?
        # Only transfer control of planet to an enemy or NPC.
        players = StatusResolver.new(old_player).filter(
          players, [StatusResolver::NPC, StatusResolver::ENEMY], :id)
      end
      
      winner = players.random_element unless players.blank?
    end

    unless winner == false
      ActiveRecord::Base.transaction do
        planet.player = winner
        planet.save!
        Notification.create_for_planet_annexed(planet, old_player, winner)
      end
    end
  end

  # Calculate [_winners_, _weights_] for planet annexation.
  def self.winners_with_weights(owner, players, outcomes, statistics)
    winners = []
    weights = []
    resolver = StatusResolver.new(owner) unless owner.nil?

    players.each do |player|
      # player can be nil if it is NPC. In that case we use ID 0 because it
      # is hardcoded into SpaceMule.
      player_id = player ? player.id : nil
      # SpaceMule player id
      sm_player_id = player ? player.id.to_s : Combat::NPC_SM
      if outcomes[sm_player_id] == Combat::OUTCOME_WIN && (
        owner.nil? || (
          status = resolver.status(player_id);
          status == StatusResolver::ENEMY ||
          status == StatusResolver::NPC
        )
      )
        winners.push player
        weights.push statistics[sm_player_id]['points_earned']
      end
    end

    [winners, weights]
  end
end