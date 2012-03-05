Factory.define :fow_ss_entry do |m|
  m.association :solar_system
end

Factory.define :fse_player, :parent => :fow_ss_entry do |m|
  m.association :player
  m.player_planets false
  m.player_ships false
  m.enemy_planets false
  m.enemy_ships false
  m.nap_planets nil
  m.nap_ships nil
  m.alliance_planet_player_ids nil
  m.alliance_ship_player_ids nil
end

Factory.define :fse_alliance, :parent => :fow_ss_entry do |m|
  m.association :alliance
  m.player_planets nil
  m.player_ships nil
  m.enemy_planets false
  m.enemy_ships false
  m.nap_planets false
  m.nap_ships false
  m.alliance_planet_player_ids []
  m.alliance_ship_player_ids []
end