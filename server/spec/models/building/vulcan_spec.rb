require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

describe Building::Vulcan do
  before(:each) do
    @model = Factory.build(:b_vulcan)
  end

  it_should_behave_like "with army points"
end