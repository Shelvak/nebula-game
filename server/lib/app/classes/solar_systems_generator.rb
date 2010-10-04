class SolarSystemsGenerator
  class << self
    # Yield each value in homeworld zone.
    def each_in_homeworld_zone(x, y)
      x_range, y_range = Galaxy.homeworld_zone(x, y)

      x_range.each do |zone_x|
        y_range.each do |zone_y|
          yield zone_x, zone_y
        end
      end
    end
  end

  def initialize(galaxy_id)
    @galaxy_id = galaxy_id
  end

  # Build and save solar systems for one +Player+. Return homeworld +Planet+
  # for him.
  #
  # If _create_children_ is true also create planets for each solar system.
  def create(create_children=true)
    x, y = build
    save

    create_planets if create_children

    solar_system = SolarSystem::Homeworld.find(:first, :conditions => {
        :x => x,
        :y => y,
        :galaxy_id => @galaxy_id
      })
    Planet::Homeworld.find_by_solar_system_id(solar_system.id)
  end

  protected
  def init_build_variables
    @homeworld_zones = {}
    # Mark already taken homeworld zones
    SolarSystem::Homeworld.get_coords(@galaxy_id).each do |x, y|
      flag_homeworld_zone(x, y)
    end

    # Arrays of type [id, x, y] will be stored here.
    @solar_systems = {
      :homeworld => [],
      :expansion => [],
      :resource => []
    }
  end

  def build
    init_build_variables

    x, y = find_location_for_new_homeworld
    create_homeworld(x, y)

    [:expansion, :resource].each do |type|
      CONFIG["galaxy.#{type}_systems.number"].times do
        x1, y1 = find_location_for_new_system(x, y)
        create_solar_system(type, x1, y1)
      end
    end

    [x, y]
  end

  def create_planets
    generator = PlanetsGenerator.new(@galaxy_id)

    @solar_systems.each do |type, list|
      list.each do |id, x, y|
        generator.build(type, id)
      end
    end

    generator.save
  end

  # Given homeworlds x, y find location for new system (not homeworld!).
  def find_location_for_new_system(home_x, home_y)
    possible_positions = []
    self.class.each_in_homeworld_zone(home_x, home_y) do |x, y|
      possible_positions.push [x, y]
    end
    possible_positions.shuffle!

    while pos = possible_positions.shift
      # true means it's taken for homeworld
      # nil won't happen because we're working in our zone
      # everything else means it's taken.
      return pos if @homeworld_zones[pos] == true
    end

    nil
  end

  def find_location_for_new_homeworld
    @position_index ||= 0
    @current_positions ||= [Galaxy::START_POSITION]

    # Select direction for new position search
    radius = CONFIG['galaxy.homeworld.direction_radius']

    # Try to find suitable place
    position = @current_positions.random_element
    x_delta, y_delta = [
      rand(1, radius + 1) * [-1, 1].random_element,
      rand(1, radius + 1) * [-1, 1].random_element
    ]
    until can_create_new_homeworld?(*position)
      position[0] += x_delta
      position[1] += y_delta
    end

    if @position_index % CONFIG['galaxy.homeworld.position_period'] == 0
      @current_positions.push position
    end
    if @position_index % CONFIG['galaxy.homeworld.expire_period'] == 0
      @current_positions.shift
    end

    # Return suitable position
    position
  end

  # Create homeworld at coords _x_, _y_.
  #
  # Flag zone as taken and push homeworld into list.
  def create_homeworld(x, y)
    flag_homeworld_zone(x, y)
    create_solar_system(:homeworld, x, y)
  end

  # Flag zone with homeworld in _x_, _y_ as taken.
  def flag_homeworld_zone(x, y)
    self.class.each_in_homeworld_zone(x, y) do |zone_x, zone_y|
      # Only flag if nil, there may be something else in same zone
      @homeworld_zones[[zone_x, zone_y]] ||= true
    end
  end

  # Create solar system of _type_ at coords _x_, _y_.
  def create_solar_system(type, x, y)
    @homeworld_zones[[x, y]] = type
    @solar_systems[type].push [nil, x, y]
  end

  def can_create_new_homeworld?(x, y)
    self.class.each_in_homeworld_zone(x, y) do |zone_x, zone_y|
      return false if @homeworld_zones[[zone_x, zone_y]] == true
    end

    true
  end

  def save
    current_id = (SolarSystem.maximum(:id) || 0) + 1

    values = []
    @solar_systems.each do |type, list|
      list.each do |entry|
        id, x, y = entry
        id = entry[0] = current_id
        values.push "(#{id}, #{@galaxy_id}, '#{type.to_s.camelize}', #{
          x}, #{y})"

        # Increment ID counter
        current_id += 1
      end
    end

    MysqlUtils.mass_insert(
      SolarSystem.table_name,
      "`id`, `galaxy_id`, `type`, `x`, `y`",
      values
    )
  end
end