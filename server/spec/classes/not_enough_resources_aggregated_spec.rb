require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe NotEnoughResourcesAggregated do
  before(:each) do
    @constructor = :constructor
    @constructables = [:constructable1, :constructable2]
    @object = NotEnoughResourcesAggregated.new(@constructor, @constructables)
  end
  
  it "should extend GameNotifiableError" do
    @object.should be_kind_of(GameNotifiableError)
  end

  it "should have #constructor" do
    @object.constructor.should == @constructor
  end

  it "should have #constructables" do
    @object.constructables.should == @constructables
  end
end