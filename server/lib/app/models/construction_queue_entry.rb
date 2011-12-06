# Actual database entries for ConstructionQueue.
#
# Do not use this class directly from the constructors. Instead use
# ConstructionQueue class that will manage these objects.
#
class ConstructionQueueEntry < ActiveRecord::Base
  default_scope :order => :position
  belongs_to :upgradable, :polymorphic => true
  belongs_to :constructor, :class_name => "Building"
  belongs_to :player
  serialize :params, Hash

  def self.notify_on_update?; false; end
  def self.notify_on_destroy?; false; end
  include Parts::Notifier
  include Parts::Object

  include FlagShihTzu
  has_flags(
    1 => :prepaid,
    :check_flag_column => false
  )

  before_save do
    reduce_resources!(count) if prepaid?
    true
  end

  # Reduces resources from constructors planet.
  def reduce_resources!(count)
    planet = constructor.planet
    metal_cost, energy_cost, zetium_cost = get_resources(count)

    raise GameLogicError.new(
      "Insuffient resources for #{planet}! Wanted to build #{count} of #{
      type}, needed: metal: #{metal_cost}, energy: #{energy_cost
      }, zetium: #{zetium_cost}"
    ) if planet.metal < metal_cost || planet.energy < energy_cost ||
      planet.zetium < zetium_cost

    planet.increase!(
      :metal => -metal_cost, :energy => -energy_cost,
      :zetium => -zetium_cost
    )
  end

  # Returns resources to constructors planet.
  def return_resources!(count)
    planet = constructor.planet
    metal_cost, energy_cost, zetium_cost = get_resources(count)

    planet.increase!(
      :metal => metal_cost, :energy => energy_cost,
      :zetium => zetium_cost
    )
  end

  def get_resources(count)
    model = constructor.build_model(constructable_type, params)
    metal_cost = model.metal_cost(level + 1) * count
    energy_cost = model.energy_cost(level + 1) * count
    zetium_cost = model.zetium_cost(level + 1) * count

    [metal_cost, energy_cost, zetium_cost]
  end

  def can_merge?(model)
    model.constructor_id == self.constructor_id \
      && model.constructable_type == self.constructable_type \
      && model.player_id == self.player_id \
      && model.prepaid == self.prepaid \
      && model.params == self.params
  end

  # Merges with _model_ by increasing _count_ in _self_ and destroying
  # _model_.
  def merge!(model)
    transaction do
      self.count += model.count
      model.destroy!

      save!
    end
  end

  # Reduce models count by _count_. Give back resources on reducing.
  def reduce!(count)
    self.count -= count

    transaction do
      return_resources!(count) if prepaid?
      save!
    end
  end

  def to_s
    "<ConstructionQueueEntry id: #{id}, c_id: #{constructor_id}, p_id: #{
      player_id}, pos: #{position}, count: #{count}, c_type: #{
      constructable_type}>"
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