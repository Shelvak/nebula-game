require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe BuildingsController do
  include ControllerSpecHelper

  before(:each) do
    init_controller BuildingsController, :login => true
  end

  shared_examples_for "finding building" do
    it_behaves_like "with param options", :required => %w{id}
    
    it "should raise error if building is not found" do
      (@building || building).destroy
      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should fail if player does not own planet" do
      planet = (@planet || self.planet)
      planet.player = nil
      planet.save!

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

  shared_examples_for "only for constructors" do |id_key|
    it "should fail if building is not an constructor" do
      @building.destroy!
      @building = Factory.create(:building_built, @constructor_opts)
      @params[id_key] = @building.id

      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end
  end

  describe "buildings|show_garrison_groups" do
    let(:planet) { Factory.create(:planet, :player => player) }
    let(:building) do
      building = Factory.create(:building, :planet => planet)
      Factory.create(:u_gnat, :location => building)
      Factory.create(:u_gnat, :location => building)
      Factory.create(:u_glancer, :location => building)
      building
    end

    before(:each) do
      @action = "buildings|show_garrison_groups"
      @params = {'id' => building.id}
    end

    it_should_behave_like "having controller action scope"
    it_behaves_like "finding building"

    it "should return building#unit_groups" do
      invoke @action, @params
      response_should_include(:groups => building.unit_groups)
    end

    it "should work for ally too" do
      alliance = create_alliance
      planet.player = alliance.owner; planet.save!
      player.alliance = alliance; player.save!
      invoke @action, @params
      response_should_include(:groups => building.unit_groups)
    end
  end

  describe "buildings|show_garrison" do
    let(:planet) { Factory.create(:planet, :player => player) }
    let(:building) { Factory.create(:building, :planet => planet) }

    before(:each) do
      @units = [
        Factory.create(:unit, :location => building),
        Factory.create(:unit, :location => building),
      ]

      @action = "buildings|show_garrison"
      @params = {'id' => building.id}
    end

    it_should_behave_like "having controller action scope"
    it_should_behave_like "finding building"

    it "should fail if building cannot be found" do
      building.destroy
      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should return units otherwise" do
      invoke @action, @params
      response_should_include(units: @units.map(&:as_json))
    end

    it "should work for ally too" do
      alliance = create_alliance
      planet.player = alliance.owner; planet.save!
      player.alliance = alliance; player.save!
      invoke @action, @params
      response_should_include(units: @units.map(&:as_json))
    end
  end

  describe "buildings|new" do
    before(:each) do
      @action = "buildings|new"
      @planet = Factory.create :planet_with_player, :player => player
      @constructor_opts = opts_active + {:planet => @planet, :x => 0, :y => 0}
      @building = Factory.create :b_constructor_test, @constructor_opts
      set_resources(@planet, 10000, 10000, 10000)
      @x = @building.x_end + 2
      @y = @building.y_end + 2
      @type = 'TestBuilding'
      @params = {'type' => @type, 'prepaid' => true,
        'x' => @x, 'y' => @y, 'constructor_id' => @building.id}
    end

    it_behaves_like "with param options", %w{constructor_id x y type prepaid}
    it_should_behave_like "only for constructors", 'constructor_id'
    it_should_behave_like "having controller action scope"

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
        @building.destroy
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should invoke #construct! on constructor" do
      Building.should_receive(:find).
        with(@building.id, an_instance_of(Hash)).and_return(@building)
      @building.should_receive(:construct!).with(
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
    it_should_behave_like "having controller action scope"

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
    it_should_behave_like "having controller action scope"
    
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
    it_should_behave_like "having controller action scope"

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
    it_should_behave_like "having controller action scope"

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
    it_should_behave_like "having controller action scope"

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
    it_should_behave_like "having controller action scope"

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
    it_should_behave_like "having controller action scope"

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
      player.pure_creds += 100000
      player.save!
      @planet = Factory.create(:planet, :player => player)
      @constructor_opts = opts_active + {:planet => @planet}
      @building = Factory.create(:b_headquarters, @constructor_opts)
      @constructable = @building.construct!(Building::Barracks.to_s, false,
        :x => 10, :y => 10)
      
      @action = "buildings|accelerate_constructor"
      @params = {'id' => @building.id,
        'index' => CONFIG['creds.upgradable.speed_up'].size - 1}
    end

    it_behaves_like "finding building"
    it_should_behave_like "only for constructors", 'id'
    it_behaves_like "accelerate"
    it_should_behave_like "having controller action scope"

    it "should accelerate building" do
      @controller.should_receive(:find_building).and_return(@building)
      Creds.should_receive(:accelerate_construction!).with(
        @building, @params['index'])
      invoke @action, @params
    end

    it "should work" do
      invoke @action, @params
    end
  end

  describe "buildings|construct_all" do
    before(:each) do
      @planet = Factory.create(:planet, player: player)
      # For population
      Factory.create(:b_housing, opts_active + {planet: @planet,
        level: Building::Housing.max_level, y: 10})
      @constructor_opts = opts_active + {:planet => @planet}
      @building = Factory.create(:b_barracks, @constructor_opts)

      player.pure_creds += 100000
      player.vip_level = 1
      player.recalculate_population
      player.save!

      @constructable = @building.
        construct!(Unit::Trooper.to_s, true, {}, @building.queue_max)

      @action = "buildings|construct_all"
      @params = {
        'id' => @building.id,
        'index' => Cfg.creds_upgradable_speed_up_data.size - 1
      }
    end

    it_behaves_like "finding building"
    it_should_behave_like "only for constructors", 'id'
    it_behaves_like "accelerate"

    it "should work" do
      invoke @action, @params
    end

    it "should mass accelerate" do
      Creds.should_receive(:mass_accelerate!).with(@building, @params['index'])
      invoke @action, @params
    end
  end

  describe "buildings|accelerate_upgrade" do
    before(:each) do
      player.pure_creds += 100000
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
    it_should_behave_like "having controller action scope"

    it "should accelerate building" do
      @controller.should_receive(:find_building).and_return(@building)
      Creds.should_receive(:accelerate!).with(@building, @params['index'])
      invoke @action, @params
    end
  end
  
  describe "buildings|cancel_constructor" do
    before(:each) do
      @planet = Factory.create(:planet, :player => player)
      @constructor_opts =  opts_active + {:planet => @planet}
      @building = Factory.create(:b_headquarters, @constructor_opts)
      @constructable = @building.construct!("Building::Barracks", false,
        :x => 10, :y => 10)
      
      @action = "buildings|cancel_constructor"
      @params = {'id' => @building.id}
    end
    
    it_behaves_like "finding building"
    it_should_behave_like "only for constructors", 'id'
    it_should_behave_like "having controller action scope"
    
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
    it_should_behave_like "having controller action scope"
    
    it "should call #cancel! on building" do
      @controller.should_receive(:find_building).and_return(@building)
      @building.should_receive(:cancel!)
      invoke @action, @params
    end
  end

  describe "buildings|set_build_in_2nd_flank" do
    before(:each) do
      @planet = Factory.create(:planet, :player => player)
      @constructor_opts = {:planet => @planet}
      @building = Factory.create(:b_constructor_test, @constructor_opts)

      @action = "buildings|set_build_in_2nd_flank"
      @params = {'id' => @building.id, 'enabled' => true}
    end

    it_behaves_like "finding building"
    it_should_behave_like "only for constructors", 'id'
    it_should_behave_like "having controller action scope"
    it_should_behave_like "with param options", :required => %w{id enabled}

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
      @constructor_opts = {:planet => @planet}
      @building = Factory.create(:b_constructor_test, @constructor_opts)

      @action = "buildings|set_build_hidden"
      @params = {'id' => @building.id, 'enabled' => true}
    end

    it_behaves_like "finding building"
    it_should_behave_like "only for constructors", 'id'
    it_should_behave_like "having controller action scope"
    it_should_behave_like "with param options", :required => %w{id enabled}

    it "should set flag on building" do
      lambda do
        invoke @action, @params
        @building.reload
      end.should change(@building, :build_hidden).to(@params['enabled'])
    end
  end

  describe "buildings|repair" do
    let(:planet) { set_resources(Factory.create(:planet, :player => player)) }
    let(:building) do
      Factory.create!(
        :b_vulcan, opts_active + opts_built +
          {:planet => planet, :hp_percentage => 0.5}
      )
    end

    before(:each) do
      Factory.create!(:t_building_repair, :level => 1, :player => player)
      @action = "buildings|repair"
      @params = {'id' => building.id}
    end

    it_behaves_like "finding building"
    it_should_behave_like "having controller action scope"

    it "should call #repair! on building" do
      lambda do
        invoke @action, @params
        building.reload
      end.should change(building, :state).to(Building::STATE_REPAIRING)
    end
  end

  describe "buildings|mass_repair" do
    let(:technology) do
      Factory.create!(:t_building_repair, level: 1, player: player)
    end
    let(:planet) { set_resources(Factory.create(:planet, player: player)) }
    let(:buildings) do
      opts = {:hp_percentage => 0.75, :planet => planet}
      [
        Factory.create!(:b_vulcan, opts_active + opts_built + opts + {:x => 0}),
        Factory.create!(:b_vulcan, opts_active + opts_built + opts + {:x => 3}),
        Factory.create!(:b_vulcan, opts_active + opts_built + opts + {:x => 6}),
      ]
    end

    before(:each) do
      player.vip_level = 1
      player.save!
      technology
      @action = "buildings|mass_repair"
      @params = {
        'planet_id' => planet.id,
        'building_ids' => buildings.map(&:id)
      }
    end

    it_should_behave_like "having controller action scope"
    it_should_behave_like "with param options",
      :required => %w{planet_id building_ids}

    it "should fail if player is not vip" do
      player.vip_level = 0
      player.save!

      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should fail if planet does not belong to player" do
      planet.player = Factory.create(:player)
      planet.save!

      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should fail if planet cannot be found" do
      lambda do
        invoke @action, @params.merge('planet_id' => SsObject.maximum(:id) + 1)
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should fail if all buildings cannot be found" do
      buildings[0].destroy!
      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should call #mass_repair on planet" do
      SsObject::Planet.any_instance.should_receive(:mass_repair!).
        with(buildings)
      invoke @action, @params
    end

    it "should change all buildings into repairing state" do
      status = lambda { buildings.map(&:state).uniq }

      lambda do
        invoke @action, @params
        buildings.each(&:reload)
      end.should change(status, :call).
        from([Building::STATE_ACTIVE]).to([Building::STATE_REPAIRING])
    end
  end

  describe "buildings|transport_resources" do
    let(:planet) do
      planet = Factory.create(:planet, :player => player)
      set_resources(planet, 10000, 10000, 10000)
      planet
    end
    let(:target_planet) do
      planet = Factory.create(:planet, :player => player)
      Factory.create!(:b_resource_transporter, :planet => planet)
      planet
    end
    let(:building_opts) { opts_active + {:level => 2, :planet => planet} }
    let(:building) do
      Factory.create!(:b_resource_transporter, building_opts)
    end

    before(:each) do
      # For "finding building"
      @planet = planet
      @building = building

      @action = "buildings|transport_resources"
      @params = {'id' => building.id, 'target_planet_id' => target_planet.id,
        'metal' => 10, 'energy' => 15, 'zetium' => 20}
    end

    it_should_behave_like "with param options",
      %w{id target_planet_id metal energy zetium}
    it_should_behave_like "having controller action scope"
    it_should_behave_like "finding building"

    def stub_find
      @controller.should_receive(:find_building).and_return(building)
      building
    end

    it "should fail if building is not a resource transporter" do
      building.destroy!
      building = Factory.create(:building_built, :planet => planet)
      @params['id'] = building.id

      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end

    it "should invoke #transport! on building" do
      stub_find.should_receive(:transport!).with(
        target_planet, @params['metal'], @params['energy'], @params['zetium']
      )
      invoke @action, @params
    end

    it "should return bad response if target does not have transporter" do
      stub_find.should_receive(:transport!).
        and_raise(Building::ResourceTransporter::NoTransporterError)
      invoke @action, @params
      response_should_include(:error => "no_transporter")
    end

    it "should work" do
      invoke @action, @params
    end
  end
end