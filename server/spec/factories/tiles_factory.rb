Factory.define :tile, :class => Tile do |m|
  m.association :planet
  m.kind Tile::SAND
  m.x 0
  m.y 0
end

Factory.define :block_tile, :parent => :tile do |m|
end

Factory.define :t_junkyard, :parent => :tile do |m|
  m.kind Tile::JUNKYARD
end

Factory.define :t_noxrium, :parent => :tile do |m|
  m.kind Tile::NOXRIUM
end

Factory.define :t_sand, :parent => :tile do |m|
  m.kind Tile::SAND
end

Factory.define :t_titan, :parent => :tile do |m|
  m.kind Tile::TITAN
end

Factory.define :t_water, :parent => :tile do |m|
  m.kind Tile::WATER
end

Tile::MAPPING.each do |tile_id, name|
  Factory.define "t_#{name}", :parent => :block_tile do |m|
    m.kind tile_id
  end
end