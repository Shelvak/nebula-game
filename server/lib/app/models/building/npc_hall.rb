class Building::NpcHall < Building
  include Parts::WithCooldown
  include Parts::ResetableCooldown
  include Parts::LoopedCooldown

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