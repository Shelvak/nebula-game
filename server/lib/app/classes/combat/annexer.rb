class Combat::Annexer
  # Annexes a +SsObject+ if:
  # 1. It was without an owner - assign player randomly.
  # 2. It was owned - only change planet ownership to enemy player.
  #
  # If there was a combat, then calculate winners from _outcomes_ and
  # random weights from _statistics_. Otherwise these two can be nil.
  #
  def self.annex!(planet, status, alliances, outcomes, statistics)
    winner = nil
    players = alliances.values.flatten

    if status == Combat::CheckReport::CONFLICT
      if outcomes.nil? || statistics.nil?
        # If no combat was ran, don't do anything
      else
        winners, weights = winners_with_weights(planet.player, players,
          outcomes, statistics)
        winner = winners.weighted_random(weights) unless winners.blank?
      end
    else
      unless planet.player_id.nil?
        # Only transfer control of planet to an enemy.
        players = StatusResolver.new(planet.player).filter(
          players, StatusResolver::ENEMY, :id)
      end
      
      winner = players.random_element unless players.blank?
    end

    unless winner.nil?
      planet.player = winner
      planet.save!
    end
  end

  # Calculate [_winners_, _weights_] for planet annexation.
  def self.winners_with_weights(owner, players, outcomes, statistics)
    winners = []
    weights = []
    resolver = StatusResolver.new(owner) unless owner.nil?

    players.each do |player|
      # player can be nil if it is NPC.
      player_id = player ? player.id : nil
      if outcomes[player_id] == Combat::Report::OUTCOME_WIN && (
        owner.nil? || resolver.status(player_id) == StatusResolver::ENEMY
      )
        winners.push player
        weights.push statistics[player_id]
      end
    end

    [winners, weights]
  end
end