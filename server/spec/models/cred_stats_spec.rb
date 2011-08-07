require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe CredStats do
  describe ".accelerate!" do
    it "should work" do
      model = Factory.create(:unit, :player => Factory.create(:player))
      CredStats.accelerate!(model, 1000, 100, 100)
    end
  end

  describe ".self_destruct!" do
    it "should work" do
      planet = Factory.create(:planet, :player => Factory.create(:player))
      model = Factory.create(:building, :planet => planet)
      CredStats.self_destruct!(model)
    end
  end

  describe ".move!" do
    it "should work" do
      planet = Factory.create(:planet, :player => Factory.create(:player))
      model = Factory.create(:building, :planet => planet)
      CredStats.move!(model)
    end
  end

  describe ".alliance_change!" do
    it "should work" do
      CredStats.alliance_change!(Factory.create(:player))
    end
  end

  describe ".movement_speed_up!" do
    it "should work" do
      CredStats.movement_speed_up!(Factory.create(:player), 100)
    end
  end

  describe ".vip!" do
    it "should work" do
      CredStats.vip!(Factory.create(:player), 1, 100)
    end
  end

  describe ".boost!" do
    it "should work" do
      CredStats.boost!(Factory.create(:player), 'metal', 'rate')
    end
  end
  
  describe ".finish_exploration!" do
    it "should work" do
      CredStats.finish_exploration!(Factory.create(:player), 3, 4)
    end
  end
end