require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

describe Building::CollectorT2 do
  before(:each) do
    @model = Factory.create!(:b_collector_t2)
  end

  it_behaves_like "collector"
end