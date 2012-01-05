require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

shared_examples_for "create for" do
  it "should set event" do
    Notification.send(@method, *@args).event.should == @event
  end

  it "should set player_id" do
    Notification.send(@method, *@args).player_id.should == @player_id
  end

  it "should save record" do
    Notification.send(@method, *@args).should_not be_new_record
  end
end

shared_examples_for "with location" do
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

    it_behaves_like "object"
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

  describe "notifier" do
    it_behaves_like "notifier",
      :build => lambda { Factory.build :notification },
      :change => lambda { |model| model.expires_at += 1.week },
      :notify_on_update => false, :notify_on_destroy => false
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
      @model.expires_at.should be_within(SPEC_TIME_PRECISION).of(
        Cfg.notification_expiration_time.from_now
      )
    end

    it "should register to CallbackManager for deletion" do
      @model.save!
      @model.
        should have_callback(CallbackManager::EVENT_DESTROY, @model.expires_at)
    end
  end

  describe ".on_callback" do
    before(:each) do
      @model = Factory.create(:notification)
    end

    it "should delete notification" do
      Notification.on_callback(@model.id, CallbackManager::EVENT_DESTROY)
      lambda do
        @model.reload
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
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
        Factory.create(:b_collector_t1, :planet => @planet, :x => 10),
      ]
      @player_id = @planet.player_id
      @args = [@player_id, @constructor, @constructables]
    end

    it_behaves_like "create for"
    it_behaves_like "with location"

    it "should set params[:constructor_type]" do
      Notification.send(@method, *@args
        ).params[:constructor_type].should == @constructor.type
    end

    it "should set params[:constructables]" do
      Notification.send(@method, *@args
        ).params[:constructables].should == {
          "Building::TestBuilding" => 2,
          "Building::CollectorT1" => 1
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

    it_behaves_like "create for"
    it_behaves_like "with location"

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
      @outcome = Combat::OUTCOME_WIN
      @combat_log = Factory.create :combat_log
      @yane_units = :yane_units
      @leveled_up = :leveled_up
      @statistics = :statistics
      @resources = :resources

      @args = [@player.id, @player.alliance_id, @alliances,
        @combat_log.id, @location.client_location.as_json, @outcome,
        @yane_units, @leveled_up, @statistics, @resources]
    end

    it_behaves_like "create for"

    it "should set params['alliance_id']" do
      Notification.send(
        @method, *@args
      ).params['alliance_id'].should == @player.alliance_id
    end

    it "should set params['alliances']" do
      Notification.send(
        @method, *@args
      ).params['alliances'].should == @alliances
    end

    it "should set params['location']" do
      Notification.send(
        @method, *@args
      ).params['location'].should == @location.client_location.as_json
    end
    
    it "should set log_id" do
      Notification.send(@method, *@args).params['log_id'].should == \
        @combat_log.id
    end

    it "should set params['outcome']" do
      Notification.send(@method, *@args).params['outcome'].should == @outcome
    end

    it "should set params['units'] from yane_units" do
      Notification.send(
        @method, *@args
      ).params['units'].should == @yane_units
    end

    it "should set params['leveled_up'] from leveled_up" do
      Notification.send(
        @method, *@args
      ).params['leveled_up'].should == @leveled_up
    end

    it "should set params['resources'] from resources" do
      Notification.send(
        @method, *@args
      ).params['resources'].should == @resources
    end

    it "should set statistics" do
      Notification.send(@method, *@args).params['statistics'].should == \
        @statistics
    end
  end

  shared_examples_for "quest notification" do
  end

  describe ".create_for_achievement_completed" do
    before(:all) do
      @achievement = Factory.create(:achievement)
      @quest_progress = Factory.create(:quest_progress,
        :quest => @achievement)

      @method = :create_for_achievement_completed
      @event = Notification::EVENT_ACHIEVEMENT_COMPLETED
      @player_id = @quest_progress.player_id

      @args = [@quest_progress]
    end

    it_behaves_like "create for"

    it "should set achievement" do
      Notification.send(
        @method, *@args
      ).params[:achievement].should == Quest.get_achievement(
        @achievement.id, @player_id)
    end
  end

  describe ".create_for_quest_completed" do
    before(:all) do
      @quest_progress = Factory.create(:quest_progress)

      @started_quests = [
        Factory.create(:quest),
        Factory.create(:quest)
      ]

      @method = :create_for_quest_completed
      @event = Notification::EVENT_QUEST_COMPLETED
      @player_id = @quest_progress.player_id

      @args = [@quest_progress, @started_quests]
    end

    it_behaves_like "create for"

    it "should set finished quest id" do
      Notification.send(
        @method, *@args
      ).params[:finished].should == @quest_progress.quest_id
    end

    it "should set started quest ids" do
      Notification.send(
        @method, *@args
      ).params[:started].should == @started_quests.map(&:id)
    end
  end

  describe ".create_for_exploration_finished" do
    before(:all) do
      @planet = Factory.create(:planet_with_player)
      @rewards = Rewards.new(Rewards::METAL => 100)
      @player_id = @planet.player_id

      @event = Notification::EVENT_EXPLORATION_FINISHED
      @method = :create_for_exploration_finished
      @args = [@planet, @rewards]
    end

    it_behaves_like "create for"

    it "should have :location" do
      Notification.send(
        @method, *@args
      ).params[:location].should == @planet.client_location.as_json
    end

    it "should have :rewards" do
      Notification.send(
        @method, *@args
      ).params[:rewards].should == @rewards.as_json
    end
  end

  describe ".create_for_planet_annexed" do
    before(:all) do
      @player_id = Factory.create(:player).id
      @planet = Factory.create(:planet_with_player)
      @outcome = Combat::OUTCOME_LOSE

      @event = Notification::EVENT_PLANET_ANNEXED
      @method = :create_for_planet_annexed
      @args = [@player_id, @planet, @outcome]
    end

    it_behaves_like "create for"

    it "should have :planet" do
      Notification.send(
        @method, *@args
      ).params[:planet].should == @planet.client_location.as_json
    end
    
    it "should have :owner" do
      Notification.send(
        @method, *@args
      ).params[:owner].should == @planet.player.as_json(:mode => :minimal)
    end
    
    it "should have :outcome" do
      Notification.send(
        @method, *@args
      ).params[:outcome].should == @outcome
    end
  end

  describe ".create_for_alliance_invite" do
    before(:all) do
      @alliance = Factory.create(:alliance)
      @player = Factory.create(:player)
      @player_id = @player.id

      @event = Notification::EVENT_ALLIANCE_INVITATION
      @method = :create_for_alliance_invite
      @args = [@alliance, @player]
    end

    it_behaves_like "create for"

    it "should have :alliance" do
      Notification.send(
        @method, *@args
      ).params[:alliance].should == @alliance.as_json(:mode => :minimal)
    end

    it "should not create duplicate invitations" do
      notification = Notification.send(@method, *@args)
      Notification.send(@method, *@args).should == notification
    end
  end

  describe ".create_for_kicked_from_alliance" do
    before(:all) do
      @alliance = Factory.create(:alliance)
      @player = Factory.create(:player)
      @player_id = @player.id

      @event = Notification::EVENT_ALLIANCE_KICK
      @method = :create_for_kicked_from_alliance
      @args = [@alliance, @player]
    end

    it_behaves_like "create for"

    it "should have :alliance" do
      Notification.send(
        @method, *@args
      ).params[:alliance].should == @alliance.as_json(:mode => :minimal)
    end
  end
  
  describe ".create_for_alliance_joined" do
    before(:all) do
      @alliance = Factory.create(:alliance)
      @members = [
        Factory.create(:player, :alliance => @alliance),
        Factory.create(:player, :alliance => @alliance),
        Factory.create(:player, :alliance => @alliance),
        Factory.create(:player, :alliance => @alliance),
      ]
      @player = Factory.create(:player)
    end

    it "should have :alliance" do
      Notification.create_for_alliance_joined(@alliance, @player).each do 
        |notification|
        notification.params[:alliance].should == 
          @alliance.as_json(:mode => :minimal)
      end
    end

    it "should have :player" do
      Notification.create_for_alliance_joined(@alliance, @player).each do 
        |notification|
        notification.params[:player].should == 
          @player.as_json(:mode => :minimal)
      end
    end
    
    it "should be sent for every alliance member" do
      notifications = 
        Notification.create_for_alliance_joined(@alliance, @player)
      @members.each do |member|
        notifications.find do |notification|
          notification.player_id == member.id
        end.should_not be_nil
      end
    end
    
    it "should not be sent for player who joined" do
      notifications = 
        Notification.create_for_alliance_joined(@alliance, @player)
      notifications.find do |notification|
        notification.player_id == @player.id
      end.should be_nil
    end
    
    it "should save all notifications" do
      Notification.create_for_alliance_joined(@alliance, @player).each do
        |notification| notification.should_not be_new_record
      end
    end
    
    it "should have event set" do
      Notification.create_for_alliance_joined(@alliance, @player).each do
        |notification| notification.event.should == 
          Notification::EVENT_ALLIANCE_JOINED
      end
    end
  end

  describe ".create_for_market_offer_bought" do
    before(:all) do
      @market_offer = Factory.create(:market_offer)
      @buyer = Factory.create(:player)
      @amount = @market_offer.from_amount
      @cost = 5032

      @player_id = @market_offer.player.id
      @event = Notification::EVENT_MARKET_OFFER_BOUGHT
      @method = :create_for_market_offer_bought
      @args = [@market_offer, @buyer, @amount, @cost]
    end

    it_behaves_like "create for"

    it "should have :buyer" do
      Notification.send(
        @method, *@args
      ).params[:buyer].should == @buyer.as_json(:mode => :minimal)
    end

    it "should have :planet" do
      Notification.send(
        @method, *@args
      ).params[:planet].should == @market_offer.planet.client_location.as_json
    end

    it "should have :from_kind" do
      Notification.send(
        @method, *@args
      ).params[:from_kind].should == @market_offer.from_kind
    end

    it "should have :amount" do
      Notification.send(
        @method, *@args
      ).params[:amount].should == @amount
    end

    it "should have :to_kind" do
      Notification.send(
        @method, *@args
      ).params[:to_kind].should == @market_offer.to_kind
    end

    it "should have :cost" do
      Notification.send(
        @method, *@args
      ).params[:cost].should == @cost
    end

    it "should have :amount_left" do
      Notification.send(
        @method, *@args
      ).params[:amount_left].should == @market_offer.from_amount
    end
  end

  describe ".create_for_vps_to_creds_conversion" do
    before(:all) do
      @player_id = Factory.create(:player).id
      @personal_creds = 123423
      @total_alliance_creds = 234234
      @alliance_creds_per_player = 2344

      @event = Notification::EVENT_VPS_CONVERTED_TO_CREDS
      @method = :create_for_vps_to_creds_conversion
      @args = [@player_id, @personal_creds,
        @total_alliance_creds, @alliance_creds_per_player]
    end

    it_behaves_like "create for"

    it "should have :personal_creds" do
      Notification.send(
        @method, *@args
      ).params[:personal_creds].should == @personal_creds
    end

    it "should have :total_alliance_creds" do
      Notification.send(
        @method, *@args
      ).params[:total_alliance_creds].should == @total_alliance_creds
    end

    it "should have :alliance_creds_per_player" do
      Notification.send(
        @method, *@args
      ).params[:alliance_creds_per_player].should == @alliance_creds_per_player
    end
  end
end
