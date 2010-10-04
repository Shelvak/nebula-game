require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Route do
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
    Route.reflections[:units].options[:dependent].should == :nullify
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
    before(:each) do
      @build = lambda { Factory.build(:route) }
      @change = lambda do |model|
        model.arrives_at += 1.minute
      end
    end

    @should_not_notify_create = true
    it_should_behave_like "notifier"
  end

  describe "#as_json" do
    it "should return Hash" do
      model = Factory.create :route
      model.as_json.should == {
        :id => model.id,
        :player_id => model.player_id,
        :cached_units => model.cached_units,
        :arrives_at => model.arrives_at,
        :source => model.source.as_json,
        :current => model.current.as_json,
        :target => model.target.as_json
      }
    end

    it "should only return id, player_id and current if mode is :enemy" do
      model = Factory.create :route
      model.as_json(:mode => :enemy).should == {
        :id => model.id,
        :player_id => model.player_id,
        :current => model.current.as_json,
      }
    end

    it_should_behave_like "to json"
  end
end