# Base class for Tile::* classes.
class Tile < ActiveRecord::Base
  include Parts::WithLocking

  include FastFind
  def self.fast_find_columns
    {:id => :to_i, :x => :to_i, :y => :to_i, :kind => :to_i}
  end

  # Not stored in database.
  VOID = -1
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

  FOLLIAGE_2X3 = 15
  FOLLIAGE_2X4 = 16
  FOLLIAGE_3X2 = 17
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
    FOLLIAGE_2X3 => 'folliage_2x3',
    FOLLIAGE_2X4 => 'folliage_2x4',
    FOLLIAGE_3X2 => 'folliage_3x2',
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
    FOLLIAGE_2X3 => [2, 3],
    FOLLIAGE_2X4 => [2, 4],
    FOLLIAGE_3X2 => [3, 2],
    FOLLIAGE_3X3 => [3, 3],
    FOLLIAGE_3X4 => [3, 4],
    FOLLIAGE_4X3 => [4, 3],
    FOLLIAGE_4X4 => [4, 4],
    FOLLIAGE_4X6 => [4, 6],
    FOLLIAGE_6X6 => [6, 6],
    FOLLIAGE_6X2 => [6, 2],
  }

  # Tiles that resource extractors are built upon.
  RESOURCE_TILES = [ORE, GEOTHERMAL, ZETIUM]

  # Tiles that can be built upon.
  REGULAR_TILES = [NOXRIUM, JUNKYARD, SAND, TITAN]

  # Tile kinds that can be explored.
  EXPLORATION_TILES = MAPPING.keys - RESOURCE_TILES - REGULAR_TILES
  
  include Parts::Object
  def self.notify_on_create?; false; end
  def self.notify_on_update?; false; end
  include Parts::Notifier

  belongs_to :planet, :class_name => "SsObject::Planet"

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

  def to_s
    "<Tile(#{id}, kind #{kind}) @ P #{planet_id}: #{x},#{y}>"
  end

  # {
  #   'id' => Fixnum,
  #   'planet_id' => Fixnum,
  #   'x' => Fixnum,
  #   'y' => Fixnum,
  #   'kind' => Fixnum
  # }
  #
  def as_json(options=nil)
    attributes
  end

  # Is this tile a block tile?
  def block_tile?
    BLOCK_SIZES.has_key?(kind)
  end

  def x_end
    raise ArgumentError.new("#{self} is not a block tile!") unless block_tile?

    x + BLOCK_SIZES[kind][0] - 1
  end

  def y_end
    raise ArgumentError.new("#{self} is not a block tile!") unless block_tile?

    y + BLOCK_SIZES[kind][1] - 1
  end

  # Checks if given _kind_ is exploration tile kind, raises ArgumentError
  # otherwise.
  def self.exploration_check_tile_kind!(kind)
    raise ArgumentError.new(
      "Cannot determine exploration time for non-exploration tile #{kind}!"
    ) unless EXPLORATION_TILES.include?(kind)
  end

  # Returns exploration time in seconds for given tile _kind_.
  def self.exploration_time(kind)
    exploration_check_tile_kind!(kind)

    width, height = BLOCK_SIZES[kind]
    CONFIG.evalproperty("tiles.exploration.time", 'width' => width,
      'height' => height).to_i
  end

  # Returns scientists needed for exploration for given tile _kind_.
  def self.exploration_scientists(kind)
    exploration_check_tile_kind!(kind)

    width, height = BLOCK_SIZES[kind]
    CONFIG.evalproperty("tiles.exploration.scientists", 'width' => width,
      'height' => height).to_i
  end

  def ==(other)
    other.is_a?(self.class) && x == other.x && y == other.y &&
      kind == other.kind && planet_id == other.planet_id
  end

  def <=>(other)
    value = x <=> other.x
    value = y <=> other.y if value == 1
    value
  end
end
