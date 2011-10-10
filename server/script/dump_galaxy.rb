#!/usr/bin/env ruby

if ARGV.size < 1
  puts "Usage: #{$0} target_dir"
  exit
end

require File.dirname(__FILE__) + '/../lib/initializer.rb'
require 'fileutils'

class SafeHash < Hash
  def []=(key, value)
    raise "key #{key.inspect} already exists and has value #{
      self[key].inspect}!" if has_key?(key)
    super(key, value)
  end
end

CHAR_NORMAL = '.'
CHAR_PULSAR = '%'
CHAR_WORMHL = '@'
CHAR_DEADSS = 'x'

def dump_grid(grid, max_coord, file_name)
  numbers = 3

  FileUtils.mkdir_p File.dirname(file_name)

  File.open(file_name, "w") do |f|
    f.write(%Q{Written out @ #{Time.now.to_s(:db)}

Legend:

  #{CHAR_NORMAL} - solar system
  #{CHAR_PULSAR} - pulsar
  #{CHAR_WORMHL} - wormhole to battleground
  #{CHAR_DEADSS} - dead solar system

})

    f.write " " * (numbers + 3)
    (-max_coord).upto(max_coord) { |x| f.write "#{x < 0 ? "-" : " "} " }
    (numbers - 2).downto(0) do |row|
      divider = 10 ** (row + 1)
      f.write "\n" + " " * (numbers + 3)
      (-max_coord).upto(max_coord) do |x|
        value = x.abs / divider
        value = " " if value == 0 && value <= divider
        f.write "#{value} "
      end
    end
    f.write "\n" + " " * (numbers + 3)
    (-max_coord).upto(max_coord) { |x| f.write "#{x.abs % 10} " }
    f.write "\n"

    (max_coord).downto(-max_coord) do |y|
      f.write("%#{numbers + 2}d " % y)

      (-max_coord).upto(max_coord) do |x|
        ss = grid[[x, y]]
        char = ss.nil? ? ' ' : case ss[:kind]
        when SolarSystem::KIND_NORMAL
          CHAR_NORMAL
        when SolarSystem::KIND_BATTLEGROUND
          CHAR_PULSAR
        when SolarSystem::KIND_WORMHOLE
          CHAR_WORMHL
        when SolarSystem::KIND_DEAD
          CHAR_DEADSS
        end
        f.write "#{char} "
      end

      f.write "\n"
    end
  end
end

dir = ARGV.shift
Galaxy.all.each do |galaxy|
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
  
  dump_grid(grid, max_coord, "#{dir}/galaxy-#{galaxy.id}.txt")
end