Factory.define :alliance do |m|
  m.name { "Alliance-#{(Alliance.maximum(:id) || 0) + 1}" }
  m.association :galaxy
end