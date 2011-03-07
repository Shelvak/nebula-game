require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Building::Barracks do
  before(:each) do
    @model = Factory.build(:b_barracks)
  end

  it_should_behave_like "with army points"
end