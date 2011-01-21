require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe UnitMover do
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

      @jump_hop_indexes = [1, 4, 6]
    end

    before(:each) do
      @units = [
        Factory.create(:u_mule, :player => @player, :location => @source),
        Factory.create(:u_mule, :player => @player, :location => @source),
        Factory.create(:u_mule, :player => @player, :location => @source),
        Factory.create(:u_crow, :player => @player, :location => @source),
      ]
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
      path = SpaceMule.instance.find_path(@source, @target, nil)
      SpaceMule.instance.should_receive(:find_path).with(
        @source, @target, nil).and_return(path)
      UnitMover.move(@player.id, @unit_ids, @source, @target)
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

    it "should set #jumps_at to nil if it's not a jump" do
      route = UnitMover.move(@player.id, @unit_ids, @source, @target)
      hops = route.hops
      ((0...hops.size).to_a - @jump_hop_indexes).each do |index|
        hops[index].jumps_at.should be_nil
      end
    end

    it "should set #jumps_at to next hops #arrives_at if zones differ" do
      route = UnitMover.move(@player.id, @unit_ids, @source, @target)
      hops = route.hops
      @jump_hop_indexes.each do |index|
        hops[index].jumps_at.should == hops[index + 1].arrives_at
      end
    end

    it "should write RouteHop indexes in increasing order" do
      route = UnitMover.move(@player.id, @unit_ids, @source, @target)
      route.hops.should == route.hops.sort_by { |i| i.index }
    end

    it "should store Route#arrives_at from last RouteHop" do
      route = UnitMover.move(@player.id, @unit_ids, @source, @target)
      route.arrives_at.to_s(:db).should == \
        route.hops.last.arrives_at.to_s(:db)
    end

    it "should use slowest of the units speed for movements" do
      LOGGER.debug "AAA"
      with_config_values(
        'units.mule.move.solar_system.hop_time' => 20,
        'units.crow.move.solar_system.hop_time' => 5,
        'units.mule.move.galaxy.hop_time' => 100,
        'units.crow.move.galaxy.hop_time' => 50,
        'solar_system.links.orbit.weight' => 1.0,
        'solar_system.links.parent.weight' => 1.0,
        'solar_system.links.planet.weight' => 1.0
      ) do
        # Pass new weights to mule
        SpaceMule.instance.restart!
        route = UnitMover.move(@player.id, @unit_ids, @source, @target)
        
        # 5 hops in SS, 3 hops in galaxy
        expected = (5 * 20 + 3 * 100).since.to_s(:db)
        route.arrives_at.to_s(:db).should == expected
      end
      # Restart with default values
      SpaceMule.instance.restart!
      LOGGER.debug "BBB"
    end
    
    it "should use weights" do
      with_config_values(
        'units.mule.move.solar_system.hop_time' => 20,
        'units.crow.move.solar_system.hop_time' => 20,
        'units.mule.move.galaxy.hop_time' => 100,
        'units.crow.move.galaxy.hop_time' => 100,
        'solar_system.links.orbit.weight' => 3.0,
        'solar_system.links.parent.weight' => 3.0,
        'solar_system.links.planet.weight' => 3.0
      ) do
        # Pass new weights to mule
        SpaceMule.instance.restart!
        route = UnitMover.move(@player.id, @unit_ids, @source, @target)

        # 5 hops in SS, 3 hops in galaxy
        expected = (5 * 20 * 3 + 3 * 100 * 1).since.to_s(:db)
        route.arrives_at.to_s(:db).should == expected
      end
      # Restart with default values
      SpaceMule.instance.restart!
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
        object.is_a?(MovementPrepareEvent) &&
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

      it "should raise error if we're trying to affetct 2 routes" do
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