require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Planet::Homeworld do
  it "should always return variation 0" do
    Planet::Homeworld.variation.should == 0
  end

  describe "creation" do
    before(:all) do
      @solar_system = Factory.create(:ss_homeworld)
      PlanetsGenerator.create_for_solar_system(:homeworld,
        @solar_system.id, @solar_system.galaxy_id
      )
      @model = Planet::Homeworld.find_by_solar_system_id(@solar_system.id)
    end

    it "should have dimensions from map" do
      width, height = Planet::Homeworld.get_dimensions(
        CONFIG['planet.homeworld.map']
      )
      [@model.width, @model.height].should eql([width, height])
    end

    it "should have mothership" do
      @model.buildings.find_by_type("Mothership").should_not be_nil
    end
  end
end