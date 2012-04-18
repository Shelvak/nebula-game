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

  INDEX_OPTIONS = logged_in + only_push
  INDEX_SCOPE = scope.world
  def self.index_action(m)
    without_locking do
      respond m, :quests => Quest.hash_all_for_player_id(m.player.id)
    end
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
  ACTION_CLAIM_REWARDS = 'quests|claim_rewards'

  CLAIM_REWARDS_OPTIONS = logged_in +
    required(:id => Fixnum, :planet_id => Fixnum)
  CLAIM_REWARDS_SCOPE = scope.world
  def self.claim_rewards_action(m)
    QuestProgress.claim_rewards!(
      m.player.id, m.params['id'], m.params['planet_id']
    )
  end
end