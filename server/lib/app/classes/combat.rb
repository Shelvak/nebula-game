# Class for combat simulation
class Combat
  require File.dirname(__FILE__) + '/combat/simulation'
  require File.dirname(__FILE__) + '/combat/integration'

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

  # Combatant kinds.
  # Used by SpaceMule in spacemule.modules.combat.objects.Combatant.Kind

  COMBATANT_KIND_UNIT = 0
  # Building with guns
  COMBATANT_KIND_SHOOTING_BUILDING = 1
  # Building without guns. We might have them one day...
  COMBATANT_KIND_PASSIVE_BUILDING = 2

  # Attributes used in statistics

  STATS_PLR_DMG_DEALT_ATTR = "damage_dealt_player"
  STATS_WAR_PTS_ATTR = "points_earned"
  STATS_VPS_ATTR = "victory_points_earned"
  STATS_CREDS_ATTR = "creds_earned"

  # Run combat in a +SsObject+ between +Player+ and NPC building.
  # Don't create cooldown and do not push notification to player.
  #
  def self.run_npc!(planet, player, player_units, target_building)
    npc_units = Unit.in_location(target_building.location_attrs).all
    run(
      planet,
      # If you're attacking building in alliance planet,
      # player might != planet.player. And we need planet owner to be in players
      # list.
      [planet.player, player, nil].uniq,
      {},
      npc_units + player_units,
      [],
      cooldown: false, skip_push_notifications_for: [player.id],
      building_type: target_building.type, building_attacker_id: player.id
    )
  end
end