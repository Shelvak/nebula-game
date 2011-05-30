require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

describe Building::Thunder do
  before(:each) do
    @model = Factory.build(:b_thunder)
  end

  it_should_behave_like "with army points"
end