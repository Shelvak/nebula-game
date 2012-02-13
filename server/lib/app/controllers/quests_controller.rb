class QuestsController < GenericController
  # Retrieves all quest progresses and objective progresses for logged in
  # player.
  # 
  # Invocation: by server
  # 
  # Parameters: none
  # 
  # Response:
  # - quests (Hash): as returned by Quest#hash_all_for_player_id
  #
  ACTION_INDEX = 'quests|index'

  def self.index_options; logged_in + only_push; end
  def self.index_scope(message); scope.player(message.player); end
  def self.index_action(m)
    respond m, :quests => Quest.hash_all_for_player_id(m.player.id)
  end

  # Claim rewards for given Quest into given SsObject.
  # 
  # Invocation: by client
  # 
  # Parameters:
  # - id (Fixnum): Quest id for which reward should be claimed.
  # - planet_id (Fixnum): SsObject id where to claim reward.
  # 
  # Response: None
  #
  def self.claim_rewards_options
    logged_in + required(:id => Fixnum, :planet_id => Fixnum)
  end
  def self.claim_rewards_scope(message); scope.player(message.player.id); end
  def self.claim_rewards_action(m)
    QuestProgress.claim_rewards!(
      m.player.id, m.params['id'], m.params['planet_id']
    )
  end
end