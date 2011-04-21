Factory.define :alliance do |m|
  m.name { "Alliance-#{(Alliance.maximum(:id) || 0) + 1}" }
  m.association :galaxy
  m.association :owner, :factory => :player
end