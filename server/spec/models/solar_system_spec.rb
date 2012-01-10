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

  it "should not allow two systems in same place" do
    model = Factory.create :solar_system
    Factory.build(:solar_system, :galaxy => model.galaxy, :x => model.x,
      :y => model.y).should_not be_valid
  end

  describe "visibility methods" do
    describe ".single_visible_for" do
      before(:all) do
        @alliance = Factory.create :alliance
        @player = Factory.create :player, :alliance => @alliance
      end

      it "should return SolarSystem if it's visible (player)" do
        ss = Factory.create :solar_system, :galaxy => @player.galaxy
        Factory.create :fse_player, :player => @player, :solar_system => ss
        SolarSystem.find_if_visible_for(ss.id, @player).should == ss
      end

      it "should return SolarSystem if it's visible (alliance)" do
        ss = Factory.create :solar_system, :galaxy => @player.galaxy
        Factory.create :fse_alliance, :alliance => @alliance,
          :solar_system => ss
        SolarSystem.find_if_visible_for(ss.id, @player).should == ss
      end

      it "should raise ActiveRecord::RecordNotFound if SolarSystem " +
      "exists but is not visible" do
        ss = Factory.create :solar_system, :galaxy => @player.galaxy
        lambda do
          SolarSystem.find_if_visible_for(ss.id, @player)
        end.should raise_error(ActiveRecord::RecordNotFound)
      end

      describe "shielded ss" do
        before(:each) do
          @ss = Factory.create(:solar_system, :galaxy => @player.galaxy,
            :shield_ends_at => 10.days.from_now,
            :shield_owner => @player)
          Factory.create :fse_player, :player => @player,
            :solar_system => @ss
        end

        it "should not allow viewing ss if it is shielded" do
          @ss.shield_owner = Factory.create(:player)
          @ss.save!

          lambda do
            SolarSystem.find_if_visible_for(@ss.id, @player)
          end.should raise_error(ActiveRecord::RecordNotFound)
        end

        it "should allow viewing ss if player is shield owner" do
          lambda do
            SolarSystem.find_if_visible_for(ss.id, @player)
          end.should_not raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    describe ".visible_for" do
      before(:each) do
        @player = Factory.create :player
      end

      it "should return solar systems visible for player in galaxy" do
        fse1 = Factory.create :fse_player, :player => @player
        fse2 = Factory.create :fse_player, :player => @player
        # Invisible SS
        Factory.create :solar_system

        SolarSystem.visible_for(@player).map do |e|
          e[:solar_system].id
        end.sort.should == [fse1.solar_system_id, fse2.solar_system_id].sort
      end

      it "should return metadata for ss'es visible for player in galaxy" do
        @player.alliance = Factory.create :alliance
        @player.save!

        fse1_p = Factory.create :fse_player, :player => @player
        fse2_p = Factory.create :fse_player, :player => @player
        fse2_a = Factory.create :fse_alliance, 
          :alliance => @player.alliance,
          :solar_system => fse2_p.solar_system
        fse3_a = Factory.create :fse_alliance, :alliance => @player.alliance
        # Invisible SS
        Factory.create :solar_system

        SolarSystem.visible_for(@player).map do |e|
          e[:metadata]
        end.should == [
          FowSsEntry.merge_metadata(fse1_p, nil),
          FowSsEntry.merge_metadata(fse2_p, fse2_a),
          FowSsEntry.merge_metadata(nil, fse3_a)
        ]
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
  
  describe "#die!" do
    before(:each) do
      @ss = Factory.create(:solar_system)
    end
    
    it "should change kind to KIND_DEAD" do
      @ss.die!
      @ss.kind.should == SolarSystem::KIND_DEAD
    end
    
    it "should save record" do
      @ss.die!
      @ss.should be_saved
    end
    
    it "should delete all assets" do
      @ss.should_receive(:delete_assets!)
      @ss.die!
    end
    
    it "should update metadata" do
      fse = Factory.create(:fse_player, :solar_system => @ss,
        :enemy_planets => true, :enemy_ships => true)
      @ss.die!
      fse.reload
      [fse.enemy_planets, fse.enemy_ships].should == [false, false]
    end

    it "should unregister spawn from callback manager" do
      CallbackManager.should_receive(:unregister).
        with(@ss, CallbackManager::EVENT_SPAWN)
      @ss.die!
    end
    
    it "should dispatch changed" do
      should_fire_event(@ss, EventBroker::CHANGED) do
        @ss.die!
      end
    end
  end

  describe "#spawn!" do
    let(:solar_system) { Factory.create(:battleground) }

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
          solar_system.galaxy_id,
          location,
          nil
        )
      end

      it "should spawn and save units" do
        units = :units
        UnitBuilder.should_receive(:from_random_ranges).with(
          Cfg.solar_system_spawn_units_definition(solar_system),
          solar_system.galaxy_id,
          an_instance_of(SolarSystemPoint),
          nil
        ).and_return(units)
        Unit.should_receive(:save_all_units).
          with(units, nil, EventBroker::CREATED)
        solar_system.spawn!
      end

      it "should check location after spawning" do
        Combat::LocationChecker.should_receive(:check_location).
          with(an_instance_of(SolarSystemPoint))
        solar_system.spawn!
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
      Dispatcher.instance.stub!(:connected?).with(player.id).and_return(true)
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
      Factory.create(:fse_player, :player => player,
                     :solar_system => solar_system)
      Factory.create(:fse_player, :solar_system => solar_system)
      should_fire_event(
        Event::FowChange::SsDestroyed.all_except(solar_system.id, player.id),
        EventBroker::FOW_CHANGE,
        EventBroker::REASON_SS_ENTRY
      ) { solar_system.detach! }
    end

    it "should remove other player fow ss entries" do
      fse = Factory.create(:fse_player, :solar_system => solar_system)
      solar_system.detach!
      lambda do
        fse.reload
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should not remove owner fow ss entry" do
      fse = Factory.create(:fse_player, :solar_system => solar_system,
                           :player => player)
      solar_system.detach!
      lambda do
        fse.reload
      end.should_not raise_error(ActiveRecord::RecordNotFound)
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
    let(:player) { Factory.create(:player, :galaxy => galaxy) }
    let(:solar_system) do
      Factory.create(:ss_detached, :player => player, :galaxy => galaxy)
    end
    let(:fse) do
      Factory.create(:fse_player, :player => player,
        :solar_system => solar_system)
    end

    def create_fges(merged={})
      [
        Factory.create(:fge_player, coords.merge(merged)),
        Factory.create(:fge_alliance, coords.merge(merged)),
      ]
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
          :alliance_id => fge.alliance_id, :counter => fge.counter
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
          :counter => fge.counter,
          :player_id => fge.player_id,
          :alliance_id => fge.alliance_id,
          :enemy_planets => fse.player_planets,
          :enemy_ships => fse.player_ships
        )
      end
      player = Player.minimal(player.id)
      should_fire_event(
        Event::FowChange::SsCreated.
          new(solar_system.id, x, y, solar_system.kind, player, entries),
        EventBroker::FOW_CHANGE,
        EventBroker::REASON_SS_ENTRY
      ) do
        solar_system.attach!(x, y)
      end
    end

    it "should activate inactive radars that belong to player" do
      radars = [
        Factory.create(:planet, :player => player, :position => 0),
        Factory.create(:planet, :player => player, :position => 1),
      ].map do |planet|
        Factory.create!(:b_radar, opts_inactive + {:planet => planet})
      end
      solar_system.attach!(x, y)
      radars.each { |r| r.reload.should be_active }
    end

    it "should not activate inactive non-player radars" do
      radars = [
        Factory.create(:planet, :position => 0),
        Factory.create(:planet, :position => 1),
      ].map do |planet|
        Factory.create!(:b_radar, opts_inactive + {:planet => planet})
      end
      solar_system.attach!(x, y)
      radars.each { |r| r.reload.should be_inactive }
    end

    it "should not fail if player radar is upgrading" do
      radars = [
        Factory.create(:planet, :player => player, :position => 0),
        Factory.create(:planet, :player => player, :position => 1),
      ].map do |planet|
        Factory.create!(:b_radar, opts_upgrading + {:planet => planet})
      end
      solar_system.attach!(x, y)
      radars.each { |r| r.reload.should be_inactive }
    end
  end

  describe ".on_callback" do
    describe "spawn" do
      before(:each) do
        @solar_system = Factory.create(:battleground)
        SolarSystem.stub!(:find).with(@solar_system.id).
          and_return(@solar_system)
      end

      it "should call #spawn! on solar system" do
        @solar_system.should_receive(:spawn!)
        SolarSystem.on_callback(@solar_system.id, CallbackManager::EVENT_SPAWN)
      end

      it "should register new callback" do
        date = SolarSystem.
          on_callback(@solar_system.id, CallbackManager::EVENT_SPAWN)
        @solar_system.should have_callback(CallbackManager::EVENT_SPAWN, date)
      end
    end
  end
end