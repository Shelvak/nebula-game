require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

class Technology::TestResourceMod < Technology
  include Parts::ResourceIncreasingTechnology
end
Factory.define :t_test_resource_mod, :class => Technology::TestResourceMod,
:parent => :technology do |m|
  m.level 1
end

describe ResourcesEntry do  
  describe "#to_json" do
    before(:all) do
      @model = Factory.create :resources_entry
    end

    @ommited_fields = %w{id}
    it_should_behave_like "to json"
  end

  describe ".on_callback" do
    before(:each) do
      @model = mock(ResourcesEntry)
      @changes = [
        [Factory.create(:building), Reducer::RELEASED]
      ]
      @planet = Factory.create(:planet_with_player)
      @model.stub!(:planet).and_return(@planet)
      @model.stub!(:planet_id).and_return(@planet.id)
      @model.stub!(:ensure_positive_energy_rate!).and_return(@changes)
      @id = -1
      ResourcesEntry.stub!(:find).with(@id).and_return(@model)
    end

    it "should call #ensure_positive_energy_rate!" do
      @model.should_receive(:ensure_positive_energy_rate!)
      ResourcesEntry.on_callback(@id,
        CallbackManager::EVENT_ENERGY_DIMINISHED)
    end

    it "should create notification with changed things" do
      Notification.should_receive(:create_for_buildings_deactivated).with(
        @model.planet, @changes
      )
      ResourcesEntry.on_callback(@id,
        CallbackManager::EVENT_ENERGY_DIMINISHED)
    end

    it "should not create notification if nothing was changed" do
      @model.stub!(:ensure_positive_energy_rate!).and_return([])
      Notification.should_not_receive(:create_for_buildings_deactivated)
      ResourcesEntry.on_callback(@id,
        CallbackManager::EVENT_ENERGY_DIMINISHED)
    end

    it "should fire CHANGED to EB" do
      should_fire_event(@model, EventBroker::CHANGED) do
        ResourcesEntry.on_callback(@id,
          CallbackManager::EVENT_ENERGY_DIMINISHED)
      end
    end
  end

  describe "#after_find" do
    it "should recalculate if needed" do
      model = Factory.create :resources_entry,
        :last_update => 10.seconds.ago
      model.should_receive(:recalculate!).once
      model.recalculate_if_unsynced!
    end

    it "should not recalculate if not needed" do
      model = Factory.create :resources_entry,
        :last_update => nil
      model.should_not_receive(:recalculate!)
      model.recalculate_if_unsynced!
    end
  end

  describe "energy diminishment" do
    describe "rate negative" do
      before(:each) do
        @model = Factory.build :resources_entry,
          :last_update => Time.now.drop_usec,
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
        @model = Factory.build :resources_entry,
          :last_update => Time.now.drop_usec,
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
      @planet = Factory.create :planet
      @re = @planet.resources_entry

      @re.energy_storage = 10000
      @re.energy = 1000
      @re.last_update = Time.now
      @re.energy_rate = -7
      @re.save!

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
      @re.ensure_positive_energy_rate!

      @b0.reload; @b0.should be_active
    end

    it "should not touch buildings that are inactive" do
      @b1.deactivate!
      lambda do
        @re.ensure_positive_energy_rate!
      end.should_not raise_error
    end

    it "should deactivate buildings to restore rate" do
      @re.ensure_positive_energy_rate!

      @re.energy_rate.should == 0

      @b1.reload; @b1.should be_inactive
      @b2.reload; @b2.should be_inactive
      @b3.reload; @b3.should be_active
      @b4.reload; @b4.should be_inactive
    end

    it "should return changes" do
      @re.ensure_positive_energy_rate!.sort_by { |e| e[0].id }.should == [
        [@b1, Reducer::RELEASED],
        [@b2, Reducer::RELEASED],
        [@b4, Reducer::RELEASED],
      ].sort_by { |e| e[0].id }
    end
  end

  describe "#resource_modifier_technologies" do
    it "should not use technologies of level 0" do
      planet = Factory.create :planet_with_player
      tech = Factory.create :t_test_resource_mod,
        :player => planet.player, :level => 0
      
      planet.resources_entry.send(
        :resource_modifier_technologies
      ).should_not include(tech)
    end

    it "should not use technologies of level > 0" do
      planet = Factory.create :planet_with_player
      tech = Factory.create :t_test_resource_mod,
        :player => planet.player, :level => 1

      planet.resources_entry.send(
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
      model = Factory.build :resources_entry,
        :metal_rate => @rate,
        :last_update => diff.seconds.ago.drop_usec

      model.metal_storage = @resource * 100
      model.metal = @resource
      model.save!

      # We might not be there in same second.
      diff = Time.now.drop_usec - model.last_update
      lambda do
        model.send(:recalculate)
      end.should change(model, :metal).from(@resource).to(
        @resource + @rate * diff)
    end

    it "should update #last_update" do
      model = Factory.build :resources_entry,
        :last_update => 30.seconds.ago.drop_usec
      model.send :recalculate
      model.last_update.drop_usec.should == Time.now.drop_usec
    end

    %w{metal energy zetium}.each do |type|
      it "should update #{type}" do
        model = Factory.build :resources_entry,
          "#{type}_rate" => @rate, :last_update => 1.second.ago.drop_usec

        model.send("#{type}_storage=", @resource + @rate * 2000)
        model.send("#{type}=", @resource)
        model.save!

        # We might not be there in same second.
        diff = Time.now.drop_usec - model.last_update
        lambda do
          model.send :recalculate
        end.should change(model, type).from(@resource).to(
          @resource + @rate * diff
        )
      end

      it "should not store more resources than storage allows" do
        storage_max = @resource + @rate / 2
        model = Factory.build :resources_entry,
          "#{type}_rate" => @rate, :last_update => 1.minute.ago

        model.send("#{type}_storage=", storage_max)
        model.send("#{type}=", @resource)
        model.save!

        lambda do
          model.send :recalculate
        end.should change(model, type).from(@resource).to(storage_max)
      end

      it "should not go to negative numbers" do
        resource = 10
        model = Factory.build :resources_entry,
          "#{type}_rate" => -30, :last_update => 1.minute.ago

        model.send("#{type}_storage=", resource)
        model.send("#{type}=", resource)
        model.save!

        lambda {
          model.send :recalculate
        }.should change(model, type).from(resource).to(0)
      end

      describe "#{type} with modifiers" do
        before(:each) do
          @planet = Factory.create :planet_with_player
          @tech = Factory.create :t_test_resource_mod,
            :player => @planet.player

          @model = @planet.resources_entry
          @model.last_update = 5.seconds.ago.drop_usec
          @model.send("#{type}_rate=", @rate)
          @storage = @resource + @rate * 2000
          @model.send("#{type}_storage=", @storage)
          @model.send("#{type}=", @resource)
          @model.save!
        end

        it "should consider added mods for rate" do
          # We might not be there in same second.
          diff = Time.now.drop_usec - @model.last_update
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
      planet = Factory.create :planet_with_player
      tech = Factory.create :t_test_resource_mod,
        :player => planet.player

      model = planet.resources_entry
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