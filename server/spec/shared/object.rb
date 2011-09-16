shared_examples_for "object" do
  it "should include Parts::Object" do
    @class.should include(Parts::Object)
  end
end