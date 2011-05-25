require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe Combat do
  describe ".npc_raid_unit_count" do
    before(:all) do
      @values = {
        'raiding.raiders' => [
          [3, "gnat", 5, 0],
          [3, "gnat", 4, 1],
          [4, "gnat", 3, 0],
          [4, "glancer", 4, 0],
        ]
      }
    end

    it "should return empty array if player has too few planets" do
      with_config_values(@values) do
        Combat.npc_raid_unit_count(2).should == []
      end
    end

    it "should return units when we meet threshold" do
      with_config_values(@values) do
        Combat.npc_raid_unit_count(3).should == [
          ["gnat", 5, 0],
          ["gnat", 4, 1],
        ]
      end
    end

    it "should return units when we meed threshold (4 planets)" do
      with_config_values(@values) do
        Combat.npc_raid_unit_count(4).should == [
          ["gnat", 5 * 2 + 3, 0],
          ["gnat", 4 * 2, 1],
          ["glancer", 4, 0],
        ]
      end
    end
  end

  describe ".npc_raid_units" do
    before(:all) do
      @player = Factory.create(:player, :planets_count => 3)
      @planet = Factory.create(:planet, :player => @player)
      Combat.should_receive(:npc_raid_unit_count).
        with(@player.planets_count).and_return([
          ["gnat", 2, 0],
          ["glancer", 1, 1],
        ])
      @units = Combat.npc_raid_units(@planet)
    end

    it "should place units in planet" do
      @units.each { |unit| unit.location.should == @planet.location_point }
    end

    it "should set unit flanks" do
      @units.map(&:flank).should == [0, 0, 1]
    end

    it "should set unit levels" do
      @units.each { |unit| unit.level.should == 1 }
    end

    it "should set unit to full hp" do
      @units.each { |unit| unit.hp.should == unit.hit_points }
    end

    it "should not belong to any player" do
      @units.each { |unit| unit.player.should be_nil }
    end

    it "should be correct types" do
      @units.map { |u| u.class.to_s }.should == [
        "Unit::Gnat",
        "Unit::Gnat",
        "Unit::Glancer",
      ]
    end

    it "should not be saved" do
      @units.each { |unit| unit.id.should be_nil }
    end
  end

  describe ".npc_raid!" do
    before(:each) do
      @player = Factory.create(:player, :planets_count => 
          CONFIG['raiding.planet.threshold'])
      @planet = Factory.create(:planet, :player => @player)
      @unit = Factory.create(:u_trooper, :location => @planet,
        :player => @player, :level => 1)
    end

    it "should create npc units in planet" do
      Combat.should_receive(:npc_raid_units).with(@planet).and_return([
          Factory.build(:u_gnat, :location => @planet, :player => nil,
            :level => 1)
      ])
      Combat.npc_raid!(@planet)
    end

    it "should run combat" do
      Combat.should_receive(:run)
      Combat.npc_raid!(@planet)
    end

    it "should take away planet" do
      @unit.destroy
      Combat.npc_raid!(@planet)
      @planet.reload
      @planet.player.should be_nil
    end

    describe "raid cleared", :shared => true do
      it "should not register raid" do
        @planet.should_not_receive(:register_raid!)
        Combat.npc_raid!(@planet)
      end

      it "should clear #next_raid_at" do
        @planet.should_receive(:clear_raid!)
        Combat.npc_raid!(@planet)
      end
    end

    describe "raid survived" do
      before(:each) do
        # Ensure player survives the raid
        Factory.create!(:u_azure, :location => @planet,
          :player => @player, :level => 10)
        Factory.create!(:u_rhyno, :location => @planet,
          :player => @player, :level => 10)
      end

      it "should register next raid if player has enough planets" do
        @planet.should_receive(:register_raid!)
        Combat.npc_raid!(@planet)
      end

      it "should dispatch changed with planet" do
        should_fire_event(@planet, EventBroker::CHANGED) do
          Combat.npc_raid!(@planet)
        end
      end

      describe "when there is no next raid" do
        before(:each) do
          @player.planets_count -= 1
          @player.save!
        end

        it_should_behave_like "raid cleared"
      end
    end

    describe "when npc takes the planet" do
      before(:each) do
        @unit.destroy
      end

      it_should_behave_like "raid cleared"
    end
  end

  describe "combat" do
    before(:each) do
      @dsl = CombatDsl.new do
        location :planet do
          buildings { vulcan }
        end

        alliance do
          player :planet_owner => true do
            units { trooper; trooper :flank => 1 }
          end
          player { units { trooper } }
        end

        a2 = alliance do
          player do
            units { trooper :hp => 10; trooper :flank => 1, :hp => 10 }
          end
        end

        a3 = alliance do
          player { units { trooper :hp => 10 } }
        end

        nap(a2, a3)
      end

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
        [0, 1, 2].map { |i| @units[i] }, EventBroker::REASON_COMBAT
      )
      @dsl.run
    end

    it "should destroy dead units" do
      Unit.should_receive(:delete_all_units).with(
        [3, 4, 5].map { |i| @units[i] }, an_instance_of(Hash),
        EventBroker::REASON_COMBAT
      )
      @dsl.run
    end

    it "should calculate wreckages" do
      Wreckage.should_receive(:calculate).and_return do |units|
        Set.new(units).should == Set.new([3, 4, 5].map { |i| @units[i] })
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

    rhyno = dsl.units[0]
    rhyno.xp = 100
    player = rhyno.player

    assets = dsl.run
    rhyno.xp.should == 100 +
      assets.response['statistics'][player.id.to_s]['xp_earned']
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