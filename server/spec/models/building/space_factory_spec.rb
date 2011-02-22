require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Building::SpaceFactory do
  before(:each) do
    @model = Factory.build(:b_space_factory)
  end

  it_should_behave_like "with army points"
end