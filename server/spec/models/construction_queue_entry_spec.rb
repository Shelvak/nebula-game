require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe ConstructionQueueEntry do
  describe "#as_json" do
    it_should_behave_like "as json",
      Factory.create(:construction_queue_entry), nil,
      %w{id constructable_type constructor_id count position prepaid params},
      %w{flags}
  end

  describe "find" do
    it "should be ordered by position by default" do
      model1 = Factory.create(:construction_queue_entry, :position => 10)
      model2 = Factory.create(:construction_queue_entry, :position => 5)
      model3 = Factory.create(:construction_queue_entry, :position => 7)

      ConstructionQueueEntry.where(:id => [model1.id, model2.id, model3.id]).
        map(&:position).should == [model2, model3, model1].map(&:position)
    end
  end

  describe "#reduce_resources!" do
    let(:player) { Factory.create(:player) }
    let(:planet) do
      planet = Factory.create(:planet, :player => player)
      set_resources(planet, 100_000, 100_000, 100_000)
      planet
    end
    let(:constructor) { Factory.create(:b_constructor_test, :planet => planet) }
    let(:klass) { Unit::Trooper }
    let(:entry) do
      Factory.build(
        :construction_queue_entry,
        :constructor => constructor,
        :constructable_type => klass.to_s, :count => 4,
        :prepaid => true
      )
    end

    it "should fail if entry is not prepaid" do
      entry.prepaid = false
      lambda do
        entry.reduce_resources!(2)
      end.should raise_error(ArgumentError)
    end

    it "should fail if there is not enough resources" do
      entry.stub!(:get_resources).
        and_return([planet.metal + 1, planet.energy, planet.zetium, 0])
      lambda do
        entry.reduce_resources!(1)
      end.should raise_error(GameLogicError)
    end

    it "should reduce planet resources" do
      count = 3
      lambda do
        entry.reduce_resources!(count)
      end.should change_resources_of(planet,
                   - klass.metal_cost(1) * count,
                   - klass.energy_cost(1) * count,
                   - klass.zetium_cost(1) * count
                 )
    end

    describe "when using population" do
      let(:count) { 2 }

      it "should fail if player does not have enough free population" do
        player.population = player.population_max - klass.population * count + 1
        lambda do
          entry.reduce_resources!(count)
        end.should raise_error(GameLogicError)
      end

      it "should fail if planet player is nil" do
        planet.player = nil
        planet.save!

        lambda do
          entry.reduce_resources!(1)
        end.should raise_error(ArgumentError)
      end

      it "should increase player population" do
        lambda do
          entry.reduce_resources!(count)
          player.reload
        end.should change(player, :population).by(klass.population * count)
      end
    end

    describe "when not using population" do
      let(:klass) { Building::CollectorT1 }
      before(:each) do
        entry.constructable_type = klass.to_s
      end

      it "should not fail when planet player is nil" do
        entry.reduce_resources!(1)
      end

      it "should not change player population" do
        lambda do
          entry.reduce_resources!(1)
          player.reload
        end.should_not change(player, :population)
      end
    end
  end

  describe "#return_resources!" do
    let(:player) { Factory.create(:player) }
    let(:planet) do
      planet = Factory.create(:planet, :player => player)
      set_resources(planet, 100_000, 100_000, 100_000,
                    200_000, 200_000, 200_000)
      planet
    end
    let(:constructor) { Factory.create(:b_constructor_test, :planet => planet) }
    let(:klass) { Unit::Trooper }
    let(:entry) do
      Factory.build(
        :construction_queue_entry,
        :constructor => constructor,
        :constructable_type => klass.to_s, :count => 4,
        :prepaid => true
      )
    end

    it "should fail if entry is not prepaid" do
      entry.prepaid = false
      lambda do
        entry.return_resources!(2)
      end.should raise_error(ArgumentError)
    end

    it "should increase planet resources" do
      count = 3
      lambda do
        entry.return_resources!(count)
      end.should change_resources_of(planet,
                   klass.metal_cost(1) * count,
                   klass.energy_cost(1) * count,
                   klass.zetium_cost(1) * count
                 )
    end

    describe "when using population" do
      let(:count) { 2 }

      it "should fail if planet player is nil" do
        planet.player = nil
        planet.save!

        lambda do
          entry.return_resources!(1)
        end.should raise_error(ArgumentError)
      end

      it "should decrease player population" do
        lambda do
          entry.return_resources!(count)
          player.reload
        end.should change(player, :population).by(- klass.population * count)
      end
    end

    describe "when not using population" do
      let(:klass) { Building::CollectorT1 }
      before(:each) do
        entry.constructable_type = klass.to_s
      end

      it "should not fail when planet player is nil" do
        entry.return_resources!(1)
      end

      it "should not change player population" do
        lambda do
          entry.return_resources!(1)
          player.reload
        end.should_not change(player, :population)
      end
    end
  end

  describe "#get_resources" do
    it "should fail if this is not prepaid entry" do
      entry = Factory.build(:construction_queue_entry, :prepaid => false)
      lambda do
        entry.get_resources(3)
      end.should raise_error(ArgumentError)
    end

    it "should return correct values for buildings" do
      klass = Building::ResearchCenter
      entry = Factory.build(:construction_queue_entry,
        :constructable_type => klass.to_s, :prepaid => true)
      entry.get_resources(3).should == [
        klass.metal_cost(1) * 3, klass.energy_cost(1) * 3,
        klass.zetium_cost(1) * 3, 0
      ]
    end

    it "should return correct values for units" do
      klass = Unit::Azure
      entry = Factory.build(:construction_queue_entry,
        :constructable_type => klass.to_s, :prepaid => true)
      entry.get_resources(3).should == [
        klass.metal_cost(1) * 3, klass.energy_cost(1) * 3,
        klass.zetium_cost(1) * 3, klass.population * 3
      ]
    end
  end

  describe "create" do
    it "should shift positions to right by 1" do
      model1 = Factory.create :construction_queue_entry, :position => 1

      lambda do
        Factory.create :construction_queue_entry,
          :constructor => model1.constructor,
          :position => 1
        model1.reload
      end.should change(model1, :position).by(1)
    end

    it "should not shift positions from position to left" do
      model1 = Factory.create :construction_queue_entry

      lambda do
        Factory.create :construction_queue_entry,
          :constructor => model1.constructor,
          :position => 1
        model1.reload
      end.should_not change(model1, :position)
    end
  end

  describe "update" do
    it "should not be valid if count is less than 1" do
      Factory.build(:construction_queue_entry, :count => 0).should_not be_valid
    end
  end

  describe "destroy" do
    it "should shift positions to left by 1" do
      model1 = Factory.create :construction_queue_entry
      model2 = Factory.create :construction_queue_entry,
        :constructor => model1.constructor,
        :position => 1

      lambda do
        model1.destroy
        model2.reload
      end.should change(model2, :position).by(-1)
    end

    it "should not shift positions from position to left" do
      model1 = Factory.create :construction_queue_entry
      model2 = Factory.create :construction_queue_entry,
        :constructor => model1.constructor,
        :position => 1

      lambda do
        model2.destroy
        model1.reload
      end.should_not change(model1, :position)
    end
  end

  describe "notifier" do
    it_behaves_like "notifier",
      :build => lambda { Factory.build(:construction_queue_entry) },
      :change => lambda { |model| model.count += 1 },
      :notify_on_update => false, :notify_on_destroy => false
  end
end