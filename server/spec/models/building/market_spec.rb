require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Building::Market do
  describe "#full_cost" do
    it "should return amount + fee ceiled" do
      market = Factory.create!(:b_market)
      market.should_receive(:fee).and_return(0.033)
      market.full_cost(1000).should == (1000 * 1.033).ceil
    end
  end
  
  describe "#create_offer!" do
    before(:each) do
      @market = Factory.create!(:b_market)
      @planet = @market.planet
      @amount = 1000
      @planet.metal = @market.full_cost(@amount)
      @planet.save!
    end
    
    it "should fail if there are not enough resources" do
      @planet.metal -= 1
      @planet.save!
      lambda do
        @market.create_offer!(MarketOffer::KIND_METAL, @amount, 
          MarketOffer::KIND_ZETIUM, 1)
      end.should raise_error(GameLogicError)
    end
    
    it "should deduct resources from planet" do
      lambda do
        @market.create_offer!(MarketOffer::KIND_METAL, @amount, 
            MarketOffer::KIND_ZETIUM, 1)
        @planet.reload
      end.should change(@planet, :metal).to(0)
    end
    
    it "should fire changed on planet" do
      should_fire_event(@planet, EventBroker::CHANGED, 
          EventBroker::REASON_OWNER_PROP_CHANGE) do
        @market.create_offer!(MarketOffer::KIND_METAL, @amount, 
            MarketOffer::KIND_ZETIUM, 1)
      end
    end
    
    it "should return created offer" do
      @market.create_offer!(MarketOffer::KIND_METAL, @amount, 
        MarketOffer::KIND_ZETIUM, 1).should be_instance_of(MarketOffer)
    end
    
    it "should save the created offer" do
      @market.create_offer!(MarketOffer::KIND_METAL, @amount, 
        MarketOffer::KIND_ZETIUM, 1).should be_saved
    end
  end
end