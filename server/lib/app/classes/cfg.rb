# Config shortcuts instead of using strings everywhere.
class Cfg; class << self
  # For how long planet is protected after protection is initiated?
  def planet_protection_duration
    CONFIG.evalproperty('combat.cooldown.protection.duration')
  end
  
  def planet_boost_cost; CONFIG['creds.planet.resources.boost.cost']; end
  def planet_boost_duration
    CONFIG['creds.planet.resources.boost.duration']
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
  
  def player_initial_population; CONFIG['galaxy.player.population']; end
  def player_max_population; CONFIG['galaxy.player.population.max']; end
  
  # Returns chance [0..100] of finding something useful in exploration.
  def exploration_win_chance(width, height)
    CONFIG.evalproperty("tiles.exploration.winning_chance",
      'width' => width, 'height' => height).round
  end
  
  # Returns number of creds required to instantly finish an exploration.
  def exploration_finish_cost(width, height)
    CONFIG.evalproperty("creds.exploration.finish", 
      'width' => width, 'height' => height).round
  end
end; end