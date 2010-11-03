require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

def create_planet(player)
  planet = Factory.create(:planet, :player => player)
  Factory.create(:tile, :planet => planet)
  Factory.create(:folliage, :planet => planet)
  Factory.create(:building, :planet => planet)
  Factory.create(:unit, :location => planet, :player => player)

  planet
end

describe "visible planet", :shared => true do
  it "should set currently viewed planet" do
    @controller.current_planet_id.should == @planet.id
  end

  it "should set currently viewed solar system id" do
    @controller.current_ss_id.should == @planet.solar_system_id
  end

  it "should include tiles" do
    response_should_include(
      :tiles => Tile.fast_find_all_for_planet(@planet)
    )
  end

  it "should include folliages" do
    response_should_include(
      :folliages => Folliage.fast_find_all_for_planet(@planet)
    )
  end

  it "should include buildings" do
    response_should_include(:buildings => @planet.buildings)
  end

  it "should include units" do
    response_should_include(
      :units => StatusResolver.new(player).resolve_objects(@planet.units)
    )
  end
end

describe PlanetsController do
  include ControllerSpecHelper

  before(:each) do
    init_controller PlanetsController, :login => true
  end

  describe "planets|show" do
    before(:each) do
      @action = "planets|show"
    end

    it "should not allow player to view it if not in observable list" do
      planet = Factory.create :planet
      SsObject::Planet.stub!(:find).with(planet.id).and_return(planet)
      planet.stub!(:observer_player_ids).and_return([])
      lambda do
        invoke @action, 'id' => planet.id
      end.should raise_error(GameLogicError)
    end

    describe "visible planet (without resources)" do
      before(:each) do
        @enemy = Factory.create(:player)
        @planet = create_planet(@enemy)
        SsObject::Planet.stub!(:find).with(@planet.id).and_return(@planet)
        @planet.stub!(:can_view_resources?).with(player.id).and_return(false)
        Factory.create(:unit, :location => @planet, :player => player)
        @params = {'id' => @planet.id}
        invoke @action, @params
      end

      it_should_behave_like "visible planet"

      it "should include planet without resources" do
        response_should_include(
          :planet => @planet.as_json(:resources => false, :view => true)
        )
      end
    end

    describe "visible planet (with resources)" do
      before(:each) do
        @planet = create_planet(player)
        SsObject::Planet.stub!(:find).with(@planet.id).and_return(@planet)
        @planet.stub!(:can_view_resources?).with(player.id).and_return(true)
        @params = {'id' => @planet.id}
        invoke @action, @params
      end

      it_should_behave_like "visible planet"

      it "should include planet with resources" do
        response_should_include(
          :planet => @planet.as_json(:resources => true, :view => true)
        )
      end
    end
  end

  describe "planets|player_index" do
    before(:each) do
      @action = "planets|player_index"
      @params = {}
    end

    it_should_behave_like "only push"

    it "should return players planets" do
      planet0 = Factory.create :planet_with_player
      planet1 = Factory.create :planet_with_player,
        :player => player
      planet2 = Factory.create :planet_with_player,
        :player => player
      planet3 = Factory.create :planet_with_player

      should_respond_with :planets => [planet1, planet2].map do |planet|
        planet.as_json(:resources => true)
      end
      push @action, @params
    end
  end
end