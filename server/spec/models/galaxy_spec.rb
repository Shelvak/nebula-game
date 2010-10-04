require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Galaxy do
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
        :location_type => Location::GALAXY,
        :location => GalaxyPoint.new(galaxy.id, 0, 0)
      @ally_unit_visible = Factory.create :u_mule, :player => ally,
        :location_type => Location::GALAXY,
        :location => GalaxyPoint.new(galaxy.id, 0, 0)
      @enemy_unit_visible = Factory.create :u_mule, :player => enemy,
        :location_type => Location::GALAXY,
        :location => GalaxyPoint.new(galaxy.id, 0, 0)
      @enemy_unit_invisible = Factory.create :u_mule, :player => enemy,
        :location_type => Location::GALAXY,
        :location => GalaxyPoint.new(galaxy.id, 0, 1)
      @your_unit_invisible = Factory.create :u_mule, :player => you,
        :location_type => Location::GALAXY,
        :location => GalaxyPoint.new(galaxy.id, 0, 1)
      @ally_unit_invisible = Factory.create :u_mule, :player => ally,
        :location_type => Location::GALAXY,
        :location => GalaxyPoint.new(galaxy.id, 0, 1)

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
  end

  describe "as a class" do
    describe "#homeworld_zone" do
      it "should return an Array of two ranges" do
        Galaxy.homeworld_zone(0, 0).should be_instance_of(Array)
        Galaxy.homeworld_zone(0, 0)[0].should be_instance_of(Range)
        Galaxy.homeworld_zone(0, 0)[1].should be_instance_of(Range)
      end
    end
  end

  describe "#assign_homeworld" do
    before(:all) do
      @player = Factory.build :player_with_galaxy
      @galaxy = @player.galaxy
      @player.stub!(:initialize_player).and_return(true)
      @player.save!
      @fge = Factory.create :fge_player, :rectangle => Rectangle.new(
        -100, -100, 100, 100
      ), :galaxy => @galaxy

      @homeworld = @player.galaxy.assign_homeworld(@player)
    end

    it "should assign homeworld to player" do
      @player.planets.reload
      @player.planets.size.should == 1
    end

    it "should not change level of the activated buildings" do
      @homeworld.buildings.map(&:level).uniq.should == [1]
    end

    it "should activate player controlled buildings" do
      @homeworld.buildings.reject(&:npc?).map(
        &:active?).should_not include(false)
    end

    [
      [SolarSystem::Expansion, :expansion_systems],
      [SolarSystem::Resource, :resource_systems]
    ].each do |klass, type|
      it "should create #{type} solar systems for player" do
        klass.count(
          :conditions => {:galaxy_id => @galaxy.id}
        ).should == CONFIG["galaxy.#{type}.number"]
      end
    end

    it "should join new solar systems to other players visibility" do

    end
  end

  describe "#by_coords" do
    it "should return solar system by x,y" do
      model = Factory.create :galaxy
      x = 250
      y = 300
      ss = Factory.create :ss_homeworld, :galaxy => model, :x => x, :y => y
      model.by_coords(x, y).should == ss
    end
  end
end