require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Building::ResearchCenter do
  describe "#activate" do
    before(:each) do
      @rc = Factory.create :b_research_center, opts_inactive
      @player = @rc.planet.player
    end

    it "should add scientists to player" do
      @rc.activate
      lambda do
        @rc.save!
        @player.reload
      end.should change(@player, :scientists).by(@rc.scientists)
    end

    it "should add scientists_total to player" do
      @rc.activate
      lambda do
        @rc.save!
        @player.reload
      end.should change(@player, :scientists_total).by(@rc.scientists)
    end
  end

  describe "#deactivate" do
    before(:each) do
      @rc = Factory.create :b_research_center, opts_active
      @player = @rc.planet.player
    end

    it "should subtract scientists from player" do
      @rc.deactivate
      lambda do
        @rc.save!
        @player.reload
      end.should change(@player, :scientists).by(-@rc.scientists)
    end

    it "should subtract scientists_total from player" do
      @rc.deactivate
      lambda do
        @rc.save!
        @player.reload
      end.should change(@player, :scientists_total).by(-@rc.scientists)
    end

    it "should call player.ensure_free_scientists!" do
      @rc.stub!(:player).and_return(@player)
      @player.should_receive(:ensure_free_scientists!).with(@rc.scientists)
      @rc.deactivate
      @rc.save!
    end
  end
end