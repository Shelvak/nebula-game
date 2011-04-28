# encoding: UTF-8
require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

class Technology::TestResourceMod < Technology
  include Parts::ResourceIncreasingTechnology
end
Factory.define :t_test_resource_mod, :class => Technology::TestResourceMod,
:parent => :technology do |m|
  m.level 1
end

describe SsObject::Planet do
  describe "#boosted?" do
    it "should return false if nil" do
      Factory.build(:planet, :metal_rate_boost_ends_at => nil).
        boosted?(:metal, :rate).should be_false
    end

    it "should return false if in past" do
      Factory.build(:planet, :metal_rate_boost_ends_at => 10.minutes.ago).
        boosted?(:metal, :rate).should be_false
    end

    it "should return true otherwise" do
      Factory.build(:planet, :metal_rate_boost_ends_at => 10.minutes.from_now).
        boosted?(:metal, :rate).should be_true
    end
  end

  describe "#name" do
    before(:each) do
      @min = CONFIG['planet.validation.name.length.min']
      @max = CONFIG['planet.validation.name.length.max']
      @model = Factory.build(:planet)
    end

    it_should_behave_like "name validation"
  end

  describe "#can_destroy_building?" do
    it "should return true if can_destroy_building_at is nil" do
      Factory.create(:planet, :can_destroy_building_at => nil
        ).can_destroy_building?.should be_true
    end

    it "should return true if can_destroy_building_at is in past" do
      Factory.create(:planet, :can_destroy_building_at => 5.minutes.ago
        ).can_destroy_building?.should be_true
    end

    it "should return false if can_destroy_building_at is in future" do
      Factory.create(:planet, :can_destroy_building_at => 5.minutes.since
        ).can_destroy_building?.should be_false
    end
  end

  describe "player changing" do
    before(:each) do
      @old = Factory.create(:player, :planets_count => 5)
      @new = Factory.create(:player, :planets_count => 10)
      @planet = Factory.create :planet, :player => @old
      @planet.player = @new
    end

    describe "planets counter cache" do
      it "should increase by 1 for new player" do
        lambda do
          @planet.save!
          @new.reload
        end.should change(@new, :planets_count).by(1)
      end

      it "should decrease by 1 for old player" do
        lambda do
          @planet.save!
          @old.reload
        end.should change(@old, :planets_count).by(-1)
      end

      describe "in battleground" do
        before(:each) do
          @planet.solar_system = Factory.create(:battleground)
        end

        it "should not change for new player" do
          lambda do
            @planet.save!
            @new.reload
          end.should_not change(@new, :planets_count)
        end

        it "should not change for old player" do
          lambda do
            @planet.save!
            @old.reload
          end.should_not change(@old, :planets_count)
        end
      end
    end

    describe "points" do
      [
        [:b_metal_storage, :economy_points],
        [:b_research_center, :science_points],
        [:b_barracks, :army_points]
      ].each do |factory, points_type|
        it "should remove #{points_type} from old player" do
          building = Factory.create!(factory, :level => 1,
            :planet => @planet)
          points = building.points_on_destroy
          @old.send("#{points_type}=", points)
          @old.save!
          @planet.save!
          @old.reload
          @old.send(points_type).should == 0
        end

        it "should add #{points_type} to new player" do
          building = Factory.create!(factory, :level => 1,
            :planet => @planet)
          points = building.points_on_destroy
          @old.send("#{points_type}=", points)
          @old.save!
          @planet.save!
          @new.reload
          @new.send(points_type).should == points
        end
      end
    end

    describe "clearing raid data", :shared => true do
      before(:each) do
        @planet.next_raid_at = @next_raid_at = 10.hours.from_now
        CallbackManager.register(@planet, CallbackManager::EVENT_RAID,
          @planet.next_raid_at)
      end

      it "should clear next_raid_at" do
        @planet.save!
        @planet.next_raid_at.should be_nil
      end

      it "should unregister callback" do
        @planet.save!
        @planet.should_not have_callback(CallbackManager::EVENT_RAID,
          @next_raid_at)
      end
    end

    describe "new player is npc" do
      before(:each) do
        @planet.player = nil
      end

      it_should_behave_like "clearing raid data"
    end

    describe "new player has < threshold planets" do
      before(:each) do
        @new.planets_count = CONFIG['raiding.planet.threshold'] - 2
        @new.save!
      end
      
      it_should_behave_like "clearing raid data"
    end

    describe "new player has >= threshold planets" do
      before(:each) do
        @new.planets_count = CONFIG['raiding.planet.threshold'] - 1
        @new.save!
      end
      
      it "should register next raid" do
        @planet.save!
        @planet.raid_registered?.should be_true
      end

      it "should set next raid to be in a confined window." do
        @planet.save!
        (
          (CONFIG.safe_eval(CONFIG['raiding.delay'][0]).from_now)..(
            CONFIG.safe_eval(CONFIG['raiding.delay'][1]).from_now)
        ).should cover(@planet.next_raid_at)
      end

      it "should register callback" do
        @planet.save!
        @planet.should have_callback(CallbackManager::EVENT_RAID,
          @planet.next_raid_at)
      end

      it "should not reregister raid if it is already scheduled" do
        @planet.next_raid_at = 10.minutes.from_now
        @planet.should_not_receive(:register_raid)
        @planet.save!
      end
    end

    it "should call FowSsEntry.change_planet_owner after save" do
      FowSsEntry.should_receive(:change_planet_owner).with(
        @planet, @old, @new
      ).and_return do |planet, old_player, new_player|
        planet.should be_saved
        true
      end
      @planet.save!
    end

    it "should fire event" do
      should_fire_event(@planet, EventBroker::CHANGED,
      EventBroker::REASON_OWNER_CHANGED) do
        @planet.save!
      end
    end

    it "should fire event after planet has been saved" do
      EventBroker.stub!(:fire).and_return(true)
      EventBroker.stub!(:fire).with(@planet, EventBroker::CHANGED,
      EventBroker::REASON_OWNER_CHANGED).and_return do
        |object, event_name, reason|
        object.should be_saved
      end
      @planet.save!
    end

    it "should change player ids on all constructors building units" do
      constructable = Factory.create(
        :unit, :player => @old, :location => @planet
      )
      Factory.create(:b_constructor_with_constructable,
        :planet => @planet,
        :constructable => constructable
      )
      @planet.save!
      lambda do
        constructable.reload
      end.should change(constructable, :player).from(@old).to(@new)
    end

    describe "radar" do
      before(:each) do
        @radar = Factory.create!(:b_radar, :planet => @planet)
      end

      it "should decrease vision for old player" do
        Trait::Radar.should_receive(:decrease_vision).with(
          @radar.radar_zone, @old)
        @planet.save!
      end

      it "should increase vision for new player" do
        Trait::Radar.should_receive(:increase_vision).with(
          @radar.radar_zone, @new)
        @planet.save!
      end
    end

    describe "scientists" do
      before(:each) do
        @research_center = Factory.create(:b_research_center,
          :planet => @planet)
        @old.reload
      end

      %w{scientists scientists_total}.each do |attr|
        it "should reduce #{attr} from previous owner" do
          lambda do
            @planet.save!
            @old.reload
          end.should change(@old, attr).by(- @research_center.scientists)
        end

        it "should increase #{attr} for new owner" do
          lambda do
            @planet.save!
            @new.reload
          end.should change(@new, attr).by(@research_center.scientists)
        end
      end
    end

    describe "population_max" do
      before(:each) do
        @housing = Factory.create(:b_housing, :planet => @planet)
        @old.reload
      end

      it "should reduce population_max from previous owner" do
        lambda do
          @planet.save!
          @old.reload
        end.should change(@old, :population_max).by(- @housing.population)
      end

      it "should increase population_max for new owner" do
        lambda do
          @planet.save!
          @new.reload
        end.should change(@new, :population_max).by(@housing.population)
      end
    end

    describe "exploration" do
      it "should stop exploration if exploring" do
        @planet.stub!(:exploring?).and_return(true)
        @planet.should_receive(:stop_exploration!).with(@old)
        @planet.save!
      end

      it "should not stop exploration if not exploring" do
        @planet.stub!(:exploring?).and_return(false)
        @planet.should_not_receive(:stop_exploration!)
        @planet.save!
      end
    end

    describe "special planets" do
      before(:each) do
        @planet.special = true
      end

      it "should increase victory points for new player" do
        lambda do
          @planet.save!
          @new.reload
        end.should change(@new, :victory_points).by(
          CONFIG["battleground.planet.takeover.vps"])
      end

      it "should give units in that planet" do
        Unit.should_receive(:give_units).with(
          CONFIG['battleground.planet.bonus'],
          @planet,
          @new
        )
        @planet.save!
      end
    end
  end

  describe ".increase" do
    before(:each) do
      @model = Factory.create(:planet, :player => Factory.create(:player))
    end

    it "should dispatch event" do
      should_fire_event(@model, EventBroker::CHANGED,
        EventBroker::REASON_OWNER_PROP_CHANGE) do

        SsObject::Planet.increase(@model.id,
          :metal_rate => 10)
      end
    end
  end

  describe "#explore!" do
    before(:each) do
      @player = Factory.create(:player)
      @planet = Factory.create(:planet, :player => @player)
      @x = 5
      @y = 7
      @kind = Tile::FOLLIAGE_3X3
      Factory.create(:block_tile, :kind => @kind, :x => @x,
        :y => @y, :planet => @planet)
    end

    it "should fail if planet does not have owner" do
      @planet.player = nil
      lambda do
        @planet.explore!(@x, @y)
      end.should raise_error(GameLogicError)
    end

    it "should fail if already exploring" do
      @planet.explore!(@x, @y)
      lambda do
        @planet.explore!(@x, @y)
      end.should raise_error(GameLogicError)
    end

    it "should fail if player does not have enough scientists" do
      @player.scientists = 1
      @player.save!
      lambda do
        @planet.explore!(@x, @y)
      end.should raise_error(GameLogicError)
    end

    it "should fail if given coords are not of exploration tile" do
      Tile.update_all({:kind => Tile::ORE}, {:planet_id => @planet.id})
      lambda do
        @planet.explore!(@x, @y)
      end.should raise_error(GameLogicError)
    end

    it "should fail if given coords are not of a tile" do
      Tile.delete_all({:planet_id => @planet.id})
      lambda do
        @planet.explore!(@x, @y)
      end.should raise_error(GameLogicError)
    end

    it "should store #exploration_x" do
      lambda do
        @planet.explore!(@x, @y)
      end.should change(@planet, :exploration_x).from(nil).to(@x)
    end

    it "should store #exploration_y" do
      lambda do
        @planet.explore!(@x, @y)
      end.should change(@planet, :exploration_y).from(nil).to(@y)
    end

    it "should store #exploration_ends_at" do
      @planet.explore!(@x, @y)
      @planet.exploration_ends_at.should be_close(
        Tile.exploration_time(@kind).since,
        SPEC_TIME_PRECISION)
    end

    it "should reduce scientists from player" do
      lambda do
        @planet.explore!(@x, @y)
        @player.reload
      end.should change(@player, :scientists).by(
        -Tile.exploration_scientists(@kind))
    end

    it "should register a callback" do
      @planet.explore!(@x, @y)
      @planet.should have_callback(
        CallbackManager::EVENT_EXPLORATION_COMPLETE,
        Tile.exploration_time(@kind).since
      )
    end

    it "should fire changed" do
      should_fire_event(@planet, EventBroker::CHANGED) do
        @planet.explore!(@x, @y)
      end
    end
  end

  describe "#stop_exploration!" do
    before(:each) do
      @player = Factory.create(:player, :scientists_total => 1000)
      @planet = Factory.create(:planet, :player => @player)

      @x = 5
      @y = 7
      @folliage = Factory.create(:block_tile, :planet => @planet,
        :kind => Tile::FOLLIAGE_3X3, :x => @x, :y => @y)

      @scientists = Tile.exploration_scientists(@folliage.kind)
      @player.scientists = @player.scientists_total - @scientists
      @player.save!

      @planet.exploration_x = @x
      @planet.exploration_y = @y
      @ends_at = Time.now
      @planet.exploration_ends_at = @ends_at
    end

    it "should return scientists that were exploring" do
      lambda do
        @planet.stop_exploration!
        @player.reload
      end.should change(@player, :scientists).by(@scientists)
    end

    it "should return scientists to given player if it's provided" do
      player = Factory.create(:player)
      lambda do
        @planet.stop_exploration!(player)
        player.reload
      end.should change(player, :scientists).by(@scientists)
    end

    %w{exploration_x exploration_y exploration_ends_at}.each do |attr|
      it "should nullify ##{attr}" do
        lambda do
          @planet.stop_exploration!
        end.should change(@planet, attr).to(nil)
      end
    end

    it "should remove exploration callback" do
      @planet.stop_exploration!
      @planet.should_not have_callback(
        CallbackManager::EVENT_EXPLORATION_COMPLETE, @ends_at)
    end

    it "should dispatch changed" do
      should_fire_event(@planet, EventBroker::CHANGED,
        EventBroker::REASON_OWNER_PROP_CHANGE) do
        @planet.stop_exploration!
      end
    end
  end

  describe "#finish_exploration!" do
    before(:each) do
      @player = Factory.create(:player)
      @planet = Factory.create(:planet, :exploration_x => @x,
        :exploration_y => @y, :player => @player)
      @planet.stub!(:tile_kind).and_return(Tile::FOLLIAGE_4X3)
      @planet.stub!(:stop_exploration!)
      @lucky = [
        {'weight' => 10, 'rewards' => [
            {"kind" => Rewards::UNITS, "type" => "gnat", "count" => 3,
              "hp" => 80}
        ]}
      ]
      @unlucky = [
        {'weight' => 5, 'rewards' => [
            {"kind" => Rewards::UNITS, "type" => "glancer", "count" => 3,
              "hp" => 8}
        ]}
      ]
    end
    
    it "should get winning chance based on width and height" do
      CONFIG.should_receive(:evalproperty).with(
        "tiles.exploration.winning_chance",
        'width' => 4, 'height' => 3
      ).and_return(0)
      Notification.stub!(:create_for_exploration_finished)
      @planet.finish_exploration!
    end

    it "should take win rewards if lucky roll" do
      with_config_values(
        'tiles.exploration.winning_chance' => 100,
        'tiles.exploration.rewards.win.with_units' => @lucky
      ) do
        rewards = Rewards.from_exploration(@lucky[0]['rewards'])
        Rewards.should_receive(:from_exploration).with(
          @lucky[0]['rewards']).and_return(rewards)
        @planet.finish_exploration!
      end
    end

    it "should take lose rewards if unlucky roll" do
      with_config_values(
        'tiles.exploration.winning_chance' => 0,
        'tiles.exploration.rewards.lose.with_units' => @unlucky
      ) do
        rewards = Rewards.from_exploration(@unlucky[0]['rewards'])
        Rewards.should_receive(:from_exploration).with(
          @unlucky[0]['rewards']).and_return(rewards)
        @planet.finish_exploration!
      end
    end

    describe "over population" do
      before(:each) do
        @player.population = @player.population_max
        @player.save!
      end

      it "should take win rewards without units if lucky roll" do
        with_config_values(
          'tiles.exploration.winning_chance' => 100,
          'tiles.exploration.rewards.win.without_units' => @lucky
        ) do
          rewards = Rewards.from_exploration(@lucky[0]['rewards'])
          Rewards.should_receive(:from_exploration).with(
            @lucky[0]['rewards']).and_return(rewards)
          @planet.finish_exploration!
        end
      end

      it "should take lose rewards if unlucky roll" do
        with_config_values(
          'tiles.exploration.winning_chance' => 0,
          'tiles.exploration.rewards.lose.without_units' => @unlucky
        ) do
          rewards = Rewards.from_exploration(@unlucky[0]['rewards'])
          Rewards.should_receive(:from_exploration).with(
            @unlucky[0]['rewards']).and_return(rewards)
          @planet.finish_exploration!
        end
      end
    end

    it "should create notification" do
      Notification.should_receive(:create_for_exploration_finished).with(
        @planet, an_instance_of(Rewards)).and_return(true)
      @planet.finish_exploration!
    end

    it "should claim rewards" do
      rewards = Rewards.new
      Rewards.stub!(:from_exploration).and_return(rewards)
      rewards.should_receive(:claim!).with(@planet, @planet.player)
      @planet.finish_exploration!
    end

    it "should call #stop_exploration!" do
      @planet.should_receive(:stop_exploration!).and_return(true)
      @planet.finish_exploration!
    end

    it "should progress objective" do
      Objective::ExploreBlock.should_receive(:progress).with(@planet)
      @planet.finish_exploration!
    end
  end

  describe "#can_view_resources?" do
    it "should return false if planet is unowned" do
      Factory.create(:planet).can_view_resources?(1).should be_false
    end

    it "should return true if self" do
      planet = Factory.create(:planet_with_player)
      planet.can_view_resources?(planet.player_id).should be_true
    end

    it "should return false otherwise" do
      planet = Factory.create(:planet_with_player)
      planet.can_view_resources?(planet.player_id + 1).should be_false
    end
  end

  describe ".change_resources" do
    before(:each) do
      @planet = Factory.create(:planet)
      @resources = {
        :metal => -100,
        :energy => -120,
        :zetium => -130,
      }
    end

    %w{metal energy zetium}.each do |resource|
      it "should change #{resource}" do
        lambda do
          @planet.class.change_resources(@planet.id, @resources[:metal],
            @resources[:energy], @resources[:zetium])
          @planet.reload
        end.should change(@planet, resource).by(@resources[resource.to_sym])
      end
    end

    it "should dispatch CHANGED" do
      should_fire_event(@planet, EventBroker::CHANGED,
          EventBroker::REASON_OWNER_PROP_CHANGE) do
        @planet.class.change_resources(@planet.id, @resources[:metal],
          @resources[:energy], @resources[:zetium])
      end
    end
  end

  describe ".for_player" do
    it "should return player planets" do
      planet0 = Factory.create :planet_with_player
      planet1 = Factory.create :planet_with_player
      planet2 = Factory.create :planet_with_player,
        :player => planet1.player
      planet3 = Factory.create :planet_with_player

      SsObject::Planet.for_player(planet1.player_id).all.should == [
        planet1, planet2
      ]
    end
  end

  describe "#observer_player_ids" do
    before(:all) do
      @alliance = Factory.create :alliance
      @player = Factory.create :player, :alliance => @alliance
      @ally = Factory.create :player, :alliance => @alliance
      @enemy_with_units = Factory.create :player
      @enemy = Factory.create :player

      @planet = Factory.create :planet, :player => @player
      Factory.create :unit, :location_type => Location::SS_OBJECT,
        :location_id => @planet.id, :player => @enemy_with_units

      @result = @planet.observer_player_ids
    end

    it "should include planet owner" do
      @result.should include(@player.id)
    end

    it "should include alliance members" do
      @result.should include(@ally.id)
    end

    it "should include other players that have units there" do
      @result.should include(@enemy_with_units.id)
    end

    it "should work without owning player" do
      @planet.player = nil
      @planet.save!
      @planet.observer_player_ids.should be_instance_of(Array)
    end

    it "should not include players that do not have units there" do
      @result.should_not include(@enemy.id)
    end
  end

  describe ".buildings" do
    describe ".shooting" do
      it "should return shooting buildings of that planet" do
        planet = Factory.create :planet
        shooting = Factory.create :building, :planet => planet
        Factory.create :b_collector_t1, :planet => planet,
          :x => 10, :y => 10

        with_config_values('buildings.test_building.guns' => [:aa]) do
          planet.buildings.shooting.should == [shooting]
        end
      end
    end
  end

  describe "#units" do
    it "should find planet units" do
      planet = Factory.create :planet_with_player
      player = planet.player
      unit1 = Factory.create :unit, :location => planet, :player => player
      unit2 = Factory.create :unit, :player => player
      unit3 = Factory.create :unit, :location => planet, :player => player
      unit4 = Factory.create :unit, :location => planet, :player => nil

      planet.units.map(&:id).sort.should == [unit1, unit3, unit4].map(&:id).
        sort
    end

    it "should not find units in buildings" do
      planet = Factory.create :planet_with_player
      player = planet.player

      unit1 = Factory.create :unit, :location => planet,
        :player => player
      unit2 = Factory.create :unit,
        :location => Factory.create(:building, :x => 10, :y => 20),
        :player => player
      unit3 = Factory.create :unit, :location => planet,
        :player => player

      planet.units.should == [unit1, unit3]
    end
  end

  describe "object" do
    before(:each) do
      @model = Factory.create(:planet)
    end

    it_should_behave_like "shieldable"
  end

  describe "#as_json" do
    before(:all) do
      @model = Factory.create(:planet)
    end

    it "should include player if it's available" do
      model = Factory.create(:planet_with_player)
      model.as_json["player"].should == Player.minimal(model.player_id)
    end

    describe "without options" do
      before(:all) do
        @options = nil
      end

      @required_fields = %w{name terrain}
      @ommited_fields = %w{width height metal metal_rate metal_storage
        energy energy_rate energy_storage
        zetium zetium_rate zetium_storage
        last_resources_update energy_diminish_registered status
        exploration_x exploration_y exploration_ends_at}
      it_should_behave_like "to json"
    end
    
    describe "with :view" do
      before(:all) do
        @options = {:view => true}
      end

      @required_fields = %w{width height}
      it_should_behave_like "to json"
    end

    describe "with :resources" do
      before(:all) do
        @options = {:resources => true}
      end

      @required_fields = %w{metal metal_rate metal_storage
        energy energy_rate energy_storage
        zetium zetium_rate zetium_storage
        metal_rate_boost_ends_at metal_storage_boost_ends_at
        energy_rate_boost_ends_at energy_storage_boost_ends_at
        zetium_rate_boost_ends_at zetium_storage_boost_ends_at
        last_resources_update exploration_ends_at next_raid_at}
      @ommited_fields = %w{energy_diminish_registered}
      it_should_behave_like "to json"
    end

    describe "with :perspective" do
      before(:all) do
        @player = Factory.create(:player)
        @status = StatusResolver::NPC
      end

      it_should_behave_like "with :perspective"

      describe "viewable" do
        it "should be true if planet is yours" do
          planet = Factory.create(:planet, :player => @player)
          planet.as_json(:perspective => @player)["viewable"].should be_true
        end

        it "should be true if planet is alliance" do
          @player.alliance = Factory.create(:alliance)
          @player.save!

          planet = Factory.create(:planet, :player => Factory.create(
              :player, :alliance => @player.alliance))

          planet.as_json(:perspective => @player)["viewable"].should be_true
        end

        it "should be true if you have units there" do
          planet = Factory.create(:planet)
          Factory.create(:u_trooper, :location => planet,
            :player => @player)
          planet.as_json(:perspective => @player)["viewable"].should be_true
        end

        it "should be true if your alliance has units there" do
          planet = Factory.create(:planet)
          @player.alliance = Factory.create(:alliance)
          @player.save!

          ally = Factory.create(:player, :alliance => @player.alliance)
          Factory.create(:u_trooper, :location => planet, :player => ally)

          planet.as_json(:perspective => @player)["viewable"].should be_true
        end

        it "should be false if planet is enemy" do
          planet = Factory.create(:planet,
            :player => Factory.create(:player))

          planet.as_json(:perspective => @player)["viewable"].should be_false
        end

        it "should be false if planet is nap" do
          @player.alliance = Factory.create(:alliance)
          @player.save!

          nap_alliance = Factory.create(:alliance)
          Factory.create(:nap, :initiator => nap_alliance,
            :acceptor => @player.alliance)
          nap = Factory.create(:player, :alliance => nap_alliance)

          planet = Factory.create(:planet, :player => nap)

          planet.as_json(:perspective => @player)["viewable"].should be_false
        end

        it "should be false if planet is npc" do
          planet = Factory.create(:planet)
          
          planet.as_json(:perspective => @player)["viewable"].should be_false
        end
      end
    end
  end

  describe ".on_callback" do
    describe "energy diminishment" do
      before(:each) do
        @model = Factory.create(:planet_with_player)
        @changes = [
          [Factory.create(:building), Reducer::RELEASED]
        ]
        @model.stub!(:ensure_positive_energy_rate!).and_return(@changes)
        @id = -1
        SsObject::Planet.stub!(:find).with(@id).and_return(@model)
      end

      it "should call #ensure_positive_energy_rate!" do
        @model.should_receive(:ensure_positive_energy_rate!)
        SsObject::Planet.on_callback(@id,
          CallbackManager::EVENT_ENERGY_DIMINISHED)
      end

      it "should create notification with changed things" do
        Notification.should_receive(:create_for_buildings_deactivated).with(
          @model, @changes
        )
        SsObject::Planet.on_callback(@id,
          CallbackManager::EVENT_ENERGY_DIMINISHED)
      end

      it "should not create notification with changed things " +
      "if player is nil" do
        @model.player = nil
        @model.save!
        Notification.should_not_receive(:create_for_buildings_deactivated)
        SsObject::Planet.on_callback(@id,
          CallbackManager::EVENT_ENERGY_DIMINISHED)
      end

      it "should not create notification if nothing was changed" do
        @model.stub!(:ensure_positive_energy_rate!).and_return([])
        Notification.should_not_receive(:create_for_buildings_deactivated)
        SsObject::Planet.on_callback(@id,
          CallbackManager::EVENT_ENERGY_DIMINISHED)
      end

      it "should fire CHANGED to EB" do
        should_fire_event(@model, EventBroker::CHANGED) do
          SsObject::Planet.on_callback(@id,
            CallbackManager::EVENT_ENERGY_DIMINISHED)
        end
      end
    end

    describe "exploration finished" do
      it "should finish exploration" do
        id = 10
        mock = mock(SsObject::Planet)
        SsObject::Planet.should_receive(:find).with(id).and_return(mock)
        mock.should_receive(:finish_exploration!)
        SsObject::Planet.on_callback(id,
          CallbackManager::EVENT_EXPLORATION_COMPLETE)
      end
    end

    describe "npc raid" do
      it "should call Combat.npc_raid!" do
        id = 10
        mock = mock(SsObject::Planet)
        SsObject::Planet.should_receive(:find).with(id).and_return(mock)
        Combat.should_receive(:npc_raid!).with(mock)
        SsObject::Planet.on_callback(id, CallbackManager::EVENT_RAID)
      end
    end
  end

  describe "#after_find" do
    it "should recalculate if needed" do
      model = Factory.create :planet,
        :last_resources_update => 10.seconds.ago
      model.should_receive(:recalculate!).once
      model.send :recalculate_if_unsynced!
    end

    it "should not recalculate if not needed" do
      model = Factory.create :planet,
        :last_resources_update => nil
      model.should_not_receive(:recalculate!)
      model.send :recalculate_if_unsynced!
    end
  end

  describe "energy diminishment" do
    describe "rate negative" do
      before(:each) do
        @model = Factory.create :planet,
          :last_resources_update => Time.now.drop_usec,
          :energy_rate => -3
        @model.energy_storage = 1000
        @seconds = 200
        @model.energy = @model.energy_rate * -1 * @seconds - 1
      end

      it "should register to CallbackManager" do
        @model.save!
        @model.should have_callback(CallbackManager::EVENT_ENERGY_DIMINISHED,
          @seconds.from_now)
      end

      it "should flag register" do
        @model.stub!(:id).and_return(1)
        lambda do
          @model.save!
        end.should change(@model, :energy_diminish_registered?).from(
          false).to(true)
      end

      it "should update registration to CallbackManager if " +
      "it has already registered" do
        CallbackManager.register(@model,
          CallbackManager::EVENT_ENERGY_DIMINISHED,
          (@seconds + 10.minutes).from_now
        )
        @model.energy_diminish_registered = true
        
        @model.save!
        @model.should have_callback(CallbackManager::EVENT_ENERGY_DIMINISHED,
          @seconds.from_now)
      end
    end

    describe "rate positive" do
      before(:each) do
        @model = Factory.create :planet,
          :last_resources_update => Time.now.drop_usec,
          :energy_rate => 3
        @model.energy_storage = 1000
        @model.energy = 29
      end

      it "should not register to CallbackManager" do
        CallbackManager.should_not_receive(:register)
        @model.save!
      end

      it "should unregister from CallbackManager if we are registered" do
        @model.energy_diminish_registered = true

        CallbackManager.should_receive(:unregister).with(@model,
          CallbackManager::EVENT_ENERGY_DIMINISHED)
        @model.save!
      end

      it "should unflag energy diminishment if we are registered" do
        @model.energy_diminish_registered = true
        @model.stub!(:id).and_return(1)

        @model.save!
        @model.energy_diminish_registered?.should be_false
      end

      it "should not unregister from CallbackManager " +
      "if we are not registered" do
        @model.energy_diminish_registered = false

        CallbackManager.should_not_receive(:unregister)
        @model.save!
      end
    end
  end

  describe "#ensure_positive_energy_rate!" do
    before(:each) do
      @planet = Factory.build :planet

      @planet.energy_storage = 10000
      @planet.energy = 1000
      @planet.last_resources_update = Time.now
      @planet.energy_rate = -7
      @planet.save!

      @b0 = Factory.create :building_built, opts_active + {
        :planet => @planet, :x => 0, :y => 2}
      @b1 = Factory.create :b_test_energy_user1, :planet => @planet,
        :x => 0, :y => 0
      @b2 = Factory.create :b_test_energy_user2, :planet => @planet,
        :x => 2, :y => 0
      @b3 = Factory.create :b_test_energy_user3, :planet => @planet,
        :x => 4, :y => 0
      @b4 = Factory.create :b_test_energy_user4, :planet => @planet,
        :x => 6, :y => 0
    end

    it "should not touch buildings that do not use energy" do
      @planet.ensure_positive_energy_rate!

      @b0.reload; @b0.should be_active
    end

    it "should not touch buildings that are inactive" do
      @b1.deactivate!
      lambda do
        @planet.ensure_positive_energy_rate!
      end.should_not raise_error
    end

    it "should deactivate buildings to restore rate" do
      @planet.ensure_positive_energy_rate!

      @planet.energy_rate.should == 0

      @b1.reload; @b1.should be_inactive
      @b2.reload; @b2.should be_inactive
      @b3.reload; @b3.should be_active
      @b4.reload; @b4.should be_inactive
    end

    it "should return changes" do
      @planet.ensure_positive_energy_rate!.sort_by { |e| e[0].id }.should == [
        [@b1, Reducer::RELEASED],
        [@b2, Reducer::RELEASED],
        [@b4, Reducer::RELEASED],
      ].sort_by { |e| e[0].id }
    end
  end

  describe "#resource_modifier_technologies" do
    it "should not use technologies of level 0" do
      model = Factory.create :planet_with_player
      tech = Factory.create :t_test_resource_mod,
        :player => model.player, :level => 0

      model.send(
        :resource_modifier_technologies
      ).should_not include(tech)
    end

    it "should use technologies of level > 0" do
      model = Factory.create :planet_with_player
      tech = Factory.create :t_test_resource_mod,
        :player => model.player, :level => 1

      model.send(
        :resource_modifier_technologies
      ).should include(tech)
    end
  end

  describe "#recalculate" do
    before(:all) do
      @resource = 100.0
      @rate = 7.0
    end

    it "should consider time diff since last update" do
      diff = 30
      model = Factory.build :planet,
        :metal_rate => @rate,
        :last_resources_update => diff.seconds.ago.drop_usec

      model.metal_storage = @resource * 100
      model.metal = @resource
      model.save!

      # We might not be there in same second.
      diff = Time.now.drop_usec - model.last_resources_update
      lambda do
        model.send(:recalculate)
      end.should change(model, :metal).from(@resource).to(
        @resource + @rate * diff)
    end

    it "should update #last_resources_update" do
      model = Factory.build :planet,
        :last_resources_update => 30.seconds.ago.drop_usec
      model.send :recalculate
      model.last_resources_update.drop_usec.should == Time.now.drop_usec
    end

    %w{metal energy zetium}.each do |type|
      it "should update #{type}" do
        model = Factory.build :planet,
          "#{type}_rate" => @rate,
          :last_resources_update => 1.second.ago.drop_usec

        model.send("#{type}_storage=", @resource + @rate * 2000)
        model.send("#{type}=", @resource)
        model.save!

        # We might not be there in same second.
        diff = Time.now.drop_usec - model.last_resources_update
        lambda do
          model.send :recalculate
        end.should change(model, type).from(@resource).to(
          @resource + @rate * diff
        )
      end

      it "should not store more resources than storage allows" do
        storage_max = @resource + @rate / 2
        model = Factory.build :planet,
          "#{type}_rate" => @rate, :last_resources_update => 1.minute.ago

        model.send("#{type}_storage=", storage_max)
        model.send("#{type}=", @resource)
        model.save!

        lambda do
          model.send :recalculate
        end.should change(model, type).from(@resource).to(storage_max)
      end

      it "should not go to negative numbers" do
        resource = 10
        model = Factory.build :planet,
          "#{type}_rate" => -30, :last_resources_update => 1.minute.ago

        model.send("#{type}_storage=", resource)
        model.send("#{type}=", resource)
        model.save!

        lambda {
          model.send :recalculate
        }.should change(model, type).from(resource).to(0)
      end

      it "should consider added mods for #{type} rate" do
        rate = 0.02
        percent = 34
        model = Factory.create :planet, :"#{type}_storage" => 10000,
          type => 0, :"#{type}_rate" => rate,
          :last_resources_update => 5.minutes.ago
        model.stub!(:resource_modifiers).and_return(type.to_sym => percent)

        # We might not be there in same second.
        diff = (Time.now - model.last_resources_update).to_i
        lambda do
          model.send :recalculate
        end.should change(model, type).to(
          rate * diff * (1 + percent.to_f / 100)
        )
      end

      it "should consider added mods for #{type} storage" do
        storage = 1232
        mod = :"#{type}_storage"
        percent = 34
        model = Factory.create :planet, mod => storage, type => 0
        model.stub!(:resource_modifiers).and_return(mod => percent)

        lambda do
          model.send("#{type}=", 2 * storage)
        end.should change(model, type).to(
          storage * (1 + percent.to_f / 100)
        )
      end
    end
  end

  describe "#resource_modifiers" do
    before(:each) do
      @player = Factory.create(:player)
      @planet = Factory.create(:planet, :player => @player)
    end

    %w{metal energy zetium}.each do |resource|
      describe "from techs" do
        before(:each) do
          @tech = Factory.create :t_test_resource_mod, :player => @player
        end

        it "should add #{resource} mod for rate" do
          mod = resource.to_sym
          @planet.send(:resource_modifiers, true)[mod].
            should == @tech.resource_modifiers[mod]
        end

        it "should add #{resource} mod for storage" do
          mod = "#{resource}_storage".to_sym
          @planet.send(:resource_modifiers, true)[mod].
            should == @tech.resource_modifiers[mod]
        end
      end

      describe "from boosts" do
        it "should add #{resource} mod for rate" do
          @planet.stub!("#{resource}_rate_boosted?").and_return(true)
          @planet.send(:resource_modifiers, true)[resource.to_sym].should ==
            CONFIG['creds.planet.resources.boost']
        end

        it "should add #{resource} mod for storage" do
          mod = "#{resource}_storage".to_sym
          @planet.stub!("#{resource}_storage_boosted?").and_return(true)
          @planet.send(:resource_modifiers, true)[mod].should ==
            CONFIG['creds.planet.resources.boost']
        end
      end
    end
  end

  describe ".changing_viewable" do
    describe "location is planet" do
      before(:each) do
        @planet = Factory.create(:planet)
        @unit = Factory.create(:unit, :location => @planet)
      end

      it "should fire changed on planet if observer ids changed" do
        should_fire_event(@planet, EventBroker::CHANGED) do
          SsObject::Planet.changing_viewable(@planet.location_point) do
            @unit.destroy
          end
        end
      end

      it "should fire changed on first location that is planet" do
        should_fire_event(@planet, EventBroker::CHANGED) do
          SsObject::Planet.changing_viewable([
              GalaxyPoint.new(1, 0, 0),
              @planet.location_point,
              Factory.create(:planet).location_point
          ]) do
            @unit.destroy
          end
        end
      end

      it "should not fire changed if observer ids didn't change" do
        should_not_fire_event(@planet, EventBroker::CHANGED) do
          SsObject::Planet.changing_viewable(@planet.location_point) { }
        end
      end
    end

    describe "location is not a planet" do
      it "should simply return block value" do
        SsObject::Planet.changing_viewable(GalaxyPoint.new(1, 0, 0)) do
          "a"
        end.should == "a"
      end
    end
  end
end