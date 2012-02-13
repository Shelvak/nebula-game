Factory.define :alliance do |m|
  m.name { "Alliance-#{(Alliance.maximum(:id) || 0) + 1}" }
  m.description { "We are the " + %w{Shit Ass Noob Fag Lol}.random_element }
  m.association :galaxy
  m.owner do |r|
    player = Factory.create(:player, :galaxy => r.galaxy)
    Factory.create!(:t_alliances, :level => 1, :player => player)
    player
  end
  m.after_create do |r|
    r.owner.alliance = r
    r.owner.save!
  end
end