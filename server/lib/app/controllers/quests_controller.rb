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

  def invoke(action)
    case action
    when ACTION_INDEX
      only_push!

      respond :quests => Quest.hash_all_for_player_id(player.id)
    when ACTION_CLAIM_REWARDS
      param_options(:required => %w{id planet_id})

      QuestProgress.claim_rewards!(player.id, params['id'],
        params['planet_id'])
    end
  end
end