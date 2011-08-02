# Config shortcuts instead of using strings everywhere.
class Cfg; class << self
  # For how long planet is protected after protection is initiated?
  def planet_protection_duration
    CONFIG.evalproperty('combat.cooldown.protection.duration')
  end
  
  def units_speed_up(speed_modifier, hop_count)
    [
      CONFIG.evalproperty('creds.move.speed_up', 
        'percentage' => (1.0 - speed_modifier),
        'hop_count' => hop_count
      ).round,
      CONFIG['creds.move.speed_up.max_cost']
    ].min
  end
  
  def player_max_population; CONFIG['galaxy.player.population.max']; end
end; end