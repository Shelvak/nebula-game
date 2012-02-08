Factory.define :player_no_home_ss, :class => Player do |m|
  m.name { "Player-#{(Player.maximum(:id) || 0) + 1}"}
  m.sequence(:web_user_id)
  m.association :galaxy
  m.scientists 1000
  m.scientists_total 2000
  m.population 1000
  m.population_cap 2000
  # We often take planets away from players, so just give extra planets.
  m.planets_count 3
  m.war_points 1000
  m.first_time false
end

Factory.define :player, :parent => :player_no_home_ss do |m|
  m.after_build do |r|
    Factory.create(:solar_system, :player => r, :galaxy => r.galaxy,
      :x => (SolarSystem.maximum(:x) || 0) + 1
    )
  end
end

Factory.define :player_for_ratings, :parent => :player do |m|
  (Player::POINT_ATTRIBUTES + %w{victory_points}).each do |attr|
    m.send(attr) { rand(100) }
  end
  m.planets_count { 2 + rand(10) }
end