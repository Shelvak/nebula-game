class SolarSystem::Homeworld < SolarSystem
  # Returns array of [x, y] coordinates for all given homeworld systems
  # in given galaxy.
  def self.get_coords(galaxy_id)
    connection.select_rows(
      "SELECT x, y FROM `#{table_name}` WHERE #{
        sanitize_sql_hash_for_conditions(:galaxy_id => galaxy_id)}"
    ).map do |row|
      row.map { |coord| coord.to_i }
    end
  end
end