Factory.define :player_options do |m|
  m.association :player
  m.data PlayerOptions::Data.new
end