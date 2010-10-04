# Use Planet::Regular instead of this! This acts as a base class.
class Planet < ActiveRecord::Base
  include Location
  include Parts::Object

  # You can land in these planets
  CLASS_LANDABLE = :landable
  # You CANNOT land in these planets
  CLASS_UNLANDABLE = :unlandable

  belongs_to :solar_system
  delegate :galaxy, :galaxy_id, :to => :solar_system
  belongs_to :galaxy
  belongs_to :player

  # Foreign keys take care of the destruction
  has_one :resources_entry
  has_many :tiles
  has_many :folliages
  has_many :buildings
  has_many :units,
    :finder_sql => %Q{SELECT * FROM `#{Unit.table_name}` WHERE
    `player_id` IS NOT NULL AND
    `location_type`=#{Location::PLANET} AND `location_id`=#\{id\} AND
    `location_x` IS NULL AND `location_y` IS NULL}

  validates_uniqueness_of :position, :scope => :solar_system_id

  scope :in_galaxy, Proc.new { |galaxy|
    galaxy = galaxy.id if galaxy.is_a? Galaxy

    {:conditions => {:galaxy_id => galaxy}}
  }
  scope :in_solar_system, Proc.new { |solar_system|
    solar_system = solar_system.id if solar_system.is_a? SolarSystem

    {:conditions => {:solar_system_id => solar_system}}
  }
  scope :for_player, Proc.new { |player|
    player_id = player.is_a?(Player) ? player.id : player

    {:conditions => {:player_id => player_id}}
  }

  # This one is for tests. Generating whole thing each time ain't fun.
  attr_accessor :create_empty, :skip_resources_entry

  def as_json(options=nil)
    attributes.except('type').merge(
      :player => player ? player.as_json : nil,
      :planet_class => planet_class
    )
  end

  # Returns +LocationPoint+ for this +Planet+.
  def location
    LocationPoint.new(id, Location::PLANET, nil, nil)
  end
  alias :location_point :location

  # See LocationPoint#object.
  def object
    self
  end

  # See Location#client_location
  def client_location
    ClientLocation.new(id, Location::PLANET, position, angle, name,
      variation, solar_system_id)
  end

  # See Location#route_attrs
  def route_attrs(prefix="")
    {
      "#{prefix}id".to_sym => id,
      "#{prefix}type".to_sym => Location::PLANET,
      "#{prefix}x".to_sym => position,
      "#{prefix}y".to_sym => angle
    }
  end

  def unassigned?; player_id.nil?; end

  def to_s
    "<Planet #{name}, #{position} @ Solar System (id: #{
      solar_system_id}), player_id: #{player_id}>"
  end

  # Returns Array of player ids that can view this planet.
  def observer_player_ids
    (player.nil? ? [] : player.friendly_ids) |
      Unit.player_ids_in_location(self)
  end
  
  def landable?; planet_class == CLASS_LANDABLE; end
  def unlandable?; planet_class == CLASS_UNLANDABLE; end

  # Returns one of the Planet::CLASS_* constants.
  def planet_class
    self.class.planet_class
  end

  protected
  before_create :set_missing_attributes
  def set_missing_attributes
    self.angle = rand(360) if angle.nil?

    generate_dimensions
  end

  def generate_dimensions
    type = get_type
    width, height = Map.dimensions_for_area(type)
    self.width = width if self.width.nil?
    self.height = height if self.width.nil?

    self.size = self.class.size_from_dimensions(type,
      self.width, self.height)
  end

  after_create :create_resources_entry,
    :unless => Proc.new { |record| record.skip_resources_entry }
  after_create :generate_map,
    :unless => Proc.new { |record| record.create_empty }
  def generate_map
    TilesGenerator.invoke(solar_system.galaxy_id) do |generator|
      generator.create(id, width, height, get_type)
    end
  end

  before_save :update_fow_ss_entries, :if => Proc.new {
    |r| r.player_id_changed? }
  
  # Update FOW SS Entries to ensure that we see SS with our planets there
  # even if there are no radar coverage.
  def update_fow_ss_entries
    FowSsEntry.change_planet_owner(self)
    EventBroker.fire(self, EventBroker::CHANGED, 
      EventBroker::REASON_OWNER_CHANGED)
    true
  end

  after_save :update_resources_entry
  def update_resources_entry
    if player_id
      # Update resources entry `last_update` when player is assigned
      ResourcesEntry.update_all(
        "last_update=NOW()",
        ["planet_id=? AND last_update IS NULL", id]
      )
    end
  end

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

    def generate_planet_name(galaxy_id, solar_system_id, planet_id)
      "G#{galaxy_id}-S#{solar_system_id}-P#{planet_id}"
    end

    def planet_class
      raise ArgumentError.new("planet_class for #{self.inspect} is not defined!")
    end

    # Return one variation picked from all random ones by #planet_class
    def variation
      rand(CONFIG["ui.planet.#{planet_class}.variations"])
    end

    def metal_rate; nil; end
    def energy_rate; nil; end
    def zetium_rate; nil; end

    # Return proportional planet size for planet _type_ with given
    # _width_ and _height_.
    #
    # Returns random value from planet.size for homeworld type or if
    # either _width_ or _height_ is nil.
    def size_from_dimensions(type, width, height)
      if type.to_sym == :homeworld or width.nil? or height.nil?
        CONFIG.hashrand('planet.size')
      else
        area = width + height
        area_range_size = (
          CONFIG["planet.#{type}.area.to"] -
          CONFIG["planet.#{type}.area.from"]
        ).to_f

        if area_range_size == 0
          # Average of two
          size = (
            CONFIG['planet.size.to'] + CONFIG['planet.size.from']
          ).to_f / 2
        else
          planet_range_size = (
            CONFIG['planet.size.to'] - CONFIG['planet.size.from']
          ).to_f

          size = area * (area_range_size / planet_range_size)
        end

        size.to_i
      end
    end
  end
end