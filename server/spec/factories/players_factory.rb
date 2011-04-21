Factory.define :player do |m|
  m.name { "Player-#{(Player.maximum(:id) || 0) + 1}"}
  m.auth_token { |r| "auth_token_for_#{r.name}" }
  m.association :galaxy
  m.scientists 1000
  m.scientists_total 2000
  m.population_max 2000
  m.planets_count 0
end

Factory.define :player_for_ratings, :parent => :player do |m|
  (Player::POINT_ATTRIBUTES + %w{victory_points}).each do |attr|
    m.send(attr) { rand(1000) }
  end
  m.planets_count { 1 + rand(10) }
end