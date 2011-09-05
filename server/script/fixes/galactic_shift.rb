#!/usr/bin/env ruby

puts "*" * 80
puts " " * 35 + "WARNING!"
puts "*" * 80
puts
puts "This script erases all dead stars and shifts everyone closer to the"
puts "center! Are you sure to continue?"
puts
puts "Galaxy IDs to reorganize: #{ARGV.inspect}"
puts
puts "Anything but YES exits."
puts
what = STDIN.gets.strip
unless what == "YES"
  puts
  puts "Exiting."
  exit
end

puts
puts "Okay, you're the boss. Here we go!"
puts

class SafeHash < Hash  
  def []=(key, value)
    raise "key #{key.inspect} already exists and has value #{
      self[key].inspect}!" if has_key?(key)
    super(key, value)
  end
end

require File.dirname(__FILE__) + '/../../lib/initializer.rb'
srand(10000)

# Shift posibilities for each traversing direction.
diagonal_shift = [-1, -1, lambda { |x, y| x > 0 && y > 0 } ]
HORIZONTAL = [:horizontal, [
    [0, -1, lambda { |x, y| y > 0 } ], 
    diagonal_shift
]]
VERTICAL = [:vertical, [
    [-1, 0, lambda { |x, y| x > 0 } ],
    diagonal_shift
]]
DIAGONAL = [:diagonal, [diagonal_shift]]

def dump_grid(grid, max_coord, file_name)
  File.open(file_name, "w") do |f|
    f.write " " * 5
    (-max_coord).upto(max_coord) { |x| f.write "#{x < 0 ? "-" : " "} " }
    f.write "\n" + " " * 5
    (-max_coord).upto(max_coord) { |x| f.write "#{x.abs / 10} " }
    f.write "\n" + " " * 5
    (-max_coord).upto(max_coord) { |x| f.write "#{x.abs % 10} " }
    f.write "\n"
    
    (max_coord).downto(-max_coord) do |y|
      f.write("%4d " % y)
      
      (-max_coord).upto(max_coord) do |x|
        ss = grid[[x, y]]
        char = ss.nil? ? ' ' : case ss[:kind]
        when SolarSystem::KIND_NORMAL
          '.'
        when SolarSystem::KIND_BATTLEGROUND
          'p'
        when SolarSystem::KIND_WORMHOLE
          '@'
        when SolarSystem::KIND_DEAD
          'X'
        end
        f.write "#{char} "
      end
      
      f.write "\n"
    end
  end
end

def expand_point(quarter, start_x, start_y, kind)
  to_shift = []
  if kind == :up
    quarter.each do |coords, ss|
      to_shift.push coords if coords[0] == start_x && coords[1] > start_y
    end
    to_shift.sort! { |a, b| b[1] <=> a[1] }
    x_shift = 0
    y_shift = 1
  else
    quarter.each do |coords, ss|
      to_shift.push coords if coords[0] > start_x && coords[1] == start_y
    end
    to_shift.sort! { |a, b| b[0] <=> a[0] }
    x_shift = 1
    y_shift = 0
  end
  
  to_shift.each do |x, y|
    coords = [x, y]
    new_coords = [x + x_shift, y + y_shift]
    puts "      Expanding galaxy. Moving (#{kind}) #{coords.inspect} to #{
      new_coords.inspect}"

    ss = quarter[[x, y]]
    quarter.delete(coords)
    raise "New coords are not empty!" unless quarter[new_coords].nil?
    quarter[new_coords] = ss
  end
end

# Iterate over perimeter of rectangle with distance from center.
def iterate_perimeter(distance_from_center)
  # From left to right.
  0.upto(distance_from_center - 1) do |x|
    yield x, distance_from_center, HORIZONTAL
  end

  yield distance_from_center, distance_from_center, DIAGONAL

  # From top to bottom
  (distance_from_center - 1).downto(0) do |y|
    yield distance_from_center, y, VERTICAL
  end
end

def move_needed?(quarter, checked_x, checked_y, zone_radius, systems_needed)
  x_bound = [0, checked_x - zone_radius].max
  y_bound = [0, checked_y - zone_radius].max
  
  systems_found = 0
  checked_x.downto(x_bound) do |x|
    checked_y.downto(y_bound) do |y|
      if x != checked_x && y != checked_y
        systems_found += 1 unless quarter[[x, y]].nil?
      end
    end
  end
  
  wanted_area = zone_radius ** 2 - 1
  actual_area = (checked_x - x_bound) * (checked_y - y_bound)
  actual_needed = (actual_area * systems_needed / wanted_area.to_f).ceil
  actual_needed = [actual_needed, 2].max
  
  puts "    Found #{systems_found} systems for [#{checked_x}, #{
    checked_y}], needed: #{actual_needed}."
  
  systems_found < actual_needed
end

def calculate_density(quarter, distance_from_center)
  length = distance_from_center * 2 + 1
  count = 0
  iterate_perimeter(distance_from_center) do |x, y, _|
    count += 1 unless quarter[[x, y]].nil?
  end

  count.to_f / length
end

def compress(quarter, max_coord, post_shift, mode_opts)
  puts "  Starting compression iterations."
  iteration = 1
  loop do
    puts "  Iteration #{iteration}."
    # At least on perimeter was reorganized.
    reorganized = false

    # Do one iteration of moving stuff to center.
    max_coord.downto(1) do |distance_from_center|
      puts "    Processing perimeter @ #{distance_from_center}. "
      if mode_opts[:density]
        required_density = mode_opts[:density]
        density = calculate_density(quarter, distance_from_center - 1)
        puts "Perimeter density #{density}, required: #{required_density}."
        next if density >= required_density
      end

      iterate_perimeter(distance_from_center) do |x, y, moves|
        coords = [x, y]
        ss = quarter[coords]
        type, move_posibilities = moves
        # Only move if we have a SS and it was not moved in this iteration.
        unless ss.nil? || ss[:moved]
          next if mode_opts[:move_check_radius] && 
            ! move_needed?(quarter, x, y, mode_opts[:move_check_radius],
              mode_opts[:move_check_needed])
          # Try to relocate in direction of center of the galaxy.
          move_posibilities.each do |x_shift, y_shift, shift_condition|
            next unless shift_condition.call(x, y)

            new_coords = [x + x_shift, y + y_shift]
            if quarter[new_coords].nil?
              # Move the SS.
              quarter.delete coords
              quarter[new_coords] = ss
              ss[:moved] = true
              reorganized = true

              str_coords = post_shift.call(*coords)
              str_new_coords = post_shift.call(*new_coords)
              str_x_shift = str_new_coords[0] - str_coords[0]
              str_y_shift = str_new_coords[1] - str_coords[1]

              puts "      Moved SS #{ss[:id]} from #{
                str_coords.inspect} to #{
                str_new_coords.inspect}, #{type
                } move: #{str_x_shift}, #{str_y_shift}."
              break
            end
          end
        end
      end
    end

    # Exit loop if no perimeters were reorganized.
    break unless reorganized

    # Reset moved statuses.
    quarter.each do |coords, ss|
      ss[:moved] = false
    end

    iteration += 1
  end
end

def expand(quarter, iterations, chance)
  puts "  Starting expansion."
  iterations.times do |iteration|
    puts "    Iteration #{iteration}."

    slots_wo_expansion = 0
    slot = 1
    while slots_wo_expansion <= 10000
      slots_wo_expansion += 1

      diag = (((1 + 8 * slot) ** 0.5 - 1) / 2).ceil.to_f
      x = (diag / 2 * (1 + diag) - slot).to_i
      y = (x - diag).to_i * -1 - 1

      # If we have something there, make room next to it
      unless quarter[[x, y]].nil?
        slots_wo_expansion = 0

        [:up, :right].each do |type|
          expand_point(quarter, x, y, type) if rand <= chance && (
            (type == :up && ! quarter[[x, y + 1]].nil?) ||
            (type == :right && ! quarter[[x + 1, y]].nil?)
          )
        end
      end

      slot += 1
    end
  end
end

Galaxy.find(ARGV).each do |galaxy|
  puts "Entering galaxy #{galaxy.id}."
  
  x_range = 
    galaxy.solar_systems.minimum(:x)..galaxy.solar_systems.maximum(:x)
  y_range = 
    galaxy.solar_systems.minimum(:y)..galaxy.solar_systems.maximum(:y)
  
  max_x = [x_range.first.abs, x_range.last.abs].max
  max_y = [y_range.first.abs, y_range.last.abs].max
  
  puts "  Galaxy dimensions: x: #{x_range.inspect}, y: #{y_range.inspect}"
  max_coord = [max_x, max_y].max
  puts "  Max coord: #{max_coord}"
  grid = SafeHash.new
  galaxy.solar_systems.select("id, x, y, kind").c_select_all.each do 
    |ss_row|
    
    coords = [ss_row["x"], ss_row["y"]]
    grid[coords] = {:id => ss_row["id"], :kind => ss_row["kind"]} \
      unless ss_row["x"].nil? || ss_row["y"].nil?
  end
  puts "  #{grid.size} solar systems loaded."
  dump_grid(grid, max_coord, "galaxy-#{galaxy.id}-old.txt")
  
  # Remove all dead solar systems.
  grid.keys.each do |coords|
    grid.delete(coords) if grid[coords][:kind] == SolarSystem::KIND_DEAD
  end
  
  new_grid = SafeHash.new
  
  [
    [:first, 
      lambda { |x, y| x >= 0 && y >= 0 },
      lambda { |x, y| [x, y] },
    ],
    [:second, 
      lambda { |x, y| x < 0 && y >= 0 }, 
      lambda { |x, y| [x * -1 - 1, y] },
    ],
    [:third, 
      lambda { |x, y| x < 0 && y < 0 }, 
      lambda { |x, y| [x * -1 - 1, y * -1 - 1] },
    ],
    [:fourth, 
      lambda { |x, y| x >= 0 && y < 0 }, 
      lambda { |x, y| [x, y * -1 - 1] }
    ]
  ].each do |name, fill_condition, trasform|
    puts "Doing #{name} quarter."  
    quarter = SafeHash.new
    grid.each do |coords, ss|
      quarter[trasform.call(*coords)] = ss if fill_condition.call(*coords)
    end
    puts "#{quarter.size} solar systems collected."
    
    compress(quarter, max_coord, trasform, {:move_check_radius => 4,
      :move_check_needed => 7})
    compress(quarter, max_coord, trasform, {:density => 0.15})
#    expand(quarter, 4, 0.2)
#    compress(quarter, max_coord, post_shift, 0.3)
#    expand(quarter, 2, 0.2)
#    compress(quarter, max_coord, post_shift, 0.15)
    
    quarter.each do |coords, ss|
      grid_coords = trasform.call(*coords)
      puts "Setting #{name} quarter coords #{coords.inspect} on grid #{
        grid_coords.inspect}"
      new_grid[grid_coords] = ss
    end
  end
  
  puts "Dumping to files..."
  dump_grid(new_grid, max_coord, "galaxy-#{galaxy.id}-new.txt")
  
  if grid.size != new_grid.size
    puts "Whoa, we've lost solar systems!"
    puts "Old: #{grid.size}, new: #{new_grid.size}"
    exit 1
  end
  
  puts "Updating database..."
  galaxy.solar_systems.where(:kind => SolarSystem::KIND_DEAD).delete_all
    
  c = ActiveRecord::Base.connection
  # Move all solar systems out of the way, to ensure unique checks don't 
  # fail.
  galaxy.solar_systems.update_all("x = x + #{max_coord * 3}")
  # Put them into proper positions.
  new_grid.each do |coords, ss|
    SolarSystem.update_all(
      {:x => coords[0], :y => coords[1]}, 
      {:id => ss[:id]}
    )
  end
  
  puts "Galaxy #{galaxy.id} done."
  puts
end

# Run fix_visibility to ensure all visibility things are ok.
puts "Running fix_visiblity.rb"
system("ruby #{File.expand_path(File.dirname(__FILE__) + 
  '/fix_visibility.rb')}")