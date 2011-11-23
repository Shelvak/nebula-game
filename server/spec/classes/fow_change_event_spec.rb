require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe Event::FowChange do
  describe "#player_ids" do
    before(:all) do
      @alliance = Factory.create(:alliance)
      @player1 = Factory.create(:player, :alliance => @alliance)
      @player2 = Factory.create(:player, :alliance => @alliance)
      @result = Event::FowChange.new(@player1, @alliance).player_ids
    end

    it "should include player" do
      @result.should include(@player1.id)
    end

    it "should include alliance members" do
      @result.should include(@player2.id)
    end

    it "should include player even if it is not in alliance" do
      player = Factory.create(:player)
      Event::FowChange.new(
        player, @alliance
      ).player_ids.should include(player.id)
    end

    it "should only include unique ids" do
      @result.uniq.should == @result
    end
  end
end