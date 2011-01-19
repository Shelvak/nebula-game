require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe FowChangeEvent::SolarSystem do
  before(:all) do
    solar_system = Factory.create(:solar_system)
    alliance = Factory.create(:alliance)
    @player_direct = Factory.create(:player)
    @player_ally = Factory.create(:player, :alliance => alliance)
    @player_both = Factory.create(:player, :alliance => alliance)

    @fse_direct = Factory.create(:fse_player, :solar_system => solar_system,
      :player => @player_direct)
    @fse_alliance = Factory.create(:fse_alliance,
      :solar_system => solar_system, :alliance => alliance)
    @fse_both = Factory.create(:fse_player, :solar_system => solar_system,
      :player => @player_both)

    event = FowChangeEvent::SolarSystem.new(solar_system.id)
    @player_ids = event.player_ids
    @metadatas = event.metadatas
  end

  describe "player ids" do
    it "should include direct visibility players" do
      @player_ids.should include(@player_direct.id)
    end

    it "should include alliance visibility players" do
      @player_ids.should include(@player_ally.id)
    end

    it "should include both visibility players" do
      @player_ids.should include(@player_both.id)
    end

    it "should not have duplicates" do
      @player_ids.should == @player_ids.uniq
    end
  end

  describe "metadatas" do
    it "should include for direct visibility" do
      @metadatas[@player_direct.id].should == FowSsEntry.merge_metadata(
        @fse_direct, nil)
    end

    it "should include for alliance visibility" do
      @metadatas[@player_ally.id].should == FowSsEntry.merge_metadata(
        nil, @fse_alliance)
    end

    it "should include for both visibility" do
      @metadatas[@player_both.id].should == FowSsEntry.merge_metadata(
        @fse_both, @fse_alliance)
    end
  end
end