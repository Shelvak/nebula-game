require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe FowChangeEvent::Recalculate do
  before(:all) do
    @alliance = Factory.create(:alliance)
    @player1 = Factory.create(:player, :alliance => @alliance)
    @player2 = Factory.create(:player, :alliance => @alliance)
    @solar_system = Factory.create(:solar_system)
    @result = FowChangeEvent::Recalculate.new([
      Factory.create(:fse_alliance, :alliance => @alliance,
        :solar_system => @solar_system),
      Factory.create(:fse_player, :player => @player1,
        :solar_system => @solar_system)
    ], @solar_system.id).player_ids
  end

  it "should include alliance members" do
    @result.should include(@player2.id)
  end

  it "should include players" do
    @result.should include(@player1.id)
  end

  it "should be unique" do
    @result.should == @result.uniq
  end
end