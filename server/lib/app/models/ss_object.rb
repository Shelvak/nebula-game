# Use SsObject::*SsObject* instead of this! This acts as a base class.
class SsObject < ActiveRecord::Base
  DScope = Dispatcher::Scope
  default_scope lock(true)

  include Location
  include Parts::Object
  include Parts::DelayedEventDispatcher

  # Only planets belong to player, however for optimization purposes we 
  # define this here to allow including this relationship when querying
  # for solar system objects.
  belongs_to :player
  belongs_to :solar_system
  delegate :galaxy, :galaxy_id, :to => :solar_system

  scope :in_galaxy, Proc.new { |galaxy|
    galaxy = galaxy.id if galaxy.is_a? Galaxy

    {:conditions => {:galaxy_id => galaxy}}
  }
  scope :in_solar_system, Proc.new { |solar_system|
    solar_system = solar_system.id if solar_system.is_a? SolarSystem

    {:conditions => {:solar_system_id => solar_system}}
  }

  AS_JSON_ATTRIBUTES = %w{id solar_system_id position angle type size}

  # Returns following attributes:
  # id solar_system_id position angle type size
  #
  # Type can be either "Planet", "Asteroid" or "Jumpgate"
  def as_json(options=nil)
    read_attributes(AS_JSON_ATTRIBUTES)
  end

  # Reads given _attributes_ into _storage_ and returns _storage_.
  def read_attributes(attributes, storage={})
    attributes.each do |attr|
      storage[attr.to_s] = read_attribute(attr).as_json
    end
    storage
  end

  # Returns +LocationPoint+ for this +SsObject+.
  def location
    LocationPoint.new(id, Location::SS_OBJECT, nil, nil)
  end
  alias :location_point :location

  # See LocationPoint#object.
  def object
    self
  end

  # Returns +SolarSystemPoint+ in which this +SsObject+ is.
  def solar_system_point
    SolarSystemPoint.new(solar_system_id, position, angle)
  end

  # See Location#client_location
  def client_location
    raise NotImplementedError.new(
      "I should never be called on #{self.inspect}!"
    )
  end

  # See Location#route_attrs
  def route_attrs(prefix="")
    {
      "#{prefix}id".to_sym => id,
      "#{prefix}type".to_sym => Location::SS_OBJECT,
      "#{prefix}x".to_sym => position,
      "#{prefix}y".to_sym => angle
    }
  end

  def unassigned?; player_id.nil?; end

  def to_s
    "<SSO #{id},#{position}:#{angle}@#{solar_system_id}>"
  end

  # Returns Array of player ids that can view this planet.
  def observer_player_ids; []; end

  def landable?; false; end
  def unlandable?; ! landable?; end

  protected
  def get_type
    self.class.to_s.demodulize.underscore.to_sym
  end

  class << self
    # Because combat on that location can also create a wreckage.
    def spawn_scope(asteroid); DScope.combat(asteroid.location_point); end
    def spawn_callback(asteroid); asteroid.spawn_resources!; end

    def energy_diminished_scope(planet); DScope.planet_owner(planet); end
    def energy_diminished_callback(planet)
      changes = model.ensure_positive_energy_rate!
      Notification.create_for_buildings_deactivated(
        model, changes
      ) unless changes.blank? || model.player_id.nil?
      EventBroker.fire(model, EventBroker::CHANGED)
    end

    # Raid only spawns units and creates a cooldown.
    def raid_scope(planet); DScope.planet(planet); end
    def raid_callback(planet)
      spawner = RaidSpawner.new(planet)
      spawner.raid!
    end

    # Exploration might increase resources or give new units.
    def exploration_complete_scope(planet); DScope.planet(planet); end
    def exploration_complete_callback(planet)
      planet.finish_exploration!
    end

    # Find planet by _id_ for _player_id_.
    #
    # Raise <tt>ActiveRecord::RecordNotFound</tt> if not found.
    def find_for_player!(id, player_id)
      planet = find(:first, :conditions => {
        :id => id,
        :player_id => player_id
      })
      raise ActiveRecord::RecordNotFound if planet.nil?

      planet
    end
  end
end