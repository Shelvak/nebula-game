Factory.define :notification do |m|
  m.association :player
  m.event Notification::EVENT_NOT_ENOUGH_RESOURCES
  m.params(:planet => {:name => "zug", :id => 1},
    :constructable => {:type => "TestBuilding"})
  m.expires_at nil
end