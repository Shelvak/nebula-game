require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Building::ResearchCenter do
  describe "#activate!" do
    before(:each) do
      @rc = Factory.create :b_research_center, opts_inactive
      @player = @rc.planet.player
    end

    it "should call player.change_scientist_count!" do
      @rc.stub_chain(:planet, :player).and_return(@player)
      @player.should_receive(:change_scientist_count!).with(@rc.scientists)
      @rc.activate!
    end
  end

  describe "#deactivate!" do
    before(:each) do
      @rc = Factory.create :b_research_center, opts_active
      @player = @rc.planet.player
    end

    it "should call player.chance_scientist_count!" do
      @rc.stub_chain(:planet, :player).and_return(@player)
      @player.should_receive(:change_scientist_count!).with(-@rc.scientists)
      @rc.deactivate!
    end
  end
end