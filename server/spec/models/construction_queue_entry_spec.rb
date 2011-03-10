require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe ConstructionQueueEntry do
  describe "find" do
    it "should be ordered by position by default" do
      model1 = Factory.create(:construction_queue_entry, :position => 10)
      model2 = Factory.create(:construction_queue_entry, :position => 5)
      model3 = Factory.create(:construction_queue_entry, :position => 7)

      ConstructionQueueEntry.all.map(&:position).should == [
        model2, model3, model1
      ].map(&:position)
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
    before(:all) do
      @build = lambda { Factory.build(:construction_queue_entry) }
      @change = lambda { |model| model.count += 1 }
    end

    @should_not_notify_update = true
    @should_not_notify_destroy = true
    it_should_behave_like "notifier"
  end
end