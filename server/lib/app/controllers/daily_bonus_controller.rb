class DailyBonusController < GenericController
  # Get todays reward for this player. Raises error if reward is already
  # taken.
  # 
  # Invocation: by server
  # 
  # Parameters: None
  # 
  # Response:
  # - bonus (Hash): Rewards#as_json
  #
  ACTION_SHOW = "daily_bonus|show"

  SHOW_OPTIONS = logged_in + only_push
  def self.show_scope(message); scope.player(message.player); end
  def self.show_action(m)
    respond m, :bonus => get_bonus(m.player).as_json
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
  ACTION_CLAIM = 'daily_bonus|claim'

  CLAIM_OPTIONS = logged_in + required(:planet_id => Fixnum)
  def self.claim_scope(m); scope.planet(m.params['planet_id']); end
  def self.claim_action(m)
    planet = SsObject::Planet.where(:player_id => m.player.id).
      find(m.params['planet_id'])
    
    get_bonus(m.player).claim!(planet, m.player, true)
    m.player.set_next_daily_bonus!
  end
  
  class << self
    private
    def get_bonus(player)
      raise GameLogicError.new(
        "Cannot get daily bonus, as it will only be available at #{
        player.daily_bonus_at || "nil"}") unless player.daily_bonus_available?

      DailyBonus.get_bonus(player.id, player.points)
    end
  end
end