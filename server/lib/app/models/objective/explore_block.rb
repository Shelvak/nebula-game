# Player must explore folliage block on planet to progress this objective.
class Objective::ExploreBlock < Objective
  # Only pass such planets where exploration is happening on required area
  # object.
  def filter(models)
    planet = models[0]

    if limit.nil?
      valid = true
    else
      width, height = Tile::BLOCK_SIZES[
        planet.tile_kind(planet.exploration_x, planet.exploration_y)
      ]

      valid = width * height >= limit
    end
    
    valid ? [planet] : []
  end

  # Wrap planet into array and pass it to #super
  def self.progress(planet)
    super([planet])
  end

  # Hardcoded objective key.
  KEY = "ExploreBlock"

  # Return hardcoded objective key.
  def self.resolve_key(klass); KEY; end

  # Return 1 for planet owner.
  def self.count_benefits(models)
    models.grouped_counts { |model| model.player_id }.to_a
  end
end