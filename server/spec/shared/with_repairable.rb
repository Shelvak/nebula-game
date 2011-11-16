shared_examples_for "with repairable" do |model|
  it "should include Parts::Repairable" do
    model.class.should include(Parts::Repairable)
  end
end