require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Building::ConstructorTest do
  it "should respond to construction_queue_entries" do
    Factory.create(:b_constructor_test).should respond_to(
      :construction_queue_entries)
  end

  describe "destruction" do
    before(:each) do
      @constructor = Factory.create(:b_constructor_test)
      set_resources(@constructor.planet, 10000, 10000, 10000)
      @type = "Unit::Trooper"
      @params = {'galaxy_id' => @constructor.planet.solar_system.galaxy_id}
      @data = @constructor.construct!(@type, @params, 3)
    end

    it "should cancel current constructable" do
      @constructor.constructable.should_receive(:cancel!)
      @constructor.destroy
    end

    it "should clear construction queue entries" do
      @constructor.destroy
      @constructor.construction_queue_entries(true).should be_blank
    end

    it "should deactivate" do
      @constructor.should_receive(:deactivate)
      @constructor.destroy
    end
  end

  describe "#as_json" do
    it_behaves_like "as json", Factory.create(:b_constructor_test), nil,
      %w{construction_queue_entries build_in_2nd_flank build_hidden}, []
  end

  describe "#construction_queue_entries" do
    it "should be ordered by position by default" do
      constructor = Factory.create(:b_constructor_test)
      model1 = Factory.create(:construction_queue_entry,
        :constructor => constructor, :position => 3)
      model2 = Factory.create(:construction_queue_entry,
        :constructor => constructor, :position => 0)
      model3 = Factory.create(:construction_queue_entry,
        :constructor => constructor, :position => 1)
      
      # Inserting reorders things a bit
      [model1, model2, model3].each { |m| m.reload }

      constructor.construction_queue_entries.map(&:id).should == [
        model2, model3, model1
      ].map(&:id)
    end
  end

  describe ".can_construct?" do
    %w{building unit}.each do |item|
      it "should allow constructing #{item.pluralize} by glob" do
        with_config_values(
          'buildings.constructor_test.constructor.items' => [
            "#{item}/*"
          ]
        ) do
          Building::ConstructorTest.can_construct?(
            "#{item.camelcase}::Test#{item.camelcase}"
          ).should be_true
        end
      end

      it "should allow constructing #{item.pluralize} by exact match" do
        with_config_values(
          'buildings.constructor_test.constructor.items' => [
            "#{item}/test_#{item}"
          ]
        ) do
          Building::ConstructorTest.can_construct?(
            "#{item.camelcase}::Test#{item.camelcase}"
          ).should be_true
        end
      end

      it "should not allow constructing #{item.pluralize} if disabled" do
        with_config_values(
          'buildings.constructor_test.constructor.items' => []
        ) do
          Building::ConstructorTest.can_construct?(
            "#{item.camelcase}::Test#{item.camelcase}"
          ).should be_false
        end
      end
    end
  end

  describe "#cancel_constructable!" do
    before(:each) do
      @type = 'Building::TestBuilding'
      @args = {:x => 10, :y => 20}
      @constructor = Factory.create(:b_constructor_test,
        @args)
      set_resources(@constructor.planet, 10000, 10000, 10000)
      @building = @constructor.construct!(@type,
        Factory.attributes_for(:building)
      )
    end

    it "should raise GameLogicError if not working" do
      @constructor.stub!(:state).and_return(Building::STATE_ACTIVE)
      lambda do
        @constructor.cancel_constructable!
      end.should raise_error(GameLogicError)
    end

    it "should clear constructable on model" do
      @constructor.cancel_constructable!
      @constructor.constructable.should be_nil
    end

    it "should call #cancel! on constructable" do
      @constructor.constructable.should_receive(:cancel!)
      @constructor.cancel_constructable!
    end

    it "should unregister from CM" do
      finished = @building.upgrade_ends_at
      @constructor.cancel_constructable!
      @constructor.should_not have_callback(
        CallbackManager::EVENT_CONSTRUCTION_FINISHED, finished)
    end

    it "should change state to active" do
      @constructor.cancel_constructable!
      @constructor.state.should == Building::STATE_ACTIVE
    end

    it "should save itself" do
      @constructor.cancel_constructable!
      @constructor.should_not be_changed
    end

    %w{metal energy zetium}.each do |resource|
      it "should change #{resource}" do
        planet = @constructor.planet(true)
        @constructor.cancel_constructable!
        lambda do
          planet.reload
        end.should change(planet, resource)
      end
    end

    it "should start construction of next extry from queue" do
      Factory.create(:construction_queue_entry,
        :constructor => @constructor)
      @constructor.cancel_constructable!
      @constructor.reload
      @constructor.state.should == Building::STATE_WORKING
      @constructor.construction_queue_entries(true).should be_blank
    end
  end

  describe "#construct!" do
    before(:each) do
      @type = 'Building::TestBuilding'
      @args = {:x => 10, :y => 20}
      @constructor = Factory.create(:b_constructor_test,
        @args)
      set_resources(@constructor.planet,
        10000, 10000, 10000)
    end

    it "should call Building::type.new with same args" do
      attrs = {:planet_id => 3}
      building = Factory.build(:building, :planet => @constructor.planet)
      Building::TestBuilding.should_receive(:new).with(attrs).and_return(
        building
      )
      @constructor.construct!(@type, attrs)
    end

    it "should set constructable" do
      model = @constructor.construct!(@type,
        Factory.attributes_for(:building)
      )
      @constructor.constructable.should == model
    end

    it "should create new building" do
      @constructor.construct!(@type,
        Factory.attributes_for(:building)
      ).should be_instance_of(Building::TestBuilding)
    end

    describe "if both constructing and queued" do
      before(:each) do
        @count = 5
        @response = @constructor.construct!("Unit::TestUnit",
          Factory.attributes_for(:unit),
          @count
        )
      end

      it "should have :model" do
        @response[:model].should be_instance_of(Unit::TestUnit)
      end

      it "should have :construction_queue_entry" do
        @response[:construction_queue_entry].should be_instance_of(
          ConstructionQueueEntry)
      end

      it "should reduce count by one on queue entry" do
        @response[:construction_queue_entry].count.should == @count - 1
      end
    end

    it "should call #upgrade! on constructed building" do
      building = Factory.build :building_in_construction
      building.should_receive(:upgrade!).and_return(true)
      @type.constantize.should_receive(:new).and_return(building)
      
      @constructor.construct!(@type, @args)
    end

    it "should set state to working" do
      @constructor.construct!(@type,
          :x => 0, :y => 0)
      @constructor.state.should == Building::STATE_WORKING
    end

    it "should force planet_id if Building is constructed" do
      @constructor.construct!("Building::TestBuilding",
        Factory.attributes_for(:building)
      ).planet_id.should == @constructor.planet_id
    end

    it "should force location_id if Unit is constructed" do
      @constructor.construct!("Unit::TestUnit",
        Factory.attributes_for(:unit)
      ).location_id.should == @constructor.planet_id
    end

    it "should force location_type if Unit is constructed" do
      @constructor.construct!("Unit::TestUnit",
        Factory.attributes_for(:unit)
      ).location_type.should == Location::SS_OBJECT
    end

    it "should force player_id if Unit is constructed" do
      @constructor.construct!("Unit::TestUnit",
        Factory.attributes_for(:unit)
      ).player_id.should == @constructor.planet.player_id
    end

    it "should not allow constructing if constructor is upgrading" do
      opts_upgrading | @constructor

      lambda do
        @constructor.construct!("Building::TestUnconstructable",
          :x => @constructor.x_end + 2, :y => 0)
      end.should raise_error(GameLogicError)
    end

    it "should not allow upgrading if constructor is constructing" do
      opts_active | @constructor
      @constructor.construct!(@type,
        :x => @constructor.x_end + 2, :y => 0)

      lambda do
        @constructor.upgrade!
      end.should raise_error(GameLogicError)
    end

    it "should not allow constructing if type is not constructable" do
      opts_active | @constructor

      lambda do
        @constructor.construct!("Building::TestUnconstructable",
          :x => @constructor.x_end + 2, :y => 0)
      end.should raise_error(GameLogicError)
    end

    it "should not allow constructing if type is not supported" do
      opts_active | @constructor

      with_config_values(
        'buildings.constructor_test.constructor.items' => []
      ) do
        lambda do
            @constructor.construct!(@type,
              :x => @constructor.x_end + 2)
        end.should raise_error(GameLogicError)
      end
    end

    it "should not build if constructor is not activated" do
      opts_inactive | @constructor
        
      lambda do
        @constructor.construct!(@type,
          :x => @constructor.x_end + 2)
      end.should raise_error(GameLogicError)
    end

    it "should build if constructor is activated" do
      building = @constructor.construct!(@type,
        :x => 0, :y => 0)
      building.should be_instance_of(Building::TestBuilding)
    end

    it "should queue item if currently busy" do
      opts_working | @constructor

      params = {:x => @constructor.x_end + 2, :y => 0}

      ConstructionQueue.should_receive(:push).with(@constructor.id,
        @type, 1, params.merge(
          @constructor.send(:params_for_type, @type)
        )
      )
      @constructor.construct!(@type, params)
    end

    it "should return ConstructionQueueEntry if queued" do
      opts_working | @constructor

      params = {:x => @constructor.x_end + 2, :y => 0}
      @constructor.construct!(@type, params).should be_instance_of(
        ConstructionQueueEntry)
    end


    it "should not allow constructing if queue is full" do
      opts_working | @constructor

      params = {'x' => @constructor.x_end + 2, 'y' => 0}
      @constructor.construct!(@type, params.merge('y' => 2))
      @constructor.construct!(@type, params.merge('y' => 4))
      @constructor.construct!(@type, params.merge('y' => 6))

      with_config_values "buildings.constructor_test.queue.max" => 3 do
        lambda do
          @constructor.construct!(@type, params)
        end.should raise_error(GameLogicError)
      end
    end

    it "should reduce count to free slots left + 1 if not working" do
      params = {'x' => @constructor.x_end + 2, 'y' => 0}

      with_config_values "buildings.constructor_test.queue.max" => 2 do
        hash = @constructor.construct!(@type, params, 10)
        hash[:model].should_not be_nil
        hash[:construction_queue_entry].count.should == 2
      end
    end

    it "should reduce count to free slots left if working" do
      opts_working | @constructor

      params = {'x' => @constructor.x_end + 2, 'y' => 0}
      @constructor.construct!(@type, params.merge('y' => 2))

      with_config_values "buildings.constructor_test.queue.max" => 2 do
        entry = @constructor.construct!(@type, params, 10)
        entry.count.should == 1
      end
    end

    it "should allow constructing if queue is full but constructor is" +
    " not working" do
      opts_active | @constructor

      params = {'x' => @constructor.x_end + 2, 'y' => 0}

      with_config_values "buildings.constructor_test.queue.max" => 0 do
        lambda do
          @constructor.construct!(@type, params)
        end.should_not raise_error(GameLogicError)
      end
    end
  end

  describe "#accelerate_construction!" do
    before(:each) do
      @type = 'Building::TestBuilding'
      @player = Factory.create(:player, :creds => 100000)
      @planet = Factory.create(:planet, :player => @player)
      @constructor = Factory.create(:b_constructor_test,
        :x => 10, :y => 20, :planet => @planet)
      set_resources(@constructor.planet, 10000, 10000, 10000)
      @building = @constructor.construct!(@type,
        Factory.attributes_for(:building)
      )
    end

    it "should raise error if not working" do
      @constructor.cancel_constructable!
      lambda do
        @constructor.accelerate_construction!(10, 10)
      end.should raise_error(GameLogicError)
    end

    it "should accelerate constructable" do
      @constructor.constructable.should_receive(:accelerate!).with(
        10, 10).and_return(10)
      @constructor.accelerate_construction!(10, 10)
    end

    it "should update callback manager" do
      @constructor.accelerate_construction!(10, 10)
      @constructor.should have_callback(
        CallbackManager::EVENT_CONSTRUCTION_FINISHED,
        @constructor.constructable.upgrade_ends_at
      )
    end

    it "should not have on upgrade finished registered on constructable" do
      # reload to clear constructable#register_upgrade_finished_callback
      @constructor.reload
      @constructor.accelerate_construction!(10, 10)
      @constructor.constructable.should_not have_callback(
        CallbackManager::EVENT_UPGRADE_FINISHED
      )
    end

    describe "when finishing constructable" do
      it "should unregister from callback manager" do
        @constructor.stub!(:on_construction_finished!)
        @constructor.accelerate_construction!(
          Creds::ACCELERATE_INSTANT_COMPLETE, 10
        )
        @constructor.should_not have_callback(
          CallbackManager::EVENT_CONSTRUCTION_FINISHED
        )
      end

      it "should call #on_construction_finished!" do
        @constructor.should_receive(:on_construction_finished!).with(false)
        @constructor.accelerate_construction!(
          Creds::ACCELERATE_INSTANT_COMPLETE, 10
        )
      end

      it "should call #before_finishing_constructable" do
        @constructor.should_receive(:before_finishing_constructable).
          with(@constructor.constructable)
        @constructor.accelerate_construction!(
          Creds::ACCELERATE_INSTANT_COMPLETE, 10
        )
      end

      it "should not fail" do
        @constructor.accelerate_construction!(
          Creds::ACCELERATE_INSTANT_COMPLETE, 10
        )
      end
    end
  end

  describe ".on_callback" do
    before(:each) do
      @model = Factory.create :b_constructor_test
      @klass = Building
      @klass.stub!(:find).with(@model.id).and_return(@model)
    end

    describe "on construction finished" do
      it "should call #on_construction_finished!" do
        @model.should_receive(:on_construction_finished!)
        @klass.on_callback(@model.id,
          CallbackManager::EVENT_CONSTRUCTION_FINISHED)
      end
    end
  end

  describe "#on_construction_finished!" do
    it "should call #before_finishing_constructable" do
      unit = Factory.create(:unit, opts_upgrading + {:flank => 0})
      model = Factory.create(:b_constructor_test, opts_working + {
        :constructable => unit
      })
      model.should_receive(:before_finishing_constructable).with(unit)
      model.send(:on_construction_finished!)
    end

    it "should call constructable#on_upgrade_finished!" do
      unit = Factory.create(:unit, opts_upgrading + {:flank => 0})
      model = Factory.create(:b_constructor_test, opts_working + {
        :constructable => unit
      })
      model.constructable.should_receive(:on_upgrade_finished!)
      model.send(:on_construction_finished!)
    end

    describe "when queue is empty" do
      it "should change state to active" do
        model = Factory.create(:b_constructor_test, opts_working)
        model.send(:on_construction_finished!)
        model.should be_active
      end

      it "should set constructable to nil" do
        model = Factory.create(:b_constructor_test, opts_working)
        model.send(:on_construction_finished!)
        model.constructable.should be_nil
      end

      it "should save" do
        model = Factory.create(:b_constructor_test, opts_working)
        model.send(:on_construction_finished!)
        model.should_not be_changed
      end

      it "should dispatch changed to EventBroker" do
        model = Factory.create(:b_constructor_test, opts_working)
        should_fire_event(model, EventBroker::CHANGED,
          EventBroker::REASON_CONSTRUCTABLE_CHANGED) do
          model.send(:on_construction_finished!)
        end
      end
    end

    describe "when queue is not empty" do
      before(:each) do
        @constructor = Factory.create(:b_constructor_test,
          opts_working + {:x => 0, :y => 0})
        set_resources(@constructor.planet,
          1000000, 1000000, 1000000)
        @type = "Building::TestBuilding"
        @params = {:x => 20, :y => 25, :planet_id => @constructor.planet_id}
        Factory.create(:construction_queue_entry,
          :constructor => @constructor,
          :constructable_type => @type,
          :params => @params)
      end

      it "should call Building::type.new with same args" do
        building = Factory.build(:building, @params)
        Building::TestBuilding.should_receive(:new).with(
          @params).and_return(building)
        @constructor.send(:on_construction_finished!)
      end

      it "should change constructable" do
        lambda do
          @constructor.send(:on_construction_finished!)
        end.should change(@constructor, :constructable).to(
          an_instance_of(Building::TestBuilding)
        )
      end

      it "should create new building" do
        @constructor.send(:on_construction_finished!).should \
          be_instance_of(Building::TestBuilding)
      end

      it "should call #upgrade! on constructed building" do
        building = Factory.build :building_in_construction
        building.should_receive(:upgrade!)
        
        @type.constantize.should_receive(:new).and_return(building)
        @constructor.send(:on_construction_finished!)
      end

      it "should set state to working" do
        @constructor.send(:on_construction_finished!)
        @constructor.state.should == Building::STATE_WORKING
      end

      it "should dispatch changed to EventBroker" do
        should_fire_event(@constructor, EventBroker::CHANGED,
            EventBroker::REASON_CONSTRUCTABLE_CHANGED) do
          @constructor.send(:on_construction_finished!)
        end
      end
    end
  
    describe "when queue element failed to construct" do
      before(:each) do
        @constructor = Factory.create(:b_constructor_test,
          opts_working + {:x => 0, :y => 0})
        set_resources(@constructor.planet, 0, 0, 0)
        @type = "Building::TestBuilding"
        @params = {:x => 20, :y => 25, :planet_id => @constructor.planet_id}
        Factory.create(:construction_queue_entry,
          :constructor => @constructor,
          :constructable_type => @type, :position => 0, :params => @params)
        Factory.create(:construction_queue_entry,
          :constructor => @constructor,
          :constructable_type => @type, :position => 1, :params => @params)
      end

      it "should send aggregated notifications" do
        error = :test_error
        NotEnoughResourcesAggregated.stub!(:new).with(@constructor,
          an_instance_of(Array)).and_return(error)
        Notification.should_receive(:create_from_error).with(
          error).and_return(true)
        @constructor.send(:on_construction_finished!)
      end

      it "should not send notification if planet does not belong to player" do
        planet = @constructor.planet
        planet.player = nil
        planet.save!

        Notification.should_not_receive(:create_from_error)
        @constructor.send(:on_construction_finished!)
      end

      it "should take queue elements until queue is empty" do
        @constructor.send(:on_construction_finished!)
        @constructor.construction_queue_entries.size.should == 0
      end
    end

    describe "when queue element failed to construct due to validation error" do
       before(:each) do
        @constructor = Factory.create(:b_constructor_test,
          opts_working + {:x => 0, :y => 0})
        set_resources(@constructor.planet, 10000, 10000, 10000)
        @type = "Building::TestBuilding"
        @params = {:x => 20, :y => 25, :planet_id => @constructor.planet_id}
        Factory.create(:construction_queue_entry,
          :constructor => @constructor,
          :constructable_type => @type, :position => 0, :params => @params)
        Factory.create(:construction_queue_entry,
          :constructor => @constructor,
          :constructable_type => @type, :position => 1, :params => @params)
      end

      it "should not raise error" do
        @constructor.send(:on_construction_finished!)
        @constructor.send(:on_construction_finished!)
      end
    end
  end

  describe "#construct_model!" do
    before(:each) do
      @player = Factory.create(:player)
      @model = Factory.create(:b_constructor_test, :x => 20, :y => 20,
        :level => 1, :planet => Factory.create(:planet, :player => @player))
    end

    it "should set level to 0" do
      @model.send(:construct_model!, "Unit::TestUnit",
        :player_id => @player.id,
        :location_id => @model.planet_id,
        :location_type => Location::SS_OBJECT,
        :galaxy_id => @model.planet.solar_system.galaxy_id,
        :level => 3).level.should == 0
    end

    describe "construction mod" do
      before(:each) do
        @model.construction_mod = 20
      end

      it "should add construction mod for units" do
        unit = @model.send(:construct_model!, "Unit::TestUnit",
          :player_id => @player.id,
          :location_id => @model.planet_id,
          :location_type => Location::SS_OBJECT,
          :galaxy_id => @model.planet.solar_system.galaxy_id
        )
        unit.construction_mod.should == @model.constructor_mod
      end

      it "should add construction mod for buildings" do
        building = @model.send(:construct_model!, "Building::TestBuilding",
          :x => 0, :y => 0, :planet_id => @model.planet_id)
        building.construction_mod.should == @model.constructor_mod
      end

      it "should add construction mod from level" do
        @model.construction_mod = 0
        with_config_values(
          'buildings.constructor_test.mod.construction' => '10 * level'
        ) do
          building = @model.send(:construct_model!, "Building::TestBuilding",
            :x => 0, :y => 0, :planet_id => @model.planet_id)
          building.construction_mod.should == 10
        end
      end
    end

    it "should fire event with constructable" do
      building = Factory.create :building_in_construction
      building.stub!(:upgrade!).and_return(true)
      Building::TestBuilding.stub!(:new).and_return(building)

      should_fire_event(building, EventBroker::CREATED) do
        @model.send(:construct_model!, "Building::TestBuilding",
          :x => 0, :y => 0)
      end
    end

    describe "registering construction finished to CM" do
      it "should do it if constructing a model" do
        building = Factory.create :building_in_construction
        building.stub!(:upgrade!).and_return(true)
        Building::TestBuilding.stub!(:new).and_return(building)

        CallbackManager.should_receive(:register).with(
          @model, CallbackManager::EVENT_CONSTRUCTION_FINISHED,
          building.upgrade_ends_at
        )
        @model.send(:construct_model!, "Building::TestBuilding",
          :x => 0, :y => 0)
      end

      it "should not do it if clearing construction" do
        CallbackManager.should_not_receive(:register)
        @model.send(:construct_model!, nil, nil)
      end
    end
  end

  describe "#before_finishing_constructable" do
    describe "when #build_in_2nd_flank is true" do
      it "should set constructable flank to 1 if it is a Unit" do
        unit = Factory.create(:unit, opts_upgrading + {:flank => 0})
        model = Factory.create(:b_constructor_test, opts_working + {
          :constructable => unit, :build_in_2nd_flank => true
        })
        lambda do
          model.send(:before_finishing_constructable, unit)
        end.should change(unit, :flank).to(1)
      end

      it "should not fail if it's a building" do
        building = Factory.create(:building, opts_upgrading)
        model = Factory.create(:b_constructor_test, opts_working + {
          :constructable => building, :planet => building.planet, :x => 10,
          :build_in_2nd_flank => true
        })
        model.send(:before_finishing_constructable, building)
      end
    end

    describe "when #build_hidden is true" do
      it "should set hidden to true if it is a Unit" do
        unit = Factory.create(:unit, opts_upgrading + {:hidden => false})
        model = Factory.create(:b_constructor_test, opts_working + {
          :constructable => unit, :build_hidden => true
        })
        lambda do
          model.send(:before_finishing_constructable, unit)
        end.should change(unit, :hidden?).to(true)
      end

      it "should not fail if it's a building" do
        building = Factory.create(:building, opts_upgrading)
        model = Factory.create(:b_constructor_test, opts_working + {
          :constructable => building, :planet => building.planet, :x => 10,
          :build_hidden => true
        })
        model.send(:before_finishing_constructable, building)
      end
    end
  end
end