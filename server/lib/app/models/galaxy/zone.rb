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

  def to_s
    "<Galaxy::Zone Q%d (%5d,%5d), slot %5d>" % [@quarter, @x, @y, @slot]
  end

  # Looks up zone by zone coordinates.
  def self.lookup(x, y)
    quarter = lookup_quarter(x, y)

    x, y = normalize_coords(x, y)
    diag_no = lookup_diag_no(x, y)

    # Compensate for .ceil.
    slot = diag_no + (y + 1) * -1
    new(slot, quarter)
  end

  # Looks up diagonal number for coordinates. Starts from 1.
  def self.lookup_diag_no(x, y)
    x, y = normalize_coords(x, y)
    # Magic formula reverse engineered from Mykolas.
    (((1 + 2 * (y - x)) ** 2 - 1) / 8.0) + 1
  end

  # Normalize coordinates to support all quarters.
  def self.normalize_coords(x, y)
    x = x * -1 - 1 if x < 0
    y = y * -1 - 1 if y > -1
    [x, y]
  end

  # Looks up in which quarter those coordinates are.
  def self.lookup_quarter(x, y)
    return 1 if x >= 0 && y <= -1
    return 2 if x <  0 && y <= -1
    return 3 if x <  0 && y >  -1
    return 4
  end

  # Returns +Array+ of hashes of zone player point averages.
  #
  # [
  #   {'quarter' => quarter (1 to 4), 'slot' => Fixnum (1 to inf),
  #     'points_diff' => Fixnum},
  #   ...
  # ]
  #
  # points_diff is absolute (> 0) difference between zone average points and
  # your target points.
  #
  def point_averages(galaxy_id, target_points=0)
    zone_diam = 8
    sql = %Q{
SELECT
  quarter,
  CAST(slot AS UNSIGNED) AS slot,
  CAST(ABS(AVG(points) - #{target_points.to_i}) AS UNSIGNED) AS points_diff
FROM (
  SELECT
  @zone_x := FLOOR(IF(x <  0, x * -1 - 1, x) / #{zone_diam}),
  @zone_y := FLOOR(IF(y > -1, y * -1 - 1, y) / #{zone_diam}),
  IF(x >= 0 AND y <= -1, 1,
    IF(x < 0 AND y <= -1, 2,
      IF(x < 0 AND y > -1, 3, 4)
    )
  ) AS quarter,
  ((POW(1 + 2 * (@zone_y - @zone_x), 2) - 1) / 8.0) + 1 + (@zone_y + 1) * -1
    AS slot,
  p.economy_points + p.science_points + p.army_points AS points
  FROM `solar_systems` AS s
  INNER JOIN players AS p ON p.id=s.shield_owner_id
  WHERE
    shield_owner_id IS NOT NULL AND
    x IS NOT NULL AND
    y IS NOT NULL AND
    s.galaxy_id=#{galaxy_id.to_i}
) AS tmp1
GROUP BY quarter, slot
ORDER BY points_diff
    }
    ActiveRecord::Base.connection.select_all(sql)
  end

end