module Parts
  module BuildingValidations
    def self.included(klass)
      klass.validate :validate_position, :on => :create
    end

    protected
    def validate_position
      [:x, :x_end, :y, :y_end].each do |attr|
        value = self.send(attr)
        errors.add(:base,
          "#{attr} should be Fixnum (was #{value.inspect})"
        ) unless value.is_a?(Fixnum)
      end

      # We cannot continue if coordinates are bad.
      return unless errors.blank?

      if x < 0 or x_end >= planet.width or y < 0 \
          or y_end >= planet.height
        errors.add(:base, "Building is off map!")
      elsif planet.buildings.count(:all, :conditions => [
        "(x BETWEEN ? AND ? OR x_end BETWEEN ? AND ?) AND " +
        "(y BETWEEN ? AND ? OR y_end BETWEEN ? AND ?)",
        x - 1, x_end + 1,
        x - 1, x_end + 1,
        y - 1, y_end + 1,
        y - 1, y_end + 1
      ]) > 0
        errors.add(:base,
          "Buildings collide! (#{x - 1} <= x or x_end <= #{x_end + 1}, #{
            y - 1} <= y or y_end <= #{y_end + 1})")
      end

      Tile::BLOCK_SIZES.each do |kind, dimensions|
        case kind
        when Tile::ORE
          validate_position_check_ore
        when Tile::GEOTHERMAL
          validate_position_check_geothermal
        when Tile::ZETIUM
          validate_position_check_zetium
        else
          validate_position_check_folliage(kind, dimensions)
        end
      end
    end

    def validate_position_check_ore
      validate_position_check_block(Tile::ORE,
        Tile::BLOCK_SIZES[Tile::ORE])
    end

    def validate_position_check_geothermal
      validate_position_check_block(Tile::GEOTHERMAL,
        Tile::BLOCK_SIZES[Tile::GEOTHERMAL])
    end

    def validate_position_check_zetium
      validate_position_check_block(Tile::ZETIUM,
        Tile::BLOCK_SIZES[Tile::ZETIUM])
    end

    def validate_position_check_folliage(kind, dimensions)
      validate_position_check_block(kind, dimensions)
    end

    def validate_position_check_block(tile, dimensions)
      width, height = dimensions

      if Tile.count(:conditions => [
            "planet_id=? AND
              x BETWEEN ? AND ? AND
              y BETWEEN ? AND ? AND
              kind=?",
            planet_id,
            x - width + 1, x_end,
            y - height + 1, y_end,
            tile
          ]) > 0
        errors.add(:base,
          "Building cannot be built on block (tile: #{
            Tile::MAPPING[tile]})!")
      end
    end
  end
end
