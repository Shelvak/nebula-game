# Representation of +Quest+ progress.
#
# Attributes:
# - status (Fixnum): in what stage is this progress.
# - completed (Fixnum): number of objectives completed.
#
class QuestProgress < ActiveRecord::Base
  # Methods must be before include.

  def self.notify_on_create?; false; end
  def self.notify_on_destroy?; false; end

  include Parts::Notifier
  include Parts::Object

  belongs_to :quest
  belongs_to :player

  # Quest is just started by +Player+.
  STATUS_STARTED = 0
  # Quest has been completed by +Player+ but the reward is not taken yet.
  # However children quests can be done by the player.
  STATUS_COMPLETED = 1
  # Quest has been completed and the reward was taken.
  STATUS_REWARD_TAKEN = 2

  # Rewards assigned to +SsObject::Planet+
  REWARD_RESOURCES = [
    [:metal, Quest::REWARD_METAL],
    [:energy, Quest::REWARD_ENERGY],
    [:zetium, Quest::REWARD_ZETIUM],
  ]
  # Rewards assigned to +Player+
  REWARD_PLAYER = [
    [:xp, Quest::REWARD_XP],
    [:points, Quest::REWARD_POINTS]
  ]

  # {
  #   :id => Fixnum
  #   :quest_id => Fixnum,
  #   :status => Fixnum (one of STATUS_* consts),
  #   :completed => Fixnum (number of quest objectives completed)
  # }
  #
  def as_json(options=nil)
    attributes.except('player_id').symbolize_keys
  end

  # Claim rewards for given _player_, _quest_ and _planet_.
  def self.claim_rewards!(player_id, quest_id, planet_or_id)
    self.where(
      :quest_id => quest_id, :player_id => player_id
    ).first.claim_rewards!(planet_or_id)
  end

  # Claim +Quest+ rewards and transfer it to given planet.
  def claim_rewards!(planet_or_id)
    raise GameLogicError.new(
      "Cannot claim rewards, quest is not finished yet!"
    ) if status == STATUS_STARTED
    raise GameLogicError.new(
      "Cannot claim rewards, it is already taken!"
    ) if status == STATUS_REWARD_TAKEN

    planet = planet_or_id.is_a?(SsObject) \
      ? planet_or_id : SsObject.find(planet_or_id)

    raise GameLogicError.new(
      "Cannot claim reward, planet does not belong to player"
    ) unless planet.player_id == player_id
    
    rewards = quest.rewards
    increase_values(lambda { planet }, rewards,
      REWARD_RESOURCES)
    increase_values(lambda { player }, rewards,
      REWARD_PLAYER)

    if rewards[Quest::REWARD_UNITS]
      units = []

      rewards[Quest::REWARD_UNITS].each do |specification|
        klass = "Unit::#{specification['type']}".constantize
        specification['count'].times do
          unit = klass.new(
            :level => specification['level'],
            :hp => klass.hit_points(specification['level']),
            :location => planet,
            :player => player,
            :galaxy_id => player.galaxy_id
          )
          unit.skip_validate_technologies = true
          unit.save!
          units.push unit
        end
      end

      EventBroker.fire(units, EventBroker::CREATED,
        EventBroker::REASON_REWARD_CLAIMED)
    end

    self.status = STATUS_REWARD_TAKEN
    save!
  end

  private
  # Increase values for different reward types on object.
  def increase_values(get_object, rewards, types)
    object = nil
    types.each do |type, reward|
      value = rewards[reward]
      if value
        object ||= get_object.call
        object.send("#{type}=", object.send(type) + value)
      end
    end

    if object
      object.save!
      # We need some special treatment for this baby
      EventBroker.fire(object, EventBroker::CHANGED,
        EventBroker::REASON_RESOURCES_CHANGED
      ) if object.is_a?(SsObject::Planet)
    end
  end

  # Copies objectives for player, by creating objective progresses.
  def copy_objective_progresses
    quest.objectives.each do |objective|
      op = ObjectiveProgress.new(:player_id => player_id,
        :objective => objective)
      op.completed = objective.initial_completed(player_id)

      if op.completed?
        self.completed += 1
      else
        op.save!
      end
    end

    true
  end

  before_save :check_if_completed
  def check_if_completed
    # Cannot use #before_create because it's run after #before_save
    copy_objective_progresses if new_record?

    if status == STATUS_STARTED && completed == quest.objectives.count
      self.status = STATUS_COMPLETED
      Quest.start_child_quests(quest_id, player_id)
    end

    true
  end

  after_create :dispatch_client_quest
  def dispatch_client_quest
    EventBroker.fire(ClientQuest.new(quest_id, player_id),
      EventBroker::CREATED)
  end

  after_create :create_started_notification
  def create_started_notification
    if status == STATUS_STARTED
      Notification.create_for_quest_started(self)
    end
    
    true
  end

  after_save :create_completed_notification
  def create_completed_notification
    if status == STATUS_COMPLETED
      Notification.create_for_quest_completed(self)
    end

    true
  end
end