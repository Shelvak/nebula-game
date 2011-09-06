require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

class CBTest
  attr_reader :id
  def initialize(id); @id = id; end
  def self.on_callback(id, event); end
end

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

  describe ".register_or_update" do
    it "should register if requested" do
      player = Factory.create(:player)
      time = 10.minutes.from_now
      CallbackManager.register_or_update(player, 
        CallbackManager::EVENT_CHECK_INACTIVE_PLAYER, time)
      player.should have_callback(
        CallbackManager::EVENT_CHECK_INACTIVE_PLAYER, time)
    end
    
    it "should update if already registered" do
      player = Factory.create(:player)
      time = 10.minutes.from_now
      CallbackManager.register_or_update(player, 
        CallbackManager::EVENT_CHECK_INACTIVE_PLAYER, time - 2.minutes)
      CallbackManager.register_or_update(player, 
        CallbackManager::EVENT_CHECK_INACTIVE_PLAYER, time)
      player.should have_callback(
        CallbackManager::EVENT_CHECK_INACTIVE_PLAYER, time)
    end
  end
  
  describe ".tick" do
    before(:each) do
      ActiveRecord::Base.connection.execute("DELETE FROM callbacks")
    end
    
    it "should run callbacks in correct order if one callback inserts " +
    "other in the middle of timeline" do
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
      
    describe "if exception is raised while processing" do
      before(:each) do
        @e = CallbackManager::EVENT_SPAWN
        @old_env = ENV['environment']
        ENV['environment'] = 'production'
        CallbackManager.register(CBTest.new(1), @e, 30.seconds.ago)
        CBTest.stub!(:on_callback).and_raise(Exception)
      end
      
      after(:each) do
        ENV['environment'] = @old_env
      end
      
      it "should mark callback as failed if exception is raised" do
        CallbackManager.tick
        ActiveRecord::Base.connection.
          select_all("SELECT * FROM callbacks WHERE failed=1").size.
          should > 0
      end
      
      it "should write error to logger" do
        LOGGER.should_receive(:error).with(an_instance_of(String))
        CallbackManager.tick
      end
    end
    
    describe "failed callbacks" do
      before(:each) do
        @e = CallbackManager::EVENT_SPAWN
        CallbackManager.register(CBTest.new(1), @e, 30.seconds.ago)
        ActiveRecord::Base.connection.
          execute("UPDATE callbacks SET failed=1")
      end
    
      it "should not run failed callbacks ordinarily" do
        CBTest.should_not_receive(:on_callback)
        CallbackManager.tick
      end

      it "should run failed callbacks if forced" do
        CBTest.should_receive(:on_callback).with(1, @e)
        CallbackManager.tick(true)
      end
    end
  end
end