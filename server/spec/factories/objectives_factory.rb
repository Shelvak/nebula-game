class Objective::TestObjective < Objective; end

Factory.define :objective, :class => Objective::TestObjective do |m|
  m.association :quest
  m.key "Unit::TestUnit"
end

Factory.define :o_upgrade_to, :parent => :objective,
:class => Objective::UpgradeTo do |m|
  m.level 1
end

Factory.define :o_have_upgraded_to, :parent => :o_upgrade_to,
:class => Objective::HaveUpgradedTo do |m|; end

Factory.define :o_destroy, :parent => :objective,
:class => Objective::Destroy do |m|; end

Factory.define :o_annex_planet, :parent => :objective,
:class => Objective::AnnexPlanet do |m|
  m.key Quest::DSL::PLANET_KEY
end

Factory.define :o_have_planets, :parent => :objective,
:class => Objective::HavePlanets do |m|
  m.key Quest::DSL::PLANET_KEY
end

Factory.define :o_have_points, :parent => :objective,
:class => Objective::HavePoints do |m|
  m.key Quest::DSL::PLAYER_KEY
  m.count 1
  m.limit 100
end

Factory.define :o_destroy_npc_building, :parent => :objective,
:class => Objective::DestroyNpcBuilding do |m|; end

Factory.define :o_explore_block, :parent => :objective,
:class => Objective::ExploreBlock do |m|
  m.key Objective::ExploreBlock::KEY
  m.count 1
  m.limit 9
end

Factory.define :o_become_vip, :parent => :objective,
:class => Objective::BecomeVip do |m|
  m.key Objective::BecomeVip::KEY
end

Factory.define :o_accelerate, :parent => :objective,
:class => Objective::Accelerate do |m|; end
