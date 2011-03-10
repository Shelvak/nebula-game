require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe Galaxy do
  describe ".battleground_id" do
    it "should return battleground id" do
      # other battleground in other galaxy.
      Factory.create(:solar_system, :x => nil, :y => nil)
      bg = Factory.create(:solar_system, :x => nil, :y => nil)
      Galaxy.battleground_id(bg.galaxy_id).should == bg.id
    end
  end

  describe ".units" do
    before(:all) do
      galaxy = Factory.create :galaxy
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
        :location => SolarSystemPoint.new(1, 0, 0)

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
      Factory.create(:fge_player, :galaxy => @galaxy,
        :player => @player, :rectangle => Rectangle.new(0, 0, 10, 10))
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

  describe "#by_coords" do
    it "should return solar system by x,y" do
      model = Factory.create :galaxy
      x = 250
      y = 300
      ss = Factory.create :solar_system, :galaxy => model, :x => x, :y => y
      model.by_coords(x, y).should == ss
    end
  end
end