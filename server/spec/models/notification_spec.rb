require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "create for", :shared => true do
  it "should set event" do
    Notification.send(@method, *@args).event.should == @event
  end

  it "should set player_id" do
    Notification.send(@method, *@args).player_id.should == @player_id
  end

  it "should save record" do
    Notification.send(@method, *@args).should_not be_new_record
  end

  it "should save successfully" do
    lambda do
      Notification.send(@method, *@args).save!
    end.should_not raise_error
  end
end

describe "with location", :shared => true do
  it "should set params[:location]" do
    Notification.send(@method, *@args
      ).params[:location].should == @location.client_location.as_json
  end
end

describe Notification do
  describe "object" do
    before(:all) do
      @class = Notification
    end

    it_should_behave_like "object"
  end

  describe "ordering" do
    it "should return items ordered by read, created_at" do
      n1 = Factory.create :notification, :read => true,
        :created_at => 6.minutes.ago
      n2 = Factory.create :notification, :read => false,
        :created_at => 3.minutes.ago
      n3 = Factory.create :notification, :read => true,
        :created_at => 3.minutes.ago
      n4 = Factory.create :notification, :read => false,
        :created_at => 2.minutes.ago

      Notification.find([n1.id, n2.id, n3.id, n4.id]).should == [
        n4, n2, n3, n1]
    end
  end

  describe "on update" do
    describe "combat notification" do
      before(:each) do
        @combat_log = Factory.create :combat_log
        @notification = Factory.create :notification,
          :event => Notification::EVENT_COMBAT,
          :params => {:log_id => @combat_log.sha1_id}
      end

      it "should update combat log expires_at" do
        expires_at = @combat_log.expires_at + 1.week
        @notification.expires_at = expires_at
        @notification.save!
        @combat_log.reload
        @combat_log.expires_at.to_s(:db).should == expires_at.to_s(:db)
      end

      it "should not overwrite combat log expires_at with earlier value" do
        old_expires_at = @combat_log.expires_at
        @notification.expires_at = old_expires_at
        @notification.save!
        @combat_log.reload
        @combat_log.expires_at.to_s(:db).should == old_expires_at.to_s(:db)
      end
    end
  end

  describe "notifier" do
    before(:each) do
      @build = lambda { Factory.build :notification }
      @change = lambda { |model| model.expires_at += 1.week }
    end

    @should_not_notify_update = true
    it_should_behave_like "notifier"
  end

  describe "create" do
    before(:each) do
      @model = Factory.build :notification
    end

    it "should not be starred" do
      @model.save!
      @model.should_not be_starred
    end

    it "should be unread" do
      @model.save!
      @model.should_not be_read
    end

    it "should set expiration time" do
      @model.save!
      @model.expires_at.drop_usec.should == Time.now.drop_usec +
        CONFIG['notifications.expiration_time']
    end

    it "should register to CallbackManager for deletion" do
      CallbackManager.should_receive(:register).with(@model,
        CallbackManager::EVENT_DESTROY, @model.expires_at)
      @model.save!
    end
  end

  describe ".on_callback" do
    it "should delete notification"
  end

  describe ".create_from_error" do
    it "should raise argument error if it cannot handle it" do
      lambda do
        Notification.create_from_error(Exception.new)
      end.should raise_error(ArgumentError)
    end

    it "should call .create_for_not_enough_resources" do
      planet = Factory.create :planet_with_player
      constructor = Factory.create :b_constructor_test, :planet => planet
      constructables = [
        Factory.create(:building, :planet => planet, :x => 5),
        Factory.create(:building, :planet => planet, :x => 10),
      ]
      error = NotEnoughResourcesAggregated.new(constructor, constructables)

      Notification.should_receive(:create_for_not_enough_resources).with(
        constructor.player_id, constructor, constructables
      )
      Notification.create_from_error(error)
    end
  end

  describe ".create_for_not_enough_resources" do
    before(:each) do
      @method = :create_for_not_enough_resources
      @event = Notification::EVENT_NOT_ENOUGH_RESOURCES
      
      @planet = Factory.create :planet_with_player
      @location = @planet
      @constructor = Factory.create :b_constructor_test, :planet => @planet
      @constructables = [
        Factory.create(:building, :planet => @planet, :x => 2),
        Factory.create(:building, :planet => @planet, :x => 5),
        Factory.create(:b_solar_plant, :planet => @planet, :x => 10),
      ]
      @player_id = @planet.player_id
      @args = [@player_id, @constructor, @constructables]
    end

    it_should_behave_like "create for"
    it_should_behave_like "with location"

    it "should set params[:constructor]" do
      Notification.send(@method, *@args
        ).params[:constructor].should == @constructor.as_json
    end

    it "should set params[:constructables]" do
      Notification.send(@method, *@args
        ).params[:constructables].should == {
          "Building::TestBuilding" => 2,
          "Building::SolarPlant" => 1
        }
    end

    it "should set params[:coordinates]" do
      Notification.send(
        @method, *@args
      ).params[:coordinates].should == @constructables.map do |c|
        [c.x, c.y]
      end
    end

    it "should set params[:coordinates] to empty array if constructables " +
    "are units" do
      @constructables.clear
      @constructables.push Factory.create(:unit, :location => @location)
      Notification.send(
        @method, *@args
      ).params[:coordinates].should == []
    end
  end

  describe ".create_for_buildings_deactivated" do
    before(:each) do
      @method = :create_for_buildings_deactivated
      @event = Notification::EVENT_BUILDINGS_DEACTIVATED

      @planet = Factory.create :planet_with_player
      @location = @planet
      @player_id = @planet.player_id
      @changes = [
        [Factory.create(:b_mothership), Reducer::RELEASED],
        [Factory.create(:b_barracks), Reducer::RELEASED],
        [Factory.create(:b_mothership), Reducer::RELEASED],
      ]
      @args = [@planet, @changes]
    end

    it_should_behave_like "create for"
    it_should_behave_like "with location"

    it "should set params[:buildings]" do
      Notification.send(@method, *@args
        ).params[:buildings].should equal_to_hash(
          "Mothership" => 2,
          "Barracks" => 1
        )
    end
  end

  describe ".create_for_combat" do
    before(:all) do
      @method = :create_for_combat
      @event = Notification::EVENT_COMBAT

      @location = Factory.create :planet_with_player
      @player = @location.player
      @player.alliance = Factory.create(:alliance)
      @player.save!

      @player_id = @player.id
      @alliances = :alliances
      @outcome = Notification::COMBAT_WIN
      @combat_log = Factory.create :combat_log
      @yane_units = :yane_units
      @leveled_up = :leveled_up
      @statistics = :statistics

      @args = [@player, @player.alliance_id, @alliances,
        @combat_log.id, @location.client_location.as_json, @outcome,
        @yane_units, @leveled_up, @statistics]
    end

    it_should_behave_like "create for"

    it "should set params[:alliance_id]" do
      Notification.send(
        @method, *@args
      ).params[:alliance_id].should == @player.alliance_id
    end

    it "should set params[:alliances]" do
      Notification.send(
        @method, *@args
      ).params[:alliances].should == @alliances
    end

    it "should set params[:location]" do
      Notification.send(
        @method, *@args
      ).params[:location].should == @location.client_location.as_json
    end
    
    it "should set log_id" do
      Notification.send(@method, *@args).params[:log_id].should == \
        @combat_log.id
    end

    it "should set params[:outcome]" do
      Notification.send(@method, *@args).params[:outcome].should == @outcome
    end

    it "should set params[:units] from yane_units" do
      Notification.send(
        @method, *@args
      ).params[:units].should == @yane_units
    end

    it "should set params[:leveled_up] from leveled_up" do
      Notification.send(
        @method, *@args
      ).params[:leveled_up].should == @leveled_up
    end

    it "should set statistics" do
      Notification.send(@method, *@args).params[:statistics].should == \
        @statistics
    end
  end

  describe "quest notification", :shared => true do
    it "should set quest id" do
      Notification.send(
        @method, *@args
      ).params[:id].should == @quest_progress.quest_id
    end
  end

  describe ".create_for_quest_started" do
    before(:all) do
      @quest_progress = Factory.create(:quest_progress)

      @method = :create_for_quest_started
      @event = Notification::EVENT_QUEST_STARTED
      @player_id = @quest_progress.player_id

      @args = [@quest_progress]
    end

    it_should_behave_like "create for"
    it_should_behave_like "quest notification"
  end

  describe ".create_for_quest_completed" do
    before(:all) do
      @quest_progress = Factory.create(:quest_progress)

      @method = :create_for_quest_completed
      @event = Notification::EVENT_QUEST_COMPLETED
      @player_id = @quest_progress.player_id

      @args = [@quest_progress]
    end

    it_should_behave_like "create for"
    it_should_behave_like "quest notification"
  end
end