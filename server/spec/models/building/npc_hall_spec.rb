require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

describe Building::NpcHall do
  before(:each) do
    @player = Factory.create(:player)
    @planet = Factory.create(:planet, :player => @player)
    @model = Factory.create(:b_npc_hall, :planet => @planet)
  end

  it_should_behave_like "with resetable cooldown"
  it_should_behave_like "with looped cooldown"

  describe "cooldown hit" do
    it "should give VP to player that owns the planet" do
      lambda do
        @model.cooldown_expired!
        @player.reload
      end.should change(@player, :victory_points).by(
        @model.property('victory_points'))
    end

    it "should give creds to player that owns the planet" do
      lambda do
        @model.cooldown_expired!
        @player.reload
      end.should change(@player, :creds).by(@model.property('creds'))
    end

    it "should not fail if there is no player" do
      @model.planet = Factory.create(:planet)
      @model.cooldown_expired!
    end
  end
end