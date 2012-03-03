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
    
    it "should run callbacks in correct order when inserting" do
      e = CallbackManager::EVENT_SPAWN

      g1 = Factory.create(:galaxy)
      g2 = Factory.create(:galaxy)
      g3 = Factory.create(:galaxy)

      CallbackManager.register(g1, e, 30.seconds.ago)
      CallbackManager.register(g2, e, 10.seconds.ago)

      Galaxy.should_receive(:on_callback).with(g1.id, e).ordered.and_return do
        CallbackManager.register(g3, e, 20.seconds.ago)
      end
      Galaxy.should_receive(:on_callback).with(g3.id, e).ordered
      Galaxy.should_receive(:on_callback).with(g2.id, e).ordered

      CallbackManager.tick
    end

    describe "if exception is raised while processing" do
      let(:galaxy) { Factory.create(:galaxy) }
      let(:event) { CallbackManager::EVENT_SPAWN }

      # If we try to do this with around(:each) then #stub! is not found...
      before(:each) do
        @old_env = App.env
        App.env = 'production'
        CallbackManager.register(galaxy, event, 30.seconds.ago)
        Galaxy.stub!(:on_callback).and_raise(Exception)
      end

      after(:each) do
        App.env = @old_env
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

      it "should not go into infinite loop if failed callback fails again" do
        ActiveRecord::Base.connection.execute("UPDATE callbacks SET failed=1")
        CallbackManager.tick(true)
      end

      it "should execute double failed callback on next invocation" do
        ActiveRecord::Base.connection.execute("UPDATE callbacks SET failed=1")
        CallbackManager.tick(true)
        Galaxy.should_receive(:on_callback).with(galaxy.id, event).
          and_raise(Exception)
        CallbackManager.tick(true)
      end
    end

    describe "failed callbacks" do
      let(:galaxy) { Factory.create(:galaxy) }
      let(:event) { CallbackManager::EVENT_SPAWN }

      before(:each) do
        CallbackManager.register(galaxy, event, 30.seconds.ago)
        ActiveRecord::Base.connection.
          execute("UPDATE callbacks SET failed=1")
      end

      it "should not run failed callbacks ordinarily" do
        Galaxy.should_not_receive(:on_callback)
        CallbackManager.tick
      end

      it "should run failed callbacks if forced" do
        Galaxy.should_receive(:on_callback).with(galaxy.id, event)
        CallbackManager.tick(true)
      end
    end
  end
end