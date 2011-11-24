require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe Unit do
  describe ".non_combat_types" do
    it "should return ground units without guns" do
      Unit.non_combat_types.should include("Mdh")
    end
    
    it "should not return ground units with guns" do
      Unit.non_combat_types.should_not include("Trooper")
    end
    
    it "should not return space units without guns" do
      Unit.non_combat_types.should_not include("Jumper")
    end
    
    it "should not return space units with guns" do
      Unit.non_combat_types.should_not include("Crow")
    end
  end

  describe ".combat" do
    it "should not include level == 0" do
      Unit.combat.where(:id => Factory.create!(:u_trooper, :level => 0).id).
        first.should be_nil
    end

    it "should not include non combat types" do
      Unit.combat.where(:id => Factory.create!(:u_mdh).id).
        first.should be_nil
    end

    it "should not include hidden units" do
      Unit.combat.where(:id => Factory.create!(:u_trooper, :hidden => true).id).
        first.should be_nil
    end

    it "should return combat types" do
      Unit.combat.where(:id => Factory.create!(:u_trooper).id).
        first.should_not be_nil
    end
  end
  
  describe ".on_callback" do
    describe "destroy" do
      it "should destroy unit" do
        unit = Factory.create(:unit)
        Unit.stub!(:find).with(unit.id).and_return(unit)
        unit.should_receive(:destroy!)
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
  
  describe ".give_units" do
    before(:each) do
      @description = [["dirac", 3]]
      @player = Factory.create(:player)
      @location = Factory.create(:planet)
    end
    
    it "should call #give_units_raw with correct units" do
      Unit.should_receive(:give_units_raw).and_return do 
        |units, location, player|
        
        units.size.should == 3
        
        units.each do |unit|
          unit.should be_instance_of(Unit::Dirac)
          unit.level.should == 1
        end
        
        location.should == @location
        player.should == @player
        
        units
      end
      
      Unit.give_units(@description, @location, @player)
    end
  end
  
  describe ".give_units_raw" do
    before(:each) do
      @player = Factory.create(:player)
      @location = Factory.create(:planet, :player => @player)
      @units = [
        Factory.build(:u_dirac, :level => 1),
        Factory.build(:u_thor, :level => 1),
        # This one requires technology but should not fail.
        Factory.build(:u_avenger, :level => 1),
        # This should not increase FOW.
        Factory.build(:u_trooper, :level => 1),
      ]
      @fse = Factory.create(:fse_player,
        :solar_system_id => @location.solar_system_id,
        :player => @player)
    end

    it "should place them in location" do
      Unit.give_units_raw(@units, @location, @player).each do |unit|
        unit.location.should == @location.location_point
      end
    end

    it "should give them to player" do
      Unit.give_units_raw(@units, @location, @player).each do |unit|
        unit.player.should == @player
      end
    end
    
    it "should set their galaxy id" do
      Unit.give_units_raw(@units, @location, @player).each do |unit|
        unit.galaxy_id.should == @player.galaxy_id
      end
    end
    
    it "should save them" do
      Unit.give_units_raw(@units, @location, @player).each do |unit|
        unit.should be_saved
      end
    end

    it "should increase players army points" do
      points = @units.inject(0) { |sum, u| sum + u.points_on_upgrade }
      lambda do
        Unit.give_units_raw(@units, @location, @player)
        @player.reload
      end.should change(@player, Unit.points_attribute).by(points)
    end

    it "should increase players population" do
      population = @units.inject(0) { |sum, u| sum + u.population }
      lambda do
        Unit.give_units_raw(@units, @location, @player)
        @player.reload
      end.should change(@player, :population).by(population)
    end
    
    it "should increase fow counter for space units & ! for ground units" do
      count = @units.inject(0) { |sum, u| sum + (u.space? ? 1 : 0) }
      lambda do
        Unit.give_units_raw(@units, @location, @player)
        @fse.reload
      end.should change(@fse, :counter).by(count)
    end

    it "should fire created event" do
      should_fire_event(@units, EventBroker::CREATED) do
        Unit.give_units_raw(@units, @location, @player)
      end
    end

    it "should check location if any of the units can fight" do
      @units.each { |unit| unit.stub!(:can_fight?).and_return(false) }
      @units[-2].stub!(:can_fight?).and_return(true)
      Combat::LocationChecker.should_receive(:check_location).
        with(@location.location_point)

      Unit.give_units_raw(@units, @location, @player)
    end

    it "should not check location if none of the units can fight" do
      @units.each { |unit| unit.stub!(:can_fight?).and_return(false) }
      Combat::LocationChecker.should_not_receive(:check_location)

      Unit.give_units_raw(@units, @location, @player)
    end
    
    it "should return same units" do
      Unit.give_units_raw(@units, @location, @player).should == @units
    end
  end
  
  describe ".dismiss_units" do
    before(:each) do
      @player = Factory.create(:player)
      @planet = Factory.create(:planet, :player => @player,
        :metal => 0, :energy => 0, :zetium => 0,
        :metal_storage => 10000, :energy_storage => 10000, 
          :zetium_storage => 10000
      )
      @units = [
        Factory.create(:u_gnat, :level => 1, :location => @planet,
          :hp => Unit::Gnat.hit_points / 2, :player => @player),
        Factory.create(:u_trooper, :level => 1, :location => @planet,
          :player => @player),
        Factory.create(:u_dirac, :level => 1, :location => @planet,
          :player => @player),
      ]
      @fse = Factory.create(:fse_player,
        :solar_system_id => @planet.solar_system_id,
        :player => @player)
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

    it "should check if all of these units are not upgrading" do
      @units[0].upgrade_ends_at = 40.minutes.from_now
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

      metal_diff = (
        @units.inject(0.0) { |s, u| s + u.metal_cost * u.alive_percentage } *
        CONFIG['units.self_destruct.resource_gain'] / 100.0).round
      energy_diff = (
        @units.inject(0.0) { |s, u| s + u.energy_cost * u.alive_percentage } *
        CONFIG['units.self_destruct.resource_gain'] / 100.0).round
      zetium_diff = (
        @units.inject(0.0) { |s, u| s + u.zetium_cost * u.alive_percentage } *
        CONFIG['units.self_destruct.resource_gain'] / 100.0).round

      [metal, energy, zetium].should == [metal_diff, energy_diff, zetium_diff]
    end

    it "should fire changed on planet" do
      should_fire_event(@planet, EventBroker::CHANGED,
          EventBroker::REASON_OWNER_PROP_CHANGE) do
        Unit.dismiss_units(@planet, @units.map(&:id))
      end
    end

    it "should destroy units" do
      Unit.should_receive(:delete_all_units).with(@units)
      Unit.dismiss_units(@planet, @units.map(&:id))
    end
  end

  it "should fail if we don't have enough population" do
    player = Factory.create(:player, 
      :population_cap => Unit::TestUnit.population - 1)
    unit = Factory.build(:unit, :player => player, :level => 0)
    lambda do
      unit.upgrade!
    end.should raise_error(NotEnoughResources)
  end

  it "should increase population when upgrading" do
    player = Factory.create(:player,
      :population => 0,
      :population_cap => Unit::TestUnit.population)
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

  describe ".update_location_sql" do
    before(:all) do
      @unit = Factory.create(:unit)
      @location = GalaxyPoint.new(Factory.create(:galaxy).id, 100, -100)
      Unit.where(:id => @unit.id).
        update_all(Unit.update_location_sql(@location))
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
      @mule = Factory.create!(:u_mule)
      @units = [
        Factory.create!(:u_dart, :route => @route),
        Factory.create!(:u_dart, :route => @route),
        Factory.create!(:u_crow, :route => @route),
        Factory.create!(:u_crow),
        @mule,
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
    
    it "should exclude units within other units from changed event" do
      event_units = @units.dup
      @units.push Factory.create(:u_trooper, :location => @mule)
      should_fire_event(event_units, EventBroker::CHANGED, :reason) do
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
    it_behaves_like "as json",
      Factory.create(:unit),
      nil,
      %w{id level player_id upgrade_ends_at type flank route_id stance
      construction_mod location hp hidden},
      %w{location_id location_x location_y location_type hp_remainder
      pause_remainder stored metal energy zetium galaxy_id xp flags}

    it "should include location#as_json" do
      model = Factory.create(:unit)
      model.as_json["location"].should == model.location.as_json
    end

    describe "with :perspective" do
      player = Factory.create(:player)

      it_behaves_like "with :perspective",
        Factory.create(:unit),
        player,
        StatusResolver::ENEMY

      describe "you" do
        it_behaves_like "as json",
          Factory.create(:unit, :player => player),
          {:perspective => player},
          %w{xp},
          %w{}

        describe "transporter" do
          it_behaves_like "as json",
            lambda {
              Factory.create(:u_mule, :player => player)
            }.call,
            {:perspective => player},
            %w{stored metal energy zetium},
            %w{}
        end

        describe "non-transporter" do
          it_behaves_like "as json",
            lambda {
              model = Factory.create(:u_trooper, :player => player)
            }.call,
            {:perspective => player},
            %w{},
            %w{stored metal energy zetium}
        end
      end

      describe "ally" do
        player = Factory.create(:player, :alliance => Factory.create(:alliance))
        ally = Factory.create(:player, :alliance => player.alliance)

        it_behaves_like "as json",
          Factory.create(:unit, :player => ally),
          {:perspective => player},
          %w{},
          %w{xp stored metal energy zetium}
      end
      
      describe "enemy" do
        enemy = Factory.create(:player)

        it_behaves_like "as json",
          Factory.create(:unit, :player => enemy),
          {:perspective => player},
          %w{},
          %w{xp stored metal energy zetium}
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
      Factory.create(:unit_built, :location => @location, :player => @p1)
      Factory.create(:unit_built, :location => @location, :player => @p2)
      Factory.create(:unit_built, :location => @location, :player => @p1)
      Unit.player_ids_in_location(@location).should == [@p1.id, @p2.id]
    end

    it "should not include units of level 0" do
      Factory.create(:unit_built, :location => @location, :player => @p1,
                     :level => 0)
      Factory.create(:unit_built, :location => @location, :player => @p2)
      Unit.player_ids_in_location(@location).should == [@p2.id]
    end

    it "should also include nils" do
      Factory.create(:unit_built, :location => @location, :player => nil)
      Unit.player_ids_in_location(@location).should == [nil]
    end

    it "should include ids from non combat types" do
      Factory.create!(:u_mdh, :location => @location, :player => @p1)
      Unit.player_ids_in_location(@location).should_not be_blank
    end

    describe "exclude_non_combat_types=true" do
      it "should not include ids from non combat types" do
        Factory.create!(:u_mdh, :location => @location, :player => @p1)
        Unit.player_ids_in_location(@location, true).should == []
      end

      it "should not include ids from hidden units" do
        Factory.create!(:u_trooper, :location => @location, :player => @p1,
          :hidden => true)
        Unit.player_ids_in_location(@location, true).should == []
      end
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

  describe ".positions" do
    key = lambda do |location|
      "#{location.id},#{location.type},#{location.x},#{location.y}"
    end

    it "should return structured hash" do
      player1 = Factory.create(:player)
      player2 = Factory.create(:player)

      location1 = Factory.create(:planet)
      location2 = Factory.create(:planet)

      units = [
        Factory.create!(:u_trooper, :player => player1, :location => location1),
        Factory.create!(:u_trooper, :player => player1, :location => location1),
        Factory.create!(:u_shocker, :player => player1, :location => location1),
        Factory.create!(:u_shocker, :player => player1, :location => location2),

        Factory.create!(:u_trooper, :player => player2, :location => location1),
        Factory.create!(:u_shocker, :player => player2, :location => location1),
        Factory.create!(:u_trooper, :player => player2, :location => location2),
      ]

      Unit.positions(Unit.where(:id => units.map(&:id))).should == {
        player1.id => {
          key.call(location1.location_point) => {
            "location" => location1.client_location.as_json,
            "cached_units" => {"Trooper" => 2, "Shocker" => 1}
          },
          key.call(location2.location_point) => {
            "location" => location2.client_location.as_json,
            "cached_units" => {"Shocker" => 1}
          }
        },
        player2.id => {
          key.call(location1.location_point) => {
            "location" => location1.client_location.as_json,
            "cached_units" => {"Trooper" => 1, "Shocker" => 1}
          },
          key.call(location2.location_point) => {
            "location" => location2.client_location.as_json,
            "cached_units" => {"Trooper" => 1}
          }
        }
      }
    end

    it "should not include items which do not go into scope" do
      units = [
        Factory.create!(:u_trooper),
        Factory.create!(:u_shocker),
      ]

      Unit.positions(Unit.where(:id => units[1].id)).should == {
        units[1].player_id => {
          key.call(units[1].location) => {
            "location" => units[1].location.client_location.as_json,
            "cached_units" => {"Shocker" => 1}
          }
        }
      }
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
      lambda do
        Unit.update_combat_attributes(@player.id,
          @unit1.id => [0, -1]
        )
      end.should raise_error(ArgumentError)
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

  describe ".mass_set_hidden" do
    let(:player) { Factory.create(:player) }
    let(:planet) { Factory.create(:planet, :player => player) }
    let(:units) { [
      Factory.create(:unit, :player => player, :location => planet),
      Factory.create(:unit, :player => player, :location => planet),
      Factory.create(:unit, :player => player, :location => planet),
    ] }
    let(:unit_ids) { units.map(&:id) }

    it "should fail if planet does not belong to player" do
      planet.update_row! :player_id => Factory.create(:player).id
      lambda do
        Unit.mass_set_hidden(player.id, planet.id, unit_ids, true)
      end.should raise_error(GameLogicError)
    end

    it "should fail if one of the units does not belong to player" do
      units[0].player = Factory.create(:player)
      units[0].save!
      lambda do
        Unit.mass_set_hidden(player.id, planet.id, unit_ids, true)
      end.should raise_error(GameLogicError)
    end

    it "should fail if unit is not in planet" do
      units[0].location = planet.solar_system_point
      units[0].save!
      lambda do
        Unit.mass_set_hidden(player.id, planet.id, unit_ids, true)
      end.should raise_error(GameLogicError)
    end

    it "should not change hidden flag if failed" do
      units[0].location = planet.solar_system_point
      units[0].save!
      begin
        Unit.mass_set_hidden(player.id, planet.id, unit_ids, true)
      rescue GameLogicError; end
      units[0].reload
      units[0].should_not be_hidden
    end

    it "should not change unrelated unit flags on same planet" do
      last_unit_id = unit_ids.pop
      Unit.mass_set_hidden(player.id, planet.id, unit_ids, true)
      Unit.find(last_unit_id).should_not be_hidden
    end

    it "should change flag for given units" do
      Unit.mass_set_hidden(player.id, planet.id, unit_ids, true)
      units.each { |u| u.reload.should be_hidden }
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
      @player = Factory.create(:player, :army_points => 1000)
      @model = Factory.build :unit, :location => @planet,
        :player => @player

      set_resources(@planet,
        @model.metal_cost(@model.level + 1),
        @model.energy_cost(@model.level + 1),
        @model.zetium_cost(@model.level + 1),
        1_000_000, 1_000_000, 1_000_000
      )
    end

    it_behaves_like "upgradable"
    it_behaves_like "upgradable with hp"
    it_behaves_like "default upgradable time calculation"
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

  describe "#on_upgrade_finished!" do
    describe "visibility" do
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

    describe "combat check after upgrade is finished" do
      let(:unit) { Factory.create!(:unit, opts_upgrading) }

      it "should check for combat in it's location if it can fight'" do
        unit.stub!(:can_fight?).and_return(true)
        Combat::LocationChecker.should_receive(:check_location).
          with(unit.location)
        unit.send(:on_upgrade_finished!)
      end

      it "should not check for combat in it's location if it cannot fight'" do
        unit.stub!(:can_fight?).and_return(false)
        Combat::LocationChecker.should_not_receive(:check_location)
        unit.send(:on_upgrade_finished!)
      end
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
