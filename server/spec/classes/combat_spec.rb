require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe Combat do
  describe "simulation" do
    describe ".loaded_units" do
      before(:each) do
        @transporters = [
          Factory.create(:u_mule, :stored => Unit::Trooper.volume),
          Factory.create(:u_mule, :stored => Unit::Trooper.volume)
        ]
        @loaded = [
          Factory.create(:u_trooper, :location => @transporters[0]),
          Factory.create(:u_trooper, :location => @transporters[1]),
        ]
        @location = Factory.create(:planet)
      end
      
      it "should return all units in transporters" do
        loaded_units, unloaded_unit_ids = Combat.
          loaded_units(@location, @transporters, false)
        loaded_units.should == @loaded.inject({}) do |hash, unit|
          hash[unit.location_id] ||= Set.new
          hash[unit.location_id].add unit
          hash
        end
        unloaded_unit_ids.should be_instance_of(Set)
      end
      
      it "should not change unit locations" do
        loaded_units, _ = Combat.
          loaded_units(@location, @transporters, false)
        @loaded.each do |unit|
          loaded_units[unit.location_id].find do |unit_in_transporter|
            unit_in_transporter.id == unit.id
          end.location.should == unit.location
        end
      end
      
      describe "unload=true" do
        it "should change combat unit location" do
          loaded_units, _ = Combat.
            loaded_units(@location, @transporters, true)
          @loaded.each do |unit|
            loaded_units[unit.location_id].find do |unit_in_transporter|
              unit_in_transporter.id == unit.id
            end.location.should == @location.location_point
          end
        end
        
        it "should return changed unit locations in a set" do
          _, unloaded_unit_ids = Combat.
            loaded_units(@location, @transporters, true)
          unloaded_unit_ids.should == Set.new(@loaded.map(&:id))
        end
        
        describe "non-combat units" do
          before(:each) do
            transporter = @transporters[0]
            transporter.stored += Unit::Mdh.volume
            @mdh = Factory.create!(:u_mdh, :location => transporter)
          end
        
          it "should not change non-combat unit location" do
            loaded_units, _ = Combat.
              loaded_units(@location, @transporters, true)
            loaded_units[@mdh.location_id].find do |unit_in_transporter|
              unit_in_transporter.id == @mdh.id
            end.location.should == @mdh.location
          end
          
          it "should not include non-combat unit id in unloaded ids" do
            _, unloaded_unit_ids = Combat.
              loaded_units(@location, @transporters, true)
            unloaded_unit_ids.should_not include(@mdh.id)
          end
        end
      end
    end
  end
  
  describe "combat" do
    before(:each) do
      survivors = Set.new
      dead_people = Set.new
      
      @dsl = CombatDsl.new do
        location :planet do
          buildings { vulcan }
        end

        alliance do
          player :planet_owner => true do
            units do
              survivors.add trooper
              survivors.add trooper(:flank => 1)
            end
          end
          player { units { survivors.add trooper } }
        end

        a2 = alliance do
          player do
            units do
              dead_people.add trooper(:hp => 10)
              dead_people.add trooper(:flank => 1, :hp => 10)
            end
          end
        end

        a3 = alliance do
          player { units { dead_people.add trooper(:hp => 10) } }
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
      Unit.should_receive(:save_all_units).and_return do |units, reason|
        Set.new(units).should == @survivors
        reason.should == EventBroker::REASON_COMBAT
      end
      @dsl.run
    end

    it "should destroy dead units" do
      Unit.should_receive(:delete_all_units).and_return do 
        |units, killed_by, reason|
        Set.new(units).should == @dead_people
        killed_by.should be_instance_of(Hash)
        reason.should == EventBroker::REASON_COMBAT
      end
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
        be_within(SPEC_TIME_PRECISION).of(
          CONFIG.evalproperty('combat.cooldown.planet.duration').from_now
        )
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
        be_within(SPEC_TIME_PRECISION).of(
          CONFIG.evalproperty('combat.cooldown.duration').from_now
        )
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
      player { units { winner = trooper :hp => 20 } }
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

  it "should run combat if planet is defended only by npc towers" do
    CombatDsl.new do
      location(:planet) do
        buildings do
          thunder :x => 0
          vulcan :x => 3
          screamer :x => 6
        end
      end
      player { units { mule { shocker } } }
    end.run.should_not be_nil
  end
  
  describe "alive/dead stats" do
    it "should include buildings" do
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

    it "should not include other player leveled up units" do
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
        self.player(:planet_owner => true) do
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
      mdh = nil
      @dsl = CombatDsl.new do
        planet = location(:planet).location
        player = self.player do
          units { mule { trooper; shocker :hp => 1; mdh = self.mdh } }
        end
        player { units { shocker :hp => 1, :count => 2 } }
      end
      @player = player.player
      @planet = planet
      @mdh = mdh
    end

    it "should change teleported unit location" do
      @dsl.run
      unit = Unit::Trooper.where(:player_id => @player.id).first
      unit.location.should == @planet.location_point
    end

    it "should not teleport non combat types" do
      lambda do
        @dsl.run
        @mdh.reload
      end.should_not change(@mdh, :location)
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

  describe "#895" do
    # Units are not sent in CombatLog notification if player had no units while
    # attacked in SsObject

    it "should send units in notification" do
      player = nil
      assets = CombatDsl.new do
        planet = location(:planet).location
        player = self.player(:planet_owner => true).player
        player { units { shocker } }
      end.run

      notification_id = assets.notification_ids[player.id]
      notification = Notification.find(notification_id)
      notification.params['units'].should_not be_nil
    end
  end

  it "should not kill non-combat types" do
    mule = nil
    mdh = nil
    CombatDsl.new do
      planet = location(:planet).location
      player = self.player do
        units { mule = self.mule { mdh = self.mdh } }
      end
      player { units { glancer :count => 10 } }
    end.run
    
    mdh.reload
    mdh.location.should == mule.location_point
    mdh.hp_percentage.should == 1.0
  end

  it "should still run combat if one player only has non combat types" do
    CombatDsl.new do
      location(:planet)
      player(:planet_owner => true) { units { mdh } }
      player { units { glancer :count => 10 } }
    end.run.should_not be_nil
  end

  describe "units destroyed with their transporter" do
    before(:each) do
      player = nil
      location_container = nil
      @dsl = CombatDsl.new do
        location_container = location(:solar_system)
        player = self.player do
          units { mule(:hp => 1) { trooper; mdh } }
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
    
    it "should include non-combat units in lost unit stats too" do
      assets = @dsl.run
      notification = Notification.find(
        assets.notification_ids[@player.id])
      notification.params['units']['yours']['dead'].should include(
        "Unit::Mdh")
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
          units { mule(:hp => 1) { azure :count => 1 } }
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

  describe "victory points" do
    describe "when in battleground" do
      [
        [:planet, {:solar_system => Factory.create(:battleground)}],
        [:solar_system, Factory.attributes_for(:battleground)],
      ].each do |type, options|
        describe type do
          it "should calculate victory points for doing damage to other units" do
            player1 = player2 = nil
            assets = CombatDsl.new do
              location(type, options)
              player1 = player { units { rhyno } }.player
              player2 = player { units { rhyno } }.player
            end.run

            [player1, player2].each do |player|
              notification_id = assets.notification_ids[player.id]
              notification = Notification.find(notification_id)
              notification.params['statistics'][Combat::STATS_VPS_ATTR].
                should > 0

              player.victory_points.should == notification.params['statistics'][
                Combat::STATS_VPS_ATTR
              ]
            end
          end

          it "should not calculate VPs for doing damage to NPC units" do
            player = nil
            assets = CombatDsl.new do
              location(type, options)
              player = player { units { rhyno } }.player
              player(:npc => true) { units { rhyno } }
            end.run

            notification_id = assets.notification_ids[player.id]
            notification = Notification.find(notification_id)
            notification.params['statistics'][Combat::STATS_VPS_ATTR].
              should == 0
          end
        end
      end
    end

    describe "when not in battleground" do
      [
        [:planet, {:solar_system => Factory.create(:mini_battleground)},
          " @ mini battleground"],
        [:solar_system, Factory.attributes_for(:mini_battleground),
          " @ mini battleground"],
        [:planet, {:solar_system => Factory.create(:solar_system)},
          " @ regular solar system"],
        [:solar_system, Factory.attributes_for(:solar_system),
          " @ regular solar system"],
        [:galaxy, {}, ""],
      ].each do |type, options, info|
        describe "#{type}#{info}" do
          it "should not calculate VPs for doing damage to other units" do
            player1 = player2 = nil
            assets = CombatDsl.new do
              location(type, options)
              player1 = player { units { rhyno } }.player
              player2 = player { units { rhyno } }.player
            end.run

            [player1, player2].each do |player|
              notification_id = assets.notification_ids[player.id]
              notification = Notification.find(notification_id)
              notification.params['statistics'][Combat::STATS_VPS_ATTR].
                should == 0

              player.victory_points.should == 0
            end
          end
        end
      end
    end

    it "should give victory points for units who give VPs on received damage" do
      player1 = player2 = nil
      assets = CombatDsl.new do
        location(:solar_system)
        player1 = player { units { rhyno } }.player
        player2 = player { units { boss_ship } }.player
      end.run

      (nvps1, vps1), (nvps2, vps2) = [player1, player2].map do |player|
        notification_id = assets.notification_ids[player.id]
        notification = Notification.find(notification_id)

        [
          notification.params['statistics'][Combat::STATS_VPS_ATTR],
          player.victory_points
        ]
      end
      nvps1.should > 0
      vps1.should > 0
      nvps2.should == 0
      vps2.should == 0
    end
  end

  describe "creds for killing" do
    it "should give them for killing the unit" do
      player1 = player2 = nil
      assets = CombatDsl.new do
        location(:solar_system)
        player1 = player { units { rhyno } }.player
        player2 = player { units { boss_ship :hp => 0.001 } }.player
      end.run

      (ncreds1, creds1), (ncreds2, creds2) = [player1, player2].map do |player|
        notification_id = assets.notification_ids[player.id]
        notification = Notification.find(notification_id)

        [
          notification.params['statistics'][Combat::STATS_CREDS_ATTR],
          player.creds
        ]
      end
      ncreds1.should > 0
      creds1.should > 0
      ncreds2.should == 0
      creds2.should == 0
    end

    it "should not give them for harming the unit" do
      player1 = player2 = nil
      assets = CombatDsl.new do
        location(:solar_system)
        player1 = player { units { rhyno } }.player
        player2 = player { units { boss_ship } }.player
      end.run

      (ncreds1, creds1), (ncreds2, creds2) = [player1, player2].map do |player|
        notification_id = assets.notification_ids[player.id]
        notification = Notification.find(notification_id)

        [
          notification.params['statistics'][Combat::STATS_CREDS_ATTR],
          player.creds
        ]
      end
      ncreds1.should == 0
      creds1.should == 0
      ncreds2.should == 0
      creds2.should == 0
    end
  end
end