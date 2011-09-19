require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe SolarSystem do
  describe "object" do
    before(:each) do
      @model = Factory.create(:solar_system)
    end

    it_behaves_like "shieldable"
  end

  describe "#as_json" do
    before(:each) do
      @model = Factory.create(:solar_system)
    end

    @required_fields = [:id, :x, :y, :kind]
    @ommited_fields = [:galaxy_id]
    it_behaves_like "to json"
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
          Cfg.solar_system_spawn_units_definition(solar_system.kind),
          solar_system.galaxy_id,
          location,
          nil
        )
      end

      it "should spawn and save units" do
        units = :units
        UnitBuilder.should_receive(:from_random_ranges).with(
          Cfg.solar_system_spawn_units_definition(solar_system.kind),
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

      it "should not spawn in points taken by npc" do
        all_points = @all_points.to_a
        all_points[0..-2].each do |point|
          Factory.create(:u_dirac, :galaxy_id => solar_system.galaxy_id,
            :location => point, :level => 1, :player => nil)
        end

        solar_system.spawn!.should == all_points[-1]
      end
    end

    it "should not raise any errors" do
      solar_system.spawn!
    end
  end

  describe ".on_callback" do
    describe "player inactivity check" do
      before(:each) do
        @ss = Factory.create(:solar_system)
        @player = Factory.create(:player, :galaxy => @ss.galaxy)
        @planet = Factory.create(:planet, :solar_system => @ss,
          :player => @player)
      end

      it "should fail if we have more than 1 player in that SS" do
        Factory.create(:planet, :solar_system => @ss, :angle => 90,
          :player => Factory.create(:player, :galaxy => @ss.galaxy))
        lambda do
          SolarSystem.on_callback(@ss.id,
            CallbackManager::EVENT_CHECK_INACTIVE_PLAYER)
        end.should raise_error(GameLogicError)
      end

      describe "if player does not have enough points and have not logged" +
      " in for a certain period of time" do
        before(:each) do
          @player.economy_points = 0
          @player.last_login = (CONFIG.evalproperty(
            'galaxy.player.inactivity_check.last_login_in') + 10.minutes
          ).ago
          @player.save!
        end

        it "should kill solar system" do
          SolarSystem.should_receive(:find).with(@ss.id).and_return(@ss)
          @ss.should_receive(:die!)
          SolarSystem.on_callback(@ss.id,
            CallbackManager::EVENT_CHECK_INACTIVE_PLAYER)
        end

        it "should not fail if last_login is nil" do
          @player.last_login = nil
          @player.save!
          SolarSystem.on_callback(@ss.id,
            CallbackManager::EVENT_CHECK_INACTIVE_PLAYER)
        end

        it "should destroy player" do
          SolarSystem.on_callback(@ss.id,
            CallbackManager::EVENT_CHECK_INACTIVE_PLAYER)
          lambda do
            @player.reload
          end.should raise_error(ActiveRecord::RecordNotFound)
        end
      end

      it "should not erase SS if player has enough points" do
        @player.economy_points = CONFIG[
          'galaxy.player.inactivity_check.points']
        @player.last_login = (CONFIG.evalproperty(
          'galaxy.player.inactivity_check.last_login_in') + 1.day).ago
        @player.save!

        SolarSystem.on_callback(@ss.id,
          CallbackManager::EVENT_CHECK_INACTIVE_PLAYER)
        lambda do
          @ss.reload
        end.should_not raise_error(ActiveRecord::RecordNotFound)
      end

      it "should not erase SS if player has logged in recently" do
        @player.economy_points = 0
        @player.last_login = (CONFIG.evalproperty(
          'galaxy.player.inactivity_check.last_login_in') - 10.minutes).ago
        @player.save!

        SolarSystem.on_callback(@ss.id,
          CallbackManager::EVENT_CHECK_INACTIVE_PLAYER)
        lambda do
          @ss.reload
        end.should_not raise_error(ActiveRecord::RecordNotFound)
      end
    end

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