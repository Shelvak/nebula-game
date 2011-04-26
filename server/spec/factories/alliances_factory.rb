Factory.define :alliance do |m|
  m.name { "Alliance-#{(Alliance.maximum(:id) || 0) + 1}" }
  m.association :galaxy
  m.owner do |r|
    player = Factory.create(:player, :galaxy => r.galaxy)
    Factory.create(:t_alliances, :level => 1, :player => player)
    player
  end
end