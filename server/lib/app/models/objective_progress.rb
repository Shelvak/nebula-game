class ObjectiveProgress < ActiveRecord::Base
  belongs_to :objective
  belongs_to :player

  include Parts::Object
  def self.notify_on_create?; false; end
  include Parts::Notifier
  
  # Don't notify on update if we're going to erase this record soon anyway.
  def notify_broker_update
    if completed?
      true
    else
      super
    end
  end

  # Is this progress completed?
  def completed?
    completed >= objective.count
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
    destroy

    # Record this objective as completed
    qp = objective.quest.quest_progresses.where(
      :player_id => player_id).first
    qp.completed += 1
    qp.save!
  end
end