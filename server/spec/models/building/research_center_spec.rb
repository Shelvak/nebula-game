require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

describe Building::ResearchCenter do
  before(:each) do
    @model = Factory.build(:b_research_center)
  end

  it "should include Trait::HasScientists" do
    Building::ResearchCenter.should include(Trait::HasScientists)
  end

  it_should_behave_like "with science points"
end