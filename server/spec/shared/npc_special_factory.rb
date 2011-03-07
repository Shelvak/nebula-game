describe "npc special factory", :shared => true do
  it_should_behave_like "with resetable cooldown"
  it_should_behave_like "with looped cooldown"
  it_should_behave_like "with unit bonus"
end