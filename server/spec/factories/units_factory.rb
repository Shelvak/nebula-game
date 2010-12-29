class Unit::TestUnit < Unit; end

Factory.define :unit, :class => Unit::TestUnit do |m|
  m.association :player
  m.galaxy_id do |r|
    r.player ? r.player.galaxy_id : Factory.create(:galaxy).id
  end
  m.level 0
  m.hp 0
  m.location do |r|
    Factory.create(:planet, :player => r.player)
  end
  m.xp 0
end

Factory.define :unit_built, :parent => :unit do |m|
  opts_built.factory m
end

Factory.define :unit_dead, :parent => :unit_built do |m|
  m.level 1
  m.hp 0
end

class Unit::DeployableTest < Unit; end
Factory.define :u_deployable_test, :parent => :unit_built,
  :class => Unit::DeployableTest do |m|; end

class Unit::LoadableTest < Unit; end
Factory.define :u_loadable_test, :parent => :unit_built,
  :class => Unit::LoadableTest do |m|; end

class Unit::WithStorage < Unit; end
Factory.define :u_with_storage, :parent => :unit_built,
:class => Unit::WithStorage do |m|; end

Factory.define :u_trooper, :parent => :unit_built,
:class => Unit::Trooper do |m|; end

Factory.define :u_azure, :parent => :unit_built,
:class => Unit::Azure do |m|; end

Factory.define :u_shocker, :parent => :unit_built,
:class => Unit::Shocker do |m|; end

Factory.define :u_seeker, :parent => :unit_built,
:class => Unit::Seeker do |m|; end

Factory.define :u_spy, :parent => :unit_built,
:class => Unit::Spy do |m|; end

Factory.define :u_saboteur, :parent => :unit_built,
:class => Unit::Saboteur do |m|; end

Factory.define :u_gnat, :parent => :unit_built,
:class => Unit::Gnat do |m|; end

Factory.define :u_mule, :parent => :unit_built,
:class => Unit::Mule do |m|; end

Factory.define :u_glancer, :parent => :unit_built,
:class => Unit::Glancer do |m|; end

Factory.define :u_spudder, :parent => :unit_built,
:class => Unit::Spudder do |m|; end

Factory.define :u_gnawer, :parent => :unit_built,
:class => Unit::Gnawer do |m|; end

Factory.define :u_crow, :parent => :unit_built,
:class => Unit::Crow do |m|; end

Factory.define :u_scorpion, :parent => :unit_built,
:class => Unit::Scorpion do |m|; end

Factory.define :u_cyrix, :parent => :unit_built,
:class => Unit::Cyrix do |m|; end

Factory.define :u_rhyno, :parent => :unit_built,
:class => Unit::Rhyno do |m|; end

Factory.define :u_dart, :parent => :unit_built,
:class => Unit::Dart do |m|; end

Factory.define :u_avenger, :parent => :unit_built,
:class => Unit::Avenger do |m|; end

Factory.define :u_demosis, :parent => :unit_built,
:class => Unit::Demosis do |m|; end

Factory.define :u_dirac, :parent => :unit_built,
:class => Unit::Dirac do |m|; end

Factory.define :u_mdh, :parent => :unit_built,
:class => Unit::Mdh do |m|; end

Factory.define :u_thor, :parent => :unit_built,
:class => Unit::Thor do |m|; end
