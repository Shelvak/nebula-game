# Class for combat simulation
class Combat
  extend Combat::Simulation
  extend Combat::Integration

  # NPC player
  NPC = nil

  # Neutral stance doesn't give any bonuses.
  STANCE_NEUTRAL = 0
  # Defensive stance increases defense at the expense of attack.
  STANCE_DEFENSIVE = 1
  # Aggressive stance increases attack at the expense of defense.
  STANCE_AGGRESSIVE = 2

  # This player has won the battle. Note that if even if you and Nap ended
  # up in a tie because of the pact, both of you will still get WIN outcome.
  OUTCOME_WIN = 0
  # This player has lost the battle (all your and your alliance units &
  # buildings were destroyed).
  OUTCOME_LOSE = 1
  # This player ended up in a tie at this battle (battle ended before you or
  # your allies were wiped out from the battlefield).
  OUTCOME_TIE = 2

  # Victory points attribute used in statistics
  STATS_WAR_PTS_ATTR = "points_earned"
  STATS_VPS_ATTR = "victory_points_earned"

  # Run combat in a +SsObject+ between +Player+ and NPC building.
  # Don't create cooldown.
  #
  def self.run_npc!(planet, player_units, target)
    npc_units = Unit.in_location(target.location_attrs).all
    run(
      planet,
      [planet.player, nil],
      {},
      npc_units + player_units,
      [],
      :cooldown => false
    )
  end
end