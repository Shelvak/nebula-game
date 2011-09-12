shared_examples_for "collector" do
  it "should manage resources" do
    @model.class.should manage_resources
  end

  it "should generate energy" do
    @model.energy_generation_rate.should > 0
  end
end