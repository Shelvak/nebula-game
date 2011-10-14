require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe Route do
  let(:route) { Factory.create(:route) }

  describe ".by_fow_entries" do
    let(:player) { Factory.create(:player) }
    let(:fow_entries) { [Factory.create(:fge_player, :galaxy => player.galaxy,
                                        :player => player)] }
    let(:entry) { fow_entries[0] }
    let(:galaxy) { player.galaxy }

    it "should include routes which are in visible zone" do
      route = Factory.create(:route, :player => player,
        :current => GalaxyPoint.new(galaxy.id, entry.x, entry.y).client_location
      )
      Route.by_fow_entries(fow_entries).should include(route)
    end

    describe "when currently out of visible zone" do
      it "should not include routes which started in it" do
        route = Factory.create(:route, :player => player,
          :source => GalaxyPoint.new(galaxy.id, entry.x, entry.y).
            client_location,
          :current => GalaxyPoint.new(galaxy.id, entry.x - 1, entry.y).
            client_location
        )
        Route.by_fow_entries(fow_entries).should_not include(route)
      end

      it "should not include routes which ends in it" do
        route = Factory.create(:route, :player => player,
          :target => GalaxyPoint.new(galaxy.id, entry.x, entry.y).
            client_location,
          :current => GalaxyPoint.new(galaxy.id, entry.x - 1, entry.y).
            client_location
        )
        Route.by_fow_entries(fow_entries).should_not include(route)
      end
    end
  end

  describe ".not_of" do
    it "should not include routes where player_id is in given set" do
      Route.not_of(route.player_id).should_not include(route)
    end

    it "should include routes where player_id is not in given set" do
      route = Factory.create(:route)
      other_route = Factory.create(:route)
      Route.not_of(other_route.player_id).should include(route)
    end
  end

  describe ".currently_in_solar_system" do
    let(:player) { Factory.create(:player) }
    let(:solar_system) { Factory.create(:solar_system) }
    let(:other_solar_system) { Factory.create(:solar_system) }

    it "should return route which currently is in that solar system" do
      route = Factory.create(:route, :player => player,
        :current => SolarSystemPoint.new(solar_system.id, 0, 0).client_location
      )
      Route.currently_in_solar_system(solar_system.id).should include(route)
    end

    it "should not return route which is in different solar system" do
      route = Factory.create(:route, :player => player,
        :current => SolarSystemPoint.new(other_solar_system.id, 0, 0).
          client_location
      )
      Route.currently_in_solar_system(solar_system.id).should_not include(route)
    end

    describe "when not in required solar system" do
      it "should not return route if it started in required solar system" do
        route = Factory.create(:route, :player => player,
          :source => SolarSystemPoint.new(solar_system.id, 0, 0).
            client_location,
          :current => SolarSystemPoint.new(other_solar_system.id, 0, 0).
            client_location
        )
        Route.currently_in_solar_system(solar_system.id).
          should_not include(route)
      end

      it "should not return route if it ends in required solar system" do
        route = Factory.create(:route, :player => player,
          :target => SolarSystemPoint.new(solar_system.id, 0, 0).
            client_location,
          :current => SolarSystemPoint.new(other_solar_system.id, 0, 0).
            client_location
        )
        Route.currently_in_solar_system(solar_system.id).
          should_not include(route)
      end
    end
  end
  
  describe ".currently_in_ss_object" do
    let(:player) { Factory.create(:player) }
    let(:ss_object) { Factory.create(:planet) }
    let(:other_ss_object) { Factory.create(:planet) }

    it "should return route which currently is in that ss object" do
      route = Factory.create(:route, :player => player,
        :current => ss_object.client_location
      )
      Route.currently_in_ss_object(ss_object.id).should include(route)
    end

    it "should not return route which is in different ss object" do
      route = Factory.create(:route, :player => player,
        :current => other_ss_object.client_location
      )
      Route.currently_in_ss_object(ss_object.id).should_not include(route)
    end

    describe "when not in required ss object" do
      it "should not return route if it started in required ss object" do
        route = Factory.create(:route, :player => player,
          :source => ss_object.client_location,
          :current => other_ss_object.client_location
        )
        Route.currently_in_ss_object(ss_object.id).
          should_not include(route)
      end

      it "should not return route if it ends in required ss object" do
        route = Factory.create(:route, :player => player,
          :target => ss_object.client_location,
          :current => other_ss_object.client_location
        )
        Route.currently_in_ss_object(ss_object.id).
          should_not include(route)
      end
    end
  end

  describe ".non_friendly_for_galaxy" do
    it "should chain .by_fow_entries and .not_of together" do
      mock = mock(Arel::Relation)
      Route.should_receive(:by_fow_entries).
        with(:fow_entries, Route::FOW_PREFIX_CURRENT).
        and_return(mock)
      mock.should_receive(:not_of).with(:friendly_ids).and_return(:result)
      Route.non_friendly_for_galaxy(:fow_entries, :friendly_ids).should ==
        :result
    end
  end

  describe ".non_friendly_for_solar_system" do
    it "should chain .currently_in_solar_system and .not_of together" do
      mock = mock(Arel::Relation)
      Route.should_receive(:currently_in_solar_system).with(:solar_system_id).
        and_return(mock)
      mock.should_receive(:not_of).with(:friendly_ids).and_return(:result)
      Route.non_friendly_for_solar_system(:solar_system_id, :friendly_ids).
        should == :result
    end
  end

  describe ".non_friendly_for_ss_object" do
    it "should chain .currently_in_ss_object and .not_of together" do
      mock = mock(Arel::Relation)
      Route.should_receive(:currently_in_ss_object).with(:ss_object_id).
        and_return(mock)
      mock.should_receive(:not_of).with(:friendly_ids).and_return(:result)
      Route.non_friendly_for_ss_object(:ss_object_id, :friendly_ids).
        should == :result
    end
  end

  describe ".jumps_at_hash_from_collection" do
    it "should return hash" do
      routes = [
        Factory.create(:route, :jumps_at => 5.minutes.from_now),
        Factory.create(:route, :jumps_at => 15.minutes.from_now),
      ]
      Route.jumps_at_hash_from_collection(routes).should equal_to_hash(
        routes[0].id => routes[0].jumps_at,
        routes[1].id => routes[1].jumps_at
      )
    end

    it "should skip items where jumps_at is nil" do
      routes = [
        Factory.create(:route, :jumps_at => 5.minutes.from_now),
        Factory.create(:route, :jumps_at => nil),
      ]
      Route.jumps_at_hash_from_collection(routes).should equal_to_hash(
        routes[0].id => routes[0].jumps_at
      )
    end
  end

  describe "#cached_units" do
    it "should be serializable" do
      route = Factory.create :route
      lambda { route.reload }.should_not change(route, :cached_units)
    end
  end

  describe "#subtract_from_cached_units!" do
    before(:each) do
      @route = Factory.create(:route, :cached_units => {
          "Mule" => 3,
          "Dart" => 1
        })
    end

    it "should reduce counts" do
      @route.subtract_from_cached_units!("Mule" => 2)
      @route.cached_units["Mule"].should == 1
    end

    it "should remove keys where count == 0" do
      @route.subtract_from_cached_units!("Dart" => 1)
      @route.cached_units.should_not have_key("Dart")
    end

    it "should raise error if trying to subtract more than we have" do
      lambda do
        @route.subtract_from_cached_units!("Dart" => 2)
      end.should raise_error(ArgumentError)
    end

    it "should save object" do
      @route.subtract_from_cached_units!("Dart" => 1)
      @route.should_not be_changed
    end

    it "should destroy object if cached units are blank" do
      @route.subtract_from_cached_units!(@route.cached_units)
      lambda do
        @route.reload
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

  it "should nullify units upon destruction" do
    route = Factory.create(:route)
    unit = Factory.create(:unit, :route => route)
    route.destroy
    unit.reload
    unit.route_id.should be_nil
  end

  describe "#hops_in_zone" do
    it "should call RouteHop.hops_in_zone" do
      route = Factory.create(:route)
      RouteHop.should_receive(:hops_in_zone).with(route.id, :zone)
      route.hops_in_zone(:zone)
    end
  end

  describe "#hops_in_current_zone" do
    it "should call #hops_in_zone with current zone if in galaxy" do
      location = GalaxyPoint.new(Factory.create(:galaxy).id, 0, 0)
      route = Factory.create(:route, :current => location.client_location)
      route.should_receive(:hops_in_zone).with(location.zone)
      route.hops_in_current_zone
    end

    it "should call #hops_in_zone with current zone if in solar system" do
      location = SolarSystemPoint.new(Factory.create(:solar_system).id,
        1, 0)
      route = Factory.create(:route, :current => location.client_location)
      route.should_receive(:hops_in_zone).with(location.zone)
      route.hops_in_current_zone
    end

    it "should just return [] otherwise" do
      location = Factory.create(:planet)
      route = Factory.create(:route, :current => location.client_location)
      route.hops_in_current_zone.should == []
    end
  end

  describe "notifier" do
    build = lambda { Factory.build(:route) }

    it_behaves_like "notifier", :build => build,
      :change => lambda { |model| model.arrives_at += 1.minute },
      :notify_on_create => false
    
    it "should dispatch destroyed with reason 'completed' if flag is set" do
      model = build.call
      model.save!
      model.completed = true
      should_fire_event(model, EventBroker::DESTROYED, 
          EventBroker::REASON_COMPLETED) do
        model.destroy
      end
    end
  end

  describe "#as_json" do
    it "should return Hash" do
      model = Factory.create :route
      model.as_json(nil).should == {
        :id => model.id,
        :player => Player.minimal(model.player_id),
        :cached_units => model.cached_units,
        :jumps_at => model.jumps_at,
        :arrives_at => model.arrives_at,
        :source => model.source.as_json,
        :current => model.current.as_json,
        :target => model.target.as_json
      }
    end

    it "should only support :enemy mode" do
      model = Factory.create :route
      model.as_json(:mode => :enemy).should == {
        :id => model.id,
        :player => Player.minimal(model.player_id),
        :current => model.current.as_json,
        :jumps_at => model.jumps_at,
      }
    end
  end
end