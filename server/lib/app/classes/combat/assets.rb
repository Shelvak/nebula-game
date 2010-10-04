# Encapsulates everything related to one run on combat.
class Combat::Assets
  # +Combat::Report+ object.
  attr_reader :report
  # +CombatLog+ object.
  attr_reader :combat_log
  # +Hash+ of player_id => notification_id pairs.
  attr_reader :notification_ids
  # +Cooldown+ object (if created)
  attr_reader :cooldown

  def initialize(report, combat_log, notification_ids, cooldown)
    @report = report
    @combat_log = combat_log
    @notification_ids = notification_ids
    @cooldown = cooldown
  end
end
