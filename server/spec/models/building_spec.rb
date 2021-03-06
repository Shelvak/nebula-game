require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe Building do
  describe "#managable?" do
    before(:each) do
      @building = Factory.build(:building)
    end

    it "should return true by default" do
      @building.managable?.should be_true
    end

    it "should return value if specified" do
      with_config_values 'buildings.test_building.managable' => false do
        @building.managable?.should be_false
      end
    end
  end

  describe "#self_destruct!" do
    before(:each) do
      @player = Factory.create(:player)
      @planet = Factory.create(:planet, :player => @player,
        :owner_changed => Cfg.buildings_self_destruct_creds_safeguard_time.ago)
      @building = Factory.create(:building, :planet => @planet)
    end

    it "should not fail if player is not planet owner for long enough" do
      @planet.owner_changed += 10.minutes
      @planet.save!

      lambda do
        @building.self_destruct!
      end.should_not raise_error(GameLogicError)
    end

    it "should fail if planets cooldown has not yet passed" do
      @planet.can_destroy_building_at = 5.minutes.since
      @planet.save!

      lambda do
        @building.self_destruct!
      end.should raise_error(GameLogicError)
    end

    describe "with creds" do
      before(:each) do
        @player.creds = CONFIG['creds.building.destroy']
        @player.save!
      end

      it "should not fail if cooldown is still there" do
        @planet.can_destroy_building_at = 5.minutes.since
        @planet.save!

        lambda do
          @building.self_destruct!(true)
        end.should_not raise_error(GameLogicError)
      end

      it "should fail if player is not planet owner for long enough" do
        @planet.owner_changed += 10.minutes
        @planet.save!

        lambda do
          @building.self_destruct!(true)
        end.should raise_error(GameLogicError)
      end

      it "should fail if player does not have enough creds" do
        @player.creds -= 1
        @player.save!

        lambda do
          @building.self_destruct!(true)
        end.should raise_error(GameLogicError)
      end

      it "should reduce number of creds" do
        lambda do
          @building.self_destruct!(true)
          @player.reload
        end.should change(@player, :creds).to(0)
      end

      it "should register the destruction in the log" do
        should_record_cred_stats(:self_destruct, [@building]) \
          { @building.self_destruct!(true) }
      end
    end

    it "should fail if building is upgrading" do
      opts_upgrading.apply(@building)
      
      lambda do
        @building.self_destruct!
      end.should raise_error(GameLogicError)
    end

    it "should fail if building is not managable" do
      with_config_values 'buildings.test_building.managable' => false do
        lambda do
          @building.self_destruct!
        end.should raise_error(GameLogicError)
      end
    end

    it "should fail if building is not destroyable" do
      with_config_values 'buildings.test_building.destroyable' => false do
        lambda do
          @building.self_destruct!
        end.should raise_error(GameLogicError)
      end
    end

    it "should progress objective" do
      Objective::SelfDestruct.should_receive(:progress).with(@building)
      @building.self_destruct!
    end

    it "should destroy building" do
      @building.self_destruct!
      lambda do
        @building.reload
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should destroy npc building" do
      building = Factory.create(:b_npc_solar_plant, opts_active)
      lambda do
        building.destroy
      end.should_not raise_error
    end

    it "should set new timestamp on planet" do
      @building.self_destruct!
      @planet.reload
      @planet.can_destroy_building_at.should be_within(
        SPEC_TIME_PRECISION
      ).of(CONFIG.evalproperty("buildings.self_destruct.cooldown").since)
    end

    it "should not fail if resources does not fit to planet" do
      set_resources(@planet, 0, 0, 0)
      @planet.save!

      @building.stub(:self_destruct_resources).and_return([1,2,3])
      lambda do
        @building.self_destruct!
      end.should_not raise_error
    end

    it "should add resources to planets pool" do
      set_resources(@planet, 0, 0, 0, 10, 10, 10)

      @building.stub(:self_destruct_resources).and_return([1,2,3])
      @building.self_destruct!
      @planet.reload
      @planet.metal.should == 1
      @planet.energy.should == 2
      @planet.zetium.should == 3
    end

    it "should dispatch changed with planet" do
      should_fire_event(@planet, EventBroker::CHANGED,
          EventBroker::REASON_OWNER_PROP_CHANGE) do
        @building.self_destruct!
      end
    end

    describe "0000873: Radar visibility gone bug." do
      it "should not fail" do
        player = Factory.create(:player)
        ss = Factory.create(:solar_system)
        p1 = Factory.create(:planet, :solar_system => ss, :player => player)
        p2 = Factory.create(:planet, :solar_system => ss, :position => 1,
          :player => player)

        r1 = Factory.create!(:b_radar, opts_inactive + {:planet => p1})
        r2 = Factory.create!(:b_radar, opts_inactive + {:planet => p2})

        r1.activate!
        r2.activate!

        r2.self_destruct!
        lambda do
          r2.reload
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end

    # Bugfix
    #
    # If destroying a working constructor with prepaid entries, the later SQL
    # update overwrote planet resources and only a part of resources were given
    # back.
    #
    # This could have been avoided if:
    # 1) AR would use += in SQL.
    # 2) or it would have a identity map which actually works.
    it "should return resources for building, constructable & prepaid entries" do
      set_resources(@planet, 100_000, 100_000, 100_000,
                    200_000, 200_000, 200_000)
      unit_class = Unit::Scorpion
      count = 5

      model = Factory.create!(:b_ground_factory,
                              opts_active + {:planet => @planet, :x => 10})
      model.construct!(unit_class.to_s, true, {}, count)
      @planet.reload

      metal, energy, zetium = model.self_destruct_resources
      lambda do
        model.self_destruct!
        @planet.reload
      end.should change_resources_of(@planet,
                   metal + unit_class.metal_cost(1) * count,
                   energy + unit_class.energy_cost(1) * count,
                   zetium + unit_class.zetium_cost(1) * count,
                   5
                 )
    end
  end

  describe "#move!" do
    before(:each) do
      @player = Factory.create(:player,
        :creds => CONFIG['creds.building.move'])
      @planet = Factory.create(:planet, :player => @player)
      @model = Factory.create(:b_collector_t1, opts_active + {
        :planet => @planet, :x => 0, :y => 0, :level => 1}
      )
    end

    it "should fail if building is not managable" do
      with_config_values 'buildings.collector_t1.managable' => false do
        lambda do
          @model.move!(10, 15)
        end.should raise_error(GameLogicError)
      end
    end

    it "should raise error if planet does not belong to player" do
      @planet.player = nil
      @planet.save!

      lambda do
        @model.move!(10, 15)
      end.should raise_error(ArgumentError)
    end

    it "should raise error if player does not have enough creds" do
      @player.creds -= 1
      @player.save!

      lambda do
        @model.move!(10, 15)
      end.should raise_error(GameLogicError)
    end

    it "should raise error if building is under construction" do
      opts_upgrading.apply @model
      lambda do
        @model.move!(10, 15)
      end.should raise_error(GameLogicError)
    end

    it "should raise error if building is working" do
      opts_working.apply @model
      lambda do
        @model.move!(10, 15)
      end.should raise_error(GameLogicError)
    end

    it "should reduce player creds" do
      lambda do
        @model.move!(10, 15)
      end.should change(@player, :creds).to(0)
    end

    it "should record cred stats" do
      should_record_cred_stats(:move, [@model]) { @model.move!(10, 15) }
    end

    it "should dispatch changed" do
      should_fire_event(@model, EventBroker::CHANGED) do
        @model.move!(10, 15)
      end
    end

    it "should not dispatch changed for planet if energy mod is not changed" do
      should_not_fire_event(
        @model.planet, EventBroker::CHANGED,
        EventBroker::REASON_OWNER_PROP_CHANGE
      ) do
        @model.move!(10, 15)
      end
    end

    describe "energy mod changes" do
      before(:each) do
        Factory.create(:tile, :kind => Tile::NOXRIUM, :planet => @model.planet,
          :x => 10, :y => 15)
      end

      describe "when active" do
        it "should dispatch planet changed" do
          should_fire_event(
            @model.planet, EventBroker::CHANGED,
            EventBroker::REASON_OWNER_PROP_CHANGE,
            2 # deactivate/activate
          ) do
            @model.move!(10, 15)
          end
        end

        it "should actually change energy for planet" do
          planet = @model.planet
          lambda do
            @model.move!(10, 15)
            planet.reload
          end.should change(planet, :energy_generation_rate)
        end
      end

      describe "when inactive" do
        before(:each) do
          opts_inactive.apply @model
        end

        it "should not dispatch planet changed" do
          should_not_fire_event(
            @model.planet, EventBroker::CHANGED,
            EventBroker::REASON_OWNER_PROP_CHANGE
          ) do
            @model.move!(10, 15)
          end
        end

        it "should actually change energy for planet" do
          planet = @model.planet
          lambda do
            @model.move!(10, 15)
            planet.reload
          end.should_not change(planet, :energy_generation_rate)
        end
      end
    end

    describe "when not an energy provider" do
      before(:each) do
        @model = Factory.create!(:b_radar, opts_active + {
          :planet => @planet, :x => 10, :y => 0, :level => 1}
        )
      end

      it "should not deactivate it" do
        @model.should_not_receive(:deactivate!)
        @model.move!(10, 15)
      end

      it "should not activate it" do
        @model.should_not_receive(:activate!)
        @model.move!(10, 15)
      end

      it "should save it" do
        @model.should_receive(:save!)
        @model.move!(10, 15)
      end
    end

    it "should progress objective" do
      Objective::MoveBuilding.should_receive(:progress).with(@model)
      @model.move!(10, 15)
    end

    [
      [:armor_mod, Tile::TITAN],
      [:energy_mod, Tile::NOXRIUM],
      [:construction_mod, Tile::JUNKYARD]
    ].each do |mod, kind|
      it "should recalculate #{mod}" do
        Factory.create(:tile, :kind => kind, :planet => @model.planet,
          :x => 10, :y => 15)
        @model.move!(10, 15)
        @model.send(mod).should_not == 0
      end
    end

    it "should change building coordinates" do
      @model.move!(10, 15)
      [@model.x, @model.y].should == [10, 15]
    end

    it "should check for collisions with buildings" do
      Factory.create(:building, :planet => @model.planet, :x => 10, :y => 15)
      lambda do
        @model.move!(10, 15)
      end.should raise_error(ActiveRecord::RecordInvalid)
    end

    it "should not check for collisions with itself" do
      lambda do
        @model.move!(@model.x + 1, @model.y)
      end.should_not raise_error(ActiveRecord::RecordInvalid)
    end

    it "should check for collisions with tiles" do
      Factory.create(:t_ore, :planet => @model.planet, :x => 10, :y => 15)
      lambda do
        @model.move!(10, 15)
      end.should raise_error(ActiveRecord::RecordInvalid)
    end

    it "should check for offmap" do
      lambda do
        @model.move!(-1, 0)
      end.should raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#points_on_upgrade" do
    let(:building) { Factory.create(:building, :level => 2) }

    it "should return points" do
      building.points_on_upgrade.should_not == 0
    end

    it "should return 0 if #without_points? is set" do
      building.without_points = true
      building.points_on_upgrade.should == 0
    end
  end

  describe "#points_on_destroy" do
    let(:building) { Factory.build(:building, :level => 4) }

    it "should return points for all levels" do
      points = 0
      (1..(building.level)).each do |level|
        points += Resources.total_volume(
          building.metal_cost(level),
          building.energy_cost(level),
          building.zetium_cost(level)
        )
      end
      building.points_on_destroy.should == points
    end

    it "should return 0 if #without_points? is set" do
      building.without_points = true
      building.points_on_destroy.should == 0
    end
  end

  describe "destruction" do
    it "should deactivate before destruction" do
      b = Factory.create(:building, opts_active)
      b.should_receive(:deactivate)
      b.destroy
    end

    it "should run on_deactivate when deactivating while being destroyed" do
      b = Factory.create(:building, opts_active)
      b.should_receive(:on_deactivation)
      b.destroy
    end

    it "should run on_destroy" do
      b = Factory.create(:building, opts_active)
      b.should_receive(:on_destroy)
      b.destroy
    end

    it "should not deactivate before destruction if it's already inactive" do
      b = Factory.create(:building, opts_inactive)
      b.should_not_receive(:deactivate)
      b.destroy
    end
  end

  describe ".self_destruct_resources" do
    before(:all) do
      @config_values = {
        'buildings.test_building.metal.cost' => '100 * level',
        'buildings.test_building.energy.cost' => '200 * level',
        'buildings.test_building.zetium.cost' => '300 * level',
        'buildings.self_destruct.resource_gain' => 10
      }
    end
    
    it "should consider resource gain" do
      with_config_values(@config_values) do
        Building::TestBuilding.self_destruct_resources(1).should ==
          [10, 20, 30]
      end
    end

    it "should accumulate levels" do
      with_config_values(@config_values) do
        Building::TestBuilding.self_destruct_resources(3).should ==
          [10 + 20 + 30, 20 + 40 + 60, 30 + 60 + 90]
      end
    end

    it "should round result" do
      with_config_values(
        'buildings.test_building.metal.cost' => '111 * level',
        'buildings.test_building.energy.cost' => '222 * level',
        'buildings.test_building.zetium.cost' => '333 * level',
        'buildings.self_destruct.resource_gain' => 10
      ) do
        Building::TestBuilding.self_destruct_resources(1).should ==
          [11, 22, 33]
      end
    end
  end

  describe "#unit_groups" do
    it "should return grouped unit counts" do
      building = Factory.create(:building)
      data = {
        0 => {"Gnat" => 1, "Glancer" => 2},
        1 => {"Spudder" => 1, "Gnawer" => 2},
      }
      data.each do |flank, inner_data|
        inner_data.each do |type, count|
          count.times do
            Factory.create(
              :unit_built, :location => building, :flank => flank,
              :type => type, :flank => flank
            )
          end
        end
      end

      building.unit_groups.should == data
    end
  end

  describe "notifier" do
    it_behaves_like "notifier", :build => lambda { Factory.build :building },
      :change => lambda { |model| model.level += 1 },
      :notify_on_create => false, :notify_on_update => false
  end

  describe "#upgrade_time" do
    it "should calculate mods" do
      model = Factory.create(:building)
      model.should_receive(:calculate_mods)
      model.send :upgrade_time
    end
  end

  describe "#xp" do
    it "should return 0" do
      Factory.create(:building).xp.should == 0
    end
  end
  
  describe "#xp=" do
    it "should do nothing" do
      model = Factory.create(:building)
      lambda do
        model.xp = 100
      end.should_not change(model, :xp)
    end
  end

  describe ".defensive" do
    it "should return defensive buildings" do
      with_config_values('buildings.test_building.guns' => [:aa]) do
        planet = Factory.create :planet
        shooting1 = Factory.create :building, :planet => planet, :x => 10,
          :y => 10
        shooting2 = Factory.create :building, :planet => planet, :x => 14,
          :y => 14
        Factory.create :b_collector_t1, :planet => planet,
          :x => 20, :y => 10

        Building.defensive.scoped_by_planet_id(planet.id).all.should == [
          shooting1, shooting2
        ]
      end
    end
  end

  describe ".shooting_types" do
    it "should return Array of shooting types" do
      with_config_values('buildings.foo_bar.guns' => [:aa]) do
        Building.defensive_types.should include("FooBar")
      end
    end
  end

  describe ".defensive_types" do
    it "should include shooting units" do
      shooting = Building.combat_types
      (Building.defensive_types & shooting).size.should == shooting.size
    end

    it "should include defensive portal" do
      Building.defensive_types.should include(
        Building::DefensivePortal.to_s.demodulize)
    end
  end

  describe "#npc?" do
    it "should return true if npc" do
      with_config_values('buildings.test_building.npc' => true) do
        Factory.create(:building).should be_npc
      end
    end

    it "should return true if not npc" do
      with_config_values('buildings.test_building.npc' => false) do
        Factory.create(:building).should_not be_npc
      end
    end
  end

  describe "#activate" do
    it "should raise GameLogicError if already active" do
      lambda do
        Factory.build(:building, opts_active).activate
      end.should raise_error(GameLogicError)
    end

    it "should raise GameLogicError if npc building" do
      lambda do
        Factory.build(:b_npc_solar_plant, opts_inactive).activate
      end.should raise_error(GameLogicError)
    end

    it "should not raise GameLogicError if inactive" do
      lambda do
        Factory.build(:building, opts_inactive).activate
      end.should_not raise_error(GameLogicError)
    end
    
    it "should raise error if upgrading" do
      lambda do
        Factory.build(:building, opts_upgrading).activate
      end.should raise_error(GameLogicError)
    end

    it "should fire EventBroker::CHANGED with activated reason" do
      model = Factory.build(:building, opts_inactive)
      should_fire_event(model, EventBroker::CHANGED,
          EventBroker::REASON_ACTIVATED) do
        model.activate!
      end
    end
  end

  describe "#deactivate" do
    it "should raise GameLogicError if already inactive" do
      lambda do
        Factory.build(:building, opts_inactive).deactivate
      end.should raise_error(GameLogicError)
    end

    it "should raise GameLogicError if working" do
      lambda do
        Factory.build(:building, opts_working).deactivate
      end.should raise_error(GameLogicError)
    end

    it "should raise GameLogicError if npc" do
      lambda do
        Factory.build(:b_npc_solar_plant, opts_active).deactivate
      end.should raise_error(GameLogicError)
    end

    it "should not raise GameLogicError if active" do
      lambda do
        Factory.build(:building, opts_active).deactivate
      end.should_not raise_error(GameLogicError)
    end

    it "should fire EventBroker::CHANGED with DEACTIVATED reason" do
      model = Factory.build(:building, opts_active)
      should_fire_event(model, EventBroker::CHANGED,
          EventBroker::REASON_DEACTIVATED) do
        model.deactivate!
      end
    end
  end

  it "should provide #player" do
    @model = Factory.create(:building)
    @model.player.should == @model.planet.player
  end

  it "should provice #player_id" do
    @model = Factory.create(:building)
    @model.player_id.should == @model.planet.player_id
  end

  %w{x y}.each do |attr|
    it "##{attr}_end should return calculated value instead of database" do
      building = Factory.build(:building, "#{attr}_end" => nil)
      building.send("#{attr}_end").should_not be_nil
    end

    it "##{attr}_end should return nil if #{attr} is nil" do
      building = Factory.build(:building, attr => nil)
      building.send("#{attr}_end").should be_nil
    end
  end

  describe "#as_json" do
    it_behaves_like "as json",
      Factory.create(:building),
      nil,
      %w{id planet_id x y x_end y_end armor_mod constructor_mod
      construction_mod energy_mod level type upgrade_ends_at state
      cooldown_ends_at hp overdriven},
      %w{pause_remainder hp_percentage without_points
      constructable_building_id constructable_unit_id flags }
  end

  describe "on create" do
    before(:all) do
      @building = Factory.create(:building)
    end

    [:x, :y].each do |attr|
      it "should validate #{attr} being Fixnum" do
        @model = Factory.build(:building, attr => nil)
        @model.should_not be_valid
      end
    end

    it "should not be active" do
      @building.should_not be_active
    end

    it "should remove folliage under it" do
      planet = Factory.create :planet
      building = Factory.build :building, :x => 5, :y => 5, :planet => planet
      (building.x - 1).upto(building.x + building.width) do |x|
        (building.y - 1).upto(building.y + building.height) do |y|
          Factory.build(:folliage, :planet => planet,
            :x => x, :y => y).save!
        end
      end

      old_count = Folliage.count(
        :conditions => {:planet_id => planet.id})
      building.save!
      new_count = Folliage.count(
        :conditions => {:planet_id => planet.id})

      # +1 for the x-1, y-1. I know I should write other test for this but
      # I'm too lazy now :)
      (old_count - new_count).should == building.width * building.height + 1
    end

    it "should remove folliage at x-1,y-1" do
      x = 5
      y = 5
      planet = Factory.create :planet
      building = Factory.build :building, :x => x, :y => y,
        :planet => planet
      Factory.build(:folliage, :planet => planet,
        :x => x - 1, :y => y - 1).save!

      building.save!
      Folliage.count(:conditions => {:planet_id => planet.id}).should == 0
    end

    describe "ensuring dimensions" do
      it "should set x_end from config" do
        @model = Factory.create(:building, :x_end => 1000)
        @model.x_end.should == @model.x + @model.width - 1
      end

      it "should set y_end from config" do
        @model = Factory.create(:building, :y_end => 1000)
        @model.y_end.should == @model.y + @model.height - 1
      end

      it "should not set dimensions when updating" do
        @model = Factory.create(:building)
        lambda { @model.save! }.should_not raise_error(ArgumentError)
      end
    end

    describe "building offmap" do
      before(:all) do
        @planet = Factory.create :planet_with_player, :width => 20, :height => 20
      end

      it "should not allow building offmap (x < 0)" do
        building = Factory.build(:building, :planet => @planet, :x => -1)
        building.should_not be_valid
      end

      it "should not allow building offmap (x_end > width)" do
        building = Factory.build(:building, :planet => @planet)
        building.x = @planet.width - building.width + 1
        building.should_not be_valid
      end

      it "should not allow building offmap (y < 0)" do
        building = Factory.build(:building, :planet => @planet, :y => -1)
        building.should_not be_valid
      end

      it "should not allow building offmap (y_end > height)" do
        building = Factory.build(:building, :planet => @planet)
        building.y = @planet.height - building.height + 1
        building.should_not be_valid
      end
    end

    describe "collision detection" do
      COLLISION_MAP = [
        {:x =>  0, :y =>  1, :name => "top"},
        {:x =>  1, :y =>  0, :name => "right"},
        {:x =>  0, :y => -1, :name => "bottom"},
        {:x => -1, :y =>  0, :name => "left"},
        {:x => -1, :y =>  1, :name => "top left"},
        {:x =>  1, :y =>  1, :name => "top right"},
        {:x => -1, :y => -1, :name => "bottom left"},
        {:x =>  1, :y => -1, :name => "bottom right"},
      ]

      shared_examples_for "checking colisions" do |obstruction, border|
        describe "collision" do
          COLLISION_MAP.each do |entry|
            it "should check #{entry[:name]}" do
              building = Factory.build(:building, :planet => obstruction.planet)
              building.x = case entry[:x]
                when 1 then obstruction.x_end + (border ? 1 : 0)
                when -1 then obstruction.x - building.width + (border ? 0 : 1)
                else obstruction.x
              end
              building.y = case entry[:y]
                when 1 then obstruction.y_end + (border ? 1 : 0)
                when -1 then obstruction.y - building.height + (border ? 0 : 1)
                else obstruction.y
              end
              building.should_not be_valid
            end
          end
        end

        describe "safe placement" do
          COLLISION_MAP.each do |entry|
            it "should check #{entry[:name]}" do
              building = Factory.build(:building, :planet => obstruction.planet)
              building.x = case entry[:x]
                when 1 then obstruction.x_end + (border ? 2 : 1)
                when -1 then obstruction.x - building.width - (border ? 1 : 0)
                else obstruction.x
              end
              building.y = case entry[:y]
                when 1 then obstruction.y_end + (border ? 2 : 1)
                when -1 then obstruction.y - building.height - (border ? 1 : 0)
                else obstruction.y
              end
              building.should be_valid
            end
          end
        end
      end

      describe "against buildings" do
        it_should_behave_like "checking colisions",
          Factory.create(:building, :x => 20, :y => 20),
          true
      end

      describe "against resource tiles" do
        Tile::RESOURCE_TILES.each do |tile_type|
          describe Tile::MAPPING[tile_type] do
            it_should_behave_like "checking colisions",
              Factory.create(:tile, :kind => tile_type, :x => 20, :y => 20),
              true
          end
        end
      end

      describe "against exploration tiles" do
        Tile::EXPLORATION_TILES.each do |tile_type|
          describe Tile::MAPPING[tile_type] do
            it_should_behave_like "checking colisions",
              Factory.create(:tile, :kind => tile_type, :x => 20, :y => 20),
              false
          end
        end
      end

      it "should not do these checks if updating" do
        lambda do
          @building1.save!
        end.should_not raise_error(ActiveRecord::RecordInvalid)
      end
    end

    describe "tile affection" do
      before(:each) do
        @planet = Factory.create :planet
        Factory.create :t_titan, :planet => @planet, :x => 0, :y => 0
        Factory.create :t_noxrium, :planet => @planet, :x => 0, :y => 1

        Factory.create :t_sand, :planet => @planet, :x => 1, :y => 0
        Factory.create :t_sand, :planet => @planet, :x => 1, :y => 1

        Factory.create :t_junkyard, :planet => @planet, :x => 2, :y => 0
        Factory.create :t_junkyard, :planet => @planet, :x => 2, :y => 1

        Factory.create :t_noxrium, :planet => @planet, :x => 3, :y => 0
        Factory.create :t_noxrium, :planet => @planet, :x => 3, :y => 1
      end

      def calc_mod(building, mod)
        sum = 0
        Tile.for_building(building).count(:group => "kind").each do |kind, count|
          name = Tile::MAPPING[kind]
          sum += count * (CONFIG["tiles.#{name}.mod.#{mod}"] || 0)
        end
        sum
      end

      it "should not calculate anything if all of the mods are set" do
        building = Factory.create :building, :planet => @planet,
          :x => 0, :y => 0, :armor_mod => 90, :constructor_mod => 90,
          :energy_mod => 90
        building.armor_mod.should == 90
        building.constructor_mod.should == 90
        building.energy_mod.should == 90
      end

      describe "armor" do
        it "should calculate armor_mod" do
          building = Factory.create :building, :planet => @planet,
            :x => 0, :y => 0
          building.armor_mod.should == calc_mod(building, "armor")
        end

        it "should include level armor mod" do
          building = Factory.create :building, :planet => @planet,
            :x => 0, :y => 0, :level => 2
          building.armor_mod.should == (calc_mod(building, "armor") + 10)
        end
      end

      describe "construction mod" do
        describe "constructor" do
          before(:each) do
            @building = Factory.create :b_constructor_test,
              :planet => @planet,
              :x => 2, :y => 0, :construction_mod => 10
            @mod = calc_mod(@building, "construction")
          end

          it "should be affected by tiles" do
            @building.constructor_mod.should == @mod
          end

          it "should add it to construction_mod" do
            @building.construction_mod.should == 10 + @mod
          end
        end

        describe "non-constructor" do
          before(:each) do
            @building = Factory.create :building,
              :planet => @planet,
              :x => 2, :y => 0, :construction_mod => 10
            @mod = calc_mod(@building, "construction")
          end

          it "should not set constructor mod" do
            @building.constructor_mod.should == 0
          end

          it "should still add it to construction mod" do
            @building.construction_mod.should == 10 + @mod
          end
        end
      end

      describe "energy" do
        it "should be affected by tiles if it's an energy generator" do
          building = Factory.create :b_collector_t1, :planet => @planet,
            :x => 0, :y => 0
          building.energy_mod.should == calc_mod(building, "energy")
        end

        it "should be affected by tiles if it's an energy generator " +
        "(at level 0)" do
          building = Factory.create :b_collector_t1, :planet => @planet,
            :x => 0, :y => 0, :level => 0, :hp => 0
          building.energy_mod.should == calc_mod(building, "energy")
        end

        it "should not be affected by tiles if ain't an energy generator" do
          building = Factory.create :b_barracks, :planet => @planet,
            :x => 0, :y => 0
          building.energy_mod.should == 0
        end

        it "should not be affected by tiles if ain't an energy generator" +
        " but is resources manager" do
          building = Factory.create! :b_radar, :planet => @planet,
            :x => 0, :y => 0
          building.energy_mod.should == 0
        end
      end
    end
  end

  describe "#damage_mod" do
    it "should be 0" do
      Factory.create(:building, :level => 3).damage_mod.should == 0
    end
  end

  describe "#upgrade" do
    before(:each) do
      @player = Factory.create(:player)
      @planet = Factory.create(:planet, :player => @player)
      @building = Factory.build :building, :planet => @planet, :level => 5
    end

    it "should raise GameLogicError if unmanagable" do
      with_config_values 'buildings.test_building.managable' => false do
        lambda do
          @building.upgrade
        end.should raise_error(GameLogicError)
      end
    end

    it "should call #deactivate if active" do
      opts_active | @building
      @building.should_receive(:deactivate)
      @building.upgrade
    end

    it "should not call #deactivate if inactive" do
      opts_inactive | @building
      @building.should_not_receive(:deactivate)
      @building.upgrade
    end
  end

  describe "upgradable" do
    before(:each) do
      # #economy_points is needed for #cancel! test.
      @player = Factory.create(:player, :economy_points => 10000)
      @planet = Factory.create(:planet, :player => @player)
      @model = Factory.create :building_built, :level => 1,
        :planet => @planet
      
      set_resources(@planet,
        @model.metal_cost(@model.level + 1),
        @model.energy_cost(@model.level + 1),
        @model.zetium_cost(@model.level + 1),
        1_000_000, 1_000_000, 1_000_000 # High storages for #cancel!
      )
    end

    it_behaves_like "upgradable"
    it_behaves_like "upgradable with hp"
    it_behaves_like "default upgradable time calculation"
  end
  
  describe "#cancel!" do
    before(:each) do
      @model = Factory.create(:building_built, 
        opts_upgrading + {:level => 1, :state => Building::STATE_INACTIVE})
      CallbackManager.register(@model, CallbackManager::EVENT_UPGRADE_FINISHED,
        @model.upgrade_ends_at)
    end
    
    it "should return to active state" do
      lambda do
        @model.cancel!
      end.should change(@model, :state).from(Building::STATE_INACTIVE).
        to(Building::STATE_ACTIVE)
    end

    it "should not return to active if level == 0" do
      lambda do
        @model.level = 0
        @model.cancel!
      end.should_not change(@model, :state)
    end
  end

  describe "#on_upgrade_finished" do
    before(:each) do
      @model = Factory.create :building_just_constructed,
        :level => 3
    end

    it "should activate building" do
      @model.should_receive(:activate)
      @model.send(:on_upgrade_finished)
    end

    it "should clear construction mod gained from constructor" do
      @model.construction_mod = 10
      @model.save!
      Factory.create(:t_junkyard, :planet => @model.planet, :x => @model.x,
        :y => @model.y)
      lambda do
        @model.send(:on_upgrade_finished!)
      end.should change(@model, :construction_mod).from(10).to(
        CONFIG["tiles.junkyard.mod.construction"])
    end
  end

  describe "#on_upgrade_finished!" do
    describe "combat check after upgrade is finished" do
      let(:building) { Factory.create!(:building, opts_upgrading) }

      it "should check for combat in it's location if it can fight'" do
        building.stub!(:can_fight?).and_return(true)
        Combat::LocationChecker.should_receive(:check_location).
          with(building.planet.location_point)
        building.send(:on_upgrade_finished!)
      end

      it "should not check for combat in it's location if it cannot fight'" do
        building.stub!(:can_fight?).and_return(false)
        Combat::LocationChecker.should_not_receive(:check_location)
        building.send(:on_upgrade_finished!)
      end
    end
  end

  %w{width height}.each do |attr|
    it "should respond to #{attr}" do
      @model = Factory.create(:building)
      @model.send(attr).should == CONFIG[
        "buildings.#{@model.class.to_s.demodulize.underscore}.#{attr}"
      ]
    end
  end

  describe "#hit_points" do
    it "should return int" do
      Factory.create(:building).hit_points.should == 1000
    end
  end

  %w{metal_cost energy_cost zetium_cost}.each do |attr|
    it "should respond to ##{attr}" do
      @model = Factory.create(:building)
      @model.send(attr, 1).should be_instance_of(Fixnum)
    end
  end
end