describe "with army points", :shared => true do
  describe "#points_attribute" do
    it "should return :army_points" do
      @model.points_attribute.should == :army_points
    end
  end
end