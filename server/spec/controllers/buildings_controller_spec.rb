require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe BuildingsController do
  include ControllerSpecHelper

  before(:each) do
    init_controller BuildingsController, :login => true
  end

  describe "buildings|new" do
    before(:each) do
      @action = "buildings|new"
      @planet = Factory.create :planet_with_player, :player => player
      @constructor = Factory.create :b_constructor_test, opts_active + {
        :planet => @planet, :x => 0, :y => 0}
      set_resources(@planet, 10000, 10000, 10000)
      @x = @constructor.x_end + 2
      @y = @constructor.y_end + 2
      @type = 'TestBuilding'
      @params = {'type' => @type,
        'x' => @x, 'y' => @y, 'constructor_id' => @constructor.id}
    end

    it "should not allow creating new buildings on planets that " +
    "player doesn't own" do
      @planet.player = nil
      @planet.save!

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should not allow constructing unconstructable buildings" do
      lambda do
        invoke @action, @params.merge('type' => 'Headquarters')
      end.should raise_error(GameLogicError)
    end

    it "should not allow creating new buildings if there are " +
    "no constructors" do
      lambda do
        @constructor.destroy
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
    
    @required_params = %w{constructor_id x y type}
    it_should_behave_like "with param options"
  end

  describe "buildings|upgrade" do
    before(:each) do
      @action = "buildings|upgrade"
      @planet = Factory.create :planet_with_player, :player => player
      set_resources(@planet, 10000, 10000, 10000)
      @building = Factory.create :building_built, :planet => @planet
    end

    it "should not allow upgrading buildings that player doesn't own" do
      @planet.player = nil
      @planet.save!

      lambda do
        invoke @action, 'id' => @building.id
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should return building" do
      invoke @action, 'id' => @building.id
      @building.reload
      response_should_include(:building => @building.as_json)
    end

    it "should put building into upgrading state" do
      invoke @action, 'id' => @building.id
      @building.reload
      @building.should be_upgrading
    end
  end

  describe "buildings|activate" do
    before(:each) do
      @action = "buildings|activate"
    end

    it "should activate building" do
      building = Factory.create(:building_built, opts_inactive + {
        :planet => Factory.create(:planet_with_player, :player => player)
      })
      invoke @action, 'id' => building.id
      building.reload
      building.should be_active
    end

    it "should not allow activating buildings that player doesn't own" do
      building = Factory.create :building_built, opts_inactive

      lambda do
        invoke @action, 'id' => building.id
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "buildings|deactivate" do
    before(:each) do
      @action = "buildings|deactivate"
    end

    it "should deactivate building" do
      building = Factory.create :building_built, opts_active + {
        :planet => Factory.create(:planet_with_player, :player => player)
      }
      invoke @action, 'id' => building.id
      building.reload
      building.should be_inactive
    end

    it "should not allow activating buildings that player doesn't own" do
      building = Factory.create :building_built, opts_active

      lambda do
        invoke @action, 'id' => building.id
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "buildings|self_destruct" do
    before(:each) do
      @action = "buildings|self_destruct"
      @planet = Factory.create(:planet, :player => player)
      @building = Factory.create(:building, :planet => @planet)
      @params = {'id' => @building.id, 'with_creds' => false}
    end

    @required_params = %w{id with_creds}
    it_should_behave_like "with param options"

    it "should raise error if building is not found" do
      @building.destroy
      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should raise error if planet does not belong to player" do
      @planet.player = Factory.create(:player)
      @planet.save!
      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should self destruct the building" do
      invoke @action, @params
      lambda do
        @building.reload
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "buildings|move" do
    before(:each) do
      @action = "buildings|move"
      @planet = Factory.create(:planet, :player => player)
      @building = Factory.create(:building, :planet => @planet)
      @params = {'id' => @building.id, 'x' => 10, 'y' => 15}
    end

    @required_params = %w{id x y}
    it_should_behave_like "with param options"

    it "should fail if building does not belong to player" do
      @planet.player = Factory.create(:player)
      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should move building" do
      Building.stub!(:find).with(@building.id, anything).and_return(@building)
      @building.should_receive(:move!).with(10, 15)
      invoke @action, @params
    end
  end

  describe "accelerate", :shared => true do
    it "should raise error when providing wrong index" do
      lambda do
        invoke @action, @params.merge('index' => @params['index'] + 1)
      end.should raise_error(GameLogicError)
    end

    it "should raise error if planet does not belong to player" do
      @planet.player = Factory.create(:player)
      @planet.save!

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "buildings|accelerate_constructor" do
    before(:each) do
      @action = "buildings|accelerate_constructor"
      player.creds += 100000
      player.save!
      @planet = Factory.create(:planet, :player => player)
      @building = Factory.create(:b_mothership, opts_active + 
          {:planet => @planet})
      @constructable = @building.construct!("Building::Barracks",
        :x => 10, :y => 10)
      @params = {'id' => @building.id,
        'index' => CONFIG['creds.upgradable.speed_up'].size - 1}
    end

    it_should_behave_like "accelerate"

    it "should accelerate building" do
      @controller.should_receive(:find_building).and_return(@building)
      @building.should_receive(:accelerate_construction!).with(
        @params['index'])
      invoke @action, @params
    end
  end

  describe "buildings|accelerate_upgrade" do
    before(:each) do
      @action = "buildings|accelerate_upgrade"
      player.creds += 100000
      player.save!
      @planet = Factory.create(:planet, :player => player)
      @building = Factory.create(:building, :planet => @planet)
      @building.upgrade!
      @params = {'id' => @building.id,
        'index' => CONFIG['creds.upgradable.speed_up'].size - 1}
    end

    it_should_behave_like "accelerate"

    it "should accelerate building" do
      @controller.should_receive(:find_building).and_return(@building)
      @building.should_receive(:accelerate!).with(@params['index'])
      invoke @action, @params
    end
  end
end