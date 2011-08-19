require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Building::Market do
  describe "#full_cost" do
    it "should return amount + fee(floored)" do
      market = Factory.create!(:b_market)
      fee = 0.033
      market.should_receive(:fee).and_return(fee)
      market.full_cost(1000).should == (1000 + (1000 * fee).floor)
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
    
    it "should not record cred stats" do
      CredStats.should_not_receive(:market_fee)
      @market.create_offer!(MarketOffer::KIND_METAL, @amount, 
          MarketOffer::KIND_ZETIUM, 1)
    end
    
    it "should record cred stats if #from_kind is creds" do
      @planet.player = Factory.create(:player, :creds => 100000)
      @planet.save!
      
      should_record_cred_stats(
        :market_fee, [@planet.player, @amount * @market.fee]
      ) do
        @market.create_offer!(MarketOffer::KIND_CREDS, @amount, 
          MarketOffer::KIND_ZETIUM, 1)
      end
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