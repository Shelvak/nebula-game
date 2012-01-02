# Actual database entries for ConstructionQueue.
#
# Do not use this class directly from the constructors. Instead use
# ConstructionQueue class that will manage these objects.
#
class ConstructionQueueEntry < ActiveRecord::Base
  default_scope :order => :position
  belongs_to :constructor, :class_name => "Building"
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
    metal_cost, energy_cost, zetium_cost, population_cost = get_resources(count)
    player = get_player(planet, population_cost)

    raise GameLogicError.new(
      "Insuffient resources for #{planet} && #{player}! Wanted to build #{count
      } of #{constructable_type}, needed: metal: #{metal_cost}, energy: #{
      energy_cost}, zetium: #{zetium_cost}, population: #{population_cost}"
    ) if planet.metal < metal_cost || planet.energy < energy_cost ||
      planet.zetium < zetium_cost ||
      (! player.nil? && player.population_free < population_cost)

    planet.increase!(
      :metal => -metal_cost, :energy => -energy_cost,
      :zetium => -zetium_cost
    )

    unless player.nil?
      player.population += population_cost
      player.save!
    end
  end

  # Returns resources to constructors planet.
  def return_resources!(count)
    raise ArgumentError.new(
      "Cannot return resources if this entry is not prepaid!"
    ) unless prepaid?

    planet = constructor.planet
    metal_cost, energy_cost, zetium_cost, population_cost = get_resources(count)
    player = get_player(planet, population_cost)

    planet.increase!(
      :metal => metal_cost, :energy => energy_cost,
      :zetium => zetium_cost
    )

    unless player.nil?
      player.population -= population_cost
      player.save!
    end
  end

  # Class of _constructable_type_.
  def constructable_class
    constructable_type.constantize
  end

  # Returns [metal, energy, zetium, population] required to build _count_
  # of models.
  def get_resources(count)
    raise ArgumentError.new(
      "Cannot get resources if this entry is not prepaid!"
    ) unless prepaid?

    klass = constructable_class
    metal_cost = klass.metal_cost(1) * count
    energy_cost = klass.energy_cost(1) * count
    zetium_cost = klass.zetium_cost(1) * count
    population_cost = constructable_type.starts_with?("Unit") \
      ? klass.population * count : 0

    [metal_cost, energy_cost, zetium_cost, population_cost]
  end

  def can_merge?(model)
    model.constructor_id == self.constructor_id \
      && model.constructable_type == self.constructable_type \
      && model.prepaid? == self.prepaid? \
      && model.params == self.params
  end

  # Merges with _model_ by increasing _count_ in _self_ and destroying
  # _model_.
  def merge!(model)
    raise ArgumentError.new("Cannot merge #{self} and #{model}!") \
      unless can_merge?(model)

    self.count += model.count
    # Don't destroy unsaved records, because callbacks are still fired even
    # for not saved records and we don't want that.
    model.destroy! unless model.new_record?

    save!
  end

  # Reduce models count by _count_.
  def reduce!(count)
    self.count -= count
    save!
  end

  def to_s
    "<ConstructionQueueEntry id: #{id}, c_id: #{constructor_id
      }, pos: #{position}, prepaid: #{prepaid?}, count: #{count
      }, c_type: #{constructable_type}>"
  end

  protected
  def get_player(planet, population_cost)
    player = nil
    if population_cost > 0
      player = planet.player
      raise ArgumentError.new(
        "Wanted to reduce/increase #{population_cost} population for #{count
        } of #{constructable_type} but player is nil for #{planet}!"
      ) if player.nil?
    end
    player
  end

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