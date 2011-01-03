require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Building::CollectorT2 do
  before(:each) do
    @model = Factory.create!(:b_collector_t2)
  end

  it_should_behave_like "collector"
end