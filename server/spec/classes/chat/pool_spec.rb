require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Chat::Pool do
  it "should be singleton" do
    Chat::Pool.instance.should == Chat::Pool.instance
  end

  describe "#hub_for" do
    it "should return hub by galaxy id" do
      player = Factory.create(:player)
      Chat::Pool.instance.hub_for(player).should be_instance_of(Chat::Hub)
    end

    it "should return same hub for two players in same galaxy" do
      player = Factory.create(:player)
      player2 = Factory.create(:player, :galaxy => player.galaxy)
      Chat::Pool.instance.hub_for(player).should ==
        Chat::Pool.instance.hub_for(player2)
    end
  end
end