# encoding: UTF-8
require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

class Technology::TestResourceMod < Technology
  include Parts::ResourceIncreasingTechnology
end
Factory.define :t_test_resource_mod, :class => Technology::TestResourceMod,
:parent => :technology do |m|
  m.level 1
end

describe SsObject::Planet do
  describe "#client_location" do
    it "should delegate to #location_point" do
      planet = Factory.create(:planet)
      mock = mock(LocationPoint)
      planet.should_receive(:location_point).and_return(mock)
      mock.should_receive(:client_location)
      planet.client_location
    end
  end

  describe "#next_raid_at=" do
    let(:planet) { Factory.create(:planet) }

    it "should not allow assigning nils" do
      lambda do
        planet.next_raid_at = nil
      end.should raise_error(ArgumentError)
    end

    it "should allow changing values" do
      value = 10.minutes.from_now
      lambda do
        planet.next_raid_at = value
      end.should change(planet, :next_raid_at).to(value)
    end
  end

  describe "boosts" do
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

    SsObject::Planet::RESOURCES.each do |resource|
      it "should not boost negative #{resource} rate" do
        Factory.build(:planet, 
          :"#{resource}_rate_boost_ends_at" => 10.minutes.from_now,
          :"#{resource}_generation_rate" => 0,
          :"#{resource}_usage_rate" => 10
        ).send(:"#{resource}_rate").should == -10
      end
    end
    
    describe "#boost!" do
      before(:each) do
        @player = Factory.create(:player, 
          :creds => CONFIG['creds.planet.resources.boost.cost'])
        @planet = Factory.create(:planet, :player => @player)
      end
      
      it "should fail if player does not have enough creds" do
        @player.creds -= 1
        @player.save!
        
        lambda do
          @planet.boost!(:metal, :rate)
        end.should raise_error(GameLogicError)
      end

      it "should fail if we use unknown resource" do
        lambda do
          @planet.boost!(:food, :rate)
        end.should raise_error(GameLogicError)
      end

      it "should fail if we use unknown attribute" do
        lambda do
          @planet.boost!(:metal, :color)
        end.should raise_error(GameLogicError)
      end

      it "should set boost expiration date" do
        @planet.boost!(:metal, :rate)
        @planet.reload
        @planet.metal_rate_boost_ends_at.should be_within(
          SPEC_TIME_PRECISION
        ).of(Cfg.planet_boost_duration.from_now)
      end

      it "should increase boost expiration date if already set" do
        @planet.metal_rate_boost_ends_at = 3.days.from_now
        @planet.save!

        @planet.boost!(:metal, :rate)
        @planet.reload
        @planet.metal_rate_boost_ends_at.should be_within(
          SPEC_TIME_PRECISION
        ).of((3.days + Cfg.planet_boost_duration).from_now)
      end
      
      it "should set boost expiration date from now if boost is expired" do
        @planet.metal_rate_boost_ends_at = 3.days.ago
        @planet.save!

        @planet.boost!(:metal, :rate)
        @planet.reload
        @planet.metal_rate_boost_ends_at.should be_within(
          SPEC_TIME_PRECISION
        ).of(Cfg.planet_boost_duration.from_now)
      end

      it "should reduce creds from player" do
        lambda do
          @planet.boost!(:metal, :rate)
          @player.reload
        end.should change(@player, :creds).to(0)
      end

      it "should dispatch changed on planet" do
        should_fire_event(@planet, EventBroker::CHANGED,
            EventBroker::REASON_OWNER_PROP_CHANGE) do
          @planet.boost!(:metal, :rate)
        end
      end

      it "should record cred stats" do
        should_record_cred_stats(:boost, [@player, :metal, :rate]) \
          { @planet.boost!(:metal, :rate) }
      end
    end
  end
  
  describe "#name" do
    before(:each) do
      @min = CONFIG['planet.validation.name.length.min']
      @max = CONFIG['planet.validation.name.length.max']
      @model = Factory.build(:planet)
    end

    it_behaves_like "name validation"
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
      @old = Factory.create(:player, planets_count: 5, bg_planets_count: 8)
      @new = Factory.create(:player, planets_count: 10, bg_planets_count: 12)
      @planet = Factory.create :planet, :player => @old
      @planet.player = @new
    end

    it "should call handler" do
      handler = SsObject::Planet::OwnerChangeHandler.new(@planet, @old, @new)
      SsObject::Planet::OwnerChangeHandler.should_receive(:new).
        with(@planet, @old, @new).and_return(handler)
      handler.should_receive(:handle!)
      @planet.save!
    end

    it "should save new #owner_changed" do
      @planet.save!
      @planet.owner_changed.should be_within(SPEC_TIME_PRECISION).of(Time.now)
    end
  end
  
  describe "#increase" do
    it "should dispatch event when saved" do
      model = Factory.create(:planet)
      model.increase(:metal_generation_rate => 10)
      
      should_fire_event(model, EventBroker::CHANGED,
        EventBroker::REASON_OWNER_PROP_CHANGE) do
        model.save!
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
      @planet.exploration_ends_at.should be_within(SPEC_TIME_PRECISION).of(
        Tile.exploration_time(@kind).since
      )
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
      should_fire_event(@planet, EventBroker::CHANGED, 
          EventBroker::REASON_OWNER_PROP_CHANGE) do
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
    
    it "should not fail if planet has no player" do
      @planet.player = nil
      @planet.stop_exploration!
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
        :exploration_y => @y, :exploration_ends_at => 10.minutes.from_now,
        :player => @player)
      @planet.stub!(:tile_kind).and_return(Tile::FOLLIAGE_4X3)
      @width = 4
      @height = 3
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
      @lucky_wo_units = [
        {'weight' => 10, 'rewards' => [
            {"kind" => Rewards::METAL, "count" => 100}
        ]}
      ]
      @unlucky_wo_units = [
        {'weight' => 5, 'rewards' => [
            {"kind" => Rewards::ENERGY, "count" => 10}
        ]}
      ]
    end
    
    it "should fail if not exploring" do
      @planet.finish_exploration!
      lambda do
        @planet.finish_exploration!
      end.should raise_error(GameLogicError)
    end
    
    describe "when planet has no owner" do
      before(:each) do
        @planet.player = nil
      end
      
      it "should stop exploration" do
        @planet.should_receive(:stop_exploration!)
        @planet.finish_exploration!
      end
      
      it "should return false" do
        @planet.finish_exploration!.should be_false
      end
    end
    
    it "should get winning chance based on width and height" do
      Cfg.should_receive(:exploration_win_chance).with(@width, @height).
        and_return(0)
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
        reward = @lucky_wo_units
        with_config_values(
          'tiles.exploration.winning_chance' => 100,
          'tiles.exploration.rewards.win.without_units' => reward
        ) do
          rewards = Rewards.from_exploration(reward[0]['rewards'])
          Rewards.should_receive(:from_exploration).with(
            reward[0]['rewards']).and_return(rewards)
          @planet.finish_exploration!
        end
      end

      it "should take lose rewards if unlucky roll" do
        reward = @unlucky_wo_units
        with_config_values(
          'tiles.exploration.winning_chance' => 0,
          'tiles.exploration.rewards.lose.without_units' => reward
        ) do
          rewards = Rewards.from_exploration(reward[0]['rewards'])
          Rewards.should_receive(:from_exploration).with(
            reward[0]['rewards']).and_return(rewards)
          @planet.finish_exploration!
        end
      end
    end

    describe "with creds" do
      it "should fail if player does not have enough creds" do
        @player.creds = 0
        @player.save!
        
        lambda do
          @planet.finish_exploration!(true)
        end.should raise_error(GameLogicError)
      end
      
      it "should reduce creds from player" do
        @player.pure_creds = 1000
        @player.save!
        creds = Cfg.exploration_finish_cost(@width, @height)
                
        lambda do
          @planet.finish_exploration!(true)
          @player.reload
        end.should change(@player, :creds).by(- creds)
      end
      
      it "should record cred stats" do
        @player.pure_creds = 1000
        @player.save!
        
        should_record_cred_stats(
          :finish_exploration, [@player, @width, @height]
        ) { @planet.finish_exploration!(true) }
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

  describe "#remove_foliage!" do
    before(:each) do
      @player = Factory.create(:player, 
        :creds => Cfg.foliage_removal_cost(6, 6))
      @planet = Factory.create(:planet, :player => @player)
      @x = 10; @y = 2
      @tile = Factory.create(:t_folliage_6x6, :planet => @planet,
        :x => @x, :y => @y)
    end
    
    it "should fail if exploring" do
      @planet.stub!(:exploring?).and_return(true)
      lambda do
        @planet.remove_foliage!(@x, @y)
      end.should raise_error(GameLogicError)
    end

    it "should fail if planet is in battleground solar system" do
      ss = @planet.solar_system
      ss.kind = SolarSystem::KIND_BATTLEGROUND
      ss.save!

      lambda do
        @planet.remove_foliage!(@x, @y)
      end.should raise_error(GameLogicError)
    end
    
    it "should fail if given wrong coordinates" do
      lambda do
        @planet.remove_foliage!(@x + 1, @y)
      end.should raise_error(GameLogicError)
    end
    
    it "should fail if trying to remove non-exploration tile" do
      @tile.kind = Tile::SAND
      @tile.save!
      
      lambda do
        @planet.remove_foliage!(@x, @y)
      end.should raise_error(GameLogicError)
    end
    
    it "should fail if planet has no player" do
      @planet.player = nil
      
      lambda do
        @planet.remove_foliage!(@x, @y)
      end.should raise_error(GameLogicError)
      
    end
    
    it "should fail if not enough creds" do
      @player.creds -= 1
      @player.save!
      
      lambda do
        @planet.remove_foliage!(@x, @y)
      end.should raise_error(GameLogicError)
    end
    
    it "should reduce creds from player" do
      lambda do
        @planet.remove_foliage!(@x, @y)
        @player.reload
      end.should change(@player, :creds).to(0)
    end
    
    it "should record cred stats" do
      should_record_cred_stats(:remove_foliage, [@player, 6, 6]) \
        { @planet.remove_foliage!(@x, @y) }
    end
    
    it "should destroy the tile" do
      @planet.remove_foliage!(@x, @y)
      
      lambda do
        @tile.reload
      end.should raise_error(ActiveRecord::RecordNotFound)
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
      
      @enemy_allliance = Factory.create(:alliance)
      @enemy_with_units = Factory.create :player, 
        :alliance => @enemy_allliance
      @enemy_ally = Factory.create :player, 
        :alliance => @enemy_allliance
      @enemy = Factory.create :player

      @planet = Factory.create :planet, :player => @player
      Factory.create :unit_built, location: @planet, player: @enemy_with_units

      @result = @planet.observer_player_ids
    end

    it "should include planet owner" do
      @result.should include(@player.id)
    end

    it "should include owners alliance members" do
      @result.should include(@ally.id)
    end

    it "should include other players that have units there" do
      @result.should include(@enemy_with_units.id)
    end
    
    it "should include player which belong to enemy alliance which has units" do
      @result.should include(@enemy_ally.id)
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
    describe ".combat" do
      it "should return buildings of that planet that participate " +
      "in combat" do
        planet = Factory.create :planet
        combat_building = Factory.create :building, :planet => planet
        Factory.create :b_collector_t1, :planet => planet,
          :x => 10, :y => 10

        with_config_values('buildings.test_building.guns' => [:aa]) do
          planet.buildings.combat.should == [combat_building]
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

  describe "#as_json" do
    it "should include player if it's available" do
      model = Factory.create(:planet_with_player)
      model.as_json["player"].should == Player.minimal(model.player_id)
    end

    describe "without options" do
      it_behaves_like "as json", Factory.create(:planet), nil,
        %w{name terrain width height},
        %w{metal metal_generation_rate metal_usage_rate metal_storage
          energy energy_generation_rate energy_usage_rate energy_storage
          zetium zetium_generation_rate metal_usage_rate zetium_storage
          last_resources_update energy_diminish_registered status
          exploration_x exploration_y exploration_ends_at
          next_raid_at raid_arg
        }
    end
    
    describe "with :view" do
      it_behaves_like "as json", Factory.create(:planet), {:view => true},
        %w{},
        %w{next_raid_at raid_arg energy_diminish_registered
          metal metal_generation_rate metal_usage_rate metal_storage
          energy energy_generation_rate energy_usage_rate energy_storage
          zetium zetium_generation_rate zetium_usage_rate zetium_storage
          last_resources_update}
    end

    describe "with :owner" do
      it_behaves_like "as json", Factory.create(:planet), {:owner => true},
        %w{
        metal_rate_boost_ends_at metal_storage_boost_ends_at
        energy_rate_boost_ends_at energy_storage_boost_ends_at
        zetium_rate_boost_ends_at zetium_storage_boost_ends_at
        exploration_x exploration_y exploration_ends_at
        can_destroy_building_at
        next_raid_at raid_arg owner_changed
        metal metal_generation_rate metal_usage_rate metal_storage
        energy energy_generation_rate energy_usage_rate energy_storage
        zetium zetium_generation_rate zetium_usage_rate zetium_storage
        last_resources_update
        },
        %w{energy_diminish_registered}
    end

    describe "with :index" do
      it_behaves_like "as json", Factory.create(:planet), {:index => true},
        %w{
        metal metal_generation_rate metal_usage_rate metal_storage
        energy energy_generation_rate energy_usage_rate energy_storage
        zetium zetium_generation_rate zetium_usage_rate zetium_storage
        metal_rate_boost_ends_at metal_storage_boost_ends_at
        energy_rate_boost_ends_at energy_storage_boost_ends_at
        zetium_rate_boost_ends_at zetium_storage_boost_ends_at
        last_resources_update
        next_raid_at raid_arg
        },
        %w{energy_diminish_registered}
    end

    describe "with :perspective" do
      it_behaves_like "with :perspective",
        Factory.create(:planet),
        Factory.create(:player),
        StatusResolver::NPC

      describe "viewable" do
        let(:player) { Factory.create(:player) }

        it "should be true if planet is yours" do
          planet = Factory.create(:planet, :player => player)
          planet.as_json(:perspective => player)["viewable"].should be_true
        end

        it "should be true if planet is alliance" do
          player.alliance = Factory.create(:alliance)
          player.save!

          planet = Factory.create(:planet, :player => Factory.create(
              :player, :alliance => player.alliance))

          planet.as_json(:perspective => player)["viewable"].should be_true
        end

        it "should be true if you have units there" do
          planet = Factory.create(:planet)
          Factory.create(:u_trooper, :location => planet,
            :player => player)
          planet.as_json(:perspective => player)["viewable"].should be_true
        end

        it "should be true if your alliance has units there" do
          planet = Factory.create(:planet)
          player.alliance = Factory.create(:alliance)
          player.save!

          ally = Factory.create(:player, :alliance => player.alliance)
          Factory.create(:u_trooper, :location => planet, :player => ally)

          planet.as_json(:perspective => player)["viewable"].should be_true
        end

        it "should be false if planet is enemy" do
          planet = Factory.create(:planet,
            :player => Factory.create(:player))

          planet.as_json(:perspective => player)["viewable"].should be_false
        end

        it "should be false if planet is nap" do
          player.alliance = Factory.create(:alliance)
          player.save!

          nap_alliance = Factory.create(:alliance)
          Factory.create(:nap, :initiator => nap_alliance,
            :acceptor => player.alliance)
          nap = Factory.create(:player, :alliance => nap_alliance)

          planet = Factory.create(:planet, :player => nap)

          planet.as_json(:perspective => player)["viewable"].should be_false
        end

        it "should be false if planet is npc" do
          planet = Factory.create(:planet)
          
          planet.as_json(:perspective => player)["viewable"].should be_false
        end
      end
    end
  end

  describe "callbacks" do
    describe ".energy_diminished_callback" do
      before(:each) do
        @model = Factory.create(:planet_with_player)
        @changes = [
          [Factory.create(:building), Reducer::RELEASED]
        ]
        @model.stub!(:ensure_positive_energy_rate!).and_return(@changes)
      end

      it "should have scope defined" do
        SsObject::ENERGY_DIMINISHED_SCOPE
      end

      it "should call #ensure_positive_energy_rate!" do
        @model.should_receive(:ensure_positive_energy_rate!)
        SsObject.energy_diminished_callback(@model)
      end

      it "should create notification with changed things" do
        Notification.should_receive(:create_for_buildings_deactivated).with(
          @model, @changes
        )
        SsObject.energy_diminished_callback(@model)
      end

      it "should not create notification with changed things " +
      "if player is nil" do
        @model.player = nil
        @model.save!
        Notification.should_not_receive(:create_for_buildings_deactivated)
        SsObject.energy_diminished_callback(@model)
      end

      it "should not create notification if nothing was changed" do
        @model.stub!(:ensure_positive_energy_rate!).and_return([])
        Notification.should_not_receive(:create_for_buildings_deactivated)
        SsObject.energy_diminished_callback(@model)
      end

      it "should fire CHANGED to EB" do
        should_fire_event(@model, EventBroker::CHANGED) do
          SsObject.energy_diminished_callback(@model)
        end
      end
    end

    describe ".exploration_complete_callback" do
      it "should have scope defined" do
        SsObject::EXPLORATION_COMPLETE_SCOPE
      end

      it "should finish exploration" do
        mock = mock(SsObject::Planet)
        mock.should_receive(:finish_exploration!)
        SsObject.exploration_complete_callback(mock)
      end
    end

    describe ".raid_callback" do
      it "should have scope defined" do
        SsObject::RAID_SCOPE
      end

      it "should call RaidSpawner#raid!" do
        planet = Factory.create(:planet_with_player)
        spawner = mock(RaidSpawner)
        RaidSpawner.should_receive(:new).with(planet).and_return(spawner)
        spawner.should_receive(:raid!)
        SsObject.raid_callback(planet)
      end
    end
  end

  describe "#after_find" do
    it "should recalculate if needed" do
      model = Factory.create :planet, :last_resources_update => 10.seconds.ago
      model.should_receive(:recalculate).once
      model.send :recalculate_if_unsynced
    end

    it "should not recalculate if not needed" do
      model = Factory.create :planet, :last_resources_update => nil
      model.should_not_receive(:recalculate)
      model.send :recalculate_if_unsynced
    end
  end

  describe "energy diminishment" do
    describe "rate negative" do
      before(:each) do
        @model = Factory.create :planet,
          :last_resources_update => Time.now.drop_usec,
          :energy_generation_rate => 0, :energy_usage_rate => 3
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
          :energy_generation_rate => 3, :energy_usage_rate => 0
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
      @planet.energy_generation_rate = 0
      @planet.energy_usage_rate = 7
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
      tech = Factory.create :t_test_resource_mod, player: model.player, level: 0

      model.send(:resource_modifier_technologies).should_not include(tech)
    end

    it "should use technologies of level > 0" do
      model = Factory.create :planet_with_player
      tech = Factory.create :t_test_resource_mod, player: model.player, level: 1

      model.send(:resource_modifier_technologies).should include(tech)
    end
  end

  describe "resource storage methods" do
    Resources::TYPES.each do |resource|
      w_mod = "#{resource}_storage_with_modifier"
      wo_mod = "#{resource}_storage"
      describe "##{w_mod}" do
        it "should return greater value than without modifiers" do
          planet = Factory.build(:planet)
          planet.should_receive(:resource_modifier).with(wo_mod).and_return(1.5)

          planet.send(w_mod).should == planet.send(wo_mod) * 1.5
        end
      end
    end
  end

  describe "#mass_repair!" do
    let(:player) { Factory.create(:player) }
    let(:technology) do
      Factory.create!(:t_building_repair, level: 1, player: player)
    end
    let(:planet) { set_resources(Factory.create(:planet, player: player)) }
    let(:buildings) do
      opts = opts_active + opts_built + {planet: planet}
      [
        Factory.create!(:b_vulcan, opts + {x: 0, hp_percentage: 0.11}),
        Factory.create!(:b_vulcan, opts + {x: 3, hp_percentage: 0.15}),
        Factory.create!(:b_vulcan, opts + {x: 6, hp_percentage: 0.21}),
      ]
    end

    before(:each) do
      technology
    end

    it "should fail if there are buildings which are not repairable" do
      lambda do
        planet.mass_repair!(buildings + [
          Factory.create(:b_barracks, planet: planet, x: 10, hp_percentage: 0.5)
        ])
      end.should raise_error(GameLogicError)
    end

    it "should fail if there are buildings not on this planet" do
      lambda do
        planet.mass_repair!(buildings + [
          Factory.create!(
            :b_vulcan,
            planet: Factory.create(:planet), x: 10, hp_percentage: 0.5
          )
        ])
      end.should raise_error(GameLogicError)
    end

    it "should get building repair technology" do
      Technology::BuildingRepair.should_receive(:get!).with(player.id).
        and_return(technology)
      planet.mass_repair!(buildings)
    end

    it "should call #mass_repair on each of the buildings" do
      buildings.each do |b|
        b.should_receive(:mass_repair).with(planet, technology).and_return do
          |*args|

          # Callback registration uses this later.
          b.cooldown_ends_at = 5.minutes.from_now
          50
        end
      end
      planet.mass_repair!(buildings)
    end

    it "should register cooldown expired callback on each of the buildings" do
      planet.mass_repair!(buildings)
      buildings.each do |building|
        building.should have_callback(
          CallbackManager::EVENT_COOLDOWN_EXPIRED, building.cooldown_ends_at
        )
      end
    end

    it "should save all buildings" do
      planet.mass_repair!(buildings)
      buildings.each { |building| building.should be_saved }
    end

    it "should save the planet" do
      planet.mass_repair!(buildings)
      planet.should be_saved
    end

    it "should fire changed with the buildings" do
      should_fire_event(buildings, EventBroker::CHANGED) do
        planet.mass_repair!(buildings)
      end
    end

    it "should fire changed with the planet" do
      should_fire_event(
        planet, EventBroker::CHANGED, EventBroker::REASON_OWNER_PROP_CHANGE
      ) do
        planet.mass_repair!(buildings)
      end
    end

    it "should progress Objective::RepairHp" do
      damaged_hp = buildings.sum(&:damaged_hp)
      Objective::RepairHp.should_receive(:progress).with(player, damaged_hp)
      planet.mass_repair!(buildings)
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
        :metal_generation_rate => @rate,
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
      rate_str = "#{type}_generation_rate"
      
      it "should update #{type}" do
        model = Factory.build :planet,
          rate_str => @rate,
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
          rate_str => @rate, 
          :last_resources_update => 1.minute.ago

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
          rate_str => -30, :last_resources_update => 1.minute.ago

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
          type => 0, rate_str => rate,
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
        @unit = Factory.create(:unit_built, :location => @planet)
      end

      describe "if observer ids changed" do
        it "should fire changed on planet" do
          should_fire_event(@planet, EventBroker::CHANGED) do
            SsObject::Planet.changing_viewable(@unit.location) do
              @unit.delete
            end
          end
        end

        it "should fire created with Event::PlanetObserversChange" do
          event = Event::PlanetObserversChange.
            new(@planet.id, [@unit.player_id])
          should_fire_event(event, EventBroker::CREATED) do
            SsObject::Planet.changing_viewable(@unit.location) do
              @unit.delete
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
              @unit.delete
            end
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