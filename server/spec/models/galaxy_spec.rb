require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe Galaxy do
  describe "#wormhole_count" do
    it "should calculate wormholes in this galaxy" do
      galaxy = Factory.create(:galaxy)
      wormholes = [
        Factory.create(:wormhole, galaxy: galaxy, x: 0),
        Factory.create(:wormhole, galaxy: galaxy, x: 1),
        Factory.create(:solar_system, galaxy: galaxy, x: 3),
        Factory.create(:wormhole, x: 1),
      ]
      galaxy.wormhole_count.should == 2
    end
  end

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
      solar_system = Factory.create(:solar_system, galaxy: galaxy)
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
        :location => SolarSystemPoint.new(solar_system.id, 0, 0)

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
      Factory.create(:fge, galaxy: @galaxy, player: @player,
        rectangle: Rectangle.new(0, 0, 10, 10))
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

  describe "callbacks" do
    let(:galaxy) { Factory.create(:galaxy) }

    describe ".spawn_callback" do
      before(:each) do
        galaxy.should_receive(:wormhole_count).and_return(5)
      end

      it "should call #spawn_convoy!" do
        galaxy.should_receive(:spawn_convoy!)
        Galaxy.spawn_callback(galaxy)
      end

      it "should register callback" do
        Galaxy.spawn_callback(galaxy)
        galaxy.should have_callback(
          CallbackManager::EVENT_SPAWN,
          Cfg.next_convoy_time(5)
        )
      end
    end

    describe "system offers" do
      MarketOffer::CALLBACK_MAPPINGS.each do |kind, event|
        type = CallbackManager::TYPES[event]
        scope = :"#{type.upcase}_SCOPE"
        method = :"#{type}_callback"

        it "should have scope" do
          Galaxy.const_get(scope)
        end

        it "should create system offer and save it (kind #{kind})" do
          should_execute_and_save(
            MarketOffer, :create_system_offer, [galaxy.id, kind]
          ) do
            Galaxy.send(method, galaxy)
          end
        end
      end
    end

    describe ".adjust_market_rates_callback" do
      let(:galaxy) { Factory.create(:galaxy) }

      it "should call MarketRate.adjust_rates!" do
        MarketRate.should_receive(:adjust_rates!).with(galaxy.id)
        Galaxy.adjust_market_rates_callback(galaxy)
      end

      it "should register next callback" do
        Galaxy.adjust_market_rates_callback(galaxy)
        galaxy.should have_callback(
          CallbackManager::EVENT_ADJUST_MARKET_RATES,
          Cfg.market_adjuster_next_date
        )
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
      @alliance.owner.pure_creds     = 5000
      @alliance.owner.save!

      @galaxy = @alliance.galaxy

      @allies = [
        @alliance.owner,
        Factory.create(:player,
          alliance: @alliance, galaxy: @alliance.galaxy,
          pure_creds: 10000, victory_points: 12000, alliance_vps: 10000),
        Factory.create(:player,
          alliance: @alliance, galaxy: @alliance.galaxy,
          pure_creds: 4000, victory_points: 6000, alliance_vps: 5000)
      ]
      @alliance_total_creds = @allies.map { |a| a.alliance_vps / 2 }.sum
      @alliance_per_player_creds = @alliance_total_creds / @allies.size

      @non_ally = Factory.create(:player, galaxy: @alliance.galaxy,
        pure_creds: 2000, victory_points: 6000, alliance_vps: 5000)
    end

    it "should add creds by algorithm" do
      @galaxy.convert_vps_to_creds!
      @allies.each do |player|
        old_creds = player.pure_creds
        player.reload
        player.pure_creds.should == old_creds +
          (player.victory_points - player.alliance_vps) +
          (player.alliance_vps / 2) + @alliance_per_player_creds
      end

      old_creds = @non_ally.pure_creds
      @non_ally.reload
      @non_ally.pure_creds.should == old_creds + @non_ally.victory_points
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
    let(:days) { 13.5 }
    let(:galaxy) { Factory.create(:galaxy, :created_at => days.days.ago) }

    shared_examples_for "convoy spawn" do
      it "should create route" do
        route.should be_instance_of(Route)
      end

      it "should fire created on units" do
        # We need this because creating a route fires events.
        SPEC_EVENT_HANDLER.clear_events!
        SPEC_EVENT_HANDLER.fired?(
          Unit.in_location(route.source).all, EventBroker::CREATED
        ).should be_true
      end

      it "should use speed modifier" do
        UnitMover.should_receive(:move).
          with(
            nil, an_instance_of(Array), anything, anything, false,
            Cfg.convoy_speed_modifier
          ).and_return(Factory.create(:route))
        route
      end

      it "should call units builder" do
        UnitBuilder.should_execute(
          :from_random_ranges,
          [Cfg.galaxy_convoy_units_definition, an_instance_of(GalaxyPoint),
           nil, days.round, 1]
        ) { route }
      end

      it "should create units in source location" do
        check_spawned_units_by_random_definition(
          Cfg.galaxy_convoy_units_definition,
          route.source,
          nil, days.round, 1
        )
      end

      it "should create cooldown in source location" do
        cooldown = Cooldown.in_location(route.source).first
        cooldown.ends_at.should be_within(SPEC_TIME_PRECISION).
          of(Cfg.after_spawn_cooldown)
      end

      it "should have route that goes to other wormhole" do
        raise "no points matched!" unless points.any? do |src, dst|
          if src == route.source
            route.target.location_point.should == dst
            true
          end
        end
      end

      it "should have callbacks for units which destroys them upon arrival" do
        Unit.in_location(route.source).each do |unit|
          unit.should have_callback(
            CallbackManager::EVENT_DESTROY,
            # See code for explanation for +1.
            route.arrives_at + 1
          )
        end
      end
    end

    describe "specifying your own points" do
      let(:src) { GalaxyPoint.new(galaxy.id, 10, 20) }
      let(:dst) { GalaxyPoint.new(galaxy.id, -10, 30) }
      let(:points) { [[src, dst]] }
      let(:route) { galaxy.spawn_convoy!(src, dst) }

      it_should_behave_like "convoy spawn"
    end

    describe "galaxy with < 2 wormholes" do
      it "should do nothing" do
        galaxy.spawn_convoy!.should be_nil
        Unit.where(location_galaxy_id: galaxy.id).count.should == 0
      end
    end

    describe "galaxy with >= 2 wormholes" do
      let(:wh1) do
        Factory.create(:wormhole, :galaxy => galaxy, :x => -10, :y => 20)
      end
      let(:wh2) do
        Factory.create(:wormhole, :galaxy => galaxy, :x => -30, :y => -10)
      end
      let(:points) do
        wh1p = wh1.galaxy_point
        wh2p = wh2.galaxy_point
        [[wh1p, wh2p], [wh2p, wh1p]]
      end
      let(:route) { points; galaxy.spawn_convoy! }

      it_should_behave_like "convoy spawn"
    end
  end

  describe ".create_galaxy" do
    let(:ruleset) { "default" }
    let(:callback_url) { "nebula44.lh" }
    let(:pool_free_zones) { 10 }
    let(:pool_free_home_ss) { 50 }

    %w{ruleset callback_url pool_free_zones pool_free_home_ss}.each do |attr|
      it "should set ##{attr}" do
        Galaxy.create_galaxy(
          ruleset, callback_url, pool_free_zones, pool_free_home_ss
        ).send(attr).should == send(attr)
      end
    end

    it "should set #pool_free_home_ss by default if value is not provided" do
      Galaxy.create_galaxy(
        ruleset, callback_url, pool_free_zones
      ).pool_free_home_ss.
        should == pool_free_zones * Cfg.galaxy_zone_max_player_count
    end

    it "should obey rulesets" do
      ruleset = "test_cg"
      CONFIG.global.add_set(ruleset, 'default')
      CONFIG.global.store("galaxy.zone.players", ruleset, 10)
      Galaxy.create_galaxy(
        ruleset, callback_url, pool_free_zones
      ).pool_free_home_ss.should == pool_free_zones *
        CONFIG.with_set_scope(ruleset) { Cfg.galaxy_zone_max_player_count }
    end

    %w{
      spawn_callback create_metal_system_offer_callback
      create_energy_system_offer_callback create_zetium_system_offer_callback
      adjust_market_rates_callback
    }.each do |method|
      it "should call ##{method}" do
        Galaxy.should_receive(method).with(an_instance_of(Galaxy))
        Galaxy.create_galaxy(
          ruleset, callback_url, pool_free_zones, pool_free_home_ss
        )
      end
    end

    it "should call SpaceMule#fill_galaxy" do
      SpaceMule.instance.should_receive(:fill_galaxy).
        with(an_instance_of(Galaxy))
      Galaxy.create_galaxy(
        ruleset, callback_url, pool_free_zones, pool_free_home_ss
      )
    end

    it "should save the galaxy" do
      Galaxy.create_galaxy(
        ruleset, callback_url, pool_free_zones, pool_free_home_ss
      ).should be_saved
    end
  end

  describe ".create_player" do
    let(:ruleset) { 'test_cp' }
    let(:galaxy) { Factory.create(:galaxy, ruleset: ruleset) }
    let(:galaxy_id) { galaxy.id }
    let(:web_user_id) { (Player.maximum(:web_user_id) || 0) + 1 }
    let(:name) { "P-#{web_user_id}" }
    let(:trial) { true }
    let(:planets_count) { 1 }
    let(:population_cap) { Building::Mothership.population(1) }
    let(:free_creds) { 5000 }
    let(:pooled_ss) do
      [
        Factory.create(:ss_pooled, galaxy: galaxy),
        Factory.create(:ss_pooled, galaxy: galaxy),
      ]
    end
    let(:other_ss) do
      [
        Factory.create(:solar_system, galaxy: galaxy, x: 10),
        Factory.create(:wormhole, galaxy: galaxy),
        Factory.create(:mini_battleground, galaxy: galaxy, x: 11),
        Factory.create(:battleground, galaxy: galaxy),
        Factory.create(:ss_detached, galaxy: galaxy),
      ]
    end
    let(:home_ss) { pooled_ss.first }
    let(:player) { Galaxy.create_player(galaxy_id, web_user_id, name, trial) }

    before(:each) do
      # This ensures that creds are only set if we're wrapped in appropriate
      # ruleset.
      CONFIG.global.add_set(ruleset, 'default')
      CONFIG.global.store("galaxy.player.creds.starting", ruleset, free_creds)
      other_ss
      home_ss
    end

    %w{
      galaxy_id web_user_id name trial planets_count population_cap
      free_creds
    }.each do |attr|
      it "should set Player##{attr}" do
        player.send(attr).should == send(attr)
      end
    end

    it "should save the player" do
      player.should be_saved
    end

    it "should start player quest line" do
      Quest.should_receive(:start_player_quest_line).with(player.id)
      player
    end

    it "should register inactivity check" do
      player.should have_callback(
        CallbackManager::EVENT_CHECK_INACTIVE_PLAYER,
        Cfg.player_inactivity_time(player.points).from_now
      )
    end

    it "should assign a home solar system to player" do
      player.home_solar_system.should == home_ss
    end

    it "should assing home solar system from correct galaxy pool" do
      galaxy
      another_galaxy = Factory.create(:galaxy)
      Factory.create(:ss_pooled, galaxy: another_galaxy)
      # Zone for reattachment
      Factory.create(:solar_system, galaxy: another_galaxy, x: 10)
      Factory.create(:wormhole, galaxy: another_galaxy)
      player = Galaxy.create_player(another_galaxy.id, web_user_id, name, trial)
      player.home_solar_system.galaxy_id.should == another_galaxy.id
    end

    it "should change kind of home solar system to normal" do
      player.home_solar_system.kind.should == SolarSystem::KIND_NORMAL
    end

    it "should only assign one home solar system to player" do
      player
      SolarSystem.where(player_id: player.id).count.should == 1
    end

    it "should fail if there is no pooled home solar systems" do
      pooled_ss.each(&:destroy)
      lambda do
        player
      end.should raise_error(RuntimeError)
    end

    it "should find zone and attach home solar system" do
      zone = mock(Galaxy::Zone)
      Galaxy::Zone.should_receive(:for_enrollment).with(
        galaxy_id, Cfg.galaxy_zone_maturity_age
      ).and_return(zone)
      zone.should_receive(:free_spot_coords).with(galaxy_id).
        and_return([3, 4])
      [player.home_solar_system.x, player.home_solar_system.y].should == [3, 4]
    end

    it "should dispatch created with appropriate metadata" do
      Factory.create(:planet, solar_system: home_ss, owner_changed: 2.days.ago)
      viewer = Factory.create(:fge, galaxy: galaxy,
        rectangle: Rectangle.new(-100, -100, 100, 100))

      SPEC_EVENT_HANDLER.clear_events!
      player
      event, kind, reason = SPEC_EVENT_HANDLER.events.find do
        |f_event, f_kind, f_reason|
        f_event.is_a?(Event::FowChange::SsCreated)
      end

      event.metadatas[viewer.player_id][:enemies_with_planets].
        should_not be_blank
    end

    describe "planets" do
      let(:home_ss_planets) do
        [
          Factory.create(:planet, solar_system: home_ss,
            last_resources_update: 1.day.ago),
          Factory.create(:planet, solar_system: home_ss,
            last_resources_update: 1.day.ago,
            position: 1, owner_changed: 2.days.ago),
        ]
      end
      let(:non_home_planet) { home_ss_planets.first }
      let(:home_planet) { home_ss_planets.last }
      let(:other_planets) do
        [
          Factory.create(:planet, last_resources_update: 1.day.ago)
        ]
      end

      before(:each) do
        home_ss_planets
        other_planets
      end

      # Because planet.reload.last_resources_update actually updates it now via
      # #after_find.
      def last_resources_update(planet)
        value = SsObject::Planet.select("last_resources_update").
          where(id: planet.id).c_select_value

        value.nil? ? nil : Time.parse(value)
      end

      it "should update SsObject::Planet#last_resources_update" do
        home_ss_planets.each do |planet|
          last_resources_update(planet).
            should_not be_within(SPEC_TIME_PRECISION).of(Time.now)
        end
        player
        home_ss_planets.each do |planet|
          last_resources_update(planet).
            should be_within(SPEC_TIME_PRECISION).of(Time.now)
        end
      end

      it "should not update #last_resources_update in other ss planets" do
        player
        other_planets.each do |planet|
          last_resources_update(planet).
            should_not be_within(SPEC_TIME_PRECISION).of(Time.now)
        end
      end

      it "should update SsObject::Planet#owner_changed in player planet" do
        player
        home_planet.reload.owner_changed.
          should be_within(SPEC_TIME_PRECISION).of(Time.now)
      end

      it "should not update #owner_changed in other ss planets" do
        player
        (other_planets + [non_home_planet]).each do |planet|
          planet.reload.owner_changed.should be_nil
        end
      end

      it "should assign planet to player" do
        player
        home_planet.reload.player.should == player
      end

      it "should only assign one planet to player" do
        player.planets.count.should == 1
      end
    end
  end
end