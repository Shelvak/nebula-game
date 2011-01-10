require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe ConstructionQueue do
  before(:each) do
    @constructor = Factory.create(:b_constructor_test)
    @constructor_id = @constructor.id
    @type = 'Building::TestBuilding'
    @type2 = 'Building::TestBuilding2'
    @type3 = 'Building::TestBuilding3'
  end

  describe ".push" do
    describe "new entry if there is nothing in queue" do
      it "should set constructor_id" do
        ConstructionQueue.push(@constructor_id, @type
          ).constructor_id.should == @constructor_id
      end

      it "should set constructable_type" do
        ConstructionQueue.push(@constructor_id, @type
          ).constructable_type.should == @type
      end

      it "should set position to 0" do
        ConstructionQueue.push(@constructor_id, @type).position.should == 0
      end
    end

    it "should raise exception if count < 1" do
      lambda do
        ConstructionQueue.push(@constructor_id, @type, 0)
      end.should raise_error(ArgumentError)
    end

    it "should increase count of existing entry if it exists" do
      count = 15
      entry = ConstructionQueue.push(@constructor_id, @type)
      lambda do
        ConstructionQueue.push(@constructor_id, @type, count)
        entry.reload
      end.should change(entry, :count).by(count)
    end

    it "should push event" do
      should_fire_event(ConstructionQueue::Event.new(@constructor_id),
      EventBroker::CHANGED) do
        ConstructionQueue.push(@constructor_id, @type, 1)
      end
    end

    describe "when last upgradable doesn't match" do
      it "should create new entry" do
        model1 = ConstructionQueue.push(@constructor_id, @type)
        model2 = ConstructionQueue.push(@constructor_id, @type2)
        model2.should_not == model1
      end

      it "should check params matching all arguments matching" do
        model1 = ConstructionQueue.push(@constructor_id, @type, 1, {1=>2})
        model2 = ConstructionQueue.push(@constructor_id, @type, 1)
        model2.should_not == model1
      end

      it "should put new entry with max_position+1" do
        model1 = ConstructionQueue.push(@constructor_id, @type)
        model2 = ConstructionQueue.push(@constructor_id, @type2)
        model2.position.should == model1.position + 1
      end

      it "should put entries in the line ordered by position" do
        model1 = ConstructionQueue.push(@constructor_id, @type)
        model2 = ConstructionQueue.push(@constructor_id, @type + "2")
        model3 = ConstructionQueue.push(@constructor_id, @type + "3")
        model4 = ConstructionQueue.push(@constructor_id, @type + "4")

        [model1, model2, model3, model4].map(&:position).should == [
          0, 1, 2, 3
        ]
      end
    end
  end

  describe ".shift" do
    it "should reduce count from front by 1" do
      ConstructionQueue.push(@constructor_id, @type, 10)
      ConstructionQueue.push(@constructor_id, @type2, 20)
      ConstructionQueue.shift(@constructor_id).count.should == 9
    end

    it "should delete object from front if count == 1" do
      ConstructionQueue.push(@constructor_id, @type, 1)
      ConstructionQueue.shift(@constructor_id).should be_frozen
    end

    it "should push event" do
      ConstructionQueue.push(@constructor_id, @type, 1)
      should_fire_event(ConstructionQueue::Event.new(@constructor_id),
      EventBroker::CHANGED) do
        ConstructionQueue.shift(@constructor_id)
      end
    end
  end

  describe ".reduce" do
    it "should reduce count" do
      mock = ConstructionQueue.push(@constructor_id, @type, 20)
      ConstructionQueue.reduce(mock.id, 15).count.should == 5
    end

    it "should delete object if requested == count" do
      mock = ConstructionQueue.push(@constructor_id, @type, 20)
      ConstructionQueue.reduce(mock.id, mock.count).should be_frozen
    end

    it "should merge adjacent objects on destroy" do
      model1 = ConstructionQueue.push(@constructor_id, @type, 20)
      model2 = ConstructionQueue.push(@constructor_id, @type + "2", 1)
      model3 = ConstructionQueue.push(@constructor_id, @type, 30)
      model4 = ConstructionQueue.push(@constructor_id, @type + "3", 30)

      ConstructionQueue.reduce(model2.id, model2.count)
      model1.reload
      model1.count.should == 50

      lambda do
        model3.reload
      end.should raise_error(ActiveRecord::RecordNotFound)

      model4.reload
      model4.position.should == 1
    end

    it "should push event" do
      mock = ConstructionQueue.push(@constructor_id, @type, 20)
      should_fire_event(ConstructionQueue::Event.new(@constructor_id),
      EventBroker::CHANGED) do
        ConstructionQueue.reduce(mock.id, 15)
      end
    end
  end

  describe ".move" do
    it "should raise error if given negative position" do
      lambda do
        ConstructionQueue.move(1, -1)
      end.should raise_error(GameLogicError)
    end

    it "should push event" do
      model1 = ConstructionQueue.push(@constructor_id, @type, 20)
      model2 = ConstructionQueue.push(@constructor_id, @type + "2", 20)
      should_fire_event(ConstructionQueue::Event.new(@constructor_id),
      EventBroker::CHANGED) do
        ConstructionQueue.move(model1.id, model2.position)
      end
    end

    describe "single tests" do
      before(:each) do
        @model1 = ConstructionQueue.push(@constructor_id, @type, 20)
        @model2 = ConstructionQueue.push(@constructor_id, @type + "2", 20)
        @model3 = ConstructionQueue.push(@constructor_id, @type + "3", 20)
        @model4 = ConstructionQueue.push(@constructor_id, @type + "4", 20)
        @model5 = ConstructionQueue.push(@constructor_id, @type + "5", 20)
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
          model6 = ConstructionQueue.push(@constructor_id,
            @model2.constructable_type,
            15)
          lambda do
            ConstructionQueue.move(model6.id, @model3.position)
            @model2.reload
          end.should change(@model2, :count).by(model6.count)
        end

        it "should merge objects from right" do
          model6 = ConstructionQueue.push(@constructor_id,
            @model3.constructable_type,
            15)
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
          model6 = ConstructionQueue.push(@constructor_id,
            @model3.constructable_type,
            15,
            {'x' => 10, 'y' => 20})
          lambda do
            ConstructionQueue.move(model6.id, @model3.position)
            @model3.reload
          end.should_not change(@model3, :count)
        end

        it "should delete merged objects" do
          model6 = ConstructionQueue.push(@constructor_id, @model2.constructable_type,
            15)
          model6 = ConstructionQueue.move(model6, @model3.position)
        end

        it "should not reorder existing items" do
          model6 = ConstructionQueue.push(@constructor_id, @model2.constructable_type,
            15)
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

    describe "complex tests" do
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
          "S3 F1 S1 T1"]
      ].each do |source_set, from, to, count, desc, dest_set|
        it "should #{desc} from #{from} to #{to} (count: #{count}) in '#{
        source_set}' and get #{dest_set}" do
          source_set = source_set.split(" ").map do |e|
            type = e[0].chr
            entry_count = e[1].chr.to_i

            ConstructionQueue.push(@constructor_id, "#{@type}_#{type}",
              entry_count)
          end

          ConstructionQueue.move(source_set[from], to, count)

          result = ConstructionQueueEntry.find(:all, :conditions => {
          :constructor_id => @constructor_id}).map do |entry|
            "#{entry.constructable_type.split("_")[1]}#{entry.count}"
          end.join(" ")

          result.should == dest_set
        end
      end
    end
  end

  describe "multiplication bug" do
    it "should not multiply end trooper" do
      ConstructionQueue.push(@constructor_id, "Unit::Shocker", 1)
      ConstructionQueue.push(@constructor_id, "Unit::Trooper", 1)
      ConstructionQueue.push(@constructor_id, "Unit::Shocker", 1)
      ConstructionQueue.push(@constructor_id, "Unit::Trooper", 1)
      ConstructionQueue.push(@constructor_id, "Unit::Trooper", 1)

      2.times do
        ConstructionQueue.shift(@constructor_id)
        @constructor.construction_queue_entries(true).map(
          &:count).should_not include(3)
      end
    end
  end
end