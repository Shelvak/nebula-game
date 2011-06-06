describe "upgradable with hp", :shared => true do
  describe "#hp=" do
    it "should not allow setting hp more than hp_max" do
      @model.level = 5
      @model.hp = @model.hit_points + 200
      @model.should_not be_valid
    end
  end
end
