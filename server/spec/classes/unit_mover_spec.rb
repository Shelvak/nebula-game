require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe UnitMover do
  describe ".move_meta" do
    before(:each) do
      @player = Factory.create(:player)
      ss = Factory.create(:solar_system)
      @ssp1 = SolarSystemPoint.new(ss.id, 0, 0)
      @ssp2 = SolarSystemPoint.new(ss.id, 3, 0)

      @units = [
        Factory.create(:u_mule, :player => @player, :location => @ssp1)
      ]
    end
    
    it "should give you arrival date" do
      arrives_at, _ = 
        UnitMover.move_meta(@player.id, @units.map(&:id), @ssp1, @ssp2)
      arrives_at.
        should be_within(SPEC_TIME_PRECISION).of(
          UnitMover.move(@player.id, @units.map(&:id), @ssp1, @ssp2).
            arrives_at
        )
    end
    
    it "should give you hop count" do
      _, hop_count = 
        UnitMover.move_meta(@player.id, @units.map(&:id), @ssp1, @ssp2)
      hop_count.should ==
        UnitMover.move(@player.id, @units.map(&:id), @ssp1, @ssp2).hops.size
    end
  end

  describe ".move" do
    before(:all) do
      @player = Factory.create :player

      @galaxy = Factory.create :galaxy
      @ss1 = Factory.create :solar_system, :galaxy => @galaxy,
        :x => -1, :y => 0
      @ss2 = Factory.create :solar_system, :galaxy => @galaxy,
        :x => 1, :y => 0

      @p1 = Factory.create :planet, :solar_system => @ss1,
        :position => 1, :angle => 0, :player => @player
      @source = @p1
      @jg1 = Factory.create :sso_jumpgate, :solar_system => @ss1,
        :position => 2, :angle => 0

      @p2 = Factory.create :planet, :solar_system => @ss2,
        :position => 1, :angle => 0, :player => @player
      @target = @p2
      @jg2 = Factory.create :sso_jumpgate, :solar_system => @ss2,
        :position => 2, :angle => 0
      @p3 = Factory.create :planet, :solar_system => @ss2,
        :position => 3, :angle => 0, :player => @player
    end

    before(:each) do
      @units_slow = [
        Factory.create(:u_mule, :player => @player, :location => @source),
        Factory.create(:u_mule, :player => @player, :location => @source),
        Factory.create(:u_mule, :player => @player, :location => @source),
      ]
      @units_fast = [
        Factory.create(:u_crow, :player => @player, :location => @source),
      ]

      @units = @units_slow + @units_fast
      @unit_ids = @units.map(&:id)
    end

    it "should raise error if source == target" do
      lambda do
        UnitMover.move(@player.id, @unit_ids, @source, @source)
      end.should raise_error(GameLogicError)
    end

    it "should raise error if target is unlandable planet" do
      @target.stub!(:landable?).and_return(false)
      lambda do
        UnitMover.move(@player.id, @unit_ids, @source, @target)
      end.should raise_error(GameLogicError)
    end

    it "should raise GameLogicError if any of the given units does not" +
    " belong to player" do
      unit = @units[0]
      unit.player = Factory.create :player
      unit.save!

      lambda do
        UnitMover.move(@player.id, @unit_ids, @source, @target)
      end.should raise_error(GameLogicError)
    end
  
    it "should raise GameLogicError if any of the given units does not" +
    " travel in space" do
      unit = @units[0]
      unit.type = "Trooper"
      unit.save!

      lambda do
        UnitMover.move(@player.id, @units.map(&:id), @source, @target)
      end.should raise_error(GameLogicError)
    end

    it "should raise GameLogicError if any of the given units ain't in" +
    "source location" do
      @units[0].location = Factory.create :planet
      @units[0].save!

      lambda do
        UnitMover.move(@player.id, @units.map(&:id), @source, @target)
      end.should raise_error(GameLogicError)
    end

    it "should create a new Route object" do
      UnitMover.move(
        @player.id, @units.map(&:id), @source, @target
      ).should be_instance_of(Route)
    end

    it "should pass source client location" do
      route = UnitMover.move(
        @player.id, @units.map(&:id), @source, @target
      )
      route.source.should == @source.client_location
    end

    it "should pass current client location which is eql to source loc" do
      route = UnitMover.move(
        @player.id, @units.map(&:id), @source, @target
      )
      route.current.should == @source.client_location
    end

    it "should pass target client location" do
      route = UnitMover.move(
        @player.id, @units.map(&:id), @source, @target
      )
      route.target.should == @target.client_location
    end

    it "should save created Route object" do
      UnitMover.move(
        @player.id, @units.map(&:id), @source, @target
      ).should_not be_new_record
    end
    
    it "should cache units that are en route" do
      UnitMover.move(
        @player.id, @units.map(&:id), @source, @target
      ).cached_units.should == {"Mule" => 3, "Crow" => 1}
    end

    it "should call SpaceMule.find_path" do
      avoid_npc = false
      path = SpaceMule.instance.find_path(@source, @target, avoid_npc)
      SpaceMule.instance.should_receive(:find_path).with(
        @source, @target, avoid_npc).and_return(path)
      UnitMover.move(@player.id, @unit_ids, @source, @target, avoid_npc)
    end

    it "should create RouteHop objects along the way" do
      route = UnitMover.move(@player.id, @unit_ids, @source, @target)
      route.hops.map do |h|
        [h.route_id, h.index, h.location_id, h.location_type,
          h.location_x, h.location_y]
      end.should == [
        Factory.build(:route_hop, :route => route, :index => 0,
          :location_id => @ss1.id,
          :location_type => Location::SOLAR_SYSTEM,
          :location_x => 1, :location_y => 0),
        Factory.build(:route_hop, :route => route, :index => 1,
          :location_id => @ss1.id,
          :location_type => Location::SOLAR_SYSTEM,
          :location_x => 2, :location_y => 0),
        Factory.build(:route_hop, :route => route, :index => 2,
          :location_id => @galaxy.id,
          :location_type => Location::GALAXY,
          :location_x => -1, :location_y => 0),
        Factory.build(:route_hop, :route => route, :index => 3,
          :location_id => @galaxy.id,
          :location_type => Location::GALAXY,
          :location_x => 0, :location_y => 0),
        Factory.build(:route_hop, :route => route, :index => 4,
          :location_id => @galaxy.id,
          :location_type => Location::GALAXY,
          :location_x => 1, :location_y => 0),
        Factory.build(:route_hop, :route => route, :index => 5,
          :location_id => @ss2.id,
          :location_type => Location::SOLAR_SYSTEM,
          :location_x => 2, :location_y => 0),
        Factory.build(:route_hop, :route => route, :index => 6,
          :location_id => @ss2.id,
          :location_type => Location::SOLAR_SYSTEM,
          :location_x => 1, :location_y => 0),
        Factory.build(:route_hop, :route => route, :index => 7,
          :location_id => @p2.id,
          :location_type => Location::SS_OBJECT,
          :location_x => nil, :location_y => nil),
      ].map do |h|
        [h.route_id, h.index, h.location_id, h.location_type,
          h.location_x, h.location_y]
      end
    end

    it "should write RouteHop indexes in increasing order" do
      route = UnitMover.move(@player.id, @unit_ids, @source, @target)
      route.hops.should == route.hops.sort_by { |i| i.index }
    end

    it "should store first zone jump time to Route#jumps_at" do
      route = UnitMover.move(@player.id, @unit_ids, @source, @target)
      route.jumps_at.should == route.hops[0].arrives_at
    end

    it "should set Route#jumps_at to nil if move is in-zone" do
      source = GalaxyPoint.new(@galaxy.id, 0, 0)
      target = GalaxyPoint.new(@galaxy.id, 10, 0)
      @units.each { |unit| unit.location = source; unit.save! }
      route = UnitMover.move(@player.id, @unit_ids, source, target)
      route.jumps_at.should be_nil
    end
    
    it "should store Route#arrives_at from last RouteHop" do
      route = UnitMover.move(@player.id, @unit_ids, @source, @target)
      route.arrives_at.to_s(:db).should == \
        route.hops.last.arrives_at.to_s(:db)
    end

    it "should make use of the speed multiplier" do
      mult = 1.5 # Increase move time, because decreasing requires creds.
      without_mult, _ =
        UnitMover.move_meta(@player.id, @unit_ids, @source, @target)
      original_move_time = without_mult - Time.now

      with_mult = UnitMover.move(
        @player.id, @unit_ids, @source, @target, true, mult
      ).arrives_at
      reduced_move_time = with_mult - Time.now

      (original_move_time * mult).
        should be_within(SPEC_TIME_PRECISION).of(reduced_move_time)
    end

    it "should use slowest of the units speed for movements" do
      route_with_all, _ = UnitMover.move_meta(
        @player.id, @units.map(&:id), @source, @target)
      slow_route, _ = UnitMover.move_meta(
        @player.id, @units_slow.map(&:id), @source, @target)

      route_with_all.should be_within(SPEC_TIME_PRECISION).of(slow_route)
    end

    it "should use technologies for movement" do
      with_config_values("technologies.heavy_flight.mod.speed" => 160) do
        args = [@player.id, @units_slow.map(&:id), @source, @target]
        without_tech, _ = UnitMover.move_meta(*args)
        original_move_time = without_tech - Time.now

        tech = Factory.create!(:t_heavy_flight, :player => @player, :level => 1)
        with_tech, _ = UnitMover.move_meta(*args)
        reduced_move_time = with_tech - Time.now

        (original_move_time / 2.6).
          should be_within(SPEC_TIME_PRECISION).of(reduced_move_time)
      end
    end
    
    it "should use weights" do
      s1 = SolarSystemPoint.new(@ss1.id, 0, 0)
      t1 = SolarSystemPoint.new(@ss1.id, 0, 90)

      s2 = SolarSystemPoint.new(@ss1.id, 1, 0)
      t2 = SolarSystemPoint.new(@ss1.id, 1, 45)

      @units.each { |u| u.location = s1; u.save! }
      inner, _ = UnitMover.move_meta(@player.id, @unit_ids, s1, t1)
      @units.each { |u| u.location = s2; u.save! }
      outer, _ = UnitMover.move_meta(@player.id, @unit_ids, s2, t2)

      (outer - inner).should > 0
    end

    it "should use same time for ss -> galaxy hop as galaxy -> ss hop" do
      u1 = Factory.create!(:u_rhyno, :player => @player,
        :location => @jg1.solar_system_point)
      u2 = Factory.create!(:u_rhyno, :player => @player,
        :location => @ss1.galaxy_point)

      ss_to_galaxy = UnitMover.move(@player.id, [u1.id],
        @jg1.solar_system_point, @ss1.galaxy_point)
      galaxy_to_ss = UnitMover.move(@player.id, [u2.id],
        @ss1.galaxy_point, @jg1.solar_system_point)

      ss_to_galaxy.arrives_at.should be_within(2.minutes).of(
        galaxy_to_ss.arrives_at)
    end

    it "should set #next? to true for the nearest hop" do
      route = UnitMover.move(@player.id, @unit_ids, @source, @target)
      route.hops.first.should be_next
    end
    
    it "should set up callback for the nearest hop" do
      route = UnitMover.move(@player.id, @unit_ids, @source, @target)
      first = route.hops.first
      CallbackManager.has?(first, CallbackManager::EVENT_MOVEMENT,
        first.arrives_at).should be_true
    end

    it "should fire MovementPrepare event" do
      SPEC_EVENT_HANDLER.clear_events!
      UnitMover.move(@player.id, @unit_ids, @source, @target)

      SPEC_EVENT_HANDLER.events.find do |object, event_name, reason|
        object.is_a?(Event::MovementPrepare) &&
          event_name == EventBroker::MOVEMENT_PREPARE
      end.should_not be_nil
    end

    it "should set route_id on given units" do
      route = UnitMover.move(@player.id, @unit_ids, @source, @target)
      Unit.find(@unit_ids).map do |unit|
        unit.route_id
      end.uniq.should == [route.id]
    end

    describe "moving units that are already in route" do
      before(:each) do
        @old_route = UnitMover.move(@player.id, @units.map(&:id), @source,
          @target)
        @target = @p3
        @unit_ids = [@units[2].id, @units[3].id]
      end

      it "should raise error if we're trying to affect 2 routes" do
        @units[2].route_id = Factory.create(:route).id
        @units[2].save!
        lambda do
          UnitMover.move(@player.id, @unit_ids, @source, @target)
        end.should raise_error(GameLogicError)
      end

      it "should reduce cached_units for route" do
        Route.should_receive(:find).with(@old_route.id).and_return(
          @old_route)
        @old_route.should_receive(:subtract_from_cached_units!).with(
          @unit_ids.map do |id|
            @units.find { |unit| unit.id == id }
          end.grouped_counts { |unit| unit.type }
        )
        UnitMover.move(@player.id, @unit_ids, @source, @target)
      end
    end
  end
end
