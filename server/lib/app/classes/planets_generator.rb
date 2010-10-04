class PlanetsGenerator
  class << self
    def create_for_solar_system(solar_system_type, solar_system_id,
        galaxy_id)
      generator = self.new(galaxy_id)
      generator.build(solar_system_type, solar_system_id)
      generator.save
    end
  end

  def initialize(galaxy_id)
    # Used for saving units.
    @galaxy_id = galaxy_id
    # solar_system_id => [ [id, type, position, width, height], ...]
    @planets = {}
  end

  def build(solar_system_type, solar_system_id)
    @planets[solar_system_id] = []
    solar_system_type = solar_system_type.to_sym

    planets = nil
    CONFIG.with_scope("solar_system.#{solar_system_type}") do |config|
      gaps = config.hashrand('gaps')
      regular_planets = config.hashrand('regular_planets')
      mining_planets = config.hashrand('mining_planets')
      resource_planets = config.hashrand('resource_planets')
      npc_planets = config.hashrand('npc_planets')
      jumpgates = config.hashrand('jumpgates')

      planets = (
        Array.new(gaps, nil) +
        Array.new(regular_planets, :regular) +
        Array.new(mining_planets, :mining) +
        Array.new(resource_planets, :resource) +
        Array.new(npc_planets, :npc) +
        Array.new(jumpgates, :jumpgate)
      ).sort_by { rand }

      # Gaps cannot be in the end of the system
      while planets.last.nil?
        planets.pop
        planets.insert(rand(0, planets.size), nil)
      end

      if solar_system_type == :homeworld
        home_position = CONFIG.hashrand("planets.home_position")
        planets.insert(home_position, :homeworld)
      end
    end

    homeworld_dimensions = Planet::Homeworld.get_dimensions(
      CONFIG['planet.homeworld.map'])
    planets.each_with_index do |type, position|
      # nil type means we have a gap
      unless type.nil?
        CONFIG.with_scope("planet.#{type}") do |config|
          case type
          when :homeworld
            width, height = homeworld_dimensions
          when :regular
            width, height = Map.dimensions_for_area(type)
          else
            width, height = :NULL, :NULL
          end

          @planets[solar_system_id].push [nil, type, position, width, height]
        end
      end
    end
  end

  def save(create_children=true)
    save_to_database

    create_tiles if create_children
  end

  protected
  def save_to_database
    current_id = (Planet.maximum(:id) || 0) + 1

    values = []
    resources_entry_values = []
    @planets.each do |solar_system_id, list|
      list.each do |entry|
        id, type, position, width, height, metal_rate, energy_rate,
          zetium_rate = entry
        id = entry[0] = current_id
        planet_klass = "Planet::#{type.to_s.camelcase}".constantize

        metal_rate = planet_klass.metal_rate || :NULL
        energy_rate = planet_klass.energy_rate || :NULL
        zetium_rate = planet_klass.zetium_rate || :NULL

        size = Planet.size_from_dimensions(type,
          width == :NULL ? nil : width,
          height == :NULL ? nil : height)

        values.push "(#{id}, #{solar_system_id}, '#{
          type.to_s.camelize}', #{rand_angle(position)
          }, #{width}, #{height}, #{position}, " +
          "#{planet_klass.variation}, " +
          "'#{Planet.generate_planet_name(@galaxy_id, solar_system_id, id)}', " +
          "#{size}, #{metal_rate}, #{energy_rate}, #{zetium_rate})"

        resources_entry_values.push "(#{id})"

        # Increment ID counter
        current_id += 1
      end
    end

    MysqlUtils.mass_insert(
      Planet.table_name,
      "`id`, `solar_system_id`, `type`, `angle`, `width`, `height`, " +
        "`position`, `variation`, `name`, `size`, `metal_rate`, `energy_rate`, " +
        "`zetium_rate`",
      values
    )
    MysqlUtils.mass_insert(
      ResourcesEntry.table_name,
      "`planet_id`",
      resources_entry_values
    )
  end

  # Returns "random" angle. Each position have certain allowed angles and
  # this method returns one of them.
  def rand_angle(position)
    num_of_quarter_points = position + 1
    quarter_point_degrees = 90 / num_of_quarter_points

    # random quarter + random point
    rand(4) * 90 + rand(num_of_quarter_points) * quarter_point_degrees
  end

  def create_tiles
    types = {
      :regular => []
    }
    homeworlds = []

    @planets.each do |solar_system_id, list|
      list.each do |id, type, position, width, height|
        case type
        when :homeworld
          homeworlds.push id
        when :regular
          types[type].push [id, width, height]
        end
      end
    end

    TilesGenerator.invoke(@galaxy_id) do |generator|
      types.each do |type, list|
        list.each do |id, width, height|
          generator.create(id, width, height, type)
        end
      end

      generator.create_homeworlds(homeworlds) unless homeworlds.blank?
    end
  end
end
