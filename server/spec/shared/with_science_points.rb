describe "with science points", :shared => true do
  describe "#points_attribute" do
    it "should return :science_points" do
      @model.points_attribute.should == :science_points
    end
  end
end