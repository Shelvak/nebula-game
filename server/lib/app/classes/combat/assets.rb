# Encapsulates everything related to one run on combat.
class Combat::Assets
  # Response hash from SpaceMule#combat
  attr_reader :response
  # +CombatLog+ object.
  attr_reader :combat_log
  # +Hash+ of player_id => notification_id pairs.
  attr_reader :notification_ids
  # +Cooldown+ object (if created)
  attr_reader :cooldown

  def initialize(response, combat_log, notification_ids, cooldown)
    @response = response
    @combat_log = combat_log
    @notification_ids = notification_ids
    @cooldown = cooldown
  end
end
