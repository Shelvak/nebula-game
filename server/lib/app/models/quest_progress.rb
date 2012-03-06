# Representation of +Quest+ progress.
#
# Attributes:
# - status (Fixnum): in what stage is this progress.
# - completed (Fixnum): number of objectives completed.
#
class QuestProgress < ActiveRecord::Base
  include Parts::WithLocking

  # Methods must be before include.

  def self.notify_on_create?; false; end
  def self.notify_on_destroy?; false; end

  include Parts::Notifier

  # Don't notify if this is for achievement.
  def notify_broker_update
    quest.achievement? ? true : super
  end

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

  def started?; status == STATUS_STARTED; end
  def completed?; status == STATUS_COMPLETED; end
  def reward_taken?; status == STATUS_REWARD_TAKEN; end

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
    raise GameLogicError.new("Cannot claim rewards, rewards is nil!") \
      if rewards.nil?
    rewards.claim!(planet, planet.player)

    self.status = STATUS_REWARD_TAKEN
    save!
  end

  private
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

    # Change status so after_save would
    self.status = STATUS_COMPLETED \
      if status == STATUS_STARTED && completed == quest.objectives.count

    true
  end

  after_create :dispatch_client_quest
  def dispatch_client_quest
    EventBroker.fire(ClientQuest.new(quest_id, player_id),
      EventBroker::CREATED)
  end

  # We need to run #on_quest_completed in #after_save because if quest is
  # created already completed we should dispatch creation to client first
  # and only then we should start child quests and dispatch notifications.
  after_save :on_quest_completed, :if => proc { |record|
    record.status == STATUS_COMPLETED && record.status_changed?
  }
  def on_quest_completed
    started = Quest.start_child_quests(quest_id, player_id)
    if quest.achievement?
      Objective::CompleteAchievements.progress(self)
      Notification.create_for_achievement_completed(self)
    else
      Objective::CompleteQuests.progress(self)
      Notification.create_for_quest_completed(self, started)
    end
  end
end