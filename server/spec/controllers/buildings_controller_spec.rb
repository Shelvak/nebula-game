require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe BuildingsController do
  include ControllerSpecHelper

  before(:each) do
    init_controller BuildingsController, :login => true
  end

  shared_examples_for "finding building" do
    it_behaves_like "with param options", %w{id}
    
    it "should raise error if building is not found" do
      @building.destroy
      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should fail if player does not own planet" do
      @planet.player = nil
      @planet.save!

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
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
      @params = {'type' => @type, 'prepaid' => true,
        'x' => @x, 'y' => @y, 'constructor_id' => @constructor.id}
    end

    it_behaves_like "with param options", %w{constructor_id x y type prepaid}

    it "should fail if not prepaid and not player is not vip" do
      @params['prepaid'] = false
      player.stub(:vip?).and_return(false)

      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
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

    it "should invoke #construct! on constructor" do
      Building.should_receive(:find).
        with(@constructor.id, an_instance_of(Hash)).and_return(@constructor)
      @constructor.should_receive(:construct!).with(
        "Building::#{@params['type']}", @params['prepaid'],
        :x => @params['x'], :y => @params['y']
      )
      invoke @action, @params
    end
  end

  describe "buildings|upgrade" do
    before(:each) do
      @planet = Factory.create :planet_with_player, :player => player
      set_resources(@planet, 10000, 10000, 10000)
      @building = Factory.create :building_built, :planet => @planet
      
      @action = "buildings|upgrade"
      @params = {'id' => @building.id}
    end

    it_behaves_like "finding building"

    it "should return building" do
      invoke @action, @params
      @building.reload
      response_should_include(:building => @building.as_json)
    end

    it "should put building into upgrading state" do
      invoke @action, @params
      @building.reload
      @building.should be_upgrading
    end
  end

  describe "buildings|activate" do
    before(:each) do
      @planet = Factory.create(:planet_with_player, :player => player)
      @building = Factory.create(:building_built, opts_inactive + {
        :planet => @planet
      })
    
      @action = "buildings|activate"
      @params = {'id' => @building.id}
    end

    it_behaves_like "finding building"
    
    it "should activate building" do
      lambda do
        invoke @action, @params
        @building.reload
      end.should change(@building, :state).
        from(Building::STATE_INACTIVE).
        to(Building::STATE_ACTIVE)
    end
  end

  describe "buildings|deactivate" do
    before(:each) do
      @planet = Factory.create(:planet_with_player, :player => player)
      @building = Factory.create(:building_built, opts_active + {
        :planet => @planet
      })
    
      @action = "buildings|deactivate"
      @params = {'id' => @building.id}
    end
    
    it_behaves_like "finding building"

    it "should deactivate building" do
      lambda do
        invoke @action, @params
        @building.reload
      end.should change(@building, :state).
        from(Building::STATE_ACTIVE).
        to(Building::STATE_INACTIVE)
    end
  end

  describe "buildings|activate_overdrive" do
    before(:each) do
      @planet = Factory.create(:planet_with_player, :player => player)
      tile = Factory.create(:t_ore, :planet => @planet)
      @building = Factory.create(:b_metal_extractor, opts_active + {
        :planet => @planet, :x => tile.x, :y => tile.y
      })

      @action = "buildings|activate_overdrive"
      @params = {'id' => @building.id}
    end

    it_behaves_like "finding building"

    it "should activate overdrive on building" do
      lambda do
        invoke @action, @params
        @building.reload
      end.should change(@building, :overdriven).from(false).to(true)
    end

    it "should fail if building is not overdriveable" do
      building = Factory.create(:b_collector_t1, opts_active + {
        :planet => @planet, :x => 10
      })
      lambda do
        invoke @action, @params.merge('id' => building.id)
      end.should raise_error(GameLogicError)
    end
  end

  describe "buildings|deactivate_overdrive" do
    before(:each) do
      @planet = Factory.create(:planet_with_player, :player => player)
      tile = Factory.create(:t_ore, :planet => @planet)
      @building = Factory.create(:b_metal_extractor, opts_active + {
        :planet => @planet, :x => tile.x, :y => tile.y, :overdriven => true
      })

      @action = "buildings|deactivate_overdrive"
      @params = {'id' => @building.id}
    end

    it_behaves_like "finding building"

    it "should deactivate overdrive on building" do
      lambda do
        invoke @action, @params
        @building.reload
      end.should change(@building, :overdriven).from(true).to(false)
    end

    it "should fail if building is not overdriveable" do
      building = Factory.create(:b_collector_t1, opts_active + {
        :planet => @planet, :x => 10, :overdriven => true
      })
      lambda do
        invoke @action, @params.merge('id' => building.id)
      end.should raise_error(GameLogicError)
    end
  end

  describe "buildings|self_destruct" do
    before(:each) do
      @action = "buildings|self_destruct"
      @planet = Factory.create(:planet, :player => player)
      @building = Factory.create(:building, :planet => @planet)
      @params = {'id' => @building.id, 'with_creds' => false}
    end

    it_behaves_like "with param options", %w{id with_creds}
    it_behaves_like "finding building"

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

    it_behaves_like "with param options", %w{id x y}
    it_behaves_like "finding building"

    it "should move building" do
      Building.stub!(:find).with(@building.id, anything).and_return(@building)
      @building.should_receive(:move!).with(10, 15)
      invoke @action, @params
    end
  end

  shared_examples_for "accelerate" do
    it_behaves_like "with param options", %w{id index}
    
    it "should raise error when providing wrong index" do
      lambda do
        invoke @action, @params.merge('index' => @params['index'] + 1)
      end.should raise_error(GameLogicError)
    end
  end

  describe "buildings|accelerate_constructor" do
    before(:each) do
      player.creds += 100000
      player.save!
      @planet = Factory.create(:planet, :player => player)
      @building = Factory.create(:b_headquarters, opts_active + 
          {:planet => @planet})
      @constructable = @building.construct!("Building::Barracks",
        :x => 10, :y => 10)
      
      @action = "buildings|accelerate_constructor"
      @params = {'id' => @building.id,
        'index' => CONFIG['creds.upgradable.speed_up'].size - 1}
    end

    it_behaves_like "finding building"
    it_behaves_like "accelerate"

    it "should accelerate building" do
      @controller.should_receive(:find_building).and_return(@building)
      Creds.should_receive(:accelerate_construction!).with(
        @building, @params['index'])
      invoke @action, @params
    end
  end

  describe "buildings|accelerate_upgrade" do
    before(:each) do
      player.creds += 100000
      player.save!
      @planet = Factory.create(:planet, :player => player)
      @building = Factory.create(:building, :planet => @planet)
      @building.upgrade!
      
      @action = "buildings|accelerate_upgrade"
      @params = {'id' => @building.id,
        'index' => CONFIG['creds.upgradable.speed_up'].size - 1}
    end

    it_behaves_like "finding building"
    it_behaves_like "accelerate"

    it "should accelerate building" do
      @controller.should_receive(:find_building).and_return(@building)
      Creds.should_receive(:accelerate!).with(@building, @params['index'])
      invoke @action, @params
    end
  end
  
  describe "buildings|cancel_constructor" do
    before(:each) do
      @planet = Factory.create(:planet, :player => player)
      @building = Factory.create(:b_headquarters, opts_active + 
          {:planet => @planet})
      @constructable = @building.construct!("Building::Barracks",
        :x => 10, :y => 10)
      
      @action = "buildings|cancel_constructor"
      @params = {'id' => @building.id}
    end
    
    it_behaves_like "finding building"
    
    it "should call #cancel_constructable! on constructor" do
      @controller.should_receive(:find_building).and_return(@building)
      @building.should_receive(:cancel_constructable!)
      invoke @action, @params
    end
  end
  
  describe "buildings|cancel_upgrade" do
    before(:each) do
      @planet = Factory.create(:planet, :player => player)
      @building = Factory.create(:building, :planet => @planet)
      @building.upgrade!
      
      @action = "buildings|cancel_upgrade"
      @params = {'id' => @building.id}
    end
    
    it_behaves_like "finding building"
    
    it "should call #cancel! on building" do
      @controller.should_receive(:find_building).and_return(@building)
      @building.should_receive(:cancel!)
      invoke @action, @params
    end
  end

  describe "buildings|set_build_in_2nd_flank" do
    before(:each) do
      @planet = Factory.create(:planet, :player => player)
      @building = Factory.create(:building, :planet => @planet)

      @action = "buildings|set_build_in_2nd_flank"
      @params = {'id' => @building.id, 'enabled' => true}
    end

    it_behaves_like "finding building"

    it "should set flag on building" do
      lambda do
        invoke @action, @params
        @building.reload
      end.should change(@building, :build_in_2nd_flank).to(@params['enabled'])
    end
  end

  describe "buildings|set_build_hidden" do
    before(:each) do
      @planet = Factory.create(:planet, :player => player)
      @building = Factory.create(:building, :planet => @planet)

      @action = "buildings|set_build_hidden"
      @params = {'id' => @building.id, 'enabled' => true}
    end

    it_behaves_like "finding building"

    it "should set flag on building" do
      lambda do
        invoke @action, @params
        @building.reload
      end.should change(@building, :build_hidden).to(@params['enabled'])
    end
  end
end