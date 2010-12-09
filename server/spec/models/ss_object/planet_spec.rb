require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

class Technology::TestResourceMod < Technology
  include Parts::ResourceIncreasingTechnology
end
Factory.define :t_test_resource_mod, :class => Technology::TestResourceMod,
:parent => :technology do |m|
  m.level 1
end

describe SsObject::Planet do
  describe "player changing" do
    before(:each) do
      @old = Factory.create(:player)
      @new = Factory.create(:player)
      @planet = Factory.create :planet, :player => @old
      @planet.player = @new
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
      end.should change(constructable, :player_id).from(@old.id).to(@new.id)
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
      @planet.exploration_ends_at.to_s(:db).should ==
        Tile.exploration_time(@kind).since.to_s(:db)
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
      should_fire_event(@planet, EventBroker::CHANGED) do
        @planet.stop_exploration!
      end
    end
  end

  describe "#finish_exploration!" do
    before(:each) do
      @planet = Factory.create(:planet_with_player, :exploration_x => @x,
        :exploration_y => @y)
      @planet.stub!(:tile_kind).and_return(Tile::FOLLIAGE_4X3)
      @planet.stub!(:stop_exploration!)
      @lucky = [
        {'weight' => 10, 'rewards' => [
            {"kind" => "unit", "type" => "gnat", "count" => 3, "hp" => 80}
        ]}
      ]
      @unlucky = [
        {'weight' => 5, 'rewards' => [
            {"kind" => "unit", "type" => "glancer", "count" => 3, "hp" => 8}
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
        'tiles.exploration.rewards.win' => @lucky
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
        'tiles.exploration.rewards.lose' => @unlucky
      ) do
        rewards = Rewards.from_exploration(@unlucky[0]['rewards'])
        Rewards.should_receive(:from_exploration).with(
          @unlucky[0]['rewards']).and_return(rewards)
        @planet.finish_exploration!
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
          EventBroker::REASON_RESOURCES_CHANGED) do
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
        Factory.create :b_solar_plant, :planet => planet,
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

      planet.units.should == [unit1, unit3]
    end

    it "should not find npc units" do
      planet = Factory.create :planet_with_player
      player = planet.player
      unit1 = Factory.create :unit, :location => planet, :player => nil
      unit2 = Factory.create :unit, :location => planet, :player => nil
      unit3 = Factory.create :unit, :location => planet, :player => player

      planet.units.should == [unit3]
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
    before(:all) do
      @model = Factory.create(:planet)
    end

    it "should include player if it's available" do
      model = Factory.create(:planet_with_player)
      model.as_json[:player].should == Player.minimal(model.player_id)
    end

    describe "without options" do
      before(:all) do
        @options = nil
      end

      @required_fields = %w{name terrain exploration_ends_at}
      @ommited_fields = %w{width height metal metal_rate metal_storage
        energy energy_rate energy_storage
        zetium zetium_rate zetium_storage
        last_resources_update energy_diminish_registered status
        exploration_x exploration_y}
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
        last_resources_update}
      @ommited_fields = %w{energy_diminish_registered}
      it_should_behave_like "to json"
    end

    describe "with :perspective" do
      before(:all) do
        @player = Factory.create(:player)
        @status = StatusResolver::NPC
      end

      it_should_behave_like "with :perspective"
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
        @model.energy = 5
      end

      it "should register to CallbackManager" do
        CallbackManager.should_receive(:register).with(
          @model, CallbackManager::EVENT_ENERGY_DIMINISHED,
          Time.now.drop_usec + 2.seconds
        )
        @model.save!
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
        @model.energy_diminish_registered = true

        CallbackManager.should_receive(:update).with(
          @model, CallbackManager::EVENT_ENERGY_DIMINISHED,
          Time.now.drop_usec + 2.seconds
        )
        @model.save!
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

      describe "#{type} with modifiers" do
        before(:each) do
          player = Factory.create(:player)
          @tech = Factory.create :t_test_resource_mod,
            :player => player
          @model = Factory.create :planet, :player => player

          @model.last_resources_update = 5.seconds.ago.drop_usec
          @model.send("#{type}_rate=", @rate)
          @storage = @resource + @rate * 2000
          @model.send("#{type}_storage=", @storage)
          @model.send("#{type}=", @resource)
          @model.save!
        end

        it "should consider added mods for rate" do
          # We might not be there in same second.
          diff = Time.now.drop_usec - @model.last_resources_update
          lambda do
            @model.send :recalculate
          end.should change(@model, type).from(@resource).to(
            @resource + (
              @rate * diff * (
                1 + @tech.resource_modifiers[type.to_sym].to_f / 100
              )
            )
          )
        end
      end
    end
  end

  [:metal, :energy, :zetium].each do |resource|
    it "should consider added mods for #{resource} storage" do
      player = Factory.create(:player)
      tech = Factory.create :t_test_resource_mod,
        :player => player
      model = Factory.create :planet, :player => player

      storage = 31
      model.send("#{resource}_storage=", storage)
      model.save!

      lambda do
        model.send("#{resource}=", 2 * storage)
      end.should change(model, resource).to(
        storage * (
          1 + tech.resource_modifiers[
            "#{resource}_storage".to_sym
          ].to_f / 100
        )
      )
    end
  end
end