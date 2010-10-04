require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe SolarSystem::Homeworld do
  describe "non-empty" do
    before(:all) do
      @model = Factory.create(:ss_homeworld, :create_empty => false)
    end

    it "should have one homeworld" do
      @model.planets.find(:first, :conditions => ["type=?", "Homeworld"]).should_not be_nil
    end

    it "should have homeworld positioned randomly in range" do
      position = @model.homeworld_planet.position
      position.should be_in_config_range(
        'solar_system.homeworld.planets.home_position'
      )
    end
  end
end