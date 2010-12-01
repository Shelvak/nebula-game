require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe FowChangeEvent::SolarSystem do
  describe "#player_ids" do
    before(:all) do
      solar_system = Factory.create(:solar_system)
      alliance = Factory.create(:alliance)
      @player_direct = Factory.create(:player)
      @player_ally = Factory.create(:player, :alliance => alliance)
      @player_both = Factory.create(:player, :alliance => alliance)

      Factory.create(:fse_player, :solar_system => solar_system,
        :player => @player_direct)
      Factory.create(:fse_alliance, :solar_system => solar_system,
        :alliance => alliance)
      Factory.create(:fse_player, :solar_system => solar_system,
        :player => @player_both)

      @result = FowChangeEvent::SolarSystem.new(solar_system.id).player_ids
    end

    it "should include direct visibility players" do
      @result.should include(@player_direct.id)
    end

    it "should include alliance visibility players" do
      @result.should include(@player_ally.id)
    end

    it "should not have duplicates" do
      @result.should == @result.uniq
    end
  end
end