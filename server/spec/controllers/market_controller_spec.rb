require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe MarketController do
  include ControllerSpecHelper

  before(:each) do
    init_controller MarketController, :login => true
  end
  
  describe "market|avg_rate" do
    before(:each) do
      @action = "market|avg_rate"
      @params = {'from_kind' => MarketOffer::KIND_METAL, 
        'to_kind' => MarketOffer::KIND_ZETIUM}
    end
    
    @required_params = %w{from_kind to_kind}
    it_should_behave_like "with param options"
    
    it "should return average rate" do
      rate = 0.45
      
      MarketOffer.should_receive(:avg_rate).with(player.galaxy_id, 
        @params['from_kind'], @params['to_kind']).and_return(rate)
      invoke @action, @params
      response_should_include(:avg_rate => rate)
    end
  end
  
  describe "market|index" do
    before(:each) do
      @action = "market|index"
      @planet = Factory.create(:planet, :player => player)
      planet2 = Factory.create(:planet, :player => player)
      @public_offers = [
        Factory.create(:market_offer, :galaxy_id => player.galaxy_id),
        Factory.create(:market_offer, :galaxy_id => player.galaxy_id),
        Factory.create(:market_offer, :galaxy_id => player.galaxy_id),
      ]
      @planet_offers = [
        Factory.create(:market_offer, :planet => @planet),
        Factory.create(:market_offer, :planet => @planet),
      ]
      # This should be invisible because it's on the other planet.
      Factory.create(:market_offer, :planet => planet2)
      # This should be invisible because it's in the other galaxy.
      Factory.create(:market_offer)
      @params = {'planet_id' => @planet.id}
    end
    
    @required_params = %w{planet_id}
    it_should_behave_like "with param options"
    
    it "should fail if planet does not belong to player" do
      @planet.player = Factory.create(:player)
      @planet.save!
      
      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
    
    it "should have public offers" do
      invoke @action, @params
      response[:public_offers].each_with_index do |offer_row, index|
        offer_row.should equal_to_hash(@public_offers[index].as_json)
      end
      response[:public_offers].size.should == @public_offers.size
    end
    
    it "should have planet offers" do
      invoke @action, @params
      response[:planet_offers].each_with_index do |offer_row, index|
        offer_row.should equal_to_hash(@planet_offers[index].as_json)
      end
      response[:planet_offers].size.should == @planet_offers.size
    end
  end
  
  describe "market|new" do
    before(:each) do
      @action = "market|new"
      @planet = Factory.create(:planet, :player => player)
      @market = Factory.create(:b_market, :planet => @planet)
      @params = {
        'market_id' => @market.id, 
        'from_kind' => MarketOffer::KIND_METAL,
        'from_amount' => CONFIG['market.offer.min_amount'],
        'to_kind' => MarketOffer::KIND_ZETIUM,
        'to_rate' => 0.2
      }
    end
    
    @required_params = %w{market_id from_amount from_kind to_kind 
      to_rate}
    it_should_behave_like "with param options"
    
    it "should fail if planet does not belong to player" do
      @planet.player = Factory.create(:player)
      @planet.save!
      
      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end
    
    it "should create and return offer" do
      offer = Factory.create(:market_offer, :planet => @planet)
      Building::Market.should_receive(:find).with(@market.id).
        and_return(@market)
      @market.should_receive(:create_offer!).with(
        @params['from_kind'], @params['from_amount'], 
        @params['to_kind'], @params['to_rate']
      ).and_return(offer)
      invoke @action, @params
      response_should_include(:offer => offer.as_json)
    end
  end
  
  describe "market|cancel" do
    before(:each) do
      @action = "market|cancel"
      @planet = Factory.create(:planet, :player => player)
      @offer = Factory.create(:market_offer, :planet => @planet)
      @params = {'offer_id' => @offer.id}
    end
    
    @required_params = %w{offer_id}
    it_should_behave_like "with param options"
    
    it "should fail if planet does not belong to player" do
      @planet.player = Factory.create(:player)
      @planet.save!
      
      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end
    
    it "should fail if offer cannot be found" do
      @offer.destroy
      
      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
    
    it "should cancel the offer otherwise" do
      MarketOffer.should_receive(:find).with(@offer.id).and_return(@offer)
      @offer.should_receive(:cancel!)
      invoke @action, @params
    end
  end

  describe "market|buy" do
    before(:each) do
      @action = "market|buy"
      offer_planet = Factory.create(:planet, 
        :player => Factory.create(:player, :galaxy_id => player.galaxy_id))
      @offer = Factory.create(:market_offer, :planet => offer_planet)
      @buyer_planet = Factory.create(:planet, :player => player)
      @params = {'offer_id' => @offer.id, 'planet_id' => @buyer_planet.id,
        'amount' => 100}
    end
    
    @required_params = %w{offer_id planet_id amount}
    it_should_behave_like "with param options"
    
    it "should fail if offer is not from this galaxy" do
      @offer.galaxy = Factory.create(:galaxy)
      @offer.save!
      
      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end
    
    it "should fail if trying to buy from self" do
      planet = @offer.planet
      planet.player = player
      planet.save!
      
      lambda do
        invoke @action, @params
      end.should raise_error(GameLogicError)
    end
    
    it "should fail if buyer doesn't own the planet" do
      @buyer_planet.player = Factory.create(:player)
      @buyer_planet.save!
      
      lambda do
        invoke @action, @params
      end.should raise_error(ActiveRecord::RecordNotFound)
    end
    
    it "should return amount = 0 if offer is not found" do
      @offer.destroy
      invoke @action, @params
      response_should_include(:amount => 0)
    end
    
    it "should buy from the offer" do
      lambda do
        invoke @action, @params
        @offer.reload
      end.should change(@offer, :from_amount).by(- @params['amount'])
    end
    
    it "should return amount actually bought" do
      @params['amount'] = @offer.from_amount + 1000
      invoke @action, @params
      response_should_include(:amount => @offer.from_amount)
    end
  end
end