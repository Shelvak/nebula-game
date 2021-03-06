class ObjectiveProgress < ActiveRecord::Base
  include Parts::WithLocking

  belongs_to :objective
  belongs_to :player

  include Parts::Object
  def self.notify_on_create?; false; end
  include Parts::Notifier
  
  # Don't notify on update if we're going to erase this record soon anyway
  # or this progress is for achievement.
  # 
  def notify_broker_update
    (completed? || achievement?) ? true : super
  end

  # Do not notify client about destroy if it's for achievement.
  def notify_broker_destroy
    achievement? ? true : super
  end

  def achievement?
    without_locking { objective.quest.achievement? }
  end

  # Is this progress completed?
  def completed?
    completed >= without_locking { objective.count }
  end

  # {
  #   :id => Fixnum,
  #   :objective_id => Fixnum,
  #   :completed => Fixnum (how many times it has been progressed),
  # }
  def as_json(options=nil)
    attributes.except('player_id').symbolize_keys
  end

  private
  before_save :normalize_completed
  def normalize_completed
    self.completed = 0 if completed < 0

    true
  end

  after_save :on_complete, :if => lambda { |r| r.completed? }

  def on_complete
    # I won't be needed anymore
    destroy!

    # Record this objective as completed
    quest = without_locking { objective.quest }
    qp = quest.quest_progresses.where(:player_id => player_id).first
    qp.completed += 1
    qp.save!
  end
end