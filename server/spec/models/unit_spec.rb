require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Unit do
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
      mule = Factory.create(:u_mule, :location => loc, :player => @p1)
      @loaded_units = [
        Factory.create(:u_trooper, :location => mule)
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

    it "should fire destroyed" do
      should_fire_event(@units, EventBroker::DESTROYED, :reason) do
        Unit.delete_all_units(@units, nil, :reason)
      end
    end

    it "should decrease visibility if they are in solar system" do
      FowSsEntry.should_receive(:decrease).with(@ss.id, @p1, 3)
      FowSsEntry.should_receive(:decrease).with(@ss.id, @p2, 2)
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
      @unit = Factory.create(:unit)
    end

    it "should be wrapped in SsObject::Planet.changing_viewable" do
      SsObject::Planet.should_receive(:changing_viewable).with(
        @unit.location).and_return(true)
      @unit.destroy
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

    it "should fire changed" do
      should_fire_event(@units, EventBroker::CHANGED, :reason) do
        Unit.save_all_units(@units, :reason)
      end
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

    @required_fields = %w{type hp level id player_id flank last_update
      upgrade_ends_at}
    @ommited_fields = %w{location_id location_x location_y
      location_type hp_remainder pause_remainder xp
      stored metal energy zetium}
    it_should_behave_like "to json"

    it "should include location" do
      @model.as_json[:location].should == @model.location
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

        @required_fields = %w{stored metal energy zetium}
        @ommited_fields = %w{}
        it_should_behave_like "to json"
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
      @model = Factory.build :unit, :location => @planet

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

  describe "#upgrade" do
    describe "if level == 0" do
      before(:each) do
        @player = Factory.create(:player)
        @model = Factory.create(:unit, :player => @player)
      end

      it "should increase player army points" do
        points = Resources.total_volume(
          @model.metal_cost(@model.level + 1),
          @model.energy_cost(@model.level + 1),
          @model.zetium_cost(@model.level + 1)
        )

        lambda do
          @model.upgrade!
          @player.reload
        end.should change(@player, :army_points).by(points)
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

  describe "upgrading complete" do
    it "should add visibility if it's level 1 (in planet)" do
      p = Factory.create(:planet)
      u = Factory.create(:u_crow, :level => 0, :location => p,
        :player => Factory.create(:player), :hp => 0)
      FowSsEntry.should_receive(:increase).with(p.solar_system_id,
        u.player, 1)
      u.send(:on_upgrade_finished!)
    end

    it "should not add visibility if it's ground" do
      p = Factory.create(:planet)
      u = Factory.create(:u_trooper, :level => 0, :location => p,
        :player => Factory.create(:player), :hp => 0)
      FowSsEntry.should_not_receive(:increase)
      u.send(:on_upgrade_finished!)
    end

    it "should not add visibility if it's level > 1" do
      p = Factory.create(:planet)
      u = Factory.create(:u_crow, :level => 1, :location => p,
        :player => Factory.create(:player))
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