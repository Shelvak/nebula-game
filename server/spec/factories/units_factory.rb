class Unit::TestUnit < Unit; end

Factory.define :unit, :class => Unit::TestUnit do |m|
  m.association :player
  m.galaxy_id do |r|
    r.player ? r.player.galaxy_id : Factory.create(:galaxy).id
  end
  m.level 0
  m.location do |r|
    Factory.create(:planet, :player => r.player)
  end
  m.xp 0
end

Factory.define :unit_built, :parent => :unit do |m|
  m.level 1
  m.hp { |r| Unit::TestUnit.hit_points(r.level) }
end

Factory.define :unit_dead, :parent => :unit_built do |m|
  m.level 1
  m.hp 0
end

Factory.define :u_trooper, :parent => :unit,
:class => Unit::Trooper do |m|; end

Factory.define :u_azure, :parent => :unit,
:class => Unit::Azure do |m|; end

Factory.define :u_shocker, :parent => :unit,
:class => Unit::Shocker do |m|; end

Factory.define :u_seeker, :parent => :unit,
:class => Unit::Seeker do |m|; end

Factory.define :u_spy, :parent => :unit,
:class => Unit::Spy do |m|; end

Factory.define :u_saboteur, :parent => :unit,
:class => Unit::Saboteur do |m|; end

Factory.define :u_gnat, :parent => :unit,
:class => Unit::Gnat do |m|; end

Factory.define :u_mule, :parent => :unit,
:class => Unit::Mule do |m|; end

Factory.define :u_glancer, :parent => :unit,
:class => Unit::Glancer do |m|; end

Factory.define :u_spudder, :parent => :unit,
:class => Unit::Spudder do |m|; end

Factory.define :u_gnawer, :parent => :unit,
:class => Unit::Gnawer do |m|; end

Factory.define :u_crow, :parent => :unit,
:class => Unit::Crow do |m|; end

Factory.define :u_scorpion, :parent => :unit,
:class => Unit::Scorpion do |m|; end

Factory.define :u_cyrix, :parent => :unit,
:class => Unit::Cyrix do |m|; end

Factory.define :u_rhyno, :parent => :unit,
:class => Unit::Rhyno do |m|; end

Factory.define :u_dart, :parent => :unit,
:class => Unit::Dart do |m|; end

Factory.define :u_avenger, :parent => :unit,
:class => Unit::Avenger do |m|; end

Factory.define :u_demosis, :parent => :unit,
:class => Unit::Demosis do |m|; end

Factory.define :u_dirac, :parent => :unit,
:class => Unit::Dirac do |m|; end

Factory.define :u_mdh, :parent => :unit,
:class => Unit::Mdh do |m|; end
