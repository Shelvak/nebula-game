require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe Galaxy do
  describe ".battleground_id" do
    it "should return battleground id" do
      # other battleground in other galaxy.
      Factory.create(:battleground)
      bg = Factory.create(:battleground)
      Galaxy.battleground_id(bg.galaxy_id).should == bg.id
    end

    it "should not return regular detached systems" do
      ss = Factory.create(:solar_system, :x => nil, :y => nil)
      Galaxy.battleground_id(ss.galaxy_id).should == 0
    end
  end

  describe ".apocalypse_start" do
    it "should return time if it has started" do
      time = 5.days.ago
      galaxy = Factory.create(:galaxy, :apocalypse_start => time)
      Galaxy.apocalypse_start(galaxy.id).should be_within(SPEC_TIME_PRECISION).
        of(time)
    end

    it "should return nil if it has not started" do
      galaxy = Factory.create(:galaxy, :apocalypse_start => nil)
      Galaxy.apocalypse_start(galaxy.id).should be_nil
    end
  end

  describe ".units" do
    before(:all) do
      galaxy = Factory.create :galaxy
      alliance = Factory.create :alliance
      you = Factory.create :player, :galaxy => galaxy, :alliance => alliance
      ally = Factory.create :player, :galaxy => galaxy,
        :alliance => alliance
      enemy = Factory.create :player, :galaxy => galaxy

      FowGalaxyEntry.increase(Rectangle.new(0, 0, 0, 0), you)
      @your_unit_visible = Factory.create :u_mule, :player => you,
        :location => GalaxyPoint.new(galaxy.id, 0, 0)
      @ally_unit_visible = Factory.create :u_mule, :player => ally,
        :location => GalaxyPoint.new(galaxy.id, 0, 0)
      @enemy_unit_visible = Factory.create :u_mule, :player => enemy,
        :location => GalaxyPoint.new(galaxy.id, 0, 0)
      @enemy_unit_invisible = Factory.create :u_mule, :player => enemy,
        :location => GalaxyPoint.new(galaxy.id, 0, 1)
      @your_unit_invisible = Factory.create :u_mule, :player => you,
        :location => GalaxyPoint.new(galaxy.id, 0, 1)
      @ally_unit_invisible = Factory.create :u_mule, :player => ally,
        :location => GalaxyPoint.new(galaxy.id, 0, 1)
      @not_in_galaxy = Factory.create :u_mule, :player => you,
        :location => SolarSystemPoint.new(1, 0, 0)

      @result = Galaxy.units(you)
    end

    it "should return your units in visible zone" do
      @result.should include(@your_unit_visible)
    end

    it "should return alliance units in visible zone" do
      @result.should include(@ally_unit_visible)
    end

    it "should return enemy units in visible zone" do
      @result.should include(@enemy_unit_visible)
    end

    it "should not return enemy units in invisible zone" do
      @result.should_not include(@enemy_unit_invisible)
    end

    it "should return your units in invisible zone" do
      @result.should include(@your_unit_invisible)
    end

    it "should return alliance units in invisible zone" do
      @result.should include(@ally_unit_invisible)
    end

    it "should return units non in galaxy" do
      @result.should_not include(@not_in_galaxy)
    end
  end

  describe ".closest_wormhole" do
    before(:each) do
      @player = Factory.create(:player)
      @galaxy = @player.galaxy
      Factory.create(:fge_player, :galaxy => @galaxy,
        :player => @player, :rectangle => Rectangle.new(0, 0, 10, 10))
    end

    it "should return closest wormhole" do
      wh = Factory.create(:wormhole, :galaxy => @galaxy, :x => 0, :y => 2)
      Factory.create(:wormhole, :galaxy => @galaxy, :x => 2, :y => 2)

      Galaxy.closest_wormhole(@galaxy.id, 0, 0).should == wh
    end

    it "should not return regular solar systems" do
      Factory.create(:solar_system, :galaxy => @galaxy, :x => 0, :y => 0)
      Galaxy.closest_wormhole(@galaxy.id, 0, 0).should be_nil
    end

    it "should return nil if no wormholes are visible" do
      Galaxy.closest_wormhole(@player, 0, 0).should be_nil
    end
  end

  describe ".on_callback" do
    describe "spawn convoy" do
      before(:each) do
        @galaxy = Factory.create(:galaxy)
        Galaxy.stub!(:find).with(@galaxy.id).and_return(@galaxy)
      end
      
      it "should call #spawn_convoy!" do
        @galaxy.should_receive(:spawn_convoy!)
        Galaxy.on_callback(@galaxy.id, CallbackManager::EVENT_SPAWN)
      end
      
      it "should register callback" do
        Galaxy.on_callback(@galaxy.id, CallbackManager::EVENT_SPAWN)
        @galaxy.should have_callback(CallbackManager::EVENT_SPAWN,
          CONFIG.evalproperty('galaxy.convoy.time').from_now)
      end
    end
  
    describe "system offers" do
      before(:each) do
        @galaxy = Factory.create(:galaxy)
      end
      
      MarketOffer::CALLBACK_MAPPINGS.each do |kind, event|
        it "should create system offer and save it (kind #{kind})" do
          should_execute_and_save(
            MarketOffer, :create_system_offer, [@galaxy.id, kind]
          ) do
            Galaxy.on_callback(@galaxy.id, event)
          end
        end
      end
    end
  end

  describe "#check_if_finished!" do
    let(:galaxy) { Factory.create(:galaxy) }

    it "should not finish if dev" do
      galaxy = Factory.create(:galaxy, :ruleset => "dev")
      galaxy.should_not_receive(:finish!)
      galaxy.check_if_finished!(Cfg.vps_for_winning)
    end

    it "should not finish if already finished" do
      galaxy = Factory.create(:galaxy, :apocalypse_start => 15.minutes.from_now)
      galaxy.should_not_receive(:finish!)
      galaxy.check_if_finished!(Cfg.vps_for_winning)
    end

    it "should not finish if not enough victory points" do
      galaxy.should_not_receive(:finish!)
      galaxy.check_if_finished!(Cfg.vps_for_winning - 1)
    end

    it "should finish otherwise" do
      galaxy.should_receive(:finish!)
      galaxy.check_if_finished!(Cfg.vps_for_winning)
    end
  end

  describe "#check_if_apocalypse_finished!" do
    let(:galaxy) do
      Factory.create(:galaxy, :apocalypse_start => 10.minutes.ago)
    end

    it "should fail if apocalypse has not yet started" do
      galaxy.stub!(:apocalypse_started?).and_return(false)
      lambda do
        galaxy.check_if_apocalypse_finished!
      end.should raise_error(ArgumentError)
    end

    it "should call .save_apocalypse_finish_data" do
      Factory.create(:player, :galaxy => galaxy, :planets_count => 0)

      Galaxy.should_receive(:save_apocalypse_finish_data).with(galaxy.id)
      galaxy.check_if_apocalypse_finished!
    end

    describe "we still have alive players" do
      it "should not call .save_apocalypse_finish_data" do
        Factory.create(:player, :galaxy => galaxy, :planets_count => 1)

        Galaxy.should_not_receive(:save_apocalypse_finish_data)
        galaxy.check_if_apocalypse_finished!
      end
    end

  end

  describe "#finish!" do
    let(:galaxy) { Factory.create(:galaxy) }

    it "should save statistical data" do
      Galaxy.should_receive(:save_finish_data).with(galaxy.id)
      galaxy.finish!
    end

    it "should set #apocalypse_start" do
      galaxy.finish!
      galaxy.reload
      galaxy.apocalypse_start.should be_within(SPEC_TIME_PRECISION).
                                       of(Cfg.apocalypse_start_time)
    end

    it "should dispatch apocalypse event" do
      should_fire_event(
        an_instance_of(Event::ApocalypseStart), EventBroker::CREATED
      ) do
        galaxy.finish!
      end
    end

    it "should call #convert_vps_to_creds!" do
      galaxy.should_receive(:convert_vps_to_creds!)
      galaxy.finish!
    end
  end

  describe "#apocalypse_day" do
    let(:galaxy) { Factory.build(:galaxy, :apocalypse_start => 15.6.days.ago) }

    it "should fail if apocalypse hasn't started yet" do
      galaxy.stub(:apocalypse_started?).and_return(false)
      lambda do
        galaxy.apocalypse_day
      end.should raise_error(ArgumentError)
    end

    it "should return rounded number of days otherwise" do
      galaxy.apocalypse_day.should == 17
    end
  end

  describe "#convert_vps_to_creds!" do
    before(:each) do
      @alliance = create_alliance
      @alliance.owner.alliance_vps   = 8000
      @alliance.owner.victory_points = 10000
      @alliance.owner.creds          = 5000
      @alliance.owner.save!

      @galaxy = @alliance.galaxy

      @allies = [
        @alliance.owner,
        Factory.create(:player,
          :alliance => @alliance, :galaxy => @alliance.galaxy,
          :creds => 10000, :victory_points => 12000, :alliance_vps => 10000),
        Factory.create(:player,
          :alliance => @alliance, :galaxy => @alliance.galaxy,
          :creds => 4000, :victory_points => 6000, :alliance_vps => 5000)
      ]
      @alliance_total_creds = @allies.map { |a| a.alliance_vps / 2 }.sum
      @alliance_per_player_creds = @alliance_total_creds / @allies.size

      @non_ally = Factory.create(:player, :galaxy => @alliance.galaxy,
        :creds => 2000, :victory_points => 6000, :alliance_vps => 5000)
    end

    it "should add creds by algorithm" do
      @galaxy.convert_vps_to_creds!
      @allies.each do |player|
        old_creds = player.creds
        player.reload
        player.creds.should == old_creds +
          (player.victory_points - player.alliance_vps) +
          (player.alliance_vps / 2) + @alliance_per_player_creds
      end

      old_creds = @non_ally.creds
      @non_ally.reload
      @non_ally.creds.should == old_creds + @non_ally.victory_points
    end

    it "should send out notifications" do
      @allies.each do |player|
        personal_creds = (player.victory_points - player.alliance_vps) +
          (player.alliance_vps / 2)
        Notification.should_receive(:create_for_vps_to_creds_conversion).with(
          player.id, personal_creds, @alliance_total_creds,
          @alliance_per_player_creds
        )
      end

      Notification.should_receive(:create_for_vps_to_creds_conversion).with(
        @non_ally.id, @non_ally.victory_points, nil, nil
      )
      @galaxy.convert_vps_to_creds!
    end

    it "should not send out notifications if there is nothing gained" do
      @allies.each do |player|
        player.alliance_vps = 0
        player.victory_points = 0
        player.save!
      end

      @non_ally.victory_points = 0
      @non_ally.save!

      Notification.should_not_receive(:create_for_vps_to_creds_conversion)
      @galaxy.convert_vps_to_creds!
    end
  end

  describe "#by_coords" do
    it "should return solar system by x,y" do
      model = Factory.create :galaxy
      x = 250
      y = 300
      ss = Factory.create :solar_system, :galaxy => model, :x => x, :y => y
      model.by_coords(x, y).should == ss
    end
  end

  describe "#spawn_convoy!" do
    describe "galaxy with < 2 wormholes" do
      it "should do nothing" do
        galaxy = Factory.create(:galaxy)
        galaxy.spawn_convoy!.should be_nil
        Unit.where(:galaxy_id => galaxy.id).count.should == 0
      end
    end
    
    describe "galaxy with >= 2 wormholes" do
      before(:each) do
        @galaxy = Factory.create(:galaxy)
        @wh1 = Factory.create(:wormhole, :galaxy => @galaxy, 
          :x => -10, :y => 20)
        @wh2 = Factory.create(:wormhole, :galaxy => @galaxy, 
          :x => -30, :y => -10)
        @route = @galaxy.spawn_convoy!
      end

      it "should create route" do
        @route.should be_instance_of(Route)
      end

      it "should fire created on units" do
        SPEC_EVENT_HANDLER.clear_events!
        @galaxy.spawn_convoy!
        SPEC_EVENT_HANDLER.fired?(
          Unit.in_location(@route.source).all, EventBroker::CREATED
        ).should be_true
      end
      
      it "should use speed modifier" do
        UnitMover.should_receive(:move).with(nil, an_instance_of(Array),
          anything, anything, false, 
          CONFIG['galaxy.convoy.speed_modifier']).and_return(
          Factory.create(:route))
        @galaxy.spawn_convoy!
      end
      
      it "should create units in source location" do
        check_spawned_units_by_random_definition(
          Cfg.galaxy_convoy_units_definition,
          @galaxy.id,
          @route.source,
          nil
        )
      end

      it "should have route that goes to other wormhole" do
        if @wh1.galaxy_point == @route.source
          @wh2.galaxy_point.should == @route.target
        else
          @wh1.galaxy_point.should == @route.target
        end
      end
      
      it "should have callbacks for units which destroys them upon arrival" do
        Unit.in_location(@route.source).each do |unit|
          unit.should have_callback(CallbackManager::EVENT_DESTROY, 
            @route.arrives_at)
        end
      end
    end
  end
end