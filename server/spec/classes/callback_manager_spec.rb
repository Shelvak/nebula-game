require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe CallbackManager do
  describe ".has?" do
    before(:each) do
      @object = Factory.create :building
      @event = CallbackManager::EVENT_UPGRADE_FINISHED
      @time = 10.minutes.since
    end

    it "should be false if never registered" do
      CallbackManager.has?(@object, @event, @time).should be_false
    end

    it "should return true if registered" do
      CallbackManager.register(@object, @event, @time)
      CallbackManager.has?(@object, @event, @time).should be_true
    end

    it "should return false if unregistered" do
      CallbackManager.register(@object, @event, @time)
      CallbackManager.unregister(@object, @event)

      CallbackManager.has?(@object, @event, @time).should be_false
    end
  end
end