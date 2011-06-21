require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe ClientQuest do
  describe "object" do
    before(:all) do
      @class = ClientQuest
    end

    it_should_behave_like "object"
  end

  describe "#as_json" do
    before(:all) do
      @player = Factory.create(:player)

      @quest1 = Factory.create(:quest)
      @questp1 = Factory.create(:quest_progress, :quest => @quest1,
        :status => QuestProgress::STATUS_STARTED, :player => @player)
      @obj1 = Factory.create(:objective, :quest => @quest1, :count => 5)
      @objp1 = Factory.create(:objective_progress, :objective => @obj1,
        :completed => 2, :player => @player)
      @obj2 = Factory.create(:objective, :quest => @quest1, :count => 10)

      @result = ClientQuest.new(@quest1.id, @player.id).as_json
    end

    it "should return quest" do
      @result[:quest].should == @quest1
    end

    it "should return quest progress" do
      @result[:progress].should == @questp1
    end

    it "should include their objectives" do
      @result[:objectives].map do |objective_hash|
        objective_hash[:objective]
      end.should == [@obj1, @obj2]
    end

    it "should include objective progresses" do
      @result[:objectives].find { |objective_hash|
        objective_hash[:objective] == @obj1
      }[:progress].should == @objp1
    end

    it "should be nil where objective has been finished" do
      @result[:objectives].find { |objective_hash|
        objective_hash[:objective] == @obj2
      }[:progress].should be_nil
    end
  end
end
