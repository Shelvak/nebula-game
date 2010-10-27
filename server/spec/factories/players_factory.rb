Factory.define :player do |m|
  m.name { "Player-#{(Player.maximum(:id) || 0) + 1}"}
  m.auth_token { |r| "auth_token_for_#{r.name}" }
  m.association :galaxy
  m.scientists 1000
  m.scientists_total 2000
end