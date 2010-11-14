require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe ConstructionQueue::Event do
  before(:each) do
    @object = ConstructionQueue::Event.new
  end
end