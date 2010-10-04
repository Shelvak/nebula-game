require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe SingletonBlock do
  describe "#running?" do
    before(:all) do
      @name = 'my block'
    end

    it "should return false if block is not running" do
      SingletonBlock.running?(@name).should be_false
    end

    it "should return true if block is running" do
      SingletonBlock.started(@name)
      SingletonBlock.running?(@name).should be_true
    end
  end
end