require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

def path(description)
  Path.new(description)
end

shared_examples_for "adding new solar systems" do
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

shared_examples_for "with orbit units" do
  it "should have correct number of planet orbit units" do
    @solar_systems.each do |solar_system|
      (@planets || solar_system.planets).each do |planet|
        planet.solar_system_point.should have_correct_unit_count(
          "ss_object.#{@type}.orbit.planet.units"
        )
      end
    end
  end

  it "should have correct number of asteroid orbit units" do
    @solar_systems.each do |solar_system|
      solar_system.asteroids.each do |asteroid|
        asteroid.solar_system_point.should have_correct_unit_count(
          "ss_object.#{@type}.orbit.asteroid.units",
          "ss_object.#{@type}.orbit.rich_asteroid.units"
        )
      end
    end
  end

  it "should have correct number of jumpgate orbit units" do
    @solar_systems.each do |solar_system|
      solar_system.jumpgates.each do |jumpgate|
        jumpgate.solar_system_point.should have_correct_unit_count(
          "ss_object.#{@type}.orbit.jumpgate.units"
        )
      end
    end
  end
end

shared_examples_for "with planet units" do
  it "should have correct number of planet ground units" do
    @solar_systems.each do |solar_system|
      (@planets || solar_system.planets).each do |planet|
        planet.should have_correct_unit_count(
          "ss_object.#{@type}.planet.units"
        )
      end
    end
  end
end

describe SpaceMule do
  before(:all) do
    @mule = SpaceMule.instance
  end

  describe "#create_galaxy" do
    before(:all) do
      @galaxy_id = @mule.create_galaxy("default", "localhost")
      @galaxy = Galaxy.find(@galaxy_id)
    end

    it "should return id" do
      @galaxy_id.should == Galaxy.maximum(:id)
    end

    describe "new galaxy" do
      it "should create a new galaxy" do
        @galaxy.should_not be_nil
      end

      it "should have ruleset set" do
        @galaxy.ruleset.should == "default"
      end
      
      it "should have callback url set" do
        @galaxy.callback_url.should == "localhost"
      end

      it "should have created_at set" do
        @galaxy.created_at.should be_within(10.seconds).of(Time.now)
      end
    end

    describe "battleground ss" do
      before(:all) do
        @ss = @galaxy.solar_systems.where(:x => nil, :y => nil).first
        @solar_systems = [@ss]
        @type = 'battleground'
      end

      it "should create battleground ss" do
        @ss.should_not be_nil
      end
      
      it "should have its kind set" do
        @ss.kind.should == SolarSystem::KIND_BATTLEGROUND
      end

      it "should create battleground jumpgates" do
        @ss.jumpgates.count.should == CONFIG[
          "solar_system.battleground.jumpgate.positions"].size
      end

      it "should create battleground planets" do
        @ss.planets.count.should == CONFIG[
          "solar_system.battleground.planet.positions"].size
      end

      it "should not create any asteroids" do
        (
          @ss.ss_objects.count - @ss.jumpgates.count - @ss.planets.count
        ).should == 0
      end

      describe "battleground planets" do
        %w{metal energy zetium}.each do |resource|
          it "should have storage" do
            @ss.planets.each do |planet|
              planet.send("#{resource}_storage").should ==
                CONFIG["battleground.planet.#{resource}.storage"]
            end
          end
        end
      end
      
      it_should_behave_like "with planet units"
      it_should_behave_like "with orbit units"
    end
  
    it "should have spawn callback for first convoy" do
      @galaxy.should have_callback(CallbackManager::EVENT_SPAWN,
        CONFIG.evalproperty('galaxy.convoy.time').from_now)
    end
    
    MarketOffer::CALLBACK_MAPPINGS.each do |kind, event|
      it "should have spawn callback for resource kind #{kind}" do
        seconds_range = Cfg.market_bot_resource_cooldown_range
        range = (seconds_range.first.from_now..seconds_range.last.from_now)
        @galaxy.should have_callback(event, range)
      end
    end
  end

  describe "#create_players" do
    before(:all) do
      @quest = Factory.create(:quest)
      @objective = Factory.create(:objective, :quest => @quest)
      # Restart space mule to load new quests.
      SpaceMule.instance.restart!

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
        "jkghuitughihui78t67g78b87bd43fdgwejedfvewfwevds" => "Some player"
      }
      @player_id = (Player.maximum(:id) || 0) + 1
      @result = @mule.create_players(@galaxy.id, @galaxy.ruleset, @players)
      @player = Player.find(@player_id)
    end

    it "should start quests for player" do
      QuestProgress.where(:player_id => @player_id,
        :quest_id => @quest.id, :completed => 0).count.should == 1
    end

    it "should start objectives for player" do
      ObjectiveProgress.where(:player_id => @player_id,
        :objective_id => @objective.id, :completed => 0).count.should == 1
    end

    describe "player attributes" do
      before(:all) do
        @player = Player.find(@player_id)
      end

      it "should set scientists" do
        @player.scientists.should ==
          CONFIG["buildings.mothership.scientists"].to_i
      end

      it "should set scientists_total" do
        @player.scientists_total.should == @player.scientists
      end

      it "should set population_max" do
        @player.population_max.should ==
          CONFIG["galaxy.player.population"] +
          CONFIG["buildings.mothership.population"]
      end
    end

    it "should create homeworld for player" do
      SsObject::Planet.where(:player_id => @player_id).count.should == 1
    end

    it "should not create other homeworld if we try that again" do
      player_count = Player.count
      @mule.create_players(@galaxy.id, @galaxy.ruleset, @players)
      Player.count.should == player_count
    end

    it "should register callbacks for asteroids" do
      @mule.create_players(@galaxy.id, @galaxy.ruleset, @players)
      SsObject::Asteroid.where(
        :solar_system_id => @galaxy.solar_systems.map(&:id)
      ).each do |asteroid|
        asteroid.should have_callback(CallbackManager::EVENT_SPAWN,
          CONFIG.evalproperty('ss_object.asteroid.wreckage.time.first').
            from_now)
      end
    end

    describe "home solar system" do
      before(:all) do
        @ss = SsObject::Planet.where(:player_id => @player_id
          ).first.solar_system
      end

      it "should be shielded" do
        @ss.should have_shield
      end

      it "should have correct shield owner" do
        @ss.shield_owner_id.should == @player_id
      end

      it "should have correct shield time" do
        @ss.shield_ends_at.should be_within(10).of(
          CONFIG.evalproperty('galaxy.player.shield_duration').
            seconds.from_now
        )
      end

      it "should not have any other shielded ss" do
        SolarSystem.where(
          ["galaxy_id=? AND id!=?", @ss.galaxy_id, @ss.id]
        ).all.each do |ss|
          ss.should_not have_shield
        end
      end

      it "should create other planets in that ss with specified area" do
        @ss.planets.where(:player_id => nil).each do |planet|
          (planet.width + planet.height).should == CONFIG[
            'planet.home_system.area']
        end
      end

      it "should register callback for inactivity check" do
        @ss.should have_callback(
          CallbackManager::EVENT_CHECK_INACTIVE_PLAYER,
          CONFIG.evalproperty('galaxy.player.inactivity_check').from_now)
      end
    end

    it "should create wormholes in area" do
      @mule.create_players(@galaxy.id, @galaxy.ruleset, @players)
      SolarSystem.where(:galaxy_id => @galaxy.id, 
        :kind => SolarSystem::KIND_WORMHOLE
      ).count.should == CONFIG['galaxy.wormholes.positions'].count
    end
    
    it "should create mini battlegrounds in area" do
      @mule.create_players(@galaxy.id, @galaxy.ruleset, @players)
      SolarSystem.where(:galaxy_id => @galaxy.id, 
        :kind => SolarSystem::KIND_BATTLEGROUND
      ).count.should == CONFIG['galaxy.mini_battlegrounds.positions'].count
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

      it "should not place any folliages on buildings" do
        @planets.each do |planet|
          planet.should_not have_folliages_on(Building)
        end
      end

      it "should have all player buildings activated" do
        @planets.each do |planet|
          planet.buildings.each do |building|
            building.should be_active unless building.npc?
          end
        end
      end

      it "should not have any empty npc buildings" do
        @planets.each do |planet|
          planet.should_not have_blank_npc_buildings
        end
      end

      describe "homeworld" do
        before(:all) do
          @homeworld = SsObject::Planet.where(
            :player_id => @player_id).first
        end
        
        it "should set #owner_changed" do
          @homeworld.owner_changed.
            should be_within(SPEC_TIME_PRECISION).of(Time.now)
        end
        
        describe "resources" do
          it "should set last_resources_update" do
            @homeworld.last_resources_update.should_not be_nil
          end

          %w{metal energy zetium}.each do |resource|
            [
              ["starting", ""],
              ["generate", "_rate"],
              ["store", "_storage"]
            ].each do |config_name, attr_name|
              it "should set #{resource} #{config_name}" do
                @homeworld.send("#{resource}#{attr_name}").should be_within(
                  0.5).of(
                    CONFIG.evalproperty(
                      "buildings.mothership.#{resource}.#{config_name}"
                    )
                  )
              end
            end
          end
        end
      end
    end

    describe "units" do
      describe "home solar system" do
        before(:each) do
          @homeworld = SsObject::Planet.where(:player_id => @player_id).
            first
          @ss = @homeworld.solar_system
          @solar_systems = [@ss]
          @type = 'homeworld'
        end
        
        it_should_behave_like "with planet units"

        describe "orbit units" do
          before(:each) do
            @planets = @ss.planets - [@homeworld]
          end
          
          it "should not have any units in homeworld orbit" do
            Unit.in_location(@homeworld.solar_system_point).size.should == 0
          end
          
          it_should_behave_like "with orbit units"
        end
      end
        
      describe "regular solar systems" do
        before(:each) do
          homeworld_ss_id = SsObject::Planet.
            where(:player_id => @player_id).first.solar_system_id
          @solar_systems = SolarSystem.where(
            "galaxy_id=? AND kind=? AND id!=?", 
            @galaxy.id, SolarSystem::KIND_NORMAL, homeworld_ss_id
          )
          @type = 'regular'
        end
        
        it_should_behave_like "with planet units"
        it_should_behave_like "with orbit units"
      end
      
      describe "mini battleground solar systems" do
        before(:each) do
          homeworld_ss_id = SsObject::Planet.
            where(:player_id => @player_id).first.solar_system_id
          @solar_systems = SolarSystem.where(
            "galaxy_id=? AND kind=? AND x IS NOT NULL AND y IS NOT NULL", 
            @galaxy.id, SolarSystem::KIND_BATTLEGROUND
          )
          @type = 'battleground'
        end
        
        it_should_behave_like "with planet units"
        it_should_behave_like "with orbit units"
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
    galaxy = Factory.create(:galaxy)
    ss1 = Factory.create(:solar_system, :galaxy => galaxy,
      :x => 1, :y => 0)
    ss2 = Factory.create(:solar_system, :galaxy => galaxy,
      :x => -2, :y => 2)
    ss3 = Factory.create(:solar_system, :galaxy => galaxy,
      :x => -4, :y => 2)
    wh = Factory.create(:wormhole, :galaxy => galaxy,
      :x => 1, :y => 3)
    bg = Factory.create(:battleground, :galaxy => galaxy,
      :x => nil, :y => nil)
    jg1 = Factory.create(:sso_jumpgate, :solar_system => ss1,
      :position => 2, :angle => 0)
    jg1_1 = Factory.create(:sso_jumpgate, :solar_system => ss1,
      :position => 2, :angle => 180)
    p1 = Factory.create(:planet, :solar_system => ss1,
      :position => 0, :angle => 0)
    jg2 = Factory.create(:sso_jumpgate, :solar_system => ss2,
      :position => 0, :angle => 0)

    ss3_jg1 = Factory.create(:sso_jumpgate, :solar_system => ss3,
      :position => 0, :angle => 0)
    ss3_jg2 = Factory.create(:sso_jumpgate, :solar_system => ss3,
      :position => 3, :angle => 180)

    bgjg = Factory.create(:sso_jumpgate, :solar_system => bg,
      :position => 0, :angle => 0)
    p2 = Factory.create(:planet, :solar_system => ss2,
      :position => 2, :angle => 0)
    # Some units to avoid.
    unit = Factory.create(:u_dirac, :player => nil,
      :location => SolarSystemPoint.new(ss1.id, 1, 0))
    p1_unit = Factory.create(:u_dirac, :player => nil,
      :location => p1.solar_system_point)
    p2_unit = Factory.create(:u_dirac, :player => nil,
      :location => p2.solar_system_point)
    ss3_jg_unit = Factory.create(:u_dirac, :player => nil,
      :location => ss3_jg1.solar_system_point)
    # Bad boys company which surrounds 0,0 point
    [[1,0], [0,90], [0,270], [1,45], [1,315]].each do |x, y|
      Factory.create(:u_dirac, :player => nil,
        :location => SolarSystemPoint.new(ss3.id, x, y))
    end


    [
      ### Galaxy

      # Straight lines
      path("galaxy right").galaxy(galaxy) do
        from(0,0).through(1,0, 2,0).to(3,0)
      end,
      path("galaxy left").galaxy(galaxy) do
        from(0,0).through(-1,0, -2,0).to(-3,0)
      end,
      path("galaxy top").galaxy(galaxy) do
        from(0,0).through(0,1, 0,2).to(0,3)
      end,
      path("galaxy bottom").galaxy(galaxy) do
        from(0,0).through(0,-1, 0,-2).to(0,-3)
      end,
      # Diagonal lines
      path("galaxy top-right").galaxy(galaxy) do
        from(0,0).through(1,1, 2,2).to(3,3)
      end,
      path("galaxy bottom-left").galaxy(galaxy) do
        from(0,0).through(-1,-1, -2,-2).to(-3,-3)
      end,
      path("galaxy top-left").galaxy(galaxy) do
        from(0,0).through(-1,1, -2,2).to(-3,3)
      end,
      path("galaxy bottom-right").galaxy(galaxy) do
        from(0,0).through(1,-1, 2,-2).to(3,-3)
      end,
      # Bent lines
      path("galaxy top-right right").galaxy(galaxy) do
        from(0,0).through(1,1, 2,2, 3,2).to(4,2)
      end,
      path("galaxy top-right up").galaxy(galaxy) do
        from(0,0).through(1,1, 2,2, 2,3).to(2,4)
      end,
      path("galaxy bottom-left left").galaxy(galaxy) do
        from(0,0).through(-1,0, -2,0, -3,-1).to(-4,-2)
      end,
      path("galaxy bottom-left down").galaxy(galaxy) do
        from(0,0).through(0,-1, 0,-2, -1,-3).to(-2,-4)
      end,
      path("galaxy top-left left").galaxy(galaxy) do
        from(0,0).through(-1,0, -2,0, -3,1).to(-4,2)
      end,
      path("galaxy top-left up").galaxy(galaxy) do
        from(0,0).through(0,1, 0,2, -1,3).to(-2,4)
      end,
      path("galaxy bottom-right right").galaxy(galaxy) do
        from(0,0).through(1,-1, 2,-2, 3, -2).to(4,-2)
      end,
      path("galaxy bottom-right down").galaxy(galaxy) do
        from(0,0).through(1,-1, 2,-2, 2,-3).to(2,-4)
      end,

      ### Solar system

      path("solar system straight line right").solar_system(ss1) do
        from(0,0).through(1,0, 2,0).to(3,0)
      end,
      path("solar system other side of circle").solar_system(ss1) do
        from(0,0).through(0,90).to(0,180)
      end,
      path("solar system other side of circle 2").solar_system(ss1) do
        from(1,0).through(0,0, 0,90, 0,180).to(1,180)
      end,
      path("solar system perpendicular ccw").solar_system(ss1) do
        from(1,0).through(1,45).to(1,90)
      end,
      path("solar system perpendicular cw").solar_system(ss1) do
        from(1,0).through(1,315).to(1,270)
      end,

      ### Solar system with NPC avoiding
      path("avoid flying through npc units").avoiding_npc.
      solar_system(ss1) { from(0,0).to(3,0) }.
      should do
        @actual_path.should_not include_points(Location::SOLAR_SYSTEM,
          unit.location.x, unit.location.y)
      end,
      path("avoid flying through nearest jumpgate with npc if there is " +
          "other one without them and we are avoiding npc").
        avoiding_npc.
        solar_system(ss3) { from(ss3_jg1.position + 1, ss3_jg1.angle) }.
        galaxy(galaxy) { to(ss3) }.
        should do
          @actual_path.should_not include_points(Location::SOLAR_SYSTEM,
            ss3_jg1)
          @actual_path.should include_points(Location::SOLAR_SYSTEM,
            ss3_jg2)
        end,
      path("fly through npc units if they are on source ssobj orbit " +
        "but still avoid other npc units").
      avoiding_npc.
      planet(p1).
      solar_system(ss1) { from(p1).to(3,0) }.
      should do
        @actual_path.should include_points(Location::SOLAR_SYSTEM,
          p1_unit.location.x, p1_unit.location.y)
        @actual_path.should_not include_points(Location::SOLAR_SYSTEM,
          unit.location.x, unit.location.y)
      end,
      path("fly through npc units if they are on target ssobj orbit " +
        "but still avoid other npc units").
      avoiding_npc.
      solar_system(ss1) { from(3,0).to(p1) }.
      planet(p1).
      should do
        @actual_path.should include_points(Location::SOLAR_SYSTEM,
          p1_unit.location.x, p1_unit.location.y)
        @actual_path.should_not include_points(Location::SOLAR_SYSTEM,
          unit.location.x, unit.location.y)
      end,
      path("fly through npc units if they are on target " +
        "but still avoid other npc units").avoiding_npc.
      solar_system(ss1) { from(3, 0).to(p1_unit) }.
      should do
        @actual_path.should_not include_points(Location::SOLAR_SYSTEM,
          unit.location.x, unit.location.y)
        @actual_path.should include_points(Location::SOLAR_SYSTEM,
          p1_unit.location.x, p1_unit.location.y)
      end,
      path("fly through npc units if there is no other way").avoiding_npc.
      solar_system(ss3) { from(0, 0).through(1,0, 2,0).to(3, 0) },

      ### Planet

      path("landing to planet").solar_system(ss1) do
        from(1,0).to(0,0)
      end.planet(p1),
      path("lifting off from planet").planet(p1).solar_system(ss1) do
        from(0,0).to(1,0)
      end,

      ### Complex

      path("planet to planet").planet(p1).
        solar_system(ss1) { from(p1).through(1,0).to(jg1) }.
        galaxy(galaxy) { from(ss1).through(0,0, -1,1).to(ss2) }.
        solar_system(ss2) { from(jg2).through(1,0).to(p2) }.
        planet(p2),
      path("selecting nearest JG").
        solar_system(ss1) { from(0,180).through(1,180).to(jg1_1) }.
        galaxy(galaxy) { from(ss1).to(1,1) },

      ## Battleground

      path("planet to battleground").planet(p1).
        solar_system(ss1) { from(0,0).through(1,0).to(2,0) }.
        galaxy(galaxy) { from(ss1).through(1,1, 1,2).to(wh) }.
        solar_system(bg) { from(0,0).through(1,0).to(2,0) },
      path("battleground to planet").
        solar_system(bg) { from(2,0).through(1,0).to(0,0) }.
        galaxy(galaxy) { from(wh).through(1,2, 1,1).to(ss1) }.
        solar_system(ss1) { from(2,0).through(1,0).to(0,0) }.
        planet(p1),

    ].each do |path|
      if path.has_custom_matcher?
        it "should #{path.description}" do
          @actual_path = @mule.find_path(
            path.source, path.target, path.avoid_npc
          )
          instance_eval(&path.matcher)
        end
      else
        it "should find #{path.description}" do
          @mule.find_path(
            path.source, path.target, path.avoid_npc
          ).should be_path(path.forward)
        end

        it "should go in same path if reversed for #{path.description}" do
          @mule.find_path(
            path.target, path.source, path.avoid_npc
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
        it "should find path for #{description}" do
          path = @mule.find_path(location1, location2)
          path.should be_instance_of(Array)
          path.should_not be_blank
        end
      end
    end
  end
end