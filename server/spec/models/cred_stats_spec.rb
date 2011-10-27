require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe CredStats do
  describe ".accelerate" do
    it "should work" do
      model = Factory.create(:unit, :player => Factory.create(:player))
      stats = CredStats.accelerate(model, 1000, 100, 100)
      stats.action.should == CredStats::ACTION_ACCELERATE
      stats.save!
    end
  end

  describe ".self_destruct" do
    it "should work" do
      planet = Factory.create(:planet, :player => Factory.create(:player))
      model = Factory.create(:building, :planet => planet)
      stats = CredStats.self_destruct(model)
      stats.action.should == CredStats::ACTION_SELF_DESTRUCT
      stats.save!
    end
  end

  describe ".move" do
    it "should work" do
      planet = Factory.create(:planet, :player => Factory.create(:player))
      model = Factory.create(:building, :planet => planet)
      stats = CredStats.move(model)
      stats.action.should == CredStats::ACTION_MOVE
      stats.save!
    end
  end

  describe ".alliance_change" do
    it "should work" do
      stats = CredStats.alliance_change(Factory.create(:player))
      stats.action.should == CredStats::ACTION_ALLIANCE_CHANGE
      stats.save!
    end
  end

  describe ".movement_speed_up" do
    it "should work" do
      stats = CredStats.movement_speed_up(Factory.create(:player), 100)
      stats.action.should == CredStats::ACTION_MOVEMENT_SPEED_UP
      stats.save!
    end
  end

  describe ".vip" do
    it "should work" do
      stats = CredStats.vip(Factory.create(:player), 1, 100)
      stats.action.should == CredStats::ACTION_VIP
      stats.save!
    end
  end

  describe ".boost" do
    it "should work" do
      stats = CredStats.boost(Factory.create(:player), 'metal', 'rate')
      stats.action.should == CredStats::ACTION_BOOST
      stats.save!
    end
  end
  
  describe ".finish_exploration" do
    it "should work" do
      stats = CredStats.finish_exploration(Factory.create(:player), 3, 4)
      stats.action.should == CredStats::ACTION_FINISH_EXPLORATION
      stats.save!
    end
  end
  
  describe ".remove_foliage" do
    it "should work" do
      stats = CredStats.remove_foliage(Factory.create(:player), 3, 4)
      stats.action.should == CredStats::ACTION_REMOVE_FOLIAGE
      stats.save!
    end
  end
  
  describe ".buy_offer" do
    it "should work" do
      stats = CredStats.buy_offer(Factory.create(:player), 140)
      stats.action.should == CredStats::ACTION_BUY_OFFER
      stats.save!
    end
  end
  
  describe ".market_fee" do
    it "should work" do
      stats = CredStats.market_fee(Factory.create(:player), 140)
      stats.action.should == CredStats::ACTION_MARKET_FEE
      stats.save!
    end
  end

  describe ".unlearn_technology" do
    it "should work" do
      stats = CredStats.unlearn_technology(Factory.create(:player), 140)
      stats.action.should == CredStats::ACTION_UNLEARN_TECHNOLOGY
      stats.save!
    end
  end
end