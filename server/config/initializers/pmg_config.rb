class PmgConfigInitializer < GameConfig::Initializer
  def self.generate
    LOGGER.block(
      "Generating home solar system configuration", :level => :debug
    ) { generate_home_ss }
    LOGGER.block(
      "Generating planet map configurations", :level => :debug
    ) { generate_planet_map }
  end

  def self.generate_home_ss
    dirac = Unit::Dirac.to_s.demodulize
    thor = Unit::Thor.to_s.demodulize
    demosis = Unit::Demosis.to_s.demodulize
    # TODO: replace BossShip with convoy unit
    convoy_ship = Unit::BossShip.to_s.demodulize

    w_re = /^w\[([\d\.]+)\]$/
    w = lambda do |level|
      level -= 1
      [3750.0 * 2 ** level, 7500.0 * 2 ** level, 1250.0 * 2 ** level]
    end

    r_re = /^r\[([\d\.]+)\]$/
    r = lambda do |level|
      [2.0 * level, 2.0 * level, 2.0 * level]
    end

    u_re = /^u\[([\d\.]+)\]$/
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

    apply_functions = lambda do |data, functions|
      functions.each do |regexp, function|
        match = data.match(regexp)
        return function.call(match[1].to_f) if match
      end

      raise "Unknown string signature: #{data}. Cannot apply any of the #{
        functions.inspect}!"
    end

    CONFIG.filter(/^solar_system\.map\./).each do |key, map_set|
      CONFIG[key] = map_set.map do |map_parameters|
        map_parameters['map'] = map_parameters['map'].inject({}) do
          |hash, (position, data)|

          if data.has_key?("units")
            data["units"] = [data["units"]] unless data["units"].is_a?(Array)
            data["units"] = data["units"].inject([]) do |array, unit_def|
              if unit_def.is_a?(String)
                array + apply_functions[unit_def, [[u_re, u]]]
              else
                array << unit_def
                array
              end
            end
          end

          [
            ["wreckage", [[w_re, w]]],
            ["resources", [[r_re, r]]]
          ].each do |type, functions|
            data[type] = apply_functions[data[type], functions] \
              if data[type].is_a?(String)
          end

          hash[position] = data
          hash
        end
      end
    end
  end

  def self.generate_planet_map
    gnat = Unit::Gnat.to_s.demodulize
    gnat_flanks = [0.4, 0.6]

    glancer = Unit::Glancer.to_s.demodulize
    glancer_flanks = [0, 1]

    spudder = Unit::Spudder.to_s.demodulize
    spudder_flanks = [0.3, 0.7]

    gnawer = Unit::Gnawer.to_s.demodulize
    gnawer_flanks = [0.8, 0.2]

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

    # Convert maps to more data-like format.
    #
    # {
    #   'size' => [width, height],
    #   'name' => String,
    #   'terrain' => Fixnum,
    #   'weight' => Fixnum,
    #   # Starting planet resources
    #   'resources' => [Double, Double, Double],
    #   'tiles' => {
    #     kind (Fixnum) => [[x, y], ...]
    #   },
    #   'buildings' => {
    #     building_name (String) => [[x, y, units], ...]
    #   }
    # }
    #
    CONFIG.filter(/^planet\.map\./).each do |key, map_set|
      CONFIG[key] = map_set.map do |map_parameters|
        map = map_parameters['map']
        map_data = {
          'size' => [map[0].length / 2, map.size],
          'name' => map_parameters['name'],
          'terrain' => map_parameters['terrain'],
          'weight' => map_parameters['weight'],
          'resources' => map_parameters['resources'],
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
              level = chars[index + 3].to_i
              if npc_units.has_key?(name)
                units = npc_units[name][level.to_i]
              else
                units = []
                level = [level, 1].max
              end

              map_data['buildings'][name] ||= []
              map_data['buildings'][name] << [x, y, level, units]
            end
          end
        end

        map_data
      end
    end
  end
end