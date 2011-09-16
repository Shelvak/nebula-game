require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

describe Building::SpaceFactory do
  before(:each) do
    @model = Factory.build(:b_space_factory)
  end

  it_behaves_like "with army points"
end