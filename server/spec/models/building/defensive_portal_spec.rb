require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Building::DefensivePortal do
  describe ".pick_units" do
    before(:each) do
      @planets = [
        Factory.create(:planet),
        Factory.create(:planet)
      ]
      @units = [
        Factory.create(:u_gnat, :location => @planets[0]),
        Factory.create(:u_gnat, :location => @planets[0]),
        Factory.create(:u_gnat, :location => @planets[0]),
        Factory.create(:u_gnat, :location => @planets[1]),
        Factory.create(:u_gnat, :location => @planets[1]),
      ]
    end

    it "should not take units from other planets" do
      planet = Factory.create(:planet)
      unit = Factory.create(:u_gnat, :location => planet)
      Building::DefensivePortal.pick_units(
        @planets.map(&:id), 10000).should_not include(unit)
    end

    it "should not go overboard" do
      volume = @units[0].volume + 1
      Building::DefensivePortal.pick_units(
        @planets.map(&:id), volume).map(&:volume).sum.should <= volume
    end

    it "should not fail if we have less units than volume" do
      units_volume = @units.map(&:volume).sum
      volume = units_volume * 3
      Building::DefensivePortal.pick_units(
        @planets.map(&:id), volume).map(&:volume).sum.should == units_volume
    end
  end
end