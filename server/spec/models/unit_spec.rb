require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe Unit do
  describe ".on_callback" do
    describe "destroy" do
      it "should destroy unit" do
        unit = Factory.create(:unit)
        Unit.stub!(:find).with(unit.id).and_return(unit)
        unit.should_receive(:destroy)
        Unit.on_callback(unit.id, CallbackManager::EVENT_DESTROY)
      end
      
      it "should fire destroy on unit" do
        unit = Factory.create(:unit)
        should_fire_event(unit, EventBroker::DESTROYED) do
          Unit.on_callback(unit.id, CallbackManager::EVENT_DESTROY)
        end
      end
    end
  end
  
  describe ".dismiss_units" do
    before(:each) do
      @player = Factory.create(:player)
      @planet = Factory.create(:planet, :player => @player,
        :metal => 0, :energy => 0, :zetium => 0,
        :metal_rate => 0, :energy_rate => 0, :zetium_rate => 0,
        :metal_storage => 10000, :energy_storage => 10000, 
          :zetium_storage => 10000
      )
      @units = [
        Factory.create(:u_gnat, :level => 1, :location => @planet,
          :hp => Unit::Gnat.hit_points(1) / 2, :player => @player),
        Factory.create(:u_trooper, :level => 1, :location => @planet,
          :hp => Unit::Trooper.hit_points(1), :player => @player),
      ]
    end

    it "should check if all of the units are in same planet" do
      @units[0].location = Factory.create(:planet)
      @units[0].save!

      lambda do
        Unit.dismiss_units(@planet, @units.map(&:id))
      end.should raise_error(GameLogicError)
    end

    it "should check if all of these units belong to planet owner" do
      @units[0].player = Factory.create(:player)
      @units[0].save!

      lambda do
        Unit.dismiss_units(@planet, @units.map(&:id))
      end.should raise_error(GameLogicError)
    end

    it "should increase planets resources" do
      Unit.dismiss_units(@planet, @units.map(&:id))
      @planet.reload
      metal = @planet.metal
      energy = @planet.energy
      zetium = @planet.zetium

      metal_diff = ((
        @units[0].metal_cost * @units[0].alive_percentage + @units[1].metal_cost
      ) * CONFIG['units.self_destruct.resource_gain'] / 100.0).round
      energy_diff = ((
        @units[0].energy_cost * @units[0].alive_percentage + @units[1].energy_cost
      ) * CONFIG['units.self_destruct.resource_gain'] / 100.0).round
      zetium_diff = ((
        @units[0].zetium_cost * @units[0].alive_percentage + @units[1].zetium_cost
      ) * CONFIG['units.self_destruct.resource_gain'] / 100.0).round

      [metal, energy, zetium].should == [metal_diff, energy_diff, zetium_diff]
    end

    it "should fire changed on planet" do
      should_fire_event(@planet, EventBroker::CHANGED,
          EventBroker::REASON_OWNER_PROP_CHANGE) do
        Unit.dismiss_units(@planet, @units.map(&:id))
      end
    end

    it "should destroy units" do
      Unit.dismiss_units(@planet, @units.map(&:id))
      @units.each do |unit|
        lambda do
          unit.reload
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe ".give_units" do
    before(:each) do
      @description = [["dirac", 3]]
      @player = Factory.create(:player)
      @location = Factory.create(:planet)
    end

    it "should place them in location" do
      Unit.give_units(@description, @location, @player)
      @location.units.grouped_counts { |u| u.type }.should == {"Dirac" => 3}
    end

    it "should give them to player" do
      Unit.give_units(@description, @location, @player)
      @player.units.grouped_counts { |u| u.type }.should == {"Dirac" => 3}
    end

    it "should increase players army points" do
      Unit.give_units(@description, @location, @player)
      @player.reload
      @player.send(Unit.points_attribute).should_not == 0
    end

    it "should increase players population" do
      lambda do
        Unit.give_units(@description, @location, @player)
        @player.reload
      end.should change(@player, :population).by(Unit::Dirac.population * 3)
    end

    it "should save them" do
      Unit.give_units(@description, @location, @player).each do |unit|
        unit.should be_saved
      end
    end

    it "should fire created event" do
      units = [an_instance_of(Unit::Dirac)] * 3
      should_fire_event(units, EventBroker::CREATED) do
        Unit.give_units(@description, @location, @player)
      end
    end
  end
  
  it "should fail if we don't have enough population" do
    player = Factory.create(:player, 
      :population_max => Unit::TestUnit.population - 1)
    unit = Factory.build(:unit, :player => player, :level => 0)
    lambda do
      unit.upgrade!
    end.should raise_error(NotEnoughResources)
  end

  it "should increase population when upgrading" do
    player = Factory.create(:player,
      :population_max => Unit::TestUnit.population)
    unit = Factory.build(:unit, :player => player, :level => 0)
    lambda do
      unit.upgrade!
      player.reload
    end.should change(player, :population).to(player.population_max)
  end

  describe ".flank_valid?" do
    it "should return false if > flank.max" do
      Unit.flank_valid?(CONFIG['combat.flanks.max'] + 1).should be_false
    end

    it "should return false if < 0" do
      Unit.flank_valid?(-1).should be_false
    end

    it "should return true otherwise" do
      Unit.flank_valid?(0).should be_true
    end
  end

  describe ".garrisoned_npc_in" do
    describe "non empty" do
      before(:all) do
        planet = Factory.create(:planet)
        @building = Factory.create(:b_collector_t1, :planet => planet)
        @unit = Factory.create(:u_trooper, :location => planet)
        @npc_building = Factory.create(:b_npc_solar_plant,
          :planet => planet, :x => 10)
        @npc_unit = Factory.create(:u_gnat, :location => @npc_building)
        @result = Unit.garrisoned_npc_in(planet)
      end

      it "should return a array" do
        @result.should be_instance_of(Array)
      end

      it "should not include non npc buildings" do
        @result.find do |unit|
          unit.location_id == @building.id
        end.should be_nil
      end

      it "should not include non npc units" do
        @result.should_not include(@unit)
      end

      it "should include npc buildings" do
        @result.find do |unit|
          unit.location_id == @npc_building.id
        end.should_not be_nil
      end

      it "should include units inside npc buildings" do
        @result.should include(@npc_unit)
      end
    end

    describe "empty" do
      it "should return empty array" do
        Unit.garrisoned_npc_in(Factory.create(:planet)).should == []
      end
    end
  end

  describe ".update_location_all" do
    before(:all) do
      @unit = Factory.create(:unit)
      @location = GalaxyPoint.new(Factory.create(:galaxy).id, 100, -100)
      Unit.update_location_all(@location, {:id => @unit.id})
      @unit.reload
    end

    %w{id type x y}.each do |attr|
      it "should change #{attr}" do
        @unit.send("location_#{attr}").should == @location.send(attr)
      end
    end
  end

  describe "#stance_property" do
    before(:all) do
      @model = Factory.create :unit, :stance => Combat::STANCE_AGGRESSIVE
    end

    it "should return property from config" do
      @model.stance_property('damage').should ==
        CONFIG["combat.stance.#{Combat::STANCE_AGGRESSIVE}.damage"]
    end

    it "should return default 1.0 if not defined in config" do
      with_config_values(
        "combat.stance.#{Combat::STANCE_AGGRESSIVE}.damage" => nil
      ) do
        @model.stance_property('damage').should == 1.0
      end
    end
  end

  describe ".delete_all_units" do
    before(:each) do
      @p1 = Factory.create(:player)
      @p2 = Factory.create(:player)

      @route = Factory.create(:route, :player => @p1)
      @ss = Factory.create(:solar_system)
      loc = SolarSystemPoint.new(@ss.id, 0, 0)
      mule = Factory.create(:u_mule, :location => loc, :player => @p1,
        :stored => Unit::Trooper.volume)
      @loaded_units = [
        Factory.create(:u_trooper, :location => mule, :player => @p1)
      ]
      @units = [
        Factory.create!(:u_dart, :route => @route, :location => loc,
          :player => @p1),
        Factory.create!(:u_dart, :route => @route, :location => loc,
          :player => @p1),
        Factory.create!(:u_crow, :route => @route, :location => loc,
          :player => @p2),
        Factory.create!(:u_crow, :location => loc, :player => @p2),
        mule
      ]
    end

    it "should subtract given units from Route if they have it" do
      Route.should_receive(:find).with(@route.id).and_return(
        @route)
      @route.should_receive(:subtract_from_cached_units!).with(
        "Dart" => 2,
        "Crow" => 1
      )
      Unit.delete_all_units(@units)
    end

    it "should be wrapped in SsObject::Planet.changing_viewable" do
      SsObject::Planet.should_receive(:changing_viewable).with(
        @units[0].location).and_return(true)
      Unit.delete_all_units(@units)
    end

    it "should delete given units" do
      Unit.delete_all_units(@units)
      @units.each do |unit|
        lambda do
          unit.reload
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end

    it "should delete loaded units" do
      Unit.delete_all_units(@units)
      @loaded_units.each do |unit|
        lambda do
          unit.reload
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end

    it "should reduce player army points" do
      @p1.army_points = 100000
      @p1.save!
      p1_units = @units.accept { |unit| unit.player_id == @p1.id }
      p1_loaded_units = @loaded_units.accept { |unit| unit.player_id == @p1.id }
      lambda do
        Unit.delete_all_units(@units)
        @p1.reload
      end.should change(@p1, :army_points).by(
        - (p1_units + p1_loaded_units).map(&:points_on_destroy).sum)
    end

    it "should reduce player population (with loaded units)" do
      @p1.population = 100000
      @p1.save!
      p1_units = @units.accept { |unit| unit.player_id == @p1.id }
      p1_loaded_units = @loaded_units.accept { |unit| unit.player_id == @p1.id }
      lambda do
        Unit.delete_all_units(@units)
        @p1.reload
      end.should change(@p1, :population).by(
        - (p1_units + p1_loaded_units).map(&:population).sum)
    end

    it "should fire destroyed" do
      should_fire_event(@units, EventBroker::DESTROYED, :reason) do
        Unit.delete_all_units(@units, nil, :reason)
      end
    end

    it "should fire destroyed with combat array if killed_by is given" do
      ca = CombatArray.new(@units, {})
      should_fire_event(ca, EventBroker::DESTROYED, :reason) do
        Unit.delete_all_units(@units, ca.killed_by, :reason)
      end
    end

    it "should not fire destroyed if given empty array" do
      should_not_fire_event([], EventBroker::DESTROYED, :reason) do
        Unit.delete_all_units([], nil, :reason)
      end
    end

    it "should decrease visibility if they are in solar system" do
      FowSsEntry.should_receive(:decrease).with(@ss.id, @p1, 3)
      FowSsEntry.should_receive(:decrease).with(@ss.id, @p2, 2)
      Unit.delete_all_units(@units, nil, :reason)
    end

    it "should not decrease visibility if ground units are destroyed" do
      planet = Factory.create(:planet, :solar_system => @ss)
      unit = Factory.create!(:u_trooper, :route => @route,
        :location => planet, :player => @p1)

      FowSsEntry.should_not_receive(:decrease)
      Unit.delete_all_units([unit], nil, :reason)
    end

    it "should not fail if npc units are involved" do
      @units[0].player = nil
      @units[0].save!
      Unit.delete_all_units(@units, nil, :reason)
    end

    it "should decrease visibility if they are in planet" do
      planet = Factory.create(:planet, :solar_system => @ss)

      @units.each do |unit|
        unit.location = planet
        unit.save!
      end

      FowSsEntry.should_receive(:decrease).with(@ss.id, @p1, 3)
      FowSsEntry.should_receive(:decrease).with(@ss.id, @p2, 2)
      Unit.delete_all_units(@units, nil, :reason)
    end

    it "should not decrease visibility if they are not in solar system" do
      @units.each do |unit|
        unit.location = GalaxyPoint.new(@ss.galaxy_id, 0, 0)
        unit.save!
      end

      FowSsEntry.should_not_receive(:decrease)
      Unit.delete_all_units(@units, nil, :reason)
    end
  end

  describe "#destroy" do
    before(:each) do
      @unit = Factory.create(:unit, :level => 1)
    end

    it "should be wrapped in SsObject::Planet.changing_viewable" do
      SsObject::Planet.should_receive(:changing_viewable).with(
        @unit.location).and_return(true)
      @unit.destroy
    end

    it "should reduce population" do
      player = Factory.create(:player, :population => 1000)
      @unit.player = player
      lambda do
        @unit.destroy
        player.reload
      end.should change(player, :population).by(-@unit.population)
    end

    it "should still work" do
      @unit.destroy
      lambda do
        @unit.reload
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe ".save_all_units" do
    before(:each) do
      @route = Factory.create(:route)
      @units = [
        Factory.create!(:u_dart, :route => @route),
        Factory.create!(:u_dart, :route => @route),
        Factory.create!(:u_crow, :route => @route),
        Factory.create!(:u_crow),
      ]
      @units.each { |unit| unit.hp -= 1 }
    end

    it "should save given units" do
      Unit.save_all_units(@units)
      @units.each do |unit|
        unit.should_not be_changed
      end
    end

    it "should not fire changed if given empty array" do
      should_not_fire_event([], EventBroker::CHANGED, :reason) do
        Unit.save_all_units([], :reason)
      end
    end

    it "should fire changed" do
      should_fire_event(@units, EventBroker::CHANGED, :reason) do
        Unit.save_all_units(@units, :reason)
      end
    end

    it "should fire changed with saved units" do
      EventBroker.should_receive(:fire).and_return(true) do
        |units, event, reason|
        units.each { |unit| unit.should be_saved }
      end
      Unit.save_all_units(@units, :reason)
    end
  end

  %w{armor_mod}.each do |method|
    describe "##{method}" do
      it "should delegate to class" do
        model = Factory.create(:unit, :level => 3)
        model.class.should_receive(method).with(model.level)
        model.send(method)
      end
    end
    
    describe ".#{method}" do
      it "should retrieve value from config" do
        level = 3
        Unit.should_receive(:evalproperty).with(method, 0, 'level' => level)
        Unit.send(method, level)
      end
    end
  end

  describe "#as_json" do
    before(:each) do
      @model = Factory.create :unit
    end

    @required_fields = %w{type hp level id player_id flank upgrade_ends_at}
    @ommited_fields = %w{location_id location_x location_y
      location_type hp_remainder pause_remainder xp
      stored metal energy zetium}
    it_should_behave_like "to json"

    it "should include location" do
      @model.as_json["location"].should == @model.location.as_json
    end

    describe "with :perspective" do
      before(:all) do
        @enemy = Factory.create(:player)
      end

      before(:each) do
        @player = @model.player
        @status = StatusResolver::YOU
        @options = {}
      end

      it_should_behave_like "with :perspective"
      
      describe "you" do
        before(:each) do
          @options[:perspective] = @player
        end

        describe "transporter" do
          before(:each) do
            @model.stub!(:transporter?).and_return(true)
          end

          @required_fields = %w{stored metal energy zetium}
          @ommited_fields = %w{}
          it_should_behave_like "to json"
        end

        describe "non-transporter" do
          before(:each) do
            @model.stub!(:transporter?).and_return(false)
          end
          
          @required_fields = %w{}
          @ommited_fields = %w{stored metal energy zetium}
          it_should_behave_like "to json"
        end
      end
      
      describe "enemy" do
        before(:each) do
          @options[:perspective] = @enemy
        end

        @required_fields = %w{}
        @ommited_fields = %w{stored metal energy zetium}
        it_should_behave_like "to json"
      end
    end
  end

  describe "#npc?" do
    it "should return false for PC units" do
      Factory.create(:u_trooper).should_not be_npc
    end

    it "should return true for NPC units" do
      Factory.create(:u_gnat).should be_npc
    end
  end

  describe ".player_ids_for_location" do
    before(:each) do
      @planet = Factory.create :planet
      @location = @planet.location
      @p1 = Factory.create :player
      @p2 = Factory.create :player
    end

    it "should return distinct ids from units" do
      Factory.create(:unit, :location => @location, :player => @p1)
      Factory.create(:unit, :location => @location, :player => @p2)
      Factory.create(:unit, :location => @location, :player => @p1)
      Unit.player_ids_in_location(@location).should == [@p1.id, @p2.id]
    end

    it "should also include nils" do
      Factory.create(:unit, :location => @location, :player => nil)
      Unit.player_ids_in_location(@location).should == [nil]
    end
  end

  describe ".in_location" do
    [
      ["unit", Factory.create(:unit)],
      ["building", Factory.create(:building)],
      ["planet", Factory.create(:planet)],
      ["solar system point", SolarSystemPoint.new(1, 2, 90)],
      ["galaxy point", GalaxyPoint.new(10, 2, 3)]
    ].each do |desc, obj|
      it "should find units in #{desc}" do
        unit1 = Factory.create :unit, obj.location_attrs
        unit2 = Factory.create :unit, :location_type => Location::GALAXY,
          :location_id => 1, :location_x => 0, :location_y => 0
        unit3 = Factory.create :unit, obj.location_attrs

        Unit.in_location(obj.location_attrs).all.should == [unit1, unit3]
      end
    end
  end

  describe ".units_for_moving" do
    before(:all) do
      @planet = Factory.create :planet_with_player
      @player = @planet.player
    end

    it "should return Hash of {type => count}" do
      units = [
        Factory.create(:u_trooper, :player => @player,
          :location => @planet),
        Factory.create(:u_trooper, :player => @player,
          :location => @planet),
        Factory.create(:u_mule, :player => @player,
          :location => @planet),
        Factory.create(:u_trooper, :player => @player,
          :location => @planet),
        Factory.create(:u_crow, :player => @player,
          :location => @planet),
        Factory.create(:u_crow, :player => @player,
          :location => @planet)
      ]
      Unit.units_for_moving(
        units.map(&:id), @player.id, units[0].location
      ).should == {
        "Crow" => 2,
        "Mule" => 1,
        "Trooper" => 3,
      }
    end

    it "should filter units which do not belong to player" do
      units = [
        Factory.create(:u_trooper, :player => @player,
          :location => @planet),
        Factory.create(:u_trooper, :location => @planet)
      ]
      Unit.units_for_moving(
        units.map(&:id), @player.id, units[0].location
      ).should == {"Trooper" => 1}
    end

    it "should filter units that are in different location" do
      units = [
        Factory.create(:u_trooper, :player => @player,
          :location => @planet),
        Factory.create(:u_mule, :player => @player, :location =>
          SolarSystemPoint.new(Factory.create(:solar_system).id, 1, 0)
        )
      ]
      Unit.units_for_moving(
        units.map(&:id), @player.id, units[0].location
      ).should == {"Trooper" => 1}
    end
  end

  [
    ["galaxy point", GalaxyPoint.new(1, 2, 3), Location::GALAXY, 2, 3],
    ["SS point", SolarSystemPoint.new(1, 2, 90),
      Location::SOLAR_SYSTEM, 2, 90],
    ["planet", Factory.create(:planet), Location::SS_OBJECT, nil, nil],
    ["unit", Factory.create(:unit), Location::UNIT, nil, nil],
  ].each do |desc, point, type, x, y|
    describe "#location= (#{desc})" do
      before(:all) do
        @model = Factory.create :unit
        @model.location = point
      end

      it "should set location_id" do
        @model.location_id.should == point.id
      end

      it "should set location_type" do
        @model.location_type.should == type
      end

      it "should set location_x" do
        @model.location_x.should == x
      end

      it "should set location_y" do
        @model.location_y.should == y
      end
    end

    describe "#location (#{desc})" do
      before(:all) do
        @model = Factory.create :unit
        @model.location = point
      end

      it "should return location" do
        @model.location.object.should == point
      end
    end
  end

  describe ".update_combat_attributes" do
    before(:each) do
      @player = Factory.create :player
      @unit1 = Factory.create :unit, :player => @player
      @unit2 = Factory.create :unit, :player => @player
      @unit3 = Factory.create :unit, :player => @player
      @unit4 = Factory.create :unit, :player => @player
    end

    it "should validate flank numbers" do
      with_config_values("combat.flanks.max" => 5) do
        lambda do
          Unit.update_combat_attributes(@player.id,
            @unit1.id => [5, Combat::STANCE_NEUTRAL]
          )
        end.should raise_error(ArgumentError)
      end
    end

    it "should validate stance" do
      with_config_values("combat.flanks.max" => 5) do
        lambda do
          Unit.update_combat_attributes(@player.id,
            @unit1.id => [0, -1]
          )
        end.should raise_error(ArgumentError)
      end
    end

    it "should mass update units with new attributes" do
      Unit.update_combat_attributes(@player.id,
        @unit1.id => [1, Combat::STANCE_AGGRESSIVE],
        @unit3.id => [1, Combat::STANCE_DEFENSIVE]
      )
      [@unit1, @unit3].map do |u|
        u.reload
        [u.flank, u.stance]
      end.should == [
        [1, Combat::STANCE_AGGRESSIVE],
        [1, Combat::STANCE_DEFENSIVE]
      ]
    end

    it "should update only that player units" do
      @unit1.player = Factory.create :player
      @unit1.save!

      Unit.update_combat_attributes(@player.id,
        @unit1.id => [1, Combat::STANCE_AGGRESSIVE],
        @unit3.id => [1, Combat::STANCE_AGGRESSIVE]
      )
      [@unit1, @unit3].map do |u|
        u.reload
        [u.flank, u.stance]
      end.should == [
        [0, Combat::STANCE_NEUTRAL],
        [1, Combat::STANCE_AGGRESSIVE]
      ]
    end

    it "should not update unaffected units" do
      Unit.update_combat_attributes(@player.id,
        @unit1.id => [1, Combat::STANCE_AGGRESSIVE],
        @unit3.id => [1, Combat::STANCE_AGGRESSIVE]
      )
      [@unit1, @unit2, @unit3, @unit4].map do |u|
        u.reload
        [u.flank, u.stance]
      end.should == [
        [1, Combat::STANCE_AGGRESSIVE],
        [0, Combat::STANCE_NEUTRAL],
        [1, Combat::STANCE_AGGRESSIVE],
        [0, Combat::STANCE_NEUTRAL],
      ]
    end
  end

  it "should save properly" do
    lambda do
      Factory.build(:unit).save!
    end.should_not raise_error
  end

  it "should not allow setting bigger flank than one in config" do
    Factory.build(:unit, :flank => CONFIG['combat.flanks.max']
      ).should_not be_valid
  end

  it "should not allow setting invalid flank" do
    Factory.build(:unit, :stance => -1).should_not be_valid
  end

  describe "upgradable" do
    before(:each) do
      @planet = Factory.create :planet
      @player = Factory.create(:player)
      @model = Factory.build :unit, :location => @planet,
        :player => @player

      set_resources(@planet,
        @model.metal_cost(@model.level + 1),
        @model.energy_cost(@model.level + 1),
        @model.zetium_cost(@model.level + 1)
      )
    end

    it_should_behave_like "upgradable"
    it_should_behave_like "upgradable with hp"
    it_should_behave_like "default upgradable time calculation"
  end

  describe "#method" do

  end

  describe "#upgrade" do
    describe "if level == 0" do
      before(:each) do
        @player = Factory.create(:player)
        @model = Factory.create(:unit, :player => @player)
      end
    end

    describe "if level > 0" do
      before(:each) do
        @player = Factory.create(:player)
        @model = Factory.create :unit_built, :player => @player
        @model.xp = @model.xp_needed
      end

      it "should not increase player army points" do
        lambda do
          @model.upgrade!
          @player.reload
        end.should_not change(@player, :army_points)
      end

      it "should check max level" do
        @model.level = @model.max_level
        @model.xp = @model.xp_needed
        lambda do
          @model.upgrade
        end.should raise_error(GameLogicError)
      end

      it "should upgrade instantly" do
        lambda do
          @model.upgrade
        end.should change(@model, :level).by(1)
      end

      it "should reduce xp" do
        lambda do
          @model.upgrade
        end.should change(@model, :xp).by(- @model.xp_needed)
      end

      it "should raise exception if there is not enough xp" do
        @model.xp -= 1
        lambda do
          @model.upgrade
        end.should raise_error(GameLogicError)
      end
    end
  end

  describe "#points_on_destroy" do
    before(:each) do
      @unit = Factory.build(:unit, :level => 1)
      @points = Resources.total_volume(
        @unit.metal_cost, @unit.energy_cost, @unit.zetium_cost)
    end

    it "should return points" do
      @unit.points_on_destroy.should == @points
    end

    it "should include loaded unit points" do
      @unit.stored = 10
      @unit.points_on_destroy.should == @points + @unit.stored
    end

    it "should not include loaded resource points" do
      @unit.metal = 10
      @unit.energy = 10
      @unit.zetium = 10
      @unit.stored = Resources.total_volume(@unit.metal, @unit.energy,
        @unit.zetium)
      @unit.points_on_destroy.should == @points
    end
  end

  describe "upgrading complete" do
    it "should add visibility if it's level 1 (in planet)" do
      p = Factory.create(:planet)
      u = Factory.create(:u_crow, opts_upgrading + {:level => 0,
          :location => p, :player => Factory.create(:player), :hp => 0})
      FowSsEntry.should_receive(:increase).with(p.solar_system_id,
        u.player, 1)
      u.send(:on_upgrade_finished!)
    end

    it "should not add visibility if it's NPC" do
      p = Factory.create(:planet)
      u = Factory.create(:u_crow, opts_upgrading + {:level => 0,
          :location => p, :hp => 0, :player => nil})
      FowSsEntry.should_not_receive(:increase)
      u.send(:on_upgrade_finished!)
    end

    it "should not add visibility if it's ground" do
      p = Factory.create(:planet)
      u = Factory.create(:u_trooper, opts_upgrading + {:level => 0,
          :location => p, :player => Factory.create(:player), :hp => 0})
      FowSsEntry.should_not_receive(:increase)
      u.send(:on_upgrade_finished!)
    end

    it "should not add visibility if it's level > 1" do
      p = Factory.create(:planet)
      u = Factory.create(:u_crow, opts_upgrading + {:level => 1,
          :location => p, :player => Factory.create(:player)})
      FowSsEntry.should_not_receive(:increase)
      u.send(:on_upgrade_finished!)
    end
  end

  describe "combat experience" do
    it "should upgrade if it has enough xp" do
      model = Factory.create :unit_built
      model.xp = model.xp_needed
      lambda do
        model.save!
      end.should change(model, :level).by(1)
    end

    it "should not upgrade if level is 0" do
      model = Factory.create :unit_built, :hp => 0, :level => 0
      model.xp = model.xp_needed + 10
      lambda do
        model.save!
      end.should_not change(model, :level)
    end

    it "should upgrade through multiple levels if it has enough xp" do
      model = Factory.create :unit_built
      model.xp = model.xp_needed + model.xp_needed(model.level + 2)
      lambda do
        model.save!
      end.should change(model, :level).by(2)
    end

    it "should not upgrade more than max_level" do
      model = Factory.create :unit_built
      model.xp = 9999999999
      lambda do
        model.save!
      end.should_not raise_error(GameLogicError)
    end

    it "should notify quest event handler" do
      model = Factory.create :unit_built
      model.xp = model.xp_needed

      QUEST_EVENT_HANDLER.should_receive(:fire).with(model,
        EventBroker::CHANGED,
        EventBroker::REASON_UPGRADE_FINISHED)
      model.save!
    end
  end

  describe "#can_upgrade_by" do
    it "should return 0 if level is 0" do
      model = Factory.create(:unit, :level => 0)
      model.xp = model.xp_needed
      model.can_upgrade_by.should == 0
    end

    it "should return 0 if unit is dead" do
      model = Factory.create(:unit, :level => 0)
      model.stub!(:dead?).and_return(true)
      model.can_upgrade_by.should == 0
    end

    it "should return 0 if there is not enough xp" do
      model = Factory.create(:unit_built)
      model.xp = model.xp_needed - 1
      model.can_upgrade_by.should == 0
    end

    it "should return n if there is enough xp" do
      model = Factory.create(:unit_built)
      model.xp = model.xp_needed + model.xp_needed(model.level + 2)
      model.can_upgrade_by.should == 2
    end

    it "should return max_level - level if we reach it" do
      model = Factory.create(:unit_built)
      model.xp = 99999999
      model.can_upgrade_by.should == (model.max_level - model.level)
    end
  end
end