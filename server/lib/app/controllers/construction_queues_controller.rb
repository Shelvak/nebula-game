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

  INDEX_OPTIONS = logged_in + only_push + required(:constructor_id => Fixnum)
  def self.index_scope(m) end # TODO
  def self.index_action(m)
    respond m,
      :entries => ConstructionQueueEntry.
        where(:constructor_id => m.params['constructor_id']).all.map(&:as_json),
      :constructor_id => m.params['constructor_id']
  end

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

  MOVE_OPTIONS = logged_in + required(:id => Fixnum, :position => Fixnum) +
    valid(:count => Fixnum)
  def self.move_scope(m) end # TODO
  def self.move_action(m)
    entry = get_entry(m)
    ConstructionQueue.move(entry, m.params['position'], m.params['count'])
  end

  # Reduce count from ConstructionQueueEntry. Returns resources for prepaid
  # entries.
  #
  # Invokation: by client
  #
  # Parameters:
  # - id (Fixnum): id of ConstructionQueueEntry
  # - count (Fixnum): count to reduce
  #
  # Response: None
  #
  ACTION_REDUCE = 'construction_queues|reduce'

  REDUCE_OPTIONS = logged_in + required(:id => Fixnum, :count => Fixnum)
  def self.reduce_scope(m) end # TODO
  def self.reduce_action(m)
    entry = get_entry(m)
    ConstructionQueue.reduce(entry, m.params['count'])
  end

  class << self
    private
    def get_entry(m)
      entry = ConstructionQueueEntry.find(m.params['id'])
      raise GameLogicError.new(
        "Queue entry does not belong to this player!"
      ) unless entry.constructor.planet.player_id == m.player.id

      entry
    end
  end
end