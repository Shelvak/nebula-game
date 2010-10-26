Factory.define :tile, :class => Tile do |m|
  m.association :planet
  m.kind Tile::SAND
  m.x 0
  m.y 0
end

Factory.define :block_tile, :parent => :tile do |m|
end

Tile::MAPPING.each do |tile_id, name|
  Factory.define "t_#{name}", :parent => :block_tile do |m|
    m.kind tile_id
  end
end