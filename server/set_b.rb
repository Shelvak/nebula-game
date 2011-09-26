a = {"Screamer"=>[[11, 8], [17, 8], [9, 12], [19, 12], [15, 16]], "Thunder"=>[[13, 8], [19, 8], [9, 10], [19, 14], [9, 16], [13, 16], [17, 16]], "Vulcan"=>[[9, 8], [15, 8], [19, 10], [9, 14], [11, 16], [19, 16]]}
a.each do |type, coords|
  c = coords.map do |x, y|
    "(buildings.x=#{x} AND buildings.y=#{y})"
  end.join(" OR ")
  Building.includes(:planet).where(:ss_objects => {:terrain => 0}, :type => type).
    where(c).update_all "flags=2"
end
