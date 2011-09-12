require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

describe Building::GroundFactory do
  before(:each) do
    @model = Factory.build(:b_ground_factory)
  end

  it_behaves_like "with army points"
end