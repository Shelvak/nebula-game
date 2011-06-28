class MoveSpeedModifier
  def initialize(modifier)
    sm_min = CONFIG['units.move.modifier.min']
    sm_max = CONFIG['units.move.modifier.max']
    
    raise GameLogicError.new(
      "Speed Modifier #{modifier} cannot be < #{sm_min}") \
      if modifier < sm_min
    raise GameLogicError.new(
      "Speed Modifier #{modifier} cannot be > #{sm_max}") \
      if modifier > sm_max
    
    @modifier = modifier.to_f
  end
  
  # Deducts creds from player for speeding up if needed.
  def deduct_creds!(player, unit_ids, source, target, avoid_npc)
    # Speeding units up requires creds.
    if @modifier < 1
      hop_count = hop_count(player, unit_ids, source, target, avoid_npc)

      creds_needed = Cfg.units_speed_up(@modifier, hop_count)
      raise GameLogicError.new("Not enough creds for speed up! Needed: #{
        creds_needed}, has: #{player.creds}") if player.creds < creds_needed
      player.creds -= creds_needed
      player.save!
      Objective::AccelerateFlight.progress(player)
      CredStats.movement_speed_up!(player, creds_needed)
    end
  end
  
  def to_f
    @modifier
  end
  
  private
  def hop_count(player, unit_ids, source, target, avoid_npc)
    _, hop_count = UnitMover.move_meta(
      player.id, unit_ids, source, target, avoid_npc
    )
    hop_count
  end
end