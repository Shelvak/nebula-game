require 'rubygems'
require 'chunky_png'

player = Player.find(1)

ss = SolarSystem.where(:galaxy_id => player.galaxy_id, :x => 65535, :y => 65535).first
ss.destroy if ss
ss = SolarSystem.new(:galaxy_id => player.galaxy_id, :x => 65535, :y => 65535)
ss.save!
p = SsObject::Planet.new(:solar_system => ss, :position => 0, :angle => 0, :name => "2011 02 14", :width => 41, :height => 41, :player => player, :terrain => 2)
p.save!
c = Folliage.connection

f = [0,1,2,9,10,11,12,13]

image = ChunkyPNG::Image.from_file(ARGV[0])
c.transaction do
(0...image.width).each do |y|
  (0...image.height).each do |x|
    color = image[x, y]
    if color != 0xffffffff
      px = x + 1
      py = p.height - 2 - y
      if color == 0x000000ff
        kind = [7, 8].random_element
      else
        kind = f.random_element
      end
      c.execute("INSERT INTO folliages SET x=#{px}, y=#{py}, kind=#{kind
        }, planet_id=#{p.id}")
    end
  end
end
end
