class Building::NpcHall < Building
  include Parts::WithCooldown
  include Parts::ResetableCooldown
  include Parts::LoopedCooldown

  def cooldown_expired!
    transaction do
      player = planet.player
      if player
        player.victory_points += 1
        player.creds += 1
        player.save!
      end
      
      super
    end
  end
end