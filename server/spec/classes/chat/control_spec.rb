require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Chat::Control do
  #before(:each) do
  #  @object = Chat::Control.new
  #end

  describe ".parse_args" do
    it "should support mixed notation" do
      Chat::Control.parse_args(%Q{foo "buz bar"   foo  "Dan Mc'Niel" lol'}).
        should == ["foo", "buz bar", "foo", "Dan Mc'Niel", "lol'"]
    end
  end
end