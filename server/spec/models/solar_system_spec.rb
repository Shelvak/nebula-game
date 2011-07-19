require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe SolarSystem do
  describe "object" do
    before(:each) do
      @model = Factory.create(:solar_system)
    end

    it_should_behave_like "shieldable"
  end

  describe "#as_json" do
    before(:each) do
      @model = Factory.create(:solar_system)
    end

    @required_fields = [:id, :x, :y, :kind]
    @ommited_fields = [:galaxy_id]
    it_should_behave_like "to json"
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
    
    it "should dispatch changed" do
      should_fire_event(@ss, EventBroker::CHANGED) do
        @ss.die!
      end
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
  end
end