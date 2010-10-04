require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe TilesGenerator do
  describe "regular" do
    before(:all) do
      @planet = Factory.create(:planet)
      TilesGenerator.invoke(@planet.solar_system.galaxy_id) do |generator|
        generator.create(@planet.id, 40, 40, 'regular')
      end
    end

    it "should generate tiles for planet" do
      Tile.fast_find_all_for_planet(@planet).size.should_not == 0
    end

    Tile::MAPPING.each do |kind, name|
      it "should have more than 0 of #{name} tiles" do
        @planet.tiles.count(:conditions => {:kind => kind}
          ).should be_greater_than(0)
      end
    end
  end

  it "should generate tiles for homeworld" do
    planet = Factory.create(:planet)
    TilesGenerator.invoke(planet.solar_system.galaxy_id) do |generator|
      generator.create_homeworlds([planet.id])
    end
    Tile.fast_find_all_for_planet(planet).size.should_not == 0
  end
end
