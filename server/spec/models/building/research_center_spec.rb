require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Building::ResearchCenter do
  it "should include Trait::HasScientists" do
    Building::ResearchCenter.should include(Trait::HasScientists)
  end
end