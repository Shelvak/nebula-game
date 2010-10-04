Factory.define :quest do |m|
  m.rewards('Resource::Metal' => 100, 'Resource::Energy' => 100)
end

Factory.define :child_quest, :parent => :quest do |m|
  m.association :parent, :factory => :quest
end