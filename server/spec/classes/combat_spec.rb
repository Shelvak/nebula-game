require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe Combat do
  describe "simulation" do
    describe ".parse_killed_by" do
      it "should return units" do
        unit = Factory.create(:unit)
        player_id = 30
        Combat.parse_killed_by(
          {unit.id => unit}, {}, {"t#{unit.id}" => player_id}
        ).should == {unit => player_id}
      end
      
      it "should return buildings" do
        building = Factory.create(:building)
        player_id = 30
        Combat.parse_killed_by(
          {}, {building.id => building}, {"b#{building.id}" => player_id}
        ).should == {building => player_id}
      end
    end
  
    describe ".unwrap_json_hash" do
      it "should unwrap string keys" do
        Combat.unwrap_json_hash('1' => 'foo', Combat::NPC_SM => 'bar').
          should == {1 => 'foo', Combat::NPC => 'bar'}
      end
    end
  end
  
  describe "combat" do
    before(:each) do
      survivors = []
      dead_people = []
      
      @dsl = CombatDsl.new do
        location :planet do
          buildings { vulcan }
        end

        alliance do
          player :planet_owner => true do
            units do
              survivors.push trooper
              survivors.push trooper(:flank => 1)
            end
          end
          player { units { survivors.push trooper } }
        end

        a2 = alliance do
          player do
            units do
              dead_people.push trooper(:hp => 10)
              dead_people.push trooper(:flank => 1, :hp => 10)
            end
          end
        end

        a3 = alliance do
          player { units { dead_people.push trooper(:hp => 10) } }
        end

        nap(a2, a3)
      end

      @survivors = survivors
      @dead_people = dead_people
      @units = @dsl.units
      @players = @dsl.players
      @location = @dsl.location_container.location
    end

    it "should return Combat::Assets" do
      assets = @dsl.run
      assets.should be_instance_of(Combat::Assets)
    end

    it "should create notifications for every player" do
      @dsl.run
      @players.each do |player|
        Notification.find_by_player_id_and_event(
          player.id, Notification::EVENT_COMBAT
        ).should_not be_nil
      end
    end

    it "should increase war points for every player" do
      old_points = @players.map(&:points)
      @dsl.run
      new_points = @players.map do |player|
        player.reload
        player.war_points
      end

      (0...@players.size).each do |index|
        new_points[index] > old_points[index]
      end
    end

    it "should increase units xp" do
      old_xp = @units.map(&:xp)
      @dsl.run
      @units.map(&:xp).should_not == old_xp
    end

    it "should save updated units" do
      Unit.should_receive(:save_all_units).with(
        @survivors, EventBroker::REASON_COMBAT
      )
      @dsl.run
    end

    it "should destroy dead units" do
      Unit.should_receive(:delete_all_units).with(
        @dead_people, an_instance_of(Hash),
        EventBroker::REASON_COMBAT
      )
      @dsl.run
    end

    it "should update alive buildings" do
      vulcan = @location.buildings.where(:type => "Vulcan").first
      should_fire_event([vulcan], EventBroker::CHANGED) do
        @dsl.run
      end
    end
    
    it "should calculate wreckages" do
      Wreckage.should_receive(:calculate).and_return do |units|
        Set.new(units).should == Set.new(@dead_people)
        [1, 2, 3]
      end
      @dsl.run
    end

    it "should add wreckages" do
      Wreckage.stub!(:calculate).and_return([1,2,3])
      Wreckage.should_receive(:add).with(@location, 1, 2, 3)
      @dsl.run
    end

    it "should not create cooldown" do
      @dsl.run
      Cooldown.in_location(@location.location_attrs).first.should be_nil
    end

    it "should create cooldown if battle ended in tie" do
      Combat::Integration.stub!(:has_tie?).and_return(true)
      @dsl.run
      Cooldown.in_location(@location.location_attrs).first.ends_at.should \
        be_close(
          CONFIG.evalproperty('combat.cooldown.planet.duration').from_now,
          SPEC_TIME_PRECISION)
    end
  end

  describe "combat in space" do
    before(:each) do
      location = nil
      @dsl = CombatDsl.new do
        location = location(:solar_system).location
        player { units { crow; mule { trooper } } }
        player { units { crow; mule } }
      end
      @location = location
    end

    it "should create cooldown if it ends with tie" do
      Combat::Integration.stub!(:has_tie?).and_return(true)
      @dsl.run
      Cooldown.in_location(@location.location_attrs).first.ends_at.should \
        be_close(
          CONFIG.evalproperty('combat.cooldown.duration').from_now,
          SPEC_TIME_PRECISION)
    end

    it "should not unload units into space" do
      assets = @dsl.run
      assets.response['yane'].each do |player_id, yane|
        yane.each do |allegiance, alive_dead|
          alive_dead.each do |kind, type_count|
            type_count.should_not have_key("Unit::Trooper")
          end
        end
      end
    end
  end

  describe "combat check when one has space towers and other space units" do
    it "should be able to run combat" do
      dsl = CombatDsl.new do
        location(:planet) { buildings { thunder } }
        player :planet_owner => true
        player { units { crow } }
      end
      
      dsl.run.should_not be_nil
    end
  end

  describe "#794" do
    it "should not crash if alliance name has weird characters" do
      CombatDsl.new do
        location :planet
        alliance(:name => "¨°º¤ø ULTRASONIC TEAM ø¤º°¨") do
          player(:planet_owner => true) { units { trooper } }
        end
        player { units { shocker } }
      end.run
    end
  end
  
  it "should calculate overpopulation into account" do
    loser = nil # This will lose because being THAT much into overpopulation
                # sucks bad for you.
    winner = nil
    CombatDsl.new do
      location :planet
      player(:population => 100000, :population_cap => 10) do
        units { loser = trooper }
      end
      player { units { winner = trooper :hp => 1 } }
    end.run
    
    loser.should be_dead
    winner.should be_alive
  end
  
  it "should not crash if planet owner does not have any assets" do
    CombatDsl.new do
      location :planet
      player(:planet_owner => true)
      player { units { trooper } }
      player { units { shocker } }
    end.run
  end

  it "should add to unit xp instead of overwriting it" do
    dsl = CombatDsl.new do
      location(:planet) { buildings { screamer } }
      player :planet_owner => true
      player { units { rhyno } }
    end

    rhyno = dsl.units.to_a[0]
    rhyno.xp = 100
    player = rhyno.player

    assets = dsl.run
    rhyno.xp.should == 100 +
      assets.response['statistics'][player.id]['xp_earned']
  end

  it "should run combat if there is nothing to fire, but units " +
  "can be unloaded" do
    CombatDsl.new do
      location :planet
      player(:planet_owner => true) { units { mule { trooper } } }
      player { units { shocker } }
    end.run.should_not be_nil
  end

  it "should include buildings in alive/dead stats" do
     player = nil
     dsl = CombatDsl.new do
       location(:planet) { buildings { thunder } }
       player = self.player :planet_owner => true
       player { units { crow } }
     end
 
     assets = dsl.run
     notification = Notification.find(
       assets.notification_ids[player.player.id])
     notification.params['units']['yours']['alive'].should include(
       "Building::Thunder")
  end

  it "should not include other player leveled up units in stats" do
    player = crow_unit = nil
    dsl = CombatDsl.new do
      location(:solar_system)
      player = self.player { units { crow :hp => 10 } }
      self.player { units { crow_unit = crow } }
    end
    
    crow_unit.xp = crow_unit.xp_needed(2) - 1
    crow_unit.save!

    assets = dsl.run
    notification = Notification.find(
      assets.notification_ids[player.player.id])
    notification.params['leveled_up'].find do |unit_hash|
      unit_hash[:type] == "Unit::Crow"
    end.should be_nil
  end

  it "should win a battle where one player has nothing" do
    winner = loser = nil
    
    assets = CombatDsl.new do
      location(:planet)
      loser = player(:planet_owner => true).player
      winner = (player { units { crow } }).player
    end.run
    
    assets.response['outcomes'][loser.id].should == Combat::OUTCOME_LOSE
    assets.response['outcomes'][winner.id].should == Combat::OUTCOME_WIN
  end
  
  it "should do no combat where both players can't reach" do
    assets = CombatDsl.new do
      location(:planet)
      player(:planet_owner => true) { units { trooper } }
      player { units { crow } }
    end.run
    
    assets.should be_nil
  end
  
  describe "#572: Update transporters after battle" do
    it "should dispatch transporters even if they didn't get damage" do
      mule = nil
      dsl = CombatDsl.new do
        planet = location(:planet).location
        player = self.player(:planet_owner => true) do
          units { mule = self.mule { trooper :hp => 1 } }
        end
        player { units { shocker } }
      end
      
      SPEC_EVENT_HANDLER.clear_events!
      dsl.run
      SPEC_EVENT_HANDLER.events.find do |objects, event, reason|
        event == EventBroker::CHANGED && objects.include?(mule)
      end.should_not be_nil
    end
  end
  
  describe "teleported units" do
    before(:each) do
      player = nil
      planet = nil
      @dsl = CombatDsl.new do
        planet = location(:planet).location
        player = self.player(:planet_owner => true) do
          units { mule { trooper; shocker :hp => 1 } }
        end
        player { units { shocker :hp => 1, :count => 2 } }
      end
      @player = player.player
      @planet = planet
    end

    it "should change teleported unit location" do
      @dsl.run
      unit = Unit::Trooper.where(:player_id => @player.id).first
      unit.location.should == @planet.location_point
    end

    it "should destroy teleported dead units" do
      # Ensure Shocker gets it
      Unit::Trooper.where(:player_id => @player.id).first.destroy
      @dsl.run
      Unit::Shocker.where(:player_id => @player.id).first.should be_nil
    end

    it "should include teleported units in alive/dead stats" do
      assets = @dsl.run
      notification = Notification.find(
        assets.notification_ids[@player.id])
      notification.params['units']['yours']['alive'].should include(
        "Unit::Trooper")
    end
  end

  describe "units destroyed with their transporter" do
    before(:each) do
      player = nil
      location_container = nil
      @dsl = CombatDsl.new do
        location_container = location(:solar_system)
        player = self.player do
          units { mule(:hp => 1) { trooper } }
        end
        player { units { rhyno } }
      end
      @player = player.player
      @location_container = location_container
    end

    it "should destroy units loaded in transporter" do
      @dsl.run
      Unit::Trooper.where(:player_id => @player.id).first.should be_nil
    end

    it "should include them in lost unit stats" do
      assets = @dsl.run
      notification = Notification.find(
        assets.notification_ids[@player.id])
      notification.params['units']['yours']['dead'].should include(
        "Unit::Trooper")
    end
  end

  describe "units unloaded and transporter then destroyed" do
    before(:each) do
      player = nil
      location_container = nil
      @dsl = CombatDsl.new do
        location_container = location(:planet) do
          buildings { thunder :hp => 6 }
        end
        player(:planet_owner => true)
        player = self.player do
          units { mule(:hp => 100) { azure :count => 1 } }
        end
      end
      @player = player.player
      @location_container = location_container
      @dsl.run
    end
    
    it "should destroy mule" do
      Unit::Mule.where(:player_id => @player.id).first.should be_nil
    end
    
    it "should destroy thunder" do
      Building::Thunder.where(
        :planet_id => @location_container.location.id).first.should be_nil
    end

    it "should not destroy azures" do
      Unit::Azure.where(:player_id => @player.id).count.should == 1
    end
  end

  describe "building destroyed" do
    before(:each) do
      location_container = nil
      @dsl = CombatDsl.new do
        location_container = location(:planet) do
          buildings { thunder :hp => 1 }
        end
        player(:planet_owner => true)
        player { units { shocker :count => 50 } }
      end
      @location_container = location_container
    end

    it "should not crash" do
      @dsl.run
    end

    it "should destroy thunder" do
      @dsl.run
      Building::Thunder.where(
        :planet_id => @location_container.location.id).first.should be_nil
    end
  end
end