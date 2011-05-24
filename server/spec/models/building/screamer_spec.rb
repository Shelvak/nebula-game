require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

describe Building::Screamer do
  before(:each) do
    @model = Factory.build(:b_screamer)
  end

  it_should_behave_like "with army points"
end