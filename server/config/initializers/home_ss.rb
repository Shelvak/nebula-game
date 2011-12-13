# Wrap this in a lambda so it does not pollute our global namespace.
lambda do
  # Home solar system configuration.
  #
  # Common configuration
  #
  #  "position,angle" => {
  #    "type" => "planet|asteroid|jumpgate|nothing"
  #    # array of [count, type, flank, hp percentage (Float)]
  #    "units" => [[1, dirac, 0, 1.0]]
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
  initializer = Class.new
  def initializer.run
    CONFIG['solar_system.home'] = {
      # Homeworld planet
      "0,90" => {
        "type" => "planet",
        "map" => "homeworld",
        "terrain" => 0, # Earth
        "units" => [[1, "dirac", 0, 1.0]]
      },
      # Expansion planet
      "1,135" => {
        "type" => "planet",
        "map" => "expansion",
        "terrain" => 2, # Mud
        "units" => [[2, "dirac", 0, 1.0], [2, "dirac", 1, 1.0]]
      },
      # First asteroids
      "0,0"   => {"type" => "asteroid", "resources" => r(1), "units" => u(1)},
      "0,180" => {"type" => "asteroid", "resources" => r(1), "units" => u(1)},
      "1,90"  => {"type" => "asteroid", "resources" => r(2), "units" => u(1)},

      # Resource path
      "2,150" => {"type" => "nothing", "units" => u(1.25)},
      "3,134" => {"type" => "nothing", "units" => u(1.75), "wreckage" => w(1)},
      "3,112" => {"type" => "nothing", "units" => u(2.25)},
      "3,90"  => {"type" => "nothing", "units" => u(2.5), "wreckage" => w(2)},
      "3,66"  => {"type" => "nothing", "units" => u(2.75)},
      "3,44"  => {"type" => "nothing", "units" => u(3), "wreckage" => w(3)},
      "3,22"  => {"type" => "nothing", "units" => u(4)},
      "3,0"   => {"type" => "nothing", "units" => u(5), "wreckage" => w(4)},
      "3,336" => {"type" => "nothing", "units" => u(6)},
      "3,314" => {"type" => "nothing", "units" => u(7), "wreckage" => w(5)},
      "3,292" => {"type" => "nothing", "units" => u(8)},
      "2,270" => {"type" => "nothing", "units" => u(9), "wreckage" => w(6)},

      # Protective ring near the path
      "1,180" => {"type" => "nothing", "units" => u(1.25)},
      "1,0"   => {"type" => "nothing", "units" => u(1.5)},
      "1,45"  => {"type" => "nothing", "units" => u(1.5)},
      "3,156" => {"type" => "nothing", "units" => u(1.5)},
      "2,120" => {"type" => "asteroid", "resources" => r(3), "units" => u(3)},
      "2,90"  => {"type" => "nothing", "units" => u(4)},
      "2,60"  => {"type" => "asteroid", "resources" => r(3), "units" => u(5)},
      "2,30"  => {"type" => "asteroid", "resources" => r(3), "units" => u(6)},
      "2,0"   => {"type" => "nothing", "units" => u(7)},
      "2,330" => {"type" => "asteroid", "resources" => r(3), "units" => u(8)},
      # Lesser biggest stash protection
      "0,270" => {"type" => "asteroid", "resources" => r(1), "units" => u(8)},
      "1,225" => {"type" => "asteroid", "resources" => r(2), "units" => u(8)},
      "1,315" => {"type" => "asteroid", "resources" => r(2), "units" => u(8)},
      # Greater biggest stash protection
      "1,270" => {"type" => "nothing", "units" => u(10)},
      "2,240" => {"type" => "asteroid", "resources" => r(3), "units" => u(10)},
      "2,300" => {"type" => "nothing", "units" => u(10)},
      "3,246" => {"type" => "nothing", "units" => u(10)},
      "3,270" => {"type" => "nothing", "units" => u(10)},

      # Jumpgate and its premises
      "3,202" => {
        "type" => "jumpgate",
        # TODO: replace boss_ship with convoy unit
        "units" => u(11) + [[1, "boss_ship", 0, 0.05]]
      },
      "2,180" => {"type" => "asteroid", "resources" => r(3), "units" => u(10)},
      "2,210" => {"type" => "asteroid", "resources" => r(3), "units" => u(10)},
      "3,180" => {"type" => "nothing", "units" => u(10),},
      "3,224" => {"type" => "nothing", "units" => u(10)}
    }
  end

  def initializer.w(level)
    level -= 1
    [3750.0 * 2 ** level, 7500.0 * 2 ** level, 1250.0 * 2 ** level]
  end

  def initializer.r(level)
    [2.0 * level, 2.0 * level, 2.0 * level]
  end

  def initializer.u(arg)
    units = [
      [(0.8 * arg).round, "dirac", 0, 1.0],
      [arg.round, "dirac", 1, 1.0],
    ]
    units += [
      [(0.25 * arg).round, "thor", 0, 1.0],
      [(0.75 * arg).round, "thor", 1, 1.0],
    ] if arg >= 1.5
    units += [
      [(0.5 * arg).round, "demosis", 0, 1.0]
    ] if arg >= 3
    units
  end

  initializer.run
end.call