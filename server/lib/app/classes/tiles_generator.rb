class TilesGenerator
  CONFIG_FILTER = /^(planet|buildings|units|ui)/
  TABLES = [Tile.table_name, Building.table_name, Folliage.table_name,
    Unit.table_name]

  class << self
    def invoke(galaxy_id)
      generator = new(galaxy_id)
      yield generator
      generator.close
    end
  end

  # Invoke via .invoke
  def initialize(galaxy_id)
    @generator = SpaceMule.run("planet_map_generator")

    # Tables configuration
    @generator.write "#{TABLES.join(" ")}\n"
    # Galaxy id
    @generator.write "#{galaxy_id}\n"

    @generator.write "%s\n" % CONFIG.filter(CONFIG_FILTER).to_json
    @generator.write "end_of_config\n"
  end

  def create_homeworlds(homeworlds)
    homeworlds = [homeworlds] unless homeworlds.is_a? Array

    homeworlds.each do |id|
      @generator.write "homeworld #{id}\n"
      execute_sql
    end
  end

  def create(id, width, height, name)
    @generator.write "generate #{id} #{width} #{height} #{name}\n"
    execute_sql
  end

  def execute_sql
    # Tiles, folliages, buildings, units
    # Every line might be empty
    TABLES.size.times do
      line = @generator.readline
      ActiveRecord::Base.connection.execute line unless line.blank?
    end
  end

  def close
    @generator.close
  end
end
