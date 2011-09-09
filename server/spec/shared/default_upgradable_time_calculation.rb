shared_examples_for "default upgradable time calculation" do
  describe "#calculate_ugprade_time" do
    it "should account for construction mod" do
      old_time = @model.upgrade_time(1)
      @model.construction_mod = 50
      @model.upgrade_time(1).should == (old_time.to_f / 2).floor
    end

    it "should not go below minimal amount" do
      old_time = @model.upgrade_time(1)
      @model.construction_mod = 100
      @model.upgrade_time(1).should == (old_time *
        CONFIG['buildings.constructor.min_time_percentage'].to_f / 100
      ).floor
    end
  end
end