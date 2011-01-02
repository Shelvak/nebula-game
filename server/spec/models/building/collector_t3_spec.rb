require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Building::CollectorT3 do
  before(:each) do
    @model = Factory.create(:b_collector_t3)
  end

  it_should_behave_like "collector"

  it "should include GeothermalPlant" do
    @model.class.should include(Trait::GeothermalPlant)
  end
end