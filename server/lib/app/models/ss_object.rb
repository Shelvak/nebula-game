# Use SsObject::SsObject instead of this! This acts as a base class.
class SsObject < ActiveRecord::Base
  include Location
  include Parts::Object

  # Only planets belong to player, however for optimization purposes we 
  # define this here to allow including this relationship when querying
  # for ss objects.
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
      storage[attr.to_sym] = read_attribute(attr)
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

  # See Location#client_location
  def client_location
    ClientLocation.new(id, Location::SS_OBJECT, position, angle, name,
      terrain, solar_system_id)
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
    "<SsObject #{name}, #{position} @ Solar System (id: #{
      solar_system_id}), player_id: #{player_id}>"
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