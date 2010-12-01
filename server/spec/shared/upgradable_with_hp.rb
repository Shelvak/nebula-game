describe "upgradable with hp", :shared => true do
  describe "#hp=" do
    it "should not allow setting hp more than hp_max" do
      @model.level = 5
      @model.hp = @model.hp_max + 200
      @model.should_not be_valid
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

  describe "#update_upgrade_properties!" do
    before(:each) do
      opts_upgrading | @model
      @model.level = 1
      @model.upgrade_ends_at = 10.minutes.since

      @time_diff = @model.upgrade_time(@model.level + 1)
      @seconds = 373
      @model.last_update = @seconds.ago.drop_usec
      @model.hp = 0

      @hp_diff = @model.hit_points(@model.level + 1) - @model.hit_points
      @upgrade_time = @model.upgrade_time(@model.level + 1)
      @hp_add = (@seconds * @hp_diff / @upgrade_time)
    end

    it "should add hp diff" do
      lambda do
        @model.send(:update_upgrade_properties!)
      end.should change(@model, :hp).by(@hp_add)
    end

    it "should store remainder" do
      nominator = @seconds * @hp_diff
      denominator = @upgrade_time
      remainder = nominator % denominator

      @model.send(:update_upgrade_properties!)
      @model.hp_remainder.should == remainder
    end

    it "should carry over remainder" do
      nominator = @seconds * @hp_diff
      denominator = @upgrade_time
      remainder = nominator % denominator
      @model.hp_remainder = denominator - remainder

      lambda do
        @model.send(:update_upgrade_properties!)
      end.should change(@model, :hp).to(nominator / denominator + 1)
    end

    it "should reduce remainder to below denominator" do
      nominator = @seconds * @hp_diff
      denominator = @upgrade_time
      remainder = nominator % denominator
      @model.hp_remainder = denominator - remainder

      lambda do
        @model.send(:update_upgrade_properties!)
      end.should change(@model, :hp_remainder).to(0)
    end
  end
end
