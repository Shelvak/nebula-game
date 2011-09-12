require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe MarketOffer do
  describe "validation" do    
    describe "if user has too much offers" do
      it "should fail on create" do
        with_config_values('market.offers.max' => 1) do
          player = Factory.create(:market_offer).player
          offer = Factory.build(:market_offer, 
            :planet => Factory.create(:planet, :player => player))
          offer.should_not be_valid
        end
      end
      
      it "should not fail on update" do
        player = Factory.create(:market_offer).player
        offer = Factory.create(:market_offer, 
          :planet => Factory.create(:planet, :player => player))
        with_config_values('market.offers.max' => 1) do
          offer.should be_valid
        end
      end
    end
    
    describe "when #from_amount is below minimal amount" do
      it "should fail if creating a record" do
        Factory.build(:market_offer, 
          :from_amount => CONFIG['market.offer.min_amount'] - 1).
          should_not be_valid
      end
      
      it "should not fail if record is being updated" do
        offer = Factory.create(:market_offer)
        offer.from_amount = CONFIG['market.offer.min_amount'] - 1
        offer.should be_valid
      end
    end
    
    describe "to_rate ajustment to fit avg. market rate" do
      it "should adjust it if it's too low" do
        offer = Factory.build(:market_offer, :to_rate => 1)
        MarketRate.stub!(:average).
          with(offer.player.galaxy_id, offer.from_kind, offer.to_kind).
          and_return(7)
        offer.save!
        offer.to_rate.should == 7 * (1 - CONFIG['market.average.offset'])
      end
      
      it "should adjust it if it's too big" do
        offer = Factory.build(:market_offer, :to_rate => 10)
        MarketRate.stub!(:average).
          with(offer.player.galaxy_id, offer.from_kind, offer.to_kind).
          and_return(7)
        offer.save!
        offer.to_rate.should == 7 * (1 + CONFIG['market.average.offset'])
      end
    end
  end

  describe "creation" do
    it "should add to galaxy market rate" do
      galaxy = Factory.create(:galaxy)
      offer = Factory.build(:market_offer, :galaxy => galaxy)
      offer.to_rate = MarketRate.
        average(galaxy.id, offer.from_kind, offer.to_kind)
      MarketRate.should_receive(:add).with(offer.galaxy_id, offer.from_kind,
        offer.to_kind, offer.from_amount, offer.to_rate)
      offer.save!
    end
  end

  describe "destruction" do
    it "should subtract from MarketRate" do
      offer = Factory.create(:market_offer)
      MarketRate.should_receive(:subtract).with(
        offer.galaxy_id, offer.from_kind, offer.to_kind, offer.from_amount
      )
      offer.destroy!
    end
  end
  
  describe "#as_json" do
    before(:each) do
      @model = Factory.create(:market_offer)
    end
    
    @required_params = %w{id player from_kind from_amount to_kind to_rate
      created_at}
    @ommited_params = MarketOffer.columns.map(&:name) - @required_params
    
    it_should_behave_like "to json"
    
    it "should not fail with system offer" do
      @model.planet = nil
      @model.save!
      
      @model.as_json['player'].should be_nil
    end
  end
  
  describe "#buy!" do    
    shared_examples_for "buying goods" do
      it "should increase in goods he bought" do
        lambda do
          @offer.buy!(@buyer_planet, @offer.from_amount)
        end.should change(@buyer_planet, :metal).by(@offer.from_amount)
      end
    end
    
    shared_examples_for "dispatching planet changed" do
      it "should dispatch changed event" do
        should_fire_event(@planet, EventBroker::CHANGED, 
            EventBroker::REASON_OWNER_PROP_CHANGE) do
          @offer.buy!(@buyer_planet, @offer.from_amount)
        end
      end
    end
    
    shared_examples_for "selling for resources" do
      it "should fail if buyer does not have enough goods" do
        @buyer_planet.zetium = @to_amount - 1
        lambda do
          @offer.buy!(@buyer_planet, @offer.from_amount)
        end.should raise_error(GameLogicError)
      end

      it "should not record cred stats" do
        CredStats.should_not_receive(:buy_offer)
        @offer.buy!(@buyer_planet, @offer.from_amount)
      end
    end
    
    shared_examples_for "seller planet" do
      it_should_behave_like "dispatching planet changed"

      it "should increase in goods he requested" do
        lambda do
          @offer.buy!(@buyer_planet, @offer.from_amount)
          @seller_planet.reload
        end.should change(@seller_planet, :zetium).by(@to_amount)
      end

      it "should not fail if planet is currently unoccupied" do
        # Update row to prevent callbacks kicking in.
        @seller_planet.update_row! "player_id=NULL"

        @offer.buy!(@buyer_planet, @offer.from_amount)
      end
    end
    
    describe "when selling resources" do
      describe "for resources" do
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

        it_should_behave_like "selling for resources"
        
        describe "seller planet" do
          before(:each) do
            @planet = @seller_planet
          end

          it_should_behave_like "seller planet"
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

      describe "for creds" do
        before(:each) do
          @offer = Factory.create(:market_offer, 
            :from_kind => MarketOffer::KIND_METAL,
            :to_kind => MarketOffer::KIND_CREDS)
          @seller_planet = @offer.planet
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

        it "should fail if buying with free creds" do
          @buyer.free_creds = @buyer.pure_creds
          lambda do
            @offer.buy!(@buyer_planet, @offer.from_amount)
          end.should raise_error(GameLogicError)
        end

        it "should register cred stats if it's an system offer" do
          @offer.planet = nil

          should_record_cred_stats(:buy_offer, [@buyer, @to_amount]) do
            @offer.buy!(@buyer_planet, @offer.from_amount)
          end
        end

        it "should register cred stats if it's an npc offer" do
          planet = @offer.planet
          planet.player = nil
          planet.save!

          should_record_cred_stats(:buy_offer, [@buyer, @to_amount]) do
            @offer.buy!(@buyer_planet, @offer.from_amount)
          end
        end

        it "should not record cred stats otherwise" do
          CredStats.should_not_receive(:buy_creds)
          @offer.buy!(@buyer_planet, @offer.from_amount)
        end

        describe "seller" do
          it "should transfer creds to seller account" do
            lambda do
              @offer.buy!(@buyer_planet, @offer.from_amount)
              @seller.reload
            end.should change(@seller, :creds).by(@to_amount)
          end

          it "should not fail if planet is currently unoccupied" do
            @seller_planet.player = nil
            @seller_planet.save!

            @offer.buy!(@buyer_planet, @offer.from_amount)
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
    end
    
    describe "when selling creds" do
      describe "for resources" do
        before(:each) do
          @offer = Factory.create(:market_offer, 
            :from_kind => MarketOffer::KIND_CREDS,
            :to_kind => MarketOffer::KIND_ZETIUM)
          @seller_planet = @offer.planet

          @to_amount = (@offer.from_amount * @offer.to_rate).ceil
          @buyer_planet = Factory.create(:planet_with_player)
          @buyer = @buyer_planet.player
          # We must increase this separately because of the storage/resource
          # order :/
          @buyer_planet.zetium_storage = @buyer_planet.zetium = 
            @to_amount + 1000
        end

        it_should_behave_like "selling for resources"

        describe "seller planet" do
          before(:each) do
            @planet = @seller_planet
          end
          
          it_should_behave_like "seller planet"
        end

        describe "buyer" do
          before(:each) do
            @planet = @buyer_planet
          end

          it "should transfer creds to buyer account" do
            lambda do
              @offer.buy!(@buyer_planet, @offer.from_amount)
              @buyer.reload
            end.should change(@buyer, :creds).by(@offer.from_amount)
          end        

          it "should decrease from goods with which he sold it" do
            lambda do
              @offer.buy!(@buyer_planet, @offer.from_amount)
              @buyer_planet.reload
            end.should change(@buyer_planet, :zetium).by(- @to_amount)
          end
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
        @buyer = @buyer_planet.player
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
      
      it "should reduce amount from offer if offer is not exhausted" do
        lambda do
          @offer.buy!(@buyer_planet, @offer.from_amount / 2)
          @offer.reload
        end.should change(@offer, :from_amount).by(- @offer.from_amount / 2)
      end

      it "should destroy offer if it is exhausted" do
        @offer.buy!(@buyer_planet, @offer.from_amount)
        lambda do
          @offer.reload
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
      
      it "should return amount bought" do
        amount = @offer.from_amount
        @offer.buy!(@buyer_planet, @offer.from_amount + 10).
          should == amount
      end
      
      it "should create notification" do
        Notification.should_receive(:create_for_market_offer_bought).
          with(@offer, @buyer, @offer.from_amount, @to_amount)
        @offer.buy!(@buyer_planet, @offer.from_amount)
      end
      
      it "should not create notif. if buying amount below threshold" do
        Notification.should_not_receive(:create_for_market_offer_bought)
        @offer.buy!(@buyer_planet, 
          @offer.from_amount * 
            CONFIG['market.buy.notification.threshold'] - 1
        )
      end

      it "should not create notification if planet has no owner" do
        @seller_planet.player = nil
        @seller_planet.save!
        
        Notification.should_not_receive(:create_for_market_offer_bought)
        @offer.buy!(@buyer_planet, @offer.from_amount)
      end
    
      it "should not register system callback if offer is bought out" do
        CallbackManager.should_not_receive(:register).
          with(
            @offer.galaxy, 
            MarketOffer::CALLBACK_MAPPINGS[@offer.from_kind],
            an_instance_of(Time)
          )
        @offer.buy!(@buyer_planet, @offer.from_amount)
      end

      it "should subtract amount bought from MarketRate" do
        amount = @offer.from_amount / 2
        MarketRate.should_receive(:subtract).with(
          @offer.galaxy_id, @offer.from_kind, @offer.to_kind, amount
        )
        @offer.buy!(@buyer_planet, amount)
      end

      describe "system offers" do
        before(:each) do
          @offer.planet = nil
          @offer.save!
        end

        it "should support buying them" do
          @offer.buy!(@buyer_planet, @offer.from_amount)
        end
        
        it "should register callback when offer is bought out" do
          CallbackManager.should_receive(:register).and_return do
            |galaxy, event, time|
            galaxy.should == @offer.galaxy
            event.should == MarketOffer::CALLBACK_MAPPINGS[@offer.from_kind]
            Cfg.market_bot_resource_cooldown_range.
              should cover(time - Time.now)
            
            true
          end
          @offer.buy!(@buyer_planet, @offer.from_amount)
        end
        
        it "should not register callback when offer is not bought out" do
          CallbackManager.should_not_receive(:register).
            with(
              @offer.galaxy, 
              MarketOffer::CALLBACK_MAPPINGS[@offer.from_kind],
              an_instance_of(Time)
            )
          @offer.buy!(@buyer_planet, @offer.from_amount - 100)
        end

        it "should not create notification" do
          Notification.should_not_receive(:create_for_market_offer_bought)
          @offer.buy!(@buyer_planet, @offer.from_amount + 10)
        end
      end
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
    
    it "should return from_amount to player if creds" do
      offer = Factory.create(:market_offer,
                             :from_kind => MarketOffer::KIND_CREDS)

      player = offer.player
      lambda do
        offer.cancel!
        player.reload
      end.should change(player, :market_creds).by(offer.from_amount)
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
  
  describe ".fast_offers" do
    it "should return offers in same format as #as_json" do
      offers = [
        Factory.create(:market_offer),
        Factory.create(:market_offer),
        Factory.create(:market_offer),
      ]
      
      MarketOffer.fast_offers(
        "`#{MarketOffer.table_name}`.id IN (?)", offers.map(&:id)).
        each_with_index do |row, index|
          row.should equal_to_hash(offers[index].as_json)
        end
    end
    
    it "should work with conditions" do
      planet = Factory.create(:planet_with_player)
      
      offers = [
        Factory.create(:market_offer, :planet => planet),
        Factory.create(:market_offer, :planet => planet),
        Factory.create(:market_offer),
      ]
      
      fetched = MarketOffer.fast_offers("planet_id=?", planet.id)
      fetched.each_with_index do |row, index|
        row.should equal_to_hash(offers[index].as_json)
      end
      fetched.size.should == offers.size - 1
    end
    
    it "should return offers from NPC planets" do
      planet = Factory.create(:planet_with_player)      
      # We must create an offer from planet with player.
      offer = Factory.create(:market_offer, :planet => planet)
      planet.player = nil
      planet.save!
      
      fetched = MarketOffer.fast_offers("planet_id=?", planet.id)
      fetched[0].should equal_to_hash(offer.as_json)
      fetched.size.should == 1
    end
    
    it "should return system offers" do    
      offer = Factory.create(:market_offer, :planet => nil, 
        :galaxy_id => Factory.create(:galaxy).id)
      fetched = MarketOffer.
        fast_offers("`#{MarketOffer.table_name}`.`id`=?", offer.id)
      fetched[0].should equal_to_hash(offer.as_json)
      fetched.size.should == 1
    end
  end

  describe ".create_system_offer" do
    before(:all) do
      @galaxy = Factory.create(:galaxy)
      @kind = MarketOffer::KIND_ENERGY
    end
    
    it "should set #from_amount from bot resource range" do
      Cfg.market_bot_resource_range(@kind).should cover(
        MarketOffer.create_system_offer(@galaxy.id, @kind).from_amount
      )
    end
    
    it "should set #from_kind" do
      MarketOffer.create_system_offer(@galaxy.id, @kind).
        from_kind.should == @kind
    end
    
    it "should set #to_kind" do
      MarketOffer.create_system_offer(@galaxy.id, @kind).
        to_kind.should == MarketOffer::KIND_CREDS
    end
    
    it "should set #galaxy_id" do
      MarketOffer.create_system_offer(@galaxy.id, @kind).
        galaxy_id.should == @galaxy.id
    end
    
    it "should set maximum possible selling price" do
      MarketOffer.create_system_offer(@galaxy.id, @kind).to_rate.
        should == 
      (
        MarketRate.average(@galaxy.id, @kind, MarketOffer::KIND_CREDS) *
        (1 + Cfg.market_rate_offset)
      )
    end
  end
end