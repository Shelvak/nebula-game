require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

def path(description)
  Path.new(description)
end

describe SpaceMule do
  before(:all) do
    # Ensure we're not testing against randomness: leave only one map of
    # each type.
    @old_maps = CONFIG.filter(/^(solar_system|planet)\.map\./)
    @old_maps.each { |key, map_set| CONFIG[key] = [map_set[0]] }

    @mule = SpaceMule.instance
  end

  before(:each) do
    break_transaction
  end

  after(:all) do
    @old_maps.each { |key, map_set| CONFIG[key] = map_set }
  end

  describe "#fill_galaxy" do
    let(:galaxy) { Factory.create(:galaxy) }
    let(:free_zones) { 2 }
    let(:free_home_ss) { 2 }

    before(:all) do
      @launch_time = Time.now
      @mule.fill_galaxy(galaxy, free_zones, free_home_ss)
    end

    describe "battleground ss" do
      before(:all) do
        @ss = galaxy.solar_systems.
          where(x: nil, y: nil, kind: SolarSystem::KIND_BATTLEGROUND).first
        @solar_systems = [@ss]
      end

      it "should create battleground ss" do
        @ss.should_not be_nil
      end
      
      it "should have its kind set" do
        @ss.kind.should == SolarSystem::KIND_BATTLEGROUND
      end

      it "should be created from static configuration" do
        @ss.should be_created_from_static_ss_configuration(
                     CONFIG['solar_system.map.battleground'][0]['map'],
                     @launch_time
                   )
      end

      it "should register callback for spawn" do
        @ss.should have_callback(
          CallbackManager::EVENT_SPAWN, @launch_time
        )
      end
    end

    describe "wormholes" do
      before(:all) do
        @wormholes = SolarSystem.where(
          :galaxy_id => galaxy.id,
          :kind => SolarSystem::KIND_WORMHOLE
        )
      end

      it "should create wormholes in area" do
        @wormholes.
          should have_correct_relative_coordinates('galaxy.wormholes.positions')
      end

      it "should not register spawn callback" do
        @wormholes.each do |wormhole|
          wormhole.should_not have_callback(CallbackManager::EVENT_SPAWN)
        end
      end
    end

    describe "mini battlegrounds" do
      before(:all) do
        @pulsars = SolarSystem.
          where("x IS NOT NULL AND y IS NOT NULL").
          where(
            :galaxy_id => galaxy.id,
            :kind => SolarSystem::KIND_BATTLEGROUND
          )
      end

      it "should create them in area" do
        @pulsars.should have_correct_relative_coordinates(
                          'galaxy.mini_battlegrounds.positions'
                        )
      end

      it "should have spawn callbacks registered" do
        @pulsars.each do |pulsar|
          pulsar.
            should have_callback(CallbackManager::EVENT_SPAWN, @launch_time)
        end
      end

      it "should be created from static configuration" do
        @pulsars.each do |pulsar|
          pulsar.should be_created_from_static_ss_configuration(
                       CONFIG['solar_system.map.pulsar'][0]['map'],
                       @launch_time
                     )
        end
      end
    end

    describe "home solar systems" do
      let(:condition) do
        SolarSystem.where(galaxy_id: galaxy.id, kind: SolarSystem::KIND_POOLED)
      end

      before(:all) do
        @solar_systems = condition.all
      end

      it "should create pooled home ss" do
        condition.count.should == free_home_ss
      end

      it "should register callback for spawn" do
        @solar_systems.each do |solar_system|
          solar_system.should have_callback(
            CallbackManager::EVENT_SPAWN, @launch_time
          )
        end
      end

      it "should be created from static configuration" do
        @solar_systems.each do |solar_system|
          solar_system.should be_created_from_static_ss_configuration(
            CONFIG['solar_system.map.home'][0]['map'],
            @launch_time
          )
        end
      end
    end

    describe "free solar systems" do
      before(:all) do
        @solar_systems = SolarSystem.where(
          :galaxy_id => galaxy.id, :kind => SolarSystem::KIND_NORMAL
        ).where("player_id IS NULL").all
      end

      it "should create them in area" do
        @solar_systems.should have_correct_relative_coordinates(
                          'galaxy.free_systems.positions'
                        )
      end

      it "should register callback for spawn" do
        @solar_systems.each do |ss|
          ss.should have_callback(CallbackManager::EVENT_SPAWN, @launch_time)
        end
      end

      it "should be created from static configuration" do
        @solar_systems.each do |ss|
          ss.should be_created_from_static_ss_configuration(
                      CONFIG['solar_system.map.free'][0]['map'],
                      @launch_time
                    )
        end
      end
    end

    describe "in planets" do
      before(:all) do
        ss_ids = SolarSystem.where(:galaxy_id => galaxy.id).map(&:id)
        @planets = @models =
          SsObject::Planet.where(:solar_system_id => ss_ids).all
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

      it "should have #next_raid_at set" do
        @planets.map(&:next_raid_at).should_not include(nil)
      end

      it "should have callbacks registered for #next_raid_at" do
        @planets.each do |planet|
          planet.should have_callback(
            CallbackManager::EVENT_RAID, planet.next_raid_at
          )
        end
      end
    end

  end

  describe "#ensure_pool & #pool_stats" do
    let(:galaxy) do
      Factory.create(:galaxy, pool_free_zones: 3, pool_free_home_ss: 5)
    end

    it "should ensure that pool is regenerated (with iteration limits)" do
      result = lambda do
        res = @mule.pool_stats(galaxy.id)
        [res.free_zones, res.free_home_ss]
      end

      lambda do
        @mule.ensure_pool(galaxy, 1, 1)
      end.should change(result, :call).from([0, 0]).to([1, 1])

      lambda do
        @mule.ensure_pool(galaxy, 10, 10)
      end.should change(result, :call).from([1, 1]).to([3, 5])
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
        from(1,0).through(1,315, 1,270, 1,225).to(1,180)
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
      # 0000980: Wrong route path calculation
      # http://bt.nebula44.com/view.php?id=980
      path("jump from galaxy directly to ss jg if target is the same jg").
        galaxy(galaxy) { from(ss3) }.
        solar_system(ss3) { to(ss3_jg1) }.
        avoiding_npc,

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