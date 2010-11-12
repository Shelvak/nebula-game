class ConstructionQueuesController < GenericController
  # Lists all ConstructionQueueEntry's.
  #
  # This is pushed by other actions in this controller.
  #
  # Params:
  #   * constructor_id
  #
  # Response:
  #   * entries - Array of ConstructionQueueEntry.
  #   * constructor_id (Fixnum)
  #
  ACTION_INDEX = 'construction_queues|index'
  # Move or split ConstructionQueueEntry in queue.
  #
  # Params:
  #   * id - id of ConstructionQueueEntry
  #   * position - new element position.
  #   * count - count to split of. If nil or equal to model count then
  #     entry is moved instead of splitting.
  #
  # Response: None
  # Pushes: ACTION_INDEX
  #
  ACTION_MOVE = 'construction_queues|move'
  # Reduce count from ConstructionQueueEntry.
  #
  # Invokation: by client
  #
  # Params:
  #   * id - id of ConstructionQueueEntry
  #   * count - count to reduce
  #
  # Response: None
  #
  ACTION_REDUCE = 'construction_queues|reduce'

  def invoke(action)
    case action    
    when ACTION_INDEX
      only_push!
      param_options :required => %w{constructor_id}

      respond :entries => ConstructionQueueEntry.find(:all, :conditions => {
          :constructor_id => params['constructor_id']
        }),
        :constructor_id => params['constructor_id']
    when ACTION_MOVE
      param_options :required => %w{id position}, :valid => %w{count}

      entry = get_entry
      ConstructionQueue.move(entry, params['position'],
        params['count'])
    when ACTION_REDUCE
      param_options :required => %w{id count}

      entry = get_entry
      ConstructionQueue.reduce(entry, params['count'])
    end
  end

  protected
  def get_entry
    entry = ConstructionQueueEntry.find(params['id'])
    raise GameLogicError.new(
      "Queue entry does not belong to this player!"
    ) unless entry.constructor.planet.player_id == player.id

    entry
  end
end