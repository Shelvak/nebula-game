Factory.define :player do |m|
  m.name { "Player-#{(Player.maximum(:id) || 0) + 1}"}
  m.auth_token { |r| "auth_token_for_#{r.name}" }
  m.association :galaxy
  m.scientists 1000
  m.scientists_total 2000
  m.skip_initialize_player true
end

Factory.define :player_with_galaxy, :class => Player,
:parent => :player do |m|
  m.association :galaxy
  m.skip_initialize_player false
end