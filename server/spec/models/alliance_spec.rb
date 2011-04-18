require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe Alliance do
  describe ".player_ids_for" do
    it "should return player ids" do
      alliance = Factory.create(:alliance)
      p1 = Factory.create :player, :alliance => alliance
      p2 = Factory.create :player, :alliance => alliance
      p3 = Factory.create :player
      p4 = Factory.create :player, :alliance => alliance

      Alliance.player_ids_for(alliance.id).sort.should == [
        p1.id, p2.id, p4.id
      ].sort
    end
  end

  describe ".names_for" do
    it "should return hash" do
      alliance = Factory.create(:alliance)
      Alliance.names_for([alliance.id]).should == {
        alliance.id => alliance.name
      }
    end
  end

  describe "#naps" do
    before(:all) do
      @model = Factory.create :nap
    end

    it "should find by initiator_id" do
      @model.initiator.naps.should include(@model)
    end

    it "should find by acceptor_id" do
      @model.acceptor.naps.should include(@model)
    end
  end

  describe "#accept" do
    before(:each) do
      @alliance = Factory.create :alliance
      @player = Factory.create :player
    end

    it "should raise GameLogicError if already in alliance" do
      @player.alliance = Factory.create(:alliance)
      lambda do
        @alliance.accept(@player)
      end.should raise_error(GameLogicError)
    end

    it "should update player alliance" do
      lambda do
        @alliance.accept(@player)
        @player.reload
      end.should change(@player, :alliance).from(nil).to(@alliance)
    end

    it "should assimilate player Galaxy cache" do
      FowGalaxyEntry.should_receive(:assimilate_player).with(
        @alliance, @player)
      @alliance.accept(@player)
    end

    it "should assimilate player SS cache" do
      FowSsEntry.should_receive(:assimilate_player).with(
        @alliance, @player)
      @alliance.accept(@player)
    end
  end

  describe "#throw_out" do
    before(:each) do
      @alliance = Factory.create :alliance
      @player = Factory.create :player, :alliance => @alliance
    end

    it "should raise GameLogicError if not in alliance" do
      @player.alliance = nil
      lambda do
        @alliance.throw_out(@player)
      end.should raise_error(GameLogicError)
    end

    it "should raise GameLogicError if in another alliance" do
      @player.alliance = Factory.create(:alliance)
      lambda do
        @alliance.throw_out(@player)
      end.should raise_error(GameLogicError)
    end

    it "should update player alliance" do
      lambda do
        @alliance.throw_out(@player)
        @player.reload
      end.should change(@player, :alliance).from(@alliance).to(nil)
    end

    it "should throw out player Galaxy cache" do
      FowGalaxyEntry.should_receive(:throw_out_player).with(
        @alliance, @player)
      @alliance.throw_out(@player)
    end

    it "should throw out player SS cache" do
      FowSsEntry.should_receive(:throw_out_player).with(
        @alliance, @player)
      @alliance.throw_out(@player)
    end
  end
end