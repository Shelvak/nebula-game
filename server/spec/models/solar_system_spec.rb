require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe SolarSystem do
  describe "#as_json" do
    it_behaves_like "as json", Factory.create(:solar_system), nil,
                    %w{id x y kind},
                    %w{galaxy_id}

    describe "when belongs to player" do
      it "should have player => Player#minimal" do
        ss = Factory.create(:solar_system, :player => Factory.create(:player))
        ss.as_json["player"].should == Player.minimal(ss.player_id)
      end
    end

    describe "when does not belong to player" do
      it "should have player => nil" do
        ss = Factory.create(:solar_system)
        ss.as_json["player"].should be_nil
      end
    end
  end

  describe "#npc_unit_locations" do
    before(:all) do
      @ss = Factory.create(:solar_system)
      @npc1 = Factory.create(:u_dirac, :player => nil,
        :location => SolarSystemPoint.new(@ss.id, 0, 0))
      @npc2 = Factory.create(:u_crow, :player => nil,
        :location => SolarSystemPoint.new(@ss.id, 1, 0))
      @pc = Factory.create(:u_crow, :player => Factory.create(:player),
        :location => SolarSystemPoint.new(@ss.id, 2, 0))
      @results = @ss.npc_unit_locations
    end

    it "should include npc units" do
      @results.should include(@npc1.location)
    end

    it "should include abandoned units" do
      @results.should include(@npc2.location)
    end

    it "should not include controlled units" do
      @results.should_not include(@pc.location)
    end
  end

  describe "jumpgates" do    
    before(:all) do
      @ss = Factory.create(:solar_system)
      @gates = [
        Factory.create(:sso_jumpgate, :solar_system => @ss, :position => 7),
        Factory.create(:sso_jumpgate, :solar_system => @ss, :position => 1),
        Factory.create(:sso_jumpgate, :solar_system => @ss, :position => 4)
      ]
      Factory.create(:planet, :solar_system => @ss, :position => 5)
      Factory.create(:planet, :solar_system => @ss, :position => 2)
    end
  end

  describe "#orbit_count" do
    it "should return max planet position + 1" do
      @ss = Factory.create(:solar_system)
      Factory.create(:planet, :solar_system => @ss, :position => 7)
      @ss.orbit_count.should == 8
    end
  end

  describe "visibility methods" do
    describe ".find_if_viewable_for" do
      let(:alliance) { create_alliance }
      let(:player) { alliance.owner }
      let(:alliance_player) do
        Factory.create(:player, alliance: alliance, galaxy: alliance.galaxy)
      end
      let(:ss) { Factory.create(:solar_system, galaxy: alliance.galaxy) }

      it "should return SolarSystem if it's visible (player)" do
        Factory.create(:planet, solar_system: ss, player: player)
        SolarSystem.find_if_viewable_for(ss.id, player).should == ss
      end

      it "should return SolarSystem if it's visible (alliance)" do
        Factory.create(:planet, solar_system: ss, player: alliance_player)
        SolarSystem.find_if_viewable_for(ss.id, player).should == ss
      end

      describe "SolarSystem exists but is not visible" do
        it "should raise ActiveRecord::RecordNotFound" do
          lambda do
            SolarSystem.find_if_viewable_for(ss.id, player)
          end.should raise_error(ActiveRecord::RecordNotFound)
        end
      end

      describe "shielded ss" do
        it "should not allow viewing alliance player home ss" do
          ss_id = alliance_player.home_solar_system.id
          SolarSystem.stub(:visible?).with(ss_id, player.friendly_ids).
            and_return(true)
          lambda do
            SolarSystem.find_if_viewable_for(ss_id, player)
          end.should raise_error(ActiveRecord::RecordNotFound)
        end

        it "should allow viewing ss if player is shield owner" do
          ss_id = player.home_solar_system.id
          SolarSystem.stub(:visible?).with(ss_id, player.friendly_ids).
            and_return(true)
          lambda do
            SolarSystem.find_if_viewable_for(ss_id, player)
          end.should_not raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    describe ".visible_for" do
      let(:player) { Factory.create(:player) }
      let(:friendly_ids) { player.friendly_ids }
      let(:alliance_ids) { player.alliance_ids }
      let(:galaxy) { player.galaxy }
      let(:ss) { create_ss }
      let(:md) { create_md(ss) }

      def create_ss(x=0, y=0)
        Factory.create(:solar_system, galaxy: galaxy, x: x, y: y)
      end

      def create_md(*solar_systems)
        SolarSystem::Metadatas.new(solar_systems.map(&:id))
      end

      def ss_data(solar_system=ss, metadatas=md)
        {
          solar_system: solar_system,
          metadata: metadatas.for_existing(
            solar_system.id, player.id, friendly_ids, alliance_ids
          )
        }
      end

      it "should include solar systems covered by radars" do
        fge = Factory.create(:fge, galaxy: galaxy, player: player)
        ss = create_ss(fge.x, fge.y)
        md = create_md(ss)
        SolarSystem.visible_for(player).should include(ss_data(ss, md))
      end

      it "should not include solar systems not covered by radars" do
        fge = Factory.create(:fge, galaxy: galaxy)
        ss = create_ss(fge.x - 1, fge.y)
        md = create_md(ss)
        SolarSystem.visible_for(player).should_not include(ss_data(ss, md))
      end

      it "should not include solar systems covered by other player radars" do
        fge = Factory.create(:fge, galaxy: galaxy)
        ss = create_ss(fge.x, fge.y)
        md = create_md(ss)
        SolarSystem.visible_for(player).should_not include(ss_data(ss, md))
      end

      it "should include solar systems with player units inside" do
        Factory.create(
          :u_crow, player: player, location: SolarSystemPoint.new(ss.id, 0, 0)
        )
        SolarSystem.visible_for(player).should include(ss_data)
      end

      it "should not include solar systems without player units inside" do
        Factory.create(
          :u_crow, location: SolarSystemPoint.new(ss.id, 0, 0)
        )
        SolarSystem.visible_for(player).should_not include(ss_data)
      end

      it "should include solar systems with player planets" do
        Factory.create(:planet, solar_system: ss, player: player)
        SolarSystem.visible_for(player).should include(ss_data)
      end

      it "should not include solar systems without player planets" do
        Factory.create(:planet, solar_system: ss)
        SolarSystem.visible_for(player).should_not include(ss_data)
      end

      it "should include solar systems with player units inside planets" do
        planet = Factory.create(:planet, solar_system: ss)
        Factory.create(:u_trooper, player: player, location: planet)
        SolarSystem.visible_for(player).should include(ss_data)
      end

      it "should not include ss without player units inside planets" do
        planet = Factory.create(:planet, solar_system: ss)
        Factory.create(:u_trooper, location: planet)
        SolarSystem.visible_for(player).should_not include(ss_data)
      end
    end

    describe ".visible?" do
      let(:player) { Factory.create(:player) }
      let(:pids) { player.friendly_ids }
      let(:galaxy) { player.galaxy }
      let(:ss) { create_ss }

      def create_ss(x=0, y=0)
        Factory.create(:solar_system, galaxy: galaxy, x: x, y: y)
      end

      it "should return true for solar systems covered by radars" do
        fge = Factory.create(:fge, galaxy: galaxy, player: player)
        ss = create_ss(fge.x, fge.y)
        SolarSystem.visible?(ss.id, pids).should be_true
      end

      it "should return false for solar systems not covered by radars" do
        fge = Factory.create(:fge, galaxy: galaxy)
        ss = create_ss(fge.x - 1, fge.y)
        SolarSystem.visible?(ss.id, pids).should be_false
      end

      it "should return false for solar systems covered by other player radars" do
        fge = Factory.create(:fge, galaxy: galaxy)
        ss = create_ss(fge.x, fge.y)
        SolarSystem.visible?(ss.id, pids).should be_false
      end

      it "should return true for solar systems with player units inside" do
        Factory.create(
          :u_crow, player: player, location: SolarSystemPoint.new(ss.id, 0, 0)
        )
        SolarSystem.visible?(ss.id, pids).should be_true
      end

      it "should return false for solar systems without player units inside" do
        Factory.create(
          :u_crow, location: SolarSystemPoint.new(ss.id, 0, 0)
        )
        SolarSystem.visible?(ss.id, pids).should be_false
      end

      it "should return true for solar systems with player planets" do
        Factory.create(:planet, solar_system: ss, player: player)
        SolarSystem.visible?(ss.id, pids).should be_true
      end

      it "should return false for solar systems without player planets" do
        Factory.create(:planet, solar_system: ss)
        SolarSystem.visible?(ss.id, pids).should be_false
      end

      it "should return true for ss with player units inside planets" do
        planet = Factory.create(:planet, solar_system: ss)
        Factory.create(:u_trooper, player: player, location: planet)
        SolarSystem.visible?(ss.id, pids).should be_true
      end

      it "should return false for ss without player units inside planets" do
        planet = Factory.create(:planet, solar_system: ss)
        Factory.create(:u_trooper, location: planet)
        SolarSystem.visible?(ss.id, pids).should be_false
      end
    end

    describe ".observer_player_ids" do
      let(:alliance) { create_alliance }
      let(:galaxy) { alliance.galaxy }
      let(:player) { alliance.owner }
      let(:ally) do
        Factory.create(:player, alliance: alliance, galaxy: galaxy)
      end
      let(:id_arr) { [player.id, ally.id] }
      let(:id_set) { Set.new(id_arr) }
      let(:ss) { Factory.create(:solar_system, galaxy: galaxy) }

      before(:each) do
        player; ally
      end

      it "should take solar system or id" do
        Factory.create(:planet, solar_system: ss, player: player)
        SolarSystem.observer_player_ids(ss).
          should == SolarSystem.observer_player_ids(ss.id)
      end

      describe "FowGalaxyEntry" do
        describe "main battleground" do
          let(:ss) { Factory.create(:battleground, galaxy: galaxy) }

          it "should return player & alliance ids if player has fge" do
            Factory.create(:fge, galaxy: galaxy, player: player)
            Set.new(SolarSystem.observer_player_ids(ss) & id_arr).
              should == id_set
          end

          it "should return player & alliance ids if alliance has fge" do
            Factory.create(:fge, galaxy: galaxy, player: ally)
            Set.new(SolarSystem.observer_player_ids(ss) & id_arr).
              should == id_set
          end

          it "should not return player & alliance ids if there is no fge" do
            (SolarSystem.observer_player_ids(ss) & id_arr).should be_blank
          end
        end

        describe "regular SS" do
          it "should return player & alliance ids if player has fge" do
            Factory.create(:fge, galaxy: galaxy, player: player,
              x: ss.x, y: ss.y, x_end: ss.x + 1, y_end: ss.y + 1)
            Set.new(SolarSystem.observer_player_ids(ss) & id_arr).
              should == id_set
          end

          it "should return player & alliance ids if alliance has fge" do
            Factory.create(:fge, galaxy: galaxy, player: ally,
              x: ss.x, y: ss.y, x_end: ss.x + 1, y_end: ss.y + 1)
            Set.new(SolarSystem.observer_player_ids(ss) & id_arr).
              should == id_set
          end

          it "should not return player & alliance ids if there is no fge" do
            (SolarSystem.observer_player_ids(ss) & id_arr).should be_blank
          end

          it "should not return ids if fge does not cover ss for player" do
            Factory.create(:fge, galaxy: galaxy, player: player,
              x: ss.x + 1, y: ss.y + 1, x_end: ss.x + 2, y_end: ss.y + 2)
            (SolarSystem.observer_player_ids(ss) & id_arr).should be_blank
          end

          it "should not return ids if fge does not cover ss for ally" do
            Factory.create(:fge, galaxy: galaxy, player: ally,
              x: ss.x + 1, y: ss.y + 1, x_end: ss.x + 2, y_end: ss.y + 2)
            (SolarSystem.observer_player_ids(ss) & id_arr).should be_blank
          end
        end
      end

      describe "planet ownership" do
        it "should return player & alliance ids if player has SSO" do
          Factory.create(:planet, solar_system: ss, player: player)
          Set.new(SolarSystem.observer_player_ids(ss) & id_arr).should == id_set
        end

        it "should return player & alliance ids if alliance has SSO" do
          Factory.create(:planet, solar_system: ss, player: ally)
          Set.new(SolarSystem.observer_player_ids(ss) & id_arr).should == id_set
        end

        it "should not return player & alliance ids if there is no owned SSO" do
          Factory.create(:planet, solar_system: ss)
          (SolarSystem.observer_player_ids(ss) & id_arr).should be_blank
        end
      end

      describe "units in solar system" do
        let(:location) { SolarSystemPoint.new(ss.id, 0, 0) }

        it "should return player & alliance ids if player has SS units" do
          Factory.create(:u_crow, location: location, player: player)
          Set.new(SolarSystem.observer_player_ids(ss) & id_arr).
            should == id_set
        end

        it "should return player & alliance ids if alliance has SS units" do
          Factory.create(:u_crow, location: location, player: ally)
          Set.new(SolarSystem.observer_player_ids(ss) & id_arr).
            should == id_set
        end

        it "should not return ids if there is no owned SS units" do
          Factory.create(:u_crow, location: location)
          (SolarSystem.observer_player_ids(ss) & id_arr).should be_blank
        end
      end

      describe "units in ss objects" do
        let(:planet) { Factory.create(:planet, solar_system: ss) }

        it "should return player & alliance ids if player has SSO units" do
          Factory.create(:u_crow, location: planet, player: player)
          Set.new(SolarSystem.observer_player_ids(ss) & id_arr).
            should == id_set
        end

        it "should return player & alliance ids if alliance has SSO units" do
          Factory.create(:u_crow, location: planet, player: ally)
          Set.new(SolarSystem.observer_player_ids(ss) & id_arr).
            should == id_set
        end

        it "should not return ids if there is no owned SSO units" do
          Factory.create(:u_crow, location: planet)
          (SolarSystem.observer_player_ids(ss) & id_arr).should be_blank
        end
      end
    end

    describe ".sees_wormhole?" do
      let(:alliance) { create_alliance }
      let(:galaxy) { alliance.galaxy }
      let(:player) { alliance.owner }
      let(:ally) { Factory.create(:player, alliance: alliance, galaxy: galaxy) }
      let(:wormhole) { Factory.create(:wormhole, galaxy: galaxy) }
      def fge(covered, player)
        coords = covered \
          ? {x: wormhole.x, y: wormhole.y,
             x_end: wormhole.x + 2, y_end: wormhole.y + 2} \
          : {x: wormhole.x + 1, y: wormhole.y,
             x_end: wormhole.x + 2, y_end: wormhole.y + 2}
        Factory.create(:fge, coords.merge(galaxy: galaxy, player: player))
      end

      before(:each) do
        wormhole
      end

      it "should return true if player has wormhole covered with fge" do
        fge(true, player)
        SolarSystem.sees_wormhole?(player).should be_true
      end

      it "should return true if ally has wormhole covered with fge" do
        fge(true, ally)
        SolarSystem.sees_wormhole?(player).should be_true
      end

      it "should return false if player has fge but no coverage on WH" do
        fge(false, player)
        SolarSystem.sees_wormhole?(player).should be_false
      end

      it "should return false if ally has fge but no coverage on WH" do
        fge(false, ally)
        SolarSystem.sees_wormhole?(player).should be_false
      end

      it "should return false if player && ally has no FGEs" do
        SolarSystem.sees_wormhole?(player).should be_false
      end
    end
  end
  
  describe "#delete_assets!" do
    before(:all) do
      @ss = Factory.create(:solar_system)
    end
    
    it "should delete ss objects" do
      sso = Factory.create(:ss_object, :solar_system => @ss)
      @ss.delete_assets!
      lambda do
        sso.reload
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
    
    it "should delete wreckages" do
      wreckage = Factory.create(:wreckage, :location => 
          SolarSystemPoint.new(@ss.id, 0, 0))
      @ss.delete_assets!
      lambda do
        wreckage.reload
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
    
    it "should delete units" do
      unit = Factory.create(:u_dirac, :location => 
          SolarSystemPoint.new(@ss.id, 0, 0))
      @ss.delete_assets!
      lambda do
        unit.reload
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
  end
  
  describe "#spawn!" do
    let(:solar_system) { Factory.create(:battleground, spawn_counter: 8) }

    describe "when it already has more spots taken than max" do
      around(:each) do |example|
        with_config_values(
          'solar_system.spawn.battleground.max_spots' => 0
        ) { example.call }
      end

      it "should not spawn any units" do
        lambda do
          solar_system.spawn!
        end.should_not change(Unit, :count)
      end

      it "should not increment spawn counter" do
        lambda do
          solar_system.spawn!
          solar_system.reload
        end.should_not change(solar_system, :spawn_counter)
      end

      it "should return nil" do
        solar_system.spawn!.should be_nil
      end
    end

    describe "when it has less spots taken than max" do
      before(:all) do
        @all_points = SolarSystemPoint.all_orbit_points(solar_system.id)
      end

      around(:each) do |example|
        with_config_values(
          'solar_system.spawn.battleground.max_spots' => @all_points.size
        ) { example.call }
      end

      it "should conform to the definition" do
        location = solar_system.spawn!
        check_spawned_units_by_random_definition(
          Cfg.solar_system_spawn_units_definition(solar_system),
          location, nil, solar_system.spawn_counter - 1, 1
        )
      end

      it "should spawn and save units" do
        units = :units
        UnitBuilder.should_receive(:from_random_ranges).with(
          Cfg.solar_system_spawn_units_definition(solar_system),
          an_instance_of(SolarSystemPoint),
          nil, solar_system.spawn_counter, 1
        ).and_return(units)
        Unit.should_receive(:save_all_units).
          with(units, nil, EventBroker::CREATED)
        solar_system.spawn!
      end

      it "should calculate correct spot value" do
        units = :units
        all_points = @all_points.to_a
        Factory.create(:u_dirac, location: all_points[0], player: nil)
        Factory.create(:u_dirac, location: all_points[3], player: nil)
        UnitBuilder.should_receive(:from_random_ranges).with(
          Cfg.solar_system_spawn_units_definition(solar_system),
          an_instance_of(SolarSystemPoint),
          nil, solar_system.spawn_counter, 3
        ).and_return(units)
        Unit.should_receive(:save_all_units).
          with(units, nil, EventBroker::CREATED)
        solar_system.spawn!
      end

      it "should create cooldown after spawning" do
        Cooldown.should_receive(:create_unless_exists).and_return do |ssp, time|
          ssp.should be_instance_of(SolarSystemPoint)
          time.should be_within(SPEC_TIME_PRECISION).
            of(Cfg.after_spawn_cooldown)
          true
        end
        solar_system.spawn!
      end

      it "should increment spawn counter" do
        lambda do
          solar_system.spawn!
          solar_system.reload
        end.should change(solar_system, :spawn_counter).by(1)
      end

      it "should spawn in point returned by spawn strategy" do
        strategy = mock(SsSpawnStrategy)
        SsSpawnStrategy.should_receive(:new).with(
          solar_system, an_instance_of(Set)
        ).and_return(strategy)
        point = SolarSystemPoint.new(solar_system.id, 0, 0)
        strategy.should_receive(:pick).and_return(point)

        solar_system.spawn!.should == point
      end
    end

    it "should not raise any errors" do
      solar_system.spawn!
    end
  end

  describe "#detach!" do
    let(:player) { Factory.create(:player) }
    let(:solar_system) { Factory.create(:solar_system, :player => player) }

    it "should fail if already detached" do
      solar_system.x = nil; solar_system.y = nil
      lambda do
        solar_system.detach!
      end.should raise_error(RuntimeError)
    end

    it "should fail if it is not a home solar system" do
      solar_system.player = nil
      lambda do
        solar_system.detach!
      end.should raise_error(RuntimeError)
    end

    it "should fail if player is currently connected" do
      Celluloid::Actor[:dispatcher].stub!(:player_connected?).with(player.id).
        and_return(true)
      lambda do
        solar_system.detach!
      end.should raise_error(RuntimeError)
    end

    it "should deactivate all player radars in solar system" do
      radars = [
        Factory.create(:planet, :player => player, :position => 0),
        Factory.create(:planet, :player => player, :position => 1),
      ].map do |planet|
        Factory.create!(:b_radar, opts_active + {:planet => planet})
      end
      solar_system.detach!
      radars.each { |r| r.reload.should be_inactive }
    end

    it "should not deactivate non-player radars in solar system" do
      radars = [
        Factory.create(:planet, :position => 0),
        Factory.create(:planet, :position => 1),
      ].map do |planet|
        Factory.create!(:b_radar, opts_active + {:planet => planet})
      end
      solar_system.detach!
      radars.each { |r| r.reload.should be_active }
    end

    it "should not fail if player owned radar is inactive" do
      radars = [
        Factory.create(:planet, :player => player, :position => 0),
        Factory.create(:planet, :player => player, :position => 1),
      ].map do |planet|
        Factory.create!(:b_radar, opts_inactive + {:planet => planet})
      end
      solar_system.detach!
      radars.each { |r| r.reload.should be_inactive }
    end

    it "should fire ss destroyed event for other players" do
      location = SolarSystemPoint.new(solar_system.id, 0, 0)
      Factory.create(:u_crow, player: player, location: location)
      Factory.create(:u_crow, location: location)

      should_fire_event(
        Event::FowChange::SsDestroyed.all_except(solar_system.id, player.id),
        EventBroker::FOW_CHANGE,
        EventBroker::REASON_SS_ENTRY
      ) { solar_system.detach! }
    end

    it "should set coordinates to nil" do
      solar_system.detach!
      [solar_system.x, solar_system.y].should == [nil, nil]
    end

    it "should save the record" do
      solar_system.detach!
      solar_system.should be_saved
    end
  end

  describe "#attach!" do
    let(:x) { 3 }
    let(:y) { 4 }
    let(:coords) do
      {:x => x - 5, :x_end => x + 5, :y => y - 2, :y_end => y + 2}
    end
    let(:galaxy) { Factory.create(:galaxy) }
    let(:player) { Factory.create(:player_no_home_ss, :galaxy => galaxy) }
    let(:solar_system) do
      Factory.create(:ss_detached, :player => player, :galaxy => galaxy)
    end
    let(:fse) do
      Factory.create(
        :fse_player, :player => player, :solar_system => solar_system,
        :counter => 1
      )
    end

    def create_fges(merged={})
      fge = Factory.create(
        :fge, coords.merge(merged).merge(:counter => 1)
      )
      fge_alliance = Factory.create(
        :fge_alliance, coords.merge(merged).merge(:counter => 1)
      )
      # Second one to check counter summing values.
      coords2 = coords.dup
      coords2[:x] -= 1
      Factory.create(
        :fge, coords2.merge(merged).
          merge(:player => fge.player, :counter => 2)
      )
      Factory.create(
        :fge_alliance, coords2.merge(merged).
          merge(:alliance => fge_alliance.alliance, :counter => 2)
      )
      [fge, fge_alliance]
    end

    before(:each) { fse() }

    it "should fail if it is already attached" do
      solar_system.x = x; solar_system.y = y
      lambda do
        solar_system.attach!(x, y)
      end.should raise_error(RuntimeError)
    end

    it "should fail if it does not belong to a player" do
      solar_system.player = nil
      lambda do
        solar_system.attach!(x, y)
      end.should raise_error(RuntimeError)
    end

    describe "when spot is occupied" do
      it "should fail" do
        Factory.create(:solar_system, :galaxy => solar_system.galaxy,
          :x => x, :y => y)
        lambda do
          solar_system.attach!(x, y)
        end.should raise_error(ArgumentError)
      end

      it "should not fail if another solar system is in other galaxy" do
        Factory.create(:solar_system, :x => x, :y => y)
        lambda do
          solar_system.attach!(x, y)
        end.should_not raise_error(ArgumentError)
      end
    end

    it "should fail if there is no owner FSE" do
      fse.destroy!
      lambda do
        solar_system.attach!(x, y)
      end.should raise_error(RuntimeError)
    end

    it "should create FSEs for players who will be able to see it" do
      fow_galaxy_entries = create_fges(:galaxy => galaxy)
      solar_system.attach!(x, y)

      fow_galaxy_entries.each do |fge|
        FowSsEntry.where(
          :solar_system_id => solar_system.id, :player_id => fge.player_id,
          :alliance_id => fge.alliance_id, :counter => 3
        ).exists?.should be_true
      end
    end

    it "should not create FSEs for player from other galaxy" do
      create_fges()
      lambda do
        solar_system.attach!(x, y)
      end.should_not change(
        FowSsEntry.where(:solar_system_id => solar_system.id), :count
      )
    end

    it "should set its coordinates" do
      solar_system.attach!(x, y)
      [solar_system.x, solar_system.y].should == [x, y]
    end

    it "should save the record" do
      solar_system.attach!(x, y)
      solar_system.should be_saved
    end

    it "should dispatch created with FSEs" do
      entries = create_fges(:galaxy => galaxy).map do |fge|
        FowSsEntry.new(
          :solar_system_id => solar_system.id,
          :counter => 3,
          :player_id => fge.player_id,
          :alliance_id => fge.alliance_id,
          :enemy_planets => fse.player_planets,
          :enemy_ships => fse.player_ships
        )
      end
      player = Player.minimal(player().id)
      should_fire_event(
        Event::FowChange::SsCreated.
          new(solar_system.id, x, y, solar_system.kind, player, entries),
        EventBroker::FOW_CHANGE,
        EventBroker::REASON_SS_ENTRY
      ) do
        solar_system.attach!(x, y)
      end
    end

    it "should not activate radars that belong to player" do
      radars = [
        Factory.create(:planet, :player => player, :position => 0),
        Factory.create(:planet, :player => player, :position => 1),
      ].map do |planet|
        Factory.create!(:b_radar, opts_inactive + {:planet => planet})
      end
      solar_system.attach!(x, y)
      radars.each { |r| r.reload.should be_inactive }
    end
  end

  describe "callbacks" do
    describe ".spawn_callback" do
      let(:solar_system) { Factory.create(:battleground) }

      it "should have scope" do
        SolarSystem::SPAWN_SCOPE
      end

      it "should call #spawn! on solar system" do
        solar_system.should_receive(:spawn!)
        SolarSystem.spawn_callback(solar_system)
      end

      it "should register new callback" do
        date = SolarSystem.spawn_callback(solar_system)
        solar_system.should have_callback(CallbackManager::EVENT_SPAWN, date)
      end
    end
  end
end