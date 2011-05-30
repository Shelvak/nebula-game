require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

describe Building::CollectorT1 do
  before(:each) do
    @model = Factory.create(:b_collector_t1)
  end

  it_should_behave_like "collector"
end