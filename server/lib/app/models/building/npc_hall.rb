class Building::NpcHall < Building
  include Parts::WithCallbackableCooldown
  include Parts::ResetableCooldown
  include Parts::LoopedCooldown

  # When the next cooldown should end.
  def cooldowns_at
    time_owned = planet.owner_changed.nil? \
      ? 0 : (Time.now - planet.owner_changed).to_i
    self.class.cooldowns_at(level, time_owned)
  end

  # When the next cooldown should end.
  def self.cooldowns_at(level, time_owned)
    evalproperty('cooldown', nil,
      'level' => level, 'time_owned' => time_owned).seconds.from_now
  end

  def cooldown_expired!
    player = planet.player
    if player
      player.victory_points += property('victory_points')
      player.creds += property('creds')
      player.save!
    end

    super
  end
end