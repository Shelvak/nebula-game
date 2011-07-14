require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe MarketOffer do
  describe "validation" do
    it "should fail if source_kind is creds" do
      Factory.build(:market_offer, :from_kind => MarketOffer::KIND_CREDS).
        should_not be_valid
    end
    
    describe "to_rate ajustment to fit avg. market rate" do
      it "should adjust it if it's too low" do
        offer = Factory.build(:market_offer, :to_rate => 1)
        offer.class.stub!(:avg_rate).with(offer.from_kind, offer.to_kind).
          and_return(7)
        offer.save!
        offer.to_rate.should == 7 * (1 - CONFIG['market.avg_rate.offset'])
      end
      
      it "should adjust it if it's too big" do
        offer = Factory.build(:market_offer, :to_rate => 10)
        offer.class.stub!(:avg_rate).with(offer.from_kind, offer.to_kind).
          and_return(7)
        offer.save!
        offer.to_rate.should == 7 * (1 + CONFIG['market.avg_rate.offset'])
      end
    end
  end
  
  describe "#buy!" do    
    describe "buying goods", :shared => true do
      it "should increase in goods he bought" do
        lambda do
          @offer.buy!(@buyer_planet, @offer.from_amount)
        end.should change(@buyer_planet, :metal).by(@offer.from_amount)
      end
    end
    
    describe "dispatching planet changed", :shared => true do
      it "should dispatch changed event" do
        should_fire_event(@planet, EventBroker::CHANGED, 
            EventBroker::REASON_OWNER_PROP_CHANGE) do
          @offer.buy!(@buyer_planet, @offer.from_amount)
        end
      end
    end
    
    describe "goods are resources" do
      before(:each) do
        @offer = Factory.create(:market_offer, 
          :from_kind => MarketOffer::KIND_METAL,
          :to_kind => MarketOffer::KIND_ZETIUM)
        @seller_planet = @offer.planet
        
        @to_amount = (@offer.from_amount * @offer.to_rate).ceil
        @buyer_planet = Factory.create(:planet_with_player)
        # We must increase this separately because of the storage/resource
        # order :/
        @buyer_planet.zetium_storage = @buyer_planet.zetium = 
          @to_amount + 1000
      end
      
      it "should fail if buyer does not have enough goods" do
        @buyer_planet.zetium = @to_amount - 1
        lambda do
          @offer.buy!(@buyer_planet, @offer.from_amount)
        end.should raise_error(GameLogicError)
      end
      
      describe "seller planet" do
        before(:each) do
          @planet = @seller_planet
        end
        
        it_should_behave_like "dispatching planet changed"
        
        it "should increase in goods he requested" do
          lambda do
            @offer.buy!(@buyer_planet, @offer.from_amount)
            @seller_planet.reload
          end.should change(@seller_planet, :zetium).by(@to_amount)
        end
      end
      
      describe "buyer planet" do
        before(:each) do
          @planet = @buyer_planet
        end
        
        it_should_behave_like "buying goods"
        it_should_behave_like "dispatching planet changed"
        
        it "should decrease from goods with which he sold it" do
          lambda do
            @offer.buy!(@buyer_planet, @offer.from_amount)
            @buyer_planet.reload
          end.should change(@buyer_planet, :zetium).by(- @to_amount)
        end
        
      end
    end
    
    describe "goods are creds" do
      before(:each) do
        @offer = Factory.create(:market_offer, 
          :from_kind => MarketOffer::KIND_METAL,
          :to_kind => MarketOffer::KIND_CREDS)
        @seller = @offer.player
        
        @to_amount = (@offer.from_amount * @offer.to_rate).ceil
        @buyer = Factory.create(:player, :creds => @to_amount + 1000)
        @buyer_planet = Factory.create(:planet, :player => @buyer)
      end
      
      it "should fail if buyer does not have enough creds" do
        @buyer.creds = @to_amount - 1
        lambda do
          @offer.buy!(@buyer_planet, @offer.from_amount)
        end.should raise_error(GameLogicError)
      end
      
      describe "seller" do
        it "should transfer creds to seller account" do
          lambda do
            @offer.buy!(@buyer_planet, @offer.from_amount)
            @seller.reload
          end.should change(@seller, :creds).by(@to_amount)
        end
      end
      
      describe "buyer" do
        before(:each) do
          @planet = @buyer_planet
        end
        
        it_should_behave_like "dispatching planet changed"
        it_should_behave_like "buying goods"
        
        it "should reduce creds from buyer account" do
          lambda do
            @offer.buy!(@buyer_planet, @offer.from_amount)
            @buyer.reload
          end.should change(@buyer, :creds).by(- @to_amount)
        end
      end
    end
    
    describe "general" do
      before(:each) do
        @offer = Factory.create(:market_offer, 
          :from_kind => MarketOffer::KIND_METAL,
          :to_kind => MarketOffer::KIND_ZETIUM)
        @seller_planet = @offer.planet
        
        @to_amount = (@offer.from_amount * @offer.to_rate).ceil
        @buyer_planet = Factory.create(:planet_with_player)
        # We must increase this separately because of the storage/resource
        # order :/
        @buyer_planet.zetium_storage = @buyer_planet.zetium = 
          @to_amount + 1000
      end
      
      it "should fail if trying to buy <= 0" do
        lambda do
          @offer.buy!(@buyer_planet, 0)
        end.should raise_error(GameLogicError)
      end
      
      it "should buy available amount if trying to buy > offer amount" do
        lambda do
          @offer.buy!(@buyer_planet, @offer.from_amount + 1)
        end.should change(@offer, :from_amount).to(0)
      end
      
      it "should round cost for buyer up" do
        @offer.from_amount = 1000
        @offer.to_rate = 0.33
        @buyer_planet.zetium = (@offer.from_amount * @offer.to_rate).ceil
        lambda do
          @offer.buy!(@buyer_planet, @offer.from_amount)
        end.should change(@buyer_planet, :zetium).by(- @buyer_planet.zetium)
      end
      
      it "should reduce amount from offer if offer is not exausted" do
        lambda do
          @offer.buy!(@buyer_planet, @offer.from_amount / 2)
          @offer.reload
        end.should change(@offer, :from_amount).by(- @offer.from_amount / 2)
      end

      it "should destroy offer if it is exausted" do
        @offer.buy!(@buyer_planet, @offer.from_amount)
        lambda do
          @offer.reload
        end.should raise_error(ActiveRecord::RecordNotFound)
      end

      it "should create notification"
    end
  end
  
  describe "#cancel!" do
    before(:each) do
      @offer = Factory.create(:market_offer, 
        :from_kind => MarketOffer::KIND_ENERGY)
    end
    
    it "should return from_amount to the planet" do
      planet = @offer.planet
      lambda do
        @offer.cancel!
        planet.reload
      end.should change(planet, :energy).by(@offer.from_amount)
    end
    
    it "should dispatch changed with planet" do
      should_fire_event(@offer.planet, EventBroker::CHANGED, 
          EventBroker::REASON_OWNER_PROP_CHANGE) do
        @offer.cancel!
      end
    end
    
    it "should destroy the offer" do
      @offer.cancel!
      lambda do
        @offer.reload
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
  end
  
  describe ".avg_rate" do
    it "should raise error if no such config value exists" do
      lambda do
        MarketOffer.avg_rate(-1, -1)
      end.should raise_error(ArgumentError)
    end
    
    it "should combine config seed data & offers data" do
      MarketOffer.delete_all
      offer = Factory.create(:market_offer, 
        :from_kind => MarketOffer::KIND_METAL,
        :to_kind => MarketOffer::KIND_ENERGY)
      seed_amount, seed_rate = CONFIG[
        "market.avg_rate.seed.#{MarketOffer::KIND_METAL}.#{
        MarketOffer::KIND_ENERGY}"
      ]
      MarketOffer.
        avg_rate(MarketOffer::KIND_METAL, MarketOffer::KIND_ENERGY).
        should be_close(
          (
            offer.from_amount * offer.to_rate + seed_amount * seed_rate
          ) / (offer.from_amount + seed_amount),
          0.01
        )
    end
  end
end