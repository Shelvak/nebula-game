require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe Galaxy do
  describe ".battleground_id" do
    it "should return battleground id" do
      # other battleground in other galaxy.
      Factory.create(:solar_system, :x => nil, :y => nil)
      bg = Factory.create(:solar_system, :x => nil, :y => nil)
      Galaxy.battleground_id(bg.galaxy_id).should == bg.id
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

  describe "#finish!" do
    let(:galaxy) { Factory.create(:galaxy) }

    it "should save statistical data" do
      Galaxy.should_receive(:save_galaxy_finish_data).with(galaxy.id)
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

    it "should add #creds to players by converting #victory_points" do
      players = [
        Factory.create(:player, :galaxy => galaxy, :creds => 123,
                       :victory_points => 100),
        Factory.create(:player, :galaxy => galaxy, :creds => 820,
                       :victory_points => 600),
        Factory.create(:player, :galaxy => galaxy, :creds => 1045,
                       :victory_points => 500),
      ]
      galaxy.finish!
      players.each do |player|
        old_creds = player.creds
        player.reload
        player.creds.should == old_creds + player.victory_points
      end
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