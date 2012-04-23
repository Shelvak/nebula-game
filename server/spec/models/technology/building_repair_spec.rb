require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Technology::BuildingRepair do
  describe ".get" do
    let(:player) { Factory.create(:player) }
    def technology(level=1, player=nil)
      @technology ||= Factory.create!(
        :t_building_repair, :player => player || self.player, :level => level
      )
    end

    it "should fail if level is 0" do
      technology(0)
      lambda do
        Technology::BuildingRepair.get(player.id)
      end.should raise_error(GameLogicError)
    end

    it "should fail if other player has the tech" do
      technology(1, Factory.create(:player))
      lambda do
        Technology::BuildingRepair.get(player.id)
      end.should raise_error(GameLogicError)
    end

    it "should return technology" do
      technology
      Technology::BuildingRepair.get(player.id).should == technology
    end
  end
end