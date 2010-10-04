require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Building do
  describe "notifier" do
    before(:each) do
      @build = lambda { Factory.build :building }
      @change = lambda do |model|
        model.level += 1
      end
    end

    @should_not_notify_create = true
    @should_not_notify_update = true
    it_should_behave_like "notifier"
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

  describe ".shooting" do
    it "should return shooting buildings" do
      with_config_values('buildings.test_building.guns' => [:aa]) do
        planet = Factory.create :planet
        shooting1 = Factory.create :building, :planet => planet, :x => 10,
          :y => 10
        shooting2 = Factory.create :building, :planet => planet, :x => 14,
          :y => 14
        Factory.create :b_solar_plant, :planet => planet,
          :x => 20, :y => 10

        Building.shooting.scoped_by_planet_id(planet.id).all.should == [
          shooting1, shooting2
        ]
      end
    end
  end

  describe ".shooting_types" do
    it "should return Array of shooting types" do
      with_config_values('buildings.foo_bar.guns' => [:aa]) do
        Building.shooting_types.should include("FooBar")
      end
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

  describe "#to_json" do
    before(:all) do
      @model = Factory.create :building
    end

    @required_fields = %w{}
    @ommited_fields = %w{pause_remainder}
    it_should_behave_like "to json"
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

    it "should set hp to 0" do
      @building.hp.should == 0
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
      before(:all) do
        @building1 = Factory.create(:building, :x => 20, :y => 20)
      end

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

      COLLISION_MAP.each do |entry|
        it "should check #{entry[:name]} collision" do
          building2 = Factory.build(:building, :planet => @building1.planet)
          if entry[:x] == 1
            building2.x = @building1.x_end + 1
          elsif entry[:x] == -1
            building2.x = @building1.x - building2.width
          else
            building2.x = @building1.x
          end
          if entry[:y] == 1
            building2.y = @building1.y_end + 1
          elsif entry[:y] == -1
            building2.y = @building1.y - building2.height
          else
            building2.y = @building1.y
          end
          building2.should_not be_valid
        end

        it "should check #{entry[:name]} safe placement" do
          building2 = Factory.build(:building, :planet => @building1.planet)
          if entry[:x] == 1
            building2.x = @building1.x_end + 2
          elsif entry[:x] == -1
            building2.x = @building1.x - building2.width - 1
          else
            building2.x = @building1.x
          end
          if entry[:y] == 1
            building2.y = @building1.y_end + 2
          elsif entry[:y] == -1
            building2.y = @building1.y - building2.height - 1
          else
            building2.y = @building1.y
          end
          building2.should be_valid
        end
      end

      it "should not do these checks if updating" do
        lambda { @building1.save! }.should_not raise_error(ActiveRecord::RecordInvalid)
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

      it "should not be able to build on water" do
        Factory.create :t_water, :planet => @planet, :x => 10, :y => 10
        building = Factory.build :building, :planet => @planet, :x => 9,
          :y => 9
        building.should_not be_valid
      end

      Tile::BLOCK_SIZES.each do |kind, dimensions|
        name = Tile::MAPPING[kind]
        width, height = dimensions

        [0, width - 1].each do |x_shift|
          [0, height - 1].each do |y_shift|
            it "should not be able to build on #{name
            } (shift: #{x_shift}, #{y_shift})" do
              tile = Factory.create "t_#{name}", :planet => @planet,
                :x => 12,
                :y => 12
              building = Factory.build :building, :planet => @planet,
                :x => tile.x + x_shift,
                :y => tile.y + y_shift
              building.should_not be_valid
            end
          end
        end

        [[-1, -1], [width, 0]].each do |x_shift, x_mod|
          [[-1, -1], [height, 0]].each do |y_shift, y_mod|
            it "should be able to next to #{name
            } (shift: #{x_shift}, #{y_shift})" do
              tile = Factory.create "t_#{name}", :planet => @planet,
                :x => 20,
                :y => 20
              building = Factory.build :building, :planet => @planet
              building.x = tile.x + x_shift + (building.width - 1) * x_mod
              building.y = tile.y + y_shift + (building.height - 1) * y_mod
              building.should be_valid
            end
          end
        end
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
        before(:each) do
          @building = Factory.create :building, :planet => @planet,
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

      describe "energy" do
        it "should be affected by tiles" do
          building = Factory.create :building, :planet => @planet,
            :x => 0, :y => 0
          building.energy_mod.should == calc_mod(building, "energy")
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
      @planet = Factory.create(:resources_entry).planet
      @building = Factory.build :building, :planet => @planet, :level => 5
    end

    it "should raise GameLogicError if npc" do
      with_config_values 'buildings.test_building.npc' => true do
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
      @model = Factory.build :building_built, :level => 1
      
      @re = @model.planet.resources_entry
      set_resources(@re,
        @model.metal_cost(@model.level + 1),
        @model.energy_cost(@model.level + 1),
        @model.zetium_cost(@model.level + 1)
      )
    end

    it_should_behave_like "upgradable"
    it_should_behave_like "upgradable with hp"
    it_should_behave_like "default upgradable time calculation"
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
    it "should return 0 for level 0" do
      Factory.create(:building).hit_points(0).should == 0
    end

    it "should return use formula for other levels" do
      Factory.create(:building).hit_points(2).should == 2000
    end
  end

  %w{metal_cost energy_cost zetium_cost}.each do |attr|
    it "should respond to ##{attr}" do
      @model = Factory.create(:building)
      @model.send(attr, 1).should be_instance_of(Fixnum)
    end
  end

  %w{x x_end y y_end}.each do |attr|
    it "should not allow changing #{attr} after create" do
      building = Factory.create(:building)
      lambda do
        building.send("#{attr}=", building.send(attr) + 1)
      end.should raise_error(ArgumentError)
    end
  end
end