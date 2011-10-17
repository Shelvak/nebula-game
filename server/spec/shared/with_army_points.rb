shared_examples_for "with army points" do |model|
  describe "#points_attribute" do
    it "should return :army_points" do
      (model || @model).points_attribute.should == :army_points
    end
  end
end