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

  def as_json(options=nil)
    {
      'id' => id,
      'constructable_type' => constructable_type,
      'constructor_id' => constructor_id,
      'count' => count,
      'position' => position,
      'prepaid' => prepaid?,
      'params' => params
    }
  end

  # Reduces resources from constructors planet.
  def reduce_resources!(count)
    raise ArgumentError.new(
      "Cannot reduce resources if this entry is not prepaid!"
    ) unless prepaid?
    planet = constructor.planet
    metal_cost, energy_cost, zetium_cost = get_resources(count)

    raise GameLogicError.new(
      "Insuffient resources for #{planet}! Wanted to build #{count} of #{
      constructable_type}, needed: metal: #{metal_cost}, energy: #{energy_cost
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
    raise ArgumentError.new(
      "Cannot return resources if this entry is not prepaid!"
    ) unless prepaid?

    metal_cost, energy_cost, zetium_cost = get_resources(count)

    constructor.planet.increase!(
      :metal => metal_cost, :energy => energy_cost,
      :zetium => zetium_cost
    )
  end

  # Returns [metal, energy, zetium] required to build _count_ of models.
  def get_resources(count)
    model = constructor.build_model(constructable_type, params)
    metal_cost = model.metal_cost(model.level + 1) * count
    energy_cost = model.energy_cost(model.level + 1) * count
    zetium_cost = model.zetium_cost(model.level + 1) * count

    [metal_cost, energy_cost, zetium_cost]
  end

  def can_merge?(model)
    model.constructor_id == self.constructor_id \
      && model.constructable_type == self.constructable_type \
      && model.player_id == self.player_id \
      && model.prepaid? == self.prepaid? \
      && model.params == self.params
  end

  # Merges with _model_ by increasing _count_ in _self_ and destroying
  # _model_.
  def merge!(model)
    raise ArgumentError.new("Cannot merge #{self} and #{model}!") \
      unless can_merge?(model)

    transaction do
      self.count += model.count
      # Don't destroy unsaved records, because callbacks are still fired even
      # for not saved records and we don't want that.
      model.destroy! unless model.new_record?

      save!
    end
  end

  # Reduce models count by _count_.
  def reduce!(count)
    self.count -= count
    save!
  end

  def to_s
    "<ConstructionQueueEntry id: #{id}, c_id: #{constructor_id}, p_id: #{
      player_id}, pos: #{position}, prepaid: #{prepaid?}, count: #{count
      }, c_type: #{constructable_type}>"
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