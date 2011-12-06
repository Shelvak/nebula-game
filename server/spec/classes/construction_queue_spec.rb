require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe ConstructionQueue do
  let(:klass) { Building::TestBuilding }
  let(:klass2) { Building::Barracks }
  let(:klass3) { Building::GroundFactory }
  let(:klass4) { Building::CollectorT1 }
  let(:klass5) { Building::CollectorT2 }

  before(:each) do
    # We need player there to dispatch event to broker.
    @planet = Factory.create(:planet_with_player)
    set_resources(@planet, 1_000_000, 1_000_000, 1_000_000,
                  2_000_000, 2_000_000, 2_000_000)
    
    @constructor = Factory.create(:b_constructor_test, :planet => @planet)
    @constructor_id = @constructor.id
  end

  describe ".push" do
    describe "new entry if there is nothing in queue" do
      let(:count) { 10 }

      it "should set constructor_id" do
        ConstructionQueue.push(@constructor_id, klass.to_s, false).constructor_id.
          should == @constructor_id
      end

      it "should set constructable_type" do
        ConstructionQueue.push(@constructor_id, klass.to_s, false).
          constructable_type.should == klass.to_s
      end

      it "should extract player_id from params" do
        player = Factory.create(:player)
        entry = ConstructionQueue.push(@constructor_id, klass.to_s, false, 1,
          :player_id => player.id)

        entry.player_id.should == player.id
      end

      it "should set position to 0" do
        ConstructionQueue.push(@constructor_id, klass.to_s, false).position.
          should == 0
      end

      it "should reduce resources if prepaid" do
        lambda do
          ConstructionQueue.push(@constructor_id, klass.to_s, true, count)
          @planet.reload
        end.should change_resources_of(@planet,
          - Building::TestBuilding.metal_cost(1) * count,
          - Building::TestBuilding.energy_cost(1) * count,
          - Building::TestBuilding.zetium_cost(1) * count
        )
      end

      it "should not reduce resources if not prepaid" do
        lambda do
          ConstructionQueue.push(@constructor_id, klass.to_s, false, count)
          @planet.reload
        end.should_not change_resources_of(@planet)
      end
    end

    it "should raise exception if count < 1" do
      lambda do
        ConstructionQueue.push(@constructor_id, klass.to_s, false, 0)
      end.should raise_error(ArgumentError)
    end

    describe "merging with existing entry" do
      let(:count) { 15 }

      it "should increase count" do
        entry = ConstructionQueue.push(@constructor_id, klass.to_s, false)
        lambda do
          ConstructionQueue.push(@constructor_id, klass.to_s, false, count)
          entry.reload
        end.should change(entry, :count).by(count)
      end

      it "should reduce resources if prepaid" do
        ConstructionQueue.push(@constructor_id, klass.to_s, true)
        @planet.reload
        
        lambda do
          ConstructionQueue.push(@constructor_id, klass.to_s, true, count)
          @planet.reload
        end.should change_resources_of(@planet,
          - klass.metal_cost(1) * count,
          - klass.energy_cost(1) * count,
          - klass.zetium_cost(1) * count
        )
      end

      it "should not reduce resources if not prepaid" do
        ConstructionQueue.push(@constructor_id, klass.to_s, false)
        @planet.reload
        
        lambda do
          ConstructionQueue.push(@constructor_id, klass.to_s, false, count)
          @planet.reload
        end.should_not change_resources_of(@planet)
      end
    end

    it "should push event" do
      should_fire_event(Event::ConstructionQueue.new(@constructor_id),
          EventBroker::CHANGED) do
        ConstructionQueue.push(@constructor_id, klass.to_s, false, 1)
      end
    end

    describe "when last upgradable doesn't match" do
      it "should create new entry" do
        model1 = ConstructionQueue.push(@constructor_id, klass.to_s, true)
        model2 = ConstructionQueue.push(@constructor_id, klass2.to_s, true)
        model2.should_not == model1
      end

      it "should check params matching all arguments matching" do
        model1 = ConstructionQueue.push(@constructor_id, klass.to_s, true, 1,
                                        {:planet_id => @planet.id})
        model2 = ConstructionQueue.push(@constructor_id, klass.to_s, true, 1)
        model2.should_not == model1
      end

      it "should put new entry with max_position+1" do
        model1 = ConstructionQueue.push(@constructor_id, klass.to_s, true)
        model2 = ConstructionQueue.push(@constructor_id, klass2.to_s, true)
        model2.position.should == model1.position + 1
      end

      it "should put entries in the line ordered by position" do
        model1 = ConstructionQueue.push(@constructor_id, klass.to_s, true)
        model2 = ConstructionQueue.push(@constructor_id, klass2.to_s, true)
        model3 = ConstructionQueue.push(@constructor_id, klass3.to_s, true)
        model4 = ConstructionQueue.push(@constructor_id, klass.to_s, true)

        [model1, model2, model3, model4].map(&:position).should == [
          0, 1, 2, 3
        ]
      end
    end
  end

  describe ".shift" do
    it "should reduce count from front by 1" do
      ConstructionQueue.push(@constructor_id, klass.to_s, true, 10)
      ConstructionQueue.push(@constructor_id, klass2.to_s, true, 5)
      ConstructionQueue.shift(@constructor_id).count.should == 9
    end

    it "should delete object from front if count == 1" do
      ConstructionQueue.push(@constructor_id, klass.to_s, true, 1)
      ConstructionQueue.shift(@constructor_id).should be_frozen
    end

    it "should push event" do
      ConstructionQueue.push(@constructor_id, klass.to_s, true, 1)
      should_fire_event(Event::ConstructionQueue.new(@constructor_id),
      EventBroker::CHANGED) do
        ConstructionQueue.shift(@constructor_id)
      end
    end

    it "should not change planet resources" do
      ConstructionQueue.push(@constructor_id, klass.to_s, true, 10)
      @planet.reload
      
      lambda do
        ConstructionQueue.shift(@constructor_id)
        @planet.reload
      end.should_not change_resources_of(@planet)
    end

    it "should not change planet resources if shifting destroyed entry" do
      ConstructionQueue.push(@constructor_id, klass.to_s, true, 1)
      @planet.reload

      lambda do
        ConstructionQueue.shift(@constructor_id)
        @planet.reload
      end.should_not change_resources_of(@planet)
    end
  end

  describe ".clear" do
    it "should clear the queue" do
      ConstructionQueue.push(@constructor.id, Unit::Crow.to_s, false)
      ConstructionQueue.clear(@constructor.id)
      ConstructionQueue.count(@constructor.id).should == 0
    end

    it "should not return resources for not prepaid items" do
      lambda do
        ConstructionQueue.push(@constructor.id, Unit::Crow.to_s, false, 10)
        ConstructionQueue.clear(@constructor.id)
        @planet.reload
      end.should_not change_resources_of(@planet)
    end

    it "should return resources for prepaid items" do
      lambda do
        ConstructionQueue.push(@constructor.id, Unit::Crow.to_s, true, 10)
        ConstructionQueue.clear(@constructor.id)
        @planet.reload
      end.should_not change_resources_of(@planet)
    end
  end

  describe ".reduce" do
    it "should reduce count" do
      mock = ConstructionQueue.push(@constructor_id, klass.to_s, true, 20)
      ConstructionQueue.reduce(mock.id, 15).count.should == 5
    end

    it "should delete object if requested == count" do
      mock = ConstructionQueue.push(@constructor_id, klass.to_s, true, 20)
      ConstructionQueue.reduce(mock.id, mock.count).should be_frozen
    end

    it "should merge adjacent objects on destroy" do
      model1 = ConstructionQueue.push(@constructor_id, klass.to_s, true, 2)
      model2 = ConstructionQueue.push(@constructor_id, klass2.to_s, true, 1)
      model3 = ConstructionQueue.push(@constructor_id, klass.to_s, true, 3)
      model4 = ConstructionQueue.push(@constructor_id, klass3.to_s, true, 3)

      ConstructionQueue.reduce(model2.id, model2.count)
      model1.reload
      model1.count.should == 5

      lambda do
        model3.reload
      end.should raise_error(ActiveRecord::RecordNotFound)

      model4.reload
      model4.position.should == 1
    end

    it "should push event" do
      mock = ConstructionQueue.push(@constructor_id, klass.to_s, false, 20)
      should_fire_event(
        Event::ConstructionQueue.new(@constructor_id), EventBroker::CHANGED
      ) do
        ConstructionQueue.reduce(mock.id, 15)
      end
    end

    it "should return resources if prepaid" do
      lambda do
        mock = ConstructionQueue.push(@constructor_id, klass.to_s, true, 10)
        ConstructionQueue.reduce(mock.id, 6)
        @planet.reload
      end.should change_resources_of(@planet,
        - klass.metal_cost(1) * 4,
        - klass.energy_cost(1) * 4,
        - klass.zetium_cost(1) * 4
      )
    end

    it "should return resources if prepaid && destroying object" do
      lambda do
        mock = ConstructionQueue.push(@constructor_id, klass.to_s, true, 10)
        ConstructionQueue.reduce(mock.id, 10)
        @planet.reload
      end.should_not change_resources_of(@planet)
    end

    it "should not return resources if not prepaid" do
      lambda do
        mock = ConstructionQueue.push(@constructor_id, klass.to_s, false, 10)
        ConstructionQueue.reduce(mock.id, 6)
        @planet.reload
      end.should_not change_resources_of(@planet)
    end
  end

  describe ".move" do
    it "should raise error if given negative position" do
      lambda do
        ConstructionQueue.move(1, -1)
      end.should raise_error(GameLogicError)
    end

    it "should push event" do
      model1 = ConstructionQueue.push(@constructor_id, klass.to_s, false, 20)
      model2 = ConstructionQueue.push(@constructor_id, klass2.to_s, false, 20)
      should_fire_event(Event::ConstructionQueue.new(@constructor_id),
      EventBroker::CHANGED) do
        ConstructionQueue.move(model1.id, model2.position)
      end
    end

    it "should not merge prepaid and not-prepaid items" do
      model1 = ConstructionQueue.push(@constructor_id, klass.to_s, true, 2)
      model2 = ConstructionQueue.push(@constructor_id, klass.to_s, false, 2)
      ConstructionQueue.move(model2.id, model1.position)
      [model2, model1].map { |m| m.reload; m.position }.should == [0, 1]
    end

    describe "single tests" do
      before(:each) do
        @model1 = ConstructionQueue.push(@constructor_id, klass.to_s, false, 2)
        @model2 = ConstructionQueue.push(@constructor_id, klass2.to_s, false, 2)
        @model3 = ConstructionQueue.push(@constructor_id, klass3.to_s, false, 2)
        @model4 = ConstructionQueue.push(@constructor_id, klass4.to_s, false, 2)
        @model5 = ConstructionQueue.push(@constructor_id, klass5.to_s, false, 2)
      end

      describe "left" do
        it "should reorder positions" do
          ConstructionQueue.move(@model4.id, @model2.position)

          positions = [@model1, @model4, @model2, @model3, @model5].map do |o|
            o.reload
            o.position
          end

          positions.should == [0, 1, 2, 3, 4]
        end
      end

      describe "right" do
        it "should reorder positions" do
          ConstructionQueue.move(@model2, @model4.position)

          positions = [
            @model1, @model3, @model2, @model4, @model5
          ].map do |o|
            o.reload
            o.position
          end

          positions.should == [0, 1, 2, 3, 4]
        end
      end

      it "should not do anything if trying to move to same position" do
        ConstructionQueue.move(@model4, @model4.position)

        positions = [@model1, @model2, @model3, @model4, @model5].map do |o|
          o.reload
          o.position
        end

        positions.should == [0, 1, 2, 3, 4]
      end

      describe "merging" do
        it "should merge objects from left" do
          model6 = ConstructionQueue.push(
            @constructor_id, @model2.constructable_type, false, 15
          )
          lambda do
            ConstructionQueue.move(model6.id, @model3.position)
            @model2.reload
          end.should change(@model2, :count).by(model6.count)
        end

        it "should merge objects from right" do
          model6 = ConstructionQueue.push(
            @constructor_id, @model3.constructable_type, false, 15
          )
          lambda do
            ConstructionQueue.move(model6.id, @model3.position)
            @model3.reload
          end.should change(@model3, :count).by(model6.count)
        end


        it "should merge elements from sides if you move " +
        "one out between them" do
          @model4.constructable_type = @model2.constructable_type
          @model4.params = @model2.params
          @model4.save!

          lambda do
            ConstructionQueue.move(@model3, @model5.position + 1)
            @model2.reload
          end.should change(@model2, :count).by(@model4.count)
        end

        it "should not merge objects if params differ" do
          model6 = ConstructionQueue.push(
            @constructor_id, @model3.constructable_type, false, 15,
            {'x' => 10, 'y' => 20}
          )
          lambda do
            ConstructionQueue.move(model6.id, @model3.position)
            @model3.reload
          end.should_not change(@model3, :count)
        end

        it "should delete merged objects" do
          model6 = ConstructionQueue.push(
            @constructor_id, @model2.constructable_type, false, 15
          )
          model6 = ConstructionQueue.move(model6, @model3.position)
          lambda do
            model6.reload
          end.should raise_error(ActiveRecord::RecordNotFound)
        end

        it "should not reorder existing items" do
          model6 = ConstructionQueue.push(
            @constructor_id, @model2.constructable_type, false, 15
          )
          ConstructionQueue.move(model6, @model3.position)

          positions = [@model1, @model2, @model3, @model4, @model5].map do |o|
            o.reload
            o.position
          end

          positions.should == [0, 1, 2, 3, 4]
        end

        it "should not merge with itself" do
          lambda do
            ConstructionQueue.move(@model1, @model2.position)
            @model1.reload
          end.should_not change(@model1, :count)
        end
      end
    end

    describe "complex moving tests" do
      [        
        ["A1 B1 C1 B1 A1 C1", 0, 0, nil, "in place same spot",
          "A1 B1 C1 B1 A1 C1"],
        ["A1 B1 C1 B1 A1 C1", 0, 1, nil, "in place right",
          "A1 B1 C1 B1 A1 C1"],
        ["A1 B1 A1 B1 A1", 1, 5, nil, "move and outer merge",
          "A2 B1 A1 B1"],
        ["A1 B1 A1 B1 A1", 0, 4, nil, "move and merge left",
          "B1 A1 B1 A2"],
        ["A1 B1 A1 B1 A1", 4, 1, nil, "move and merge right",
          "A2 B1 A1 B1"],
        ["A1 B1 C1 B1 A1 C1", 0, 2, nil, "move right",
          "B1 A1 C1 B1 A1 C1"],
        ["A5 B1 C1 B1 A1 C1", 0, 2, 3, "split right",
          "A2 B1 A3 C1 B1 A1 C1"],
        ["A1 B1 C1 B1 A1 C1", 0, 6, nil, "move right edge",
          "B1 C1 B1 A1 C1 A1"],
        ["A5 B1 C1 B1 A1 C1", 0, 6, 3, "split right edge",
          "A2 B1 C1 B1 A1 C1 A3"],
        ["A1 B1 C1 B1 A1 C1", 4, 2, nil, "move left",
          "A1 B1 A1 C1 B1 C1"],
        ["A1 B1 C1 B1 A5 C1", 4, 2, 3, "split left",
          "A1 B1 A3 C1 B1 A2 C1"],
        ["A1 B1 C1 B1 A1 C1", 5, 0, nil, "move left edge",
          "C1 A1 B1 C1 B1 A1"],
        ["A1 B1 C1 B1 A1 C5", 5, 0, 3, "split left edge",
          "C3 A1 B1 C1 B1 A1 C2"],
        ["S1 T1 F1 T1", 3, 0, nil, "move left (merge bug)", 
          "T1 S1 T1 F1"],
        ["S1 T1 S1", 1, 0, nil, "move left & merge (merge bug 2)",
          "T1 S2"],
        ["S2 F1 T1 S3", 0, 4, 1, "split to the end (merge bug)",
          "S1 F1 T1 S4"],
        ["F1 S1 F1 T1 F4", 2, 5, nil, "move to the end (merge bug)",
          "F1 S1 T1 F5"],
        ["F1 S1 T1 S3", 3, 0, nil, "move to begining (merge bug)",
          "S3 F1 S1 T1"],
      ].each do |source_set, from, to, count, desc, dest_set|
        it "should #{desc} from #{from} to #{to} (count: #{count}) in '#{
        source_set}' and get #{dest_set}" do
          source_set = source_set.split(" ").map do |e|
            type = e[0].chr
            entry_count = e[1].chr.to_i

            ConstructionQueue.push(@constructor_id, "#{klass.to_s}_#{type}",
              false, entry_count)
          end

          ConstructionQueue.move(source_set[from], to, count)

          result = ConstructionQueueEntry.
            where(:constructor_id => @constructor_id).map \
          do |entry|
            "#{entry.constructable_type.split("_")[1]}#{entry.count}"
          end.join(" ")

          result.should == dest_set
        end
      end
    end
  
    describe "0000840: Units queue merge algorythm fails again" do
      it "should not fail" do
        entry_m = ConstructionQueue.push(@constructor_id, "Mule", false, 2)
        entry_c = ConstructionQueue.push(@constructor_id, "Crow", false, 2)
        ConstructionQueue.move(entry_m, 2, 1)
        ConstructionQueue.move(entry_c, 3, 1)
        ConstructionQueue.push(@constructor_id, "Crow", false, 1)
        
        ConstructionQueueEntry.
          where(:constructor_id => @constructor_id).map \
        do |entry|
          "#{entry.count}x#{entry.constructable_type}"
        end.join(" ").should == "1xMule 1xCrow 1xMule 2xCrow"
      end
    end
  end

  describe "multiplication bug" do
    it "should not multiply end trooper" do
      ConstructionQueue.push(@constructor_id, "Unit::Shocker", false, 1)
      ConstructionQueue.push(@constructor_id, "Unit::Trooper", false, 1)
      ConstructionQueue.push(@constructor_id, "Unit::Shocker", false, 1)
      ConstructionQueue.push(@constructor_id, "Unit::Trooper", false, 1)
      ConstructionQueue.push(@constructor_id, "Unit::Trooper", false, 1)

      2.times do
        ConstructionQueue.shift(@constructor_id)
        @constructor.construction_queue_entries(true).map(
          &:count).should_not include(3)
      end
    end
  end
end