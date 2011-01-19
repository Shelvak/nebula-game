require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe FowChangeEvent::Recalculate do
  before(:all) do
    @alliance = Factory.create(:alliance)
    @player1 = Factory.create(:player, :alliance => @alliance)
    @player2 = Factory.create(:player, :alliance => @alliance)
    @solar_system = Factory.create(:solar_system)
    @fse_player = Factory.create(:fse_player, :player => @player1,
      :solar_system => @solar_system)
    @fse_alliance = Factory.create(:fse_alliance, :alliance => @alliance,
      :solar_system => @solar_system)
    event = FowChangeEvent::Recalculate.new([
      @fse_player, @fse_alliance
    ], @solar_system.id)
    @player_ids = event.player_ids
    @metadatas = event.metadatas
  end

  describe "player ids" do
    it "should include alliance members" do
      @player_ids.should include(@player2.id)
    end

    it "should include players" do
      @player_ids.should include(@player1.id)
    end

    it "should be unique" do
      @player_ids.should == @player_ids.uniq
    end
  end

  describe "metadatas" do
    it "should include metadata for alliance members" do
      @metadatas[@player2.id].should == FowSsEntry.merge_metadata(
        nil, @fse_alliance)
    end

    it "should include metadata for players" do
      @metadatas[@player1.id].should == FowSsEntry.merge_metadata(
        @fse_player, @fse_alliance)
    end
  end
end