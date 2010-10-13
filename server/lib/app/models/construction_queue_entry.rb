# Actual database entries for ConstructionQueue.
#
# Do not use this class directly from the constructors. Instead use
# ConstructionQueue class that will manage these objects.
#
class ConstructionQueueEntry < ActiveRecord::Base
  default_scope :order => :position
  belongs_to :upgradable, :polymorphic => true
  belongs_to :constructor, :class_name => "Building"
  serialize :params, Hash

  def self.notify_on_update?; false; end
  def self.notify_on_destroy?; false; end
  include Parts::Notifier
  include Parts::Object

  def can_merge?(model)
    model.constructor_id == self.constructor_id and \
      model.constructable_type == self.constructable_type \
      and model.params == self.params
  end

  # Merges with _model_ by increasing _count_ in _self_ and destroying
  # _model_.
  def merge!(model)
    transaction do
      self.count += model.count
      model.destroy

      save!
    end
  end

  def to_s
    "<ConstructionQueueEntry id: #{id}, c_id: #{constructor_id}, pos: #{
      position}, count: #{count}, c_type: #{constructable_type}>"
  end

  protected
  validate :validate_count
  def validate_count
    errors.add(:count, "must be positive!") unless count > 0
  end

  after_destroy :shift_positions_left
  def shift_positions_left
    self.class.update_all("position=position-1",
      ["constructor_id=? AND position>?", constructor_id, position])
  end

  before_create :shift_positions_right
  def shift_positions_right
    self.class.update_all("position=position+1",
      ["constructor_id=? AND position>=?", constructor_id, position])
  end
end