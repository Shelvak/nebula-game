shared_examples_for "with science points" do
  describe "#points_attribute" do
    it "should return :science_points" do
      @model.points_attribute.should == :science_points
    end
  end
end