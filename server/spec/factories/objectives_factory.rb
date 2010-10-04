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
  m.key "Planet"
end

Factory.define :o_have_planets, :parent => :objective,
:class => Objective::HavePlanets do |m|
  m.key "Planet"
end
