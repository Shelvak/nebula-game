# This refers to logical zone of galaxy with many solar systems in it.
#
# Each zone is positioned by slot and quarter.
#
# Quarter is part of galaxy map. Quarters are defined in such order:
#      0
#
#      |           Ist   - x: [0, inf)   y: [-1, -inf)
#  III | IV        IInd  - x: [-1, -inf) y: [-1, -inf)
# -----+-----  0   IIIrd - x: [-1, inf), y: [0, inf)
#   II | I         IVth  - x: [0, inf),  y: [0, inf)
#      |
#
# Slot is position in the quarter. They are numbered in diagonals like this in
# Ist quarter and are mirrored to others:
#      0  1  2  3  4  5
#    +------------------
# -1 | 01 02 04 07 11 <-- slot number
# -2 | 03 05 08 12
# -3 | 06 09 13
# -4 | 10 14
# -5 | 15
# -6 |

class Galaxy::Zone
  attr_reader :slot, :diagonal, :x, :y, :quarter

  QUARTER_TRANSFORMATIONS = [[1, 1], [-1, 1], [-1, -1], [1, -1]]

  # Initializes zone from slot number.
  def initialize(slot, quarter)
    raise ArgumentError.new("slot should be >= 1, but #{slot} was given!") \
      if slot < 1
    raise ArgumentError.new("quarter must be in 1..4, but it was #{quarter}") \
      unless quarter >= 1 && quarter <= 4
    @slot = slot
    @quarter = quarter
    @diameter = Cfg.galaxy_zone_diameter

    # Calculate diagonal number.
    @diagonal = (((1 + 8 * slot) ** 0.5 - 1) / 2).ceil

    # Calculate coordinates in Ist quarter.
    @x = (@diagonal.to_f / 2 * (1 + @diagonal) - slot).to_i
    @y = x - @diagonal

    # Transform to appropriate quarter.
    qt_x, qt_y = QUARTER_TRANSFORMATIONS[quarter - 1]
    @x = @x * -1 - 1 if qt_x == -1
    @y = @y * -1 - 1 if qt_y == -1
  end

  def ==(other); eql?(other); end

  def eql?(other)
    other.is_a?(self.class) && @slot == other.slot && @quarter == other.quarter
  end

  def to_s
    "<Galaxy::Zone Q%d (%5d,%5d), slot %5d>" % [@quarter, @x, @y, @slot]
  end

  # Returns absolute x and y ranges. Both ranges are inclusive.
  def ranges
    x_start, y_start = absolute(0, 0)
    x_end, y_end = absolute(@diameter - 1, @diameter - 1)

    [x_start..x_end, y_start..y_end]
  end

  # Yields each coordinate in this zone.
  def each_coord
    x_range, y_range = ranges
    x_range.each { |x| y_range.each { |y| yield [x, y] } }
  end

  # Returns free spot in the zone for given galaxy id. Raises error if such spot
  # cannot be found.
  def free_spot_coords(galaxy_id)
    x_range, y_range = ranges

    possible = Set.new
    each_coord { |coords| possible.add(coords) }

    SolarSystem.
      select("x, y").
      where(galaxy_id: galaxy_id, x: x_range, y: y_range).
      c_select_all.each { |row| possible.delete([row['x'], row['y']]) }

    if possible.blank?
      raise "No possible spaces for #{self} in galaxy #{galaxy_id}!"
    else
      possible.to_a.random_element
    end
  end

  def absolute(x, y)
    [@x * @diameter + x, @y * @diameter + y]
  end

  class << self
    # Looks up zone by zone coordinates.
    def lookup(x, y)
      quarter = lookup_quarter(x, y)

      x, y = normalize_coords(x, y)
      diag_no = lookup_diag_no(x, y)

      # Compensate for .ceil.
      slot = diag_no + (y + 1) * -1
      new(slot, quarter)
    end

    # Looks up zone by absolute solar system coordinates.
    def lookup_by_coords(x, y)
      diameter = Cfg.galaxy_zone_diameter
      lookup(
        (x.to_f / diameter).floor,
        (y.to_f / diameter).floor
      )
    end

    # Calculate relative (in-zone) coordinates for given absolute galaxy
    # coordinates.
    def relative_coords(x, y)
      diameter = Cfg.galaxy_zone_diameter

      # Calculate coordinate in zone. Ensure that in-zone coordinate is
      # calculated correctly if absolute coord is negative.
      calc_coord = lambda do |c|
        return c % diameter if c >= 0
        mod = c.abs % diameter
        mod == 0 ? 0 : diameter - mod
      end

      [calc_coord[x], calc_coord[y]]
    end

    # Returns +Zone+ to which player can be reattached. This zone is selected
    # to closely match player points, it must not have more players than allowed
    # in configuration. If such zone cannot be
    def for_reattachment(galaxy_id, player_points)
      typesig binding, Fixnum, Fixnum

      zone_diam = Cfg.galaxy_zone_diameter
      max_players = Cfg.galaxy_zone_max_player_count
      subselect = %Q{
SELECT
  #{zone_x_select(zone_diam)},
  #{zone_y_select(zone_diam)},
  #{quarter_select},
  #{slot_select(zone_diam)},
  player_id,
  #{points_select}
FROM `solar_systems` AS s
INNER JOIN players AS p ON p.id=s.player_id
WHERE
  player_id IS NOT NULL AND
  x IS NOT NULL AND
  y IS NOT NULL AND
  s.galaxy_id=#{galaxy_id.to_i}
      }

      sql = %Q{
SELECT
  quarter,
  CAST(slot AS UNSIGNED) AS slot,
  CAST(ABS(AVG(points) - #{player_points.to_i}) AS UNSIGNED) AS points_diff,
  CAST(COUNT(player_id) AS UNSIGNED) AS player_count
FROM (#{subselect}) AS tmp1
GROUP BY quarter, slot
HAVING player_count < #{max_players}
ORDER BY points_diff, slot, player_count
LIMIT 1
      }
      row = ActiveRecord::Base.connection.select_one(sql)
      return for_enrollment(galaxy_id, nil) if row.nil?
      new(row['slot'], row['quarter'])
    end

    # Returns +Zone+ to which player can be enrolled. Raises errors if no free
    # zones exist. Excludes full zones and zones where player home systems are
    # older than _max_age_.
    def for_enrollment(galaxy_id, max_age)
      typesig binding, Fixnum, [NilClass, Fixnum]

      zone_diam = Cfg.galaxy_zone_diameter
      max_players = Cfg.galaxy_zone_max_player_count

      age_select = max_age.nil? \
        ? "0 AS age" \
        : "IF(created_at, TO_SECONDS('#{Time.now.to_s(:db)
          }') - TO_SECONDS(created_at), 0) AS age"
      age_condition = max_age.nil? ? "1=1" : "max_age <= #{max_age.to_i}"

      subselect = %Q{
SELECT
  #{zone_x_select(zone_diam)},
  #{zone_y_select(zone_diam)},
  #{quarter_select},
  #{slot_select(zone_diam)},
  #{age_select},
  player_id
FROM `solar_systems` AS s
#{max_age.nil? ? "" : "LEFT JOIN players AS p ON p.id=s.player_id"}
WHERE
  kind=#{SolarSystem::KIND_NORMAL.to_i} AND
  x IS NOT NULL AND
  y IS NOT NULL AND
  s.galaxy_id=#{galaxy_id.to_i}
      }

      sql = %Q{
  SELECT
    quarter,
    CAST(slot AS UNSIGNED) AS slot,
    CAST(COUNT(player_id) AS UNSIGNED) AS player_count,
    CAST(MAX(age) AS UNSIGNED) AS max_age
  FROM (#{subselect}) AS tmp1
  GROUP BY quarter, slot
  HAVING player_count < #{max_players} AND #{age_condition}
  ORDER BY slot, player_count, max_age
  LIMIT 1
      }
      row = ActiveRecord::Base.connection.select_one(sql)

      raise "Cannot find suitable zone for reattachment in galaxy #{
        galaxy_id} with max player age #{max_age.inspect}!" if row.nil?

      new(row['slot'], row['quarter'])
    end

  private

    # Looks up diagonal number for coordinates. Starts from 1.
    def lookup_diag_no(x, y)
      x, y = normalize_coords(x, y)
      # Magic formula reverse engineered from Mykolas.
      (((1 + 2 * (y - x)) ** 2 - 1) / 8.0) + 1
    end

    # Normalize coordinates to support all quarters.
    def normalize_coords(x, y)
      x = x * -1 - 1 if x < 0
      y = y * -1 - 1 if y > -1
      [x, y]
    end

    # Looks up in which quarter those coordinates are.
    def lookup_quarter(x, y)
      return 1 if x >= 0 && y <= -1
      return 2 if x <  0 && y <= -1
      return 3 if x <  0 && y >  -1
      return 4
    end

    def zone_x_select(zone_diam)
      "@zone_x := FLOOR(IF(x <  0, x * -1 - 1, x) / #{zone_diam})"
    end

    def zone_y_select(zone_diam)
      "@zone_y := FLOOR(IF(y > -1, y * -1 - 1, y) / #{zone_diam})"
    end

    def quarter_select
      "IF(x >= 0 AND y <= -1, 1,
        IF(x < 0 AND y <= -1, 2,
          IF(x < 0 AND y > -1, 3, 4)
        )
      ) AS quarter"
    end

    def slot_select(zone_diam)
      "((POW(1 + 2 * (@zone_y - @zone_x), 2) - 1) / #{zone_diam.to_i
        }.0) + 1 + (@zone_y + 1) * -1 AS slot"
    end

    def points_select
      "#{Player::POINT_ATTRIBUTES.join("+")} AS points"
    end
  end
end