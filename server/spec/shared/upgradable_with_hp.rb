describe "upgradable with hp", :shared => true do
  describe "#hp=" do
    it "should not allow setting hp more than hp_max" do
      @model.level = 5
      @model.hp = @model.hp_max + 200
      @model.should_not be_valid
    end
  end

  describe "on upgrade finished" do
    it "should add hp" do
      @model.upgrade!
      lambda do
        @model.send(:on_upgrade_finished!)
      end.should change(@model, :hp).by(
        @model.hit_points(@model.level + 1) - @model.hit_points(@model.level)
      )
    end
  end

  describe "#hp_max" do
    describe "normal" do
      it "should return hit_points for level" do
        @model.level = 2
        @model.hp_max.should == @model.hit_points
      end
    end

    describe "upgrading" do
      it "should return hit_points for level" do
        @model.level = 2
        opts_upgrading | @model
        @model.hp_max.should == @model.hit_points(@model.level + 1)
      end
    end
  end
end
