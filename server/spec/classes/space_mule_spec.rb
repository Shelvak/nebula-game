require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

def from(x, y)
  Path.new(x, y)
end

describe "adding new solar systems", :shared => true do
  it "should add homeworld solar system" do
    FowSsEntry.where(@conditions).map do |fse|
      {
        :player_planets => fse.player_planets,
        :player_ships => fse.player_ships,
        :enemy_planets => fse.enemy_planets,
        :enemy_ships => fse.enemy_ships,
      }
    end.should include(
      :player_planets => false,
      :player_ships => false,
      :enemy_planets => true,
      :enemy_ships => false
    )
  end

  it "should add regular solar systems" do
    FowSsEntry.where(@conditions).map do |fse|
      {
        :player_planets => fse.player_planets,
        :player_ships => fse.player_ships,
        :enemy_planets => fse.enemy_planets,
        :enemy_ships => fse.enemy_ships,
      }
    end.should include(
      :player_planets => false,
      :player_ships => false,
      :enemy_planets => false,
      :enemy_ships => false
    )
  end
end

describe SpaceMule do
  before(:all) do
    @mule = SpaceMule.instance
  end

  describe "#create_players" do
    before(:all) do
      @galaxy = Factory.create(:galaxy)
      diameter = CONFIG['galaxy.zone.diameter']
      rectangle = Rectangle.new(
        -diameter, -diameter, diameter, diameter
      )
      @player_fge = Factory.create(:fge_player, :rectangle => rectangle,
        :galaxy => @galaxy)
      @alliance_fge = Factory.create(:fge_alliance, :rectangle => rectangle,
        :galaxy => @galaxy)
      @players = {
        "Some player \t \n \\t \\n lol" => "Some player \t \n \\t \\n lol",
      }
      @player_id = (Player.maximum(:id) || 0) + 1
      @result = @mule.create_players(@galaxy.id, @galaxy.ruleset, @players)
    end

    it "should create homeworld SS for player" do
      SolarSystem::Homeworld.where(
        :galaxy_id => @galaxy.id
      ).count.should == 1
    end

    it "should create expansion SS for player" do
      SolarSystem::Expansion.where(
        :galaxy_id => @galaxy.id
      ).count.should == CONFIG['galaxy.expansion_systems.number']
    end

    it "should create resource SS for player" do
      SolarSystem::Resource.where(
        :galaxy_id => @galaxy.id
      ).count.should == CONFIG['galaxy.resource_systems.number']
    end

    it "should create homeworld for player" do
      SsObject::Planet.where(:player_id => @player_id).count.should == 1
    end

    describe "in planets" do
      before(:all) do
        ss_ids = SolarSystem.where(:galaxy_id => @galaxy.id).map(&:id)
        @planets = SsObject::Planet.where(:solar_system_id => ss_ids).all
      end

      it "should not place any tiles offmap" do
        @planets.each { |planet| planet.should_not have_offmap(Tile) }
      end

      it "should not place any folliages offmap" do
        @planets.each { |planet| planet.should_not have_offmap(Folliage) }
      end

      it "should not place any buildings offmap" do
        @planets.each { |planet| planet.should_not have_offmap(Building) }
      end
    end

    it "should create fow ss entry" do
      fse = FowSsEntry.where(:player_id => @player_id).first
      {
        :player_planets => fse.player_planets,
        :player_ships => fse.player_ships,
        :enemy_planets => fse.enemy_planets,
        :enemy_ships => fse.enemy_ships,
      }.should == {
        :player_planets => true,
        :player_ships => false,
        :enemy_planets => false,
        :enemy_ships => false,
      }
    end

    it "should only create one fow ss entry" do
      FowSsEntry.where(:player_id => @player_id).count.should == 1
    end

    describe "visibility for existing ss where radar covers it" do
      describe "player" do
        before(:each) do
          @conditions = {:player_id => @player_fge.player_id}
        end

        it_should_behave_like "adding new solar systems"
      end

      describe "alliance" do
        before(:each) do
          @conditions = {:alliance_id => @alliance_fge.alliance_id}
        end

        it_should_behave_like "adding new solar systems"
      end
    end
  end

  describe "#find_path" do
    describe "galaxy" do
      [
        # Straight lines
        from(0,0).through(1,0, 2,0).to(3,0).desc("right"),
        from(0,0).through(-1,0, -2,0).to(-3,0).desc("left"),
        from(0,0).through(0,1, 0,2).to(0,3).desc("top"),
        from(0,0).through(0,-1, 0,-2).to(0,-3).desc("bottom"),
        # Diagonal lines
        from(0,0).through(1,1, 2,2).to(3,3).desc("top-right"),
        from(0,0).through(-1,-1, -2,-2).to(-3,-3).desc("bottom-left"),
        from(0,0).through(-1,1, -2,2).to(-3,3).desc("top-left"),
        from(0,0).through(1,-1, 2,-2).to(3,-3).desc("bottom-right"),
        # Bent lines
        from(0,0).through(1,1, 2,2, 3,2).to(4,2).desc("top-right right"),
        from(0,0).through(1,1, 2,2, 2,3).to(2,4).desc("top-right up"),
        from(0,0).through(-1,0, -2,0, -3,-1).to(-4,-2).desc(
          "bottom-left left"),
        from(0,0).through(0,-1, 0,-2, -1,-3).to(-2,-4).desc(
          "bottom-left down"),
        from(0,0).through(-1,0, -2,0, -3,1).to(-4,2).desc(
          "top-left left"),
        from(0,0).through(0,1, 0,2, -1,3).to(-2,4).desc(
          "top-left up"),
        from(0,0).through(1,-1, 2,-2, 3, -2).to(4,-2).desc(
          "bottom-right right"),
        from(0,0).through(1,-1, 2,-2, 2,-3).to(2,-4).desc(
          "bottom-right down"),
      ].each do |path|
        it "should find #{path.description}" do
          @mule.find_path(
            path.source.galaxy_point,
            path.target.galaxy_point
          ).should be_path(path.forward)
        end

        it "should go in same path if reversed for #{path.description}" do
          @mule.find_path(
            path.target.galaxy_point,
            path.source.galaxy_point
          ).should be_path(path.backward)
        end
      end
    end

    describe "solar system" do
      before(:all) do
        @ss = Factory.create(:solar_system)
      end

      [
        from(0,0).through(1,0, 2,0).to(3,0).desc("straight line right"),
        from(0,0).through(0,90).to(0,180).desc("other side of circle"),
        from(1,0).through(0,0, 0,90, 0,180).to(1,180).desc(
          "other side of circle 2"),
        from(1,0).through(1,45).to(1,90).desc("perpendicular ccw"),
        from(1,0).through(1,315).to(1,270).desc("perpendicular cw"),
      ].each do |path|
        it "should find #{path.description}" do
          @mule.find_path(
            path.source.solar_system_point(@ss.id),
            path.target.solar_system_point(@ss.id)
          ).should be_path(path.forward)
        end

        it "should go in same path if reversed for #{path.description}" do
          @mule.find_path(
            path.target.solar_system_point(@ss.id),
            path.source.solar_system_point(@ss.id)
          ).should be_path(path.backward)
        end
      end
    end

    describe "all variations" do
      @galaxy = Factory.create :galaxy
      @gp1 = GalaxyPoint.new(@galaxy.id, 4, -2)
      @gp2 = GalaxyPoint.new(@galaxy.id, -3, 6)
      @ss1 = Factory.create :solar_system, :galaxy => @galaxy
      @sp1 = SolarSystemPoint.new(@ss1.id, 3, 270 + 22)
      @ss2 = Factory.create :solar_system, :galaxy => @galaxy,
        :x => 5, :y => 5
      @sp2 = SolarSystemPoint.new(@ss2.id, 2, 180 + 60)
      @p1 = Factory.create :planet, :solar_system => @ss1
      @jg1 = Factory.create :sso_jumpgate, :solar_system => @ss1,
        :position => 3, :angle => 90 + 22 * 3
      @p2 = Factory.create :planet, :solar_system => @ss2
      @jg2 = Factory.create :sso_jumpgate, :solar_system => @ss2,
        :position => 3, :angle => 180 + 22

      it "should raise GameLogicError if JG is not in same SS as source" do
        p1 = Factory.create(:planet)
        p2 = Factory.create(:planet)
        jg = Factory.create(:sso_jumpgate, :solar_system => p2.solar_system,
          :position => 3, :angle => 180 + 22)

        lambda do
          @mule.find_path(p1, p2, jg)
        end.should raise_error(GameLogicError)
      end

      # Through JG ant not
      [
        [nil, "no JG"],
        [@jg1, "via JG"]
      ].each do |jumpgate, jgdesc|
        [
          ["Planet->Planet", @p1, @p2],
          ["Planet->Solar system point (same ss)", @p1, @sp1],
          ["Planet->Solar system point", @p1, @sp2],
          ["Planet->Galaxy point", @p1, @gp1],
          ["Solar system point->Planet", @sp1, @p2],
          ["Solar system point->Solar system point", @sp1, @sp2],
          ["Solar system point->Galaxy point", @sp1, @gp1],
          ["Galaxy point->Planet", @gp1, @p2],
          ["Galaxy point->Solar system point", @gp1, @sp2],
          ["Galaxy point->Galaxy point", @gp1, @gp2],
        ].each do |description, location1, location2|
          it "should find path for #{description} (#{jgdesc})" do
            path = @mule.find_path(location1, location2, jumpgate)
            path.should be_instance_of(Array)
            path.should_not be_blank
          end
        end
      end
    end
  end
end