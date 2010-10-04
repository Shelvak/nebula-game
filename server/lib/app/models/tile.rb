# Base class for Tile::* classes.
class Tile < ActiveRecord::Base
  include FastFind
  def self.fast_find_columns
    {:x => :to_i, :y => :to_i, :kind => :to_i}
  end

  # Only metal extractors can be built on these
  ORE = 0
  # Only geothermal plants can be built on these
  GEOTHERMAL = 1
  # Only zetium extractors can be built on these
  ZETIUM = 2
  # Provides additional energy output
  NOXRIUM = 3
  # Provides faster building
  JUNKYARD = 4
  # Reduces buildings armor
  SAND = 5
  # Increases buildings armor
  TITAN = 6
  
  # Nothing can be built on these types
  
  WATER = 7
  FOLLIAGE_3X3 = 8
  FOLLIAGE_3X4 = 14
  FOLLIAGE_4X3 = 9
  FOLLIAGE_4X4 = 10
  FOLLIAGE_4X6 = 11
  FOLLIAGE_6X6 = 12
  FOLLIAGE_6X2 = 13

  MAPPING = {
    ORE => 'ore',
    GEOTHERMAL => 'geothermal',
    ZETIUM => 'zetium',
    NOXRIUM => 'noxrium',
    JUNKYARD => 'junkyard',
    SAND => 'sand',
    TITAN => 'titan',
    WATER => 'water',
    FOLLIAGE_3X3 => 'folliage_3x3',
    FOLLIAGE_3X4 => 'folliage_3x4',
    FOLLIAGE_4X3 => 'folliage_4x3',
    FOLLIAGE_4X4 => 'folliage_4x4',
    FOLLIAGE_4X6 => 'folliage_4x6',
    FOLLIAGE_6X6 => 'folliage_6x6',
    FOLLIAGE_6X2 => 'folliage_6x2',
  }

  BLOCK_SIZES = {
    ORE => [2, 2],
    GEOTHERMAL => [2, 2],
    ZETIUM => [2, 2],
    FOLLIAGE_3X3 => [3, 3],
    FOLLIAGE_3X4 => [3, 4],
    FOLLIAGE_4X3 => [4, 3],
    FOLLIAGE_4X4 => [4, 4],
    FOLLIAGE_4X6 => [4, 6],
    FOLLIAGE_6X6 => [6, 6],
    FOLLIAGE_6X2 => [6, 2],
  }

  belongs_to :planet

  validates_uniqueness_of :planet_id, :scope => [:x, :y]

  scope :for_building, Proc.new { |building|
    {
      :conditions => [
        "planet_id=? AND x BETWEEN ? AND ? AND y BETWEEN ? AND ?",
        building.planet_id,
        building.x, building.x_end,
        building.y, building.y_end
      ]
    }
  }

  def as_json(options=nil)
    attributes.except('id', 'planet_id')
  end

  def <=>(other)
    value = x <=> other.x
    value = y <=> other.y if value == 1
    value
  end
end
