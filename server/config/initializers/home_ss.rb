# Wrap this in a lambda so it does not pollute our global namespace.
lambda do
  # Home solar system configuration.
  #
  # Common configuration
  #
  #  "position,angle" => {
  #    "type" => "planet|asteroid|jumpgate|nothing"
  #    # array of [count, type, flank, hp percentage (Float)]
  #    "units" => [[1, "dirac", 0, 1.0]]
  #    "wreckage" => [metal, energy, zetium] (Floats)
  #  }
  #
  # Extra parameters for planet type:
  #   "map" => "homeworld|other_map_name"
  #   "terrain" => 0 # Earth
  #
  # Extra parameters for asteroid type:
  #   "resources" => [metal, energy, zetium] (Floats)
  #
  gnat = Unit::Gnat.to_s.demodulize.underscore
  gnat_flanks = [0.4, 0.6]

  glancer = Unit::Glancer.to_s.demodulize.underscore
  glancer_flanks = [0, 1]

  spudder = Unit::Spudder.to_s.demodulize.underscore
  spudder_flanks = [0.3, 0.7]

  gnawer = Unit::Gnawer.to_s.demodulize.underscore
  gnawer_flanks = [0.8, 0.2]

  dirac = Unit::Dirac.to_s.demodulize.underscore
  dirac_flanks = [0.2, 0.8]

  thor = Unit::Thor.to_s.demodulize.underscore
  thor_flanks = [0.65, 0.35]

  demosis = Unit::Demosis.to_s.demodulize.underscore
  demosis_flanks = [0.75, 0.25]

  # TODO: replace BossShip with convoy unit
  convoy_ship = Unit::BossShip.to_s.demodulize.underscore
  convoy_ship_flanks = [1, 0]

  w = lambda do |level|
    level -= 1
    [3750.0 * 2 ** level, 7500.0 * 2 ** level, 1250.0 * 2 ** level]
  end

  r = lambda do |level|
    [2.0 * level, 2.0 * level, 2.0 * level]
  end

  u = lambda do |arg|
    units = [
      [(0.8 * arg).round, dirac, 0, 1.0],
      [arg.round, dirac, 1, 1.0],
    ]
    units += [
      [(0.25 * arg).round, thor, 0, 1.0],
      [(0.75 * arg).round, thor, 1, 1.0],
    ] if arg >= 1.5
    units += [
      [(0.5 * arg).round, demosis, 0, 1.0]
    ] if arg >= 3
    units
  end
  
  CONFIG['solar_system.home'] = {
    # Homeworld planet
    "0,90" => {
      "type" => "planet",
      "map" => "homeworld",
      "terrain" => 0, # Earth
      "units" => [[1, dirac, 0, 1.0]]
    },
    # Expansion planet
    "1,135" => {
      "type" => "planet",
      "map" => "expansion",
      "terrain" => 2, # Mud
      "units" => [[2, dirac, 0, 1.0], [2, dirac, 1, 1.0]]
    },
    # First asteroids
    "0,0"   => {"type" => "asteroid", "resources" => r[1], "units" => u[1]},
    "0,180" => {"type" => "asteroid", "resources" => r[1], "units" => u[1]},
    "1,90"  => {"type" => "asteroid", "resources" => r[2], "units" => u[1]},

    # Resource path
    "2,150" => {"type" => "nothing", "units" => u[1.25]},
    "3,134" => {"type" => "nothing", "units" => u[1.75], "wreckage" => w[1]},
    "3,112" => {"type" => "nothing", "units" => u[2.25]},
    "3,90"  => {"type" => "nothing", "units" => u[2.5], "wreckage" => w[2]},
    "3,66"  => {"type" => "nothing", "units" => u[2.75]},
    "3,44"  => {"type" => "nothing", "units" => u[3], "wreckage" => w[3]},
    "3,22"  => {"type" => "nothing", "units" => u[4]},
    "3,0"   => {"type" => "nothing", "units" => u[5], "wreckage" => w[4]},
    "3,336" => {"type" => "nothing", "units" => u[6]},
    "3,314" => {"type" => "nothing", "units" => u[7], "wreckage" => w[5]},
    "3,292" => {"type" => "nothing", "units" => u[8]},
    "2,270" => {"type" => "nothing", "units" => u[9], "wreckage" => w[6]},

    # Protective ring near the path
    "1,180" => {"type" => "nothing", "units" => u[1.25]},
    "1,0"   => {"type" => "nothing", "units" => u[1.5]},
    "1,45"  => {"type" => "nothing", "units" => u[1.5]},
    "3,156" => {"type" => "nothing", "units" => u[1.5]},
    "2,120" => {"type" => "asteroid", "resources" => r[3], "units" => u[3]},
    "2,90"  => {"type" => "nothing", "units" => u[4]},
    "2,60"  => {"type" => "asteroid", "resources" => r[3], "units" => u[5]},
    "2,30"  => {"type" => "asteroid", "resources" => r[3], "units" => u[6]},
    "2,0"   => {"type" => "nothing", "units" => u[7]},
    "2,330" => {"type" => "asteroid", "resources" => r[3], "units" => u[8]},
    # Lesser biggest stash protection
    "0,270" => {"type" => "asteroid", "resources" => r[1], "units" => u[8]},
    "1,225" => {"type" => "asteroid", "resources" => r[2], "units" => u[8]},
    "1,315" => {"type" => "asteroid", "resources" => r[2], "units" => u[8]},
    # Greater biggest stash protection
    "1,270" => {"type" => "nothing", "units" => u[10]},
    "2,240" => {"type" => "asteroid", "resources" => r[3], "units" => u[10]},
    "2,300" => {"type" => "nothing", "units" => u[10]},
    "3,246" => {"type" => "nothing", "units" => u[10]},
    "3,270" => {"type" => "nothing", "units" => u[10]},

    # Jumpgate and its premises
    "3,202" => {
      "type" => "jumpgate",
      "units" => u[11] + [[1, convoy_ship, 0, 0.05]]
    },
    "2,180" => {"type" => "asteroid", "resources" => r[3], "units" => u[10]},
    "2,210" => {"type" => "asteroid", "resources" => r[3], "units" => u[10]},
    "3,180" => {"type" => "nothing", "units" => u[10],},

    # Mega-stash of resources
    "3,224" => {"type" => "nothing", "units" => u[45], "wreckage" => w[8]}
  }

  resolve_unit_params = lambda do |storage, name, unit_params|
    storage[name] = Array.new(10) { [] }

    unit_params.each do
      |count_range, level_range, unit_name, unit_flanks, hp_percentage|

      min_count = count_range.first
      per_level = (count_range.last - min_count).to_f /
        (level_range.last - level_range.first)

      level_range.each do |level|
        unit_flanks.each_with_index do |flank_percentage, flank|
          # Subtract start of level range because it can start not from 0.
          count = ((
            min_count + per_level * (level - level_range.first)
          ) * flank_percentage).round

          storage[name][level] <<
            [count, unit_name, flank, hp_percentage] unless count <= 0
        end
      end
    end
  end

  # Map tile signatures
  tile_signatures = {
    '.' => Tile::VOID,
    '-' => Tile::VOID,
    '_' => Tile::SAND,
    '/' => Tile::NOXRIUM,
    '#' => Tile::JUNKYARD,
    '^' => Tile::TITAN,

    'O' => Tile::ORE,
    '%' => Tile::GEOTHERMAL,
    '$' => Tile::ZETIUM,

    '1' => Tile::FOLLIAGE_2X4,
    '2' => Tile::FOLLIAGE_2X3,
    '5' => Tile::FOLLIAGE_3X2,
    '3' => Tile::FOLLIAGE_3X3,
    '*' => Tile::FOLLIAGE_3X4,
    '!' => Tile::FOLLIAGE_4X3,
    '@' => Tile::FOLLIAGE_4X4,
    '4' => Tile::FOLLIAGE_4X6,
    '~' => Tile::FOLLIAGE_6X2,
    '6' => Tile::FOLLIAGE_6X6,
  }

  # Map building signatures with no npc units.
  building_signatures = {
    'm' => Building::Mothership.to_s.demodulize,
    'h' => Building::Headquarters.to_s.demodulize,
    'b' => Building::Barracks.to_s.demodulize,
    'x' => Building::MetalExtractorT2.to_s.demodulize,
    'c' => Building::CollectorT2.to_s.demodulize,
    'z' => Building::ZetiumExtractorT2.to_s.demodulize,
    'a' => Building::NpcHall.to_s.demodulize,
    'i' => Building::NpcInfantryFactory.to_s.demodulize,
    'n' => Building::NpcTankFactory.to_s.demodulize,
    'f' => Building::NpcSpaceFactory.to_s.demodulize,
  }
  npc_units = {}

  {
    'P' => [
      Building::NpcSolarPlant.to_s.demodulize,
      [
        # [count_range, level_range, unit_name, [flank1_probability, ...],
        #    hp_percentage]
        [5..25, 0..9, gnat, gnat_flanks, 1.0],
        [1..10, 3..9, glancer, glancer_flanks, 1.0],
        [1..5,  6..9, spudder, spudder_flanks, 1.0],
      ]
    ],
    'H' => [
      Building::NpcCommunicationsHub.to_s.demodulize,
      [
        [8..35, 0..9, gnat, gnat_flanks, 1.0],
        [1..16, 0..9, glancer, glancer_flanks, 1.0],
        [1..10, 4..9, spudder, spudder_flanks, 1.0],
      ]
    ],
    'X' => [
      Building::NpcMetalExtractor.to_s.demodulize,
      [
        [10..40, 0..9, gnat, gnat_flanks, 1.0],
        [ 3..20, 0..9, glancer, glancer_flanks, 1.0],
        [ 1..15, 1..9, spudder, spudder_flanks, 1.0],
        [ 1..8,  2..9, gnawer, gnawer_flanks, 1.0],
      ]
    ],
    'Z' => [
      Building::NpcZetiumExtractor.to_s.demodulize,
      [
        [12..45, 0..9, gnat, gnat_flanks, 1.0],
        [ 5..26, 0..9, glancer, glancer_flanks, 1.0],
        [ 1..19, 0..9, spudder, spudder_flanks, 1.0],
        [ 2..12, 3..9, gnawer, gnawer_flanks, 1.0],
      ]
    ],
    'E' => [
      Building::NpcTemple.to_s.demodulize,
      [
        [18..50, 0..9, gnat, gnat_flanks, 1.0],
        [10..60, 0..9, glancer, glancer_flanks, 1.0],
        [10..23, 0..9, spudder, spudder_flanks, 1.0],
        [ 3..15, 1..9, gnawer, gnawer_flanks, 1.0],
      ]
    ],
    'G' => [
      Building::NpcGeothermalPlant.to_s.demodulize,
      [
        [27..55, 0..9, gnat, gnat_flanks, 1.0],
        [17..32, 0..9, glancer, glancer_flanks, 1.0],
        [19..27, 0..9, spudder, spudder_flanks, 1.0],
        [ 5..15, 0..9, gnawer, gnawer_flanks, 1.0],
      ]
    ],
    'R' => [
      Building::NpcResearchCenter.to_s.demodulize,
      [
        [14..20, 0..9, gnat,    [1, 0],     1.0],
        [ 5..15, 0..9, glancer, [0.2, 0.8], 1.0],
        [25..60, 0..9, spudder, [0, 1],     1.0],
        [ 3..10, 0..9, gnawer,  [0.9, 0.1], 1.0],
      ]
    ],
    'C' => [
      Building::NpcExcavationSite.to_s.demodulize,
      [
        [75..200, 0..9, gnat,    [1, 0], 1.0],
        [10..15,  0..9, glancer, [0, 1], 1.0],
        [ 2..10,  0..9, spudder, [0, 1], 1.0],
        [ 1..8,   0..9, gnawer,  [0, 1], 1.0],
      ]
    ],
    'U' => [
      Building::NpcJumpgate.to_s.demodulize,
      [
        [12..32, 0..9, gnat, gnat_flanks, 1.0],
        [ 5..20, 0..9, glancer, glancer_flanks, 1.0],
        [15..40, 0..9, spudder, spudder_flanks, 1.0],
        [20..60, 0..9, gnawer, gnawer_flanks, 1.0],
      ]
    ]
  }.each do |signature, (name, unit_params)|
    building_signatures[signature] = name
    resolve_unit_params[npc_units, name, unit_params]
  end

  # Convert maps to more programatic format.
  #
  # {
  #   'size' => [width, height],
  #   'name' => String,
  #   'terrain' => Fixnum,
  #   'tiles' => {
  #     kind (Fixnum) => [[x, y], ...]
  #   },
  #   'buildings' => {
  #     building_name (String) => [[x, y, units], ...]
  #   }
  # }
  #
  CONFIG.filter(/^planet\.map\./).each do |key, map_set|
    puts key
    CONFIG[key] = map_set.map do |map_parameters|
      map = map_parameters['map']
      map_data = {
        'size' => [map[0].length / 2, map.size],
        'name' => map_parameters['name'],
        'terrain' => map_parameters['terrain'],
        'tiles' => {},
        'buildings' => {}
      }

      map.reverse.each_with_index do |line, y|
        chars = line.split('')
        0.step(chars.size / 2, 2) do |index|
          x = index / 2
          tile = chars[index]
          building = chars[index + 1]

          kind = tile_signatures[tile]
          map_data['tiles'][kind] ||= []
          map_data['tiles'][kind] << [x, y]

          name = building_signatures[building]
          unless name.nil?
            level = chars[index + 3]
            units = npc_units.has_key?(name) && level != '-' \
              ? npc_units[name][level.to_i] \
              : []

            map_data['buildings'][name] ||= []
            map_data['buildings'][name] << [x, y, units]
          end
        end
      end

      map_data
    end
  end

end.call