describe "npc special factory", :shared => true do
  it_should_behave_like "with resetable cooldown"
  it_should_behave_like "with looped cooldown"
  it_should_behave_like "with unit bonus"
  
  describe "cooldown" do
    describe "related to building level" do
      it "should have smaller cooldown with greater level" do
        @model.level = 1
        at_level_1 = @model.cooldowns_at
        @model.level = @model.max_level
        at_max_level = @model.cooldowns_at
        (at_level_1 > at_max_level).should be_true
      end
    end
    
    describe "related to planets #owner_changed" do
      it "should have bigger impact to cooldown when level is bigger" do
        times = [1.day.ago, 10.days.ago]
        
        @model.level = 1
        @model.planet.owner_changed = times[0]
        at_level_1_d1 = @model.cooldowns_at # This should be X
        @model.planet.owner_changed = times[1]
        at_level_1_d2 = @model.cooldowns_at # This should be > X
        
        @model.level = @model.max_level
        @model.planet.owner_changed = times[0]
        at_max_level_d1 = @model.cooldowns_at
        @model.planet.owner_changed = times[1]
        at_max_level_d2 = @model.cooldowns_at
        
        at_level_1_ratio = at_level_1_d2.to_f / at_level_1_d1.to_f
        at_max_level_ratio = at_max_level_d2.to_f / at_max_level_d1.to_f
        at_max_level_ratio.should > at_level_1_ratio
      end
    end
  end
end