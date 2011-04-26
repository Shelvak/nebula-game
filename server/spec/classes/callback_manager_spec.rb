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

  describe ".tick" do
    it "should run callbacks in correct order if one callback inserts " +
    "other in the middle of timeline" do
      class CBTest
        attr_reader :id
        def initialize(id); @id = id; end
        def self.on_callback(id, event); end
      end

      e = CallbackManager::EVENT_SPAWN

      CallbackManager.register(CBTest.new(1), e, 30.seconds.ago)
      CallbackManager.register(CBTest.new(2), e, 10.seconds.ago)

      CBTest.should_receive(:on_callback).with(1, e).ordered.and_return do
        CallbackManager.register(CBTest.new(3), e, 20.seconds.ago)
      end
      CBTest.should_receive(:on_callback).with(3, e).ordered
      CBTest.should_receive(:on_callback).with(2, e).ordered
      
      CallbackManager.tick
    end
  end
end