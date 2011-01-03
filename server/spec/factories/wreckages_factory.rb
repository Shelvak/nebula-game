Factory.define :wreckage do |m|
  m.location do
    GalaxyPoint.new(Factory.create(:galaxy).id, 0, 0)
  end
  m.metal 100
  m.energy 80
  m.zetium 60
end