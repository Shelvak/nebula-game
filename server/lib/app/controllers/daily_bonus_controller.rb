class DailyBonusController < GenericController
  # Get todays reward for this player. Raises error if reward is already
  # taken.
  # 
  # Invocation: by client
  # 
  # Parameters: None
  # 
  # Response:
  # - bonus (Hash): Rewards#as_json
  #
  def action_get
    respond :bonus => get_bonus.as_json
  end
  
  # Reclaim todays reward for this player to some planet. 
  # Raises error if reward is already taken.
  # 
  # Invocation: by client
  # 
  # Parameters:
  # - planet_id (Fixnum)
  # 
  # Response: None
  #
  def action_claim
    param_options :required => %w{planet_id}
    
    planet = SsObject::Planet.where(:player_id => player.id).
      find(params['planet_id'])
    
    get_bonus.claim!(planet, player)
    player.daily_bonus_at = CONFIG['daily_bonus.cooldown'].from_now
    player.save!
  end
  
  private
  def get_bonus
    raise GameLogicError.new(
      "Cannot get daily bonus, as it will only be available at #{
      player.daily_bonus_at}") unless player.daily_bonus_available?
    
    DailyBonus.get_bonus(player.id, player.points)
  end
end