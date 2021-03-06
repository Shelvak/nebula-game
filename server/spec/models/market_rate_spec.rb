require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe MarketRate do
  let(:galaxy) { Factory.create(:galaxy) }
  let(:from_kind) { MarketOffer::KIND_METAL }
  let(:to_kind) { MarketOffer::KIND_ENERGY }
  let(:model) do
    Factory.create(
      :market_rate, galaxy: galaxy, from_kind: from_kind, to_kind: to_kind
    )
  end

  describe ".get" do
    it "should create record from seed values if it does not exist" do
      model = MarketRate.get(galaxy.id, from_kind, to_kind)
      seed_amount, seed_rate = Cfg.market_seed(from_kind, to_kind)
      model.from_amount.should == seed_amount
      model.to_rate.should == seed_rate
    end

    it "should lookup and return record if it exists" do
      MarketRate.get(model.galaxy_id, model.from_kind, model.to_kind).
        should == model
    end

    it "should fail if from_kind == to_kind" do
      lambda do
        MarketRate.get(galaxy.id, from_kind, from_kind)
      end.should raise_error(ArgumentError)
    end
  end

  describe ".average" do
    it "should get record by .get" do
      MarketRate.should_receive(:get).with(galaxy.id, from_kind, to_kind).
        and_return(model)
      MarketRate.average(galaxy.id, from_kind, to_kind)
    end

    it "should return #to_rate" do
      MarketRate.average(model.galaxy_id, model.from_kind, model.to_kind).
        should == model.to_rate
    end
  end

  describe ".lowest" do
    let(:galaxy) { Factory.create(:galaxy) }
    let(:from_kind) { MarketOffer::KIND_METAL }
    let(:to_kind) { MarketOffer::KIND_CREDS }
    let(:avg_rate) { MarketRate.average(galaxy.id, from_kind, to_kind) }

    it "should filter by galaxy_id, from_kind and to_kind" do
      # Wrong galaxy
      Factory.create(:market_offer, :to_rate => avg_rate + 0.001,
        :from_kind => from_kind, :to_kind => to_kind)
      # Wrong from_kind
      Factory.create(:market_offer, :to_rate => avg_rate + 0.002,
        :galaxy => galaxy,
        :from_kind => MarketOffer::KIND_ENERGY, :to_kind => to_kind)
      # Wrong to_kind
      Factory.create(:market_offer, :to_rate => avg_rate + 0.003,
        :galaxy => galaxy,
        :from_kind => from_kind, :to_kind => MarketOffer::KIND_ENERGY)
      # Good record
      offer = Factory.create(:market_offer, :to_rate => avg_rate + 0.004,
        :galaxy => galaxy, :from_kind => from_kind, :to_kind => to_kind)
      MarketRate.lowest(galaxy.id, from_kind, to_kind).
        should be_within(SPEC_FLOAT_PRECISION).of(offer.to_rate)
    end

    it "should return lowest to_rate" do
      Factory.create(:market_offer, :to_rate => avg_rate + 0.1,
        :galaxy => galaxy, :from_kind => from_kind, :to_kind => to_kind)
      offer = Factory.create(:market_offer, :to_rate => avg_rate - 0.1,
        :galaxy => galaxy, :from_kind => from_kind, :to_kind => to_kind)
      MarketRate.lowest(galaxy.id, from_kind, to_kind).
        should be_within(SPEC_FLOAT_PRECISION).of(offer.to_rate)
    end

    it "should return nil if no offers are found" do
      MarketRate.lowest(galaxy.id, from_kind, to_kind).should be_nil
    end
  end

  describe ".add" do
    let(:added_amount) { 1231 }
    let(:added_rate) { 10 }

    it "should get record by .get and return it" do
      MarketRate.should_receive(:get).with(galaxy.id, from_kind, to_kind).
        and_return(model)
      MarketRate.add(galaxy.id, from_kind, to_kind, added_amount, added_rate).
        should == model
    end

    it "should increase #to_rate by average" do
      existing_weight = model.from_amount * model.to_rate
      added_weight = added_amount * added_rate
      new_avg = (existing_weight + added_weight) /
        (model.from_amount + added_amount)
      MarketRate.add(model.galaxy_id, model.from_kind, model.to_kind,
        added_amount, added_rate)
      model.reload
      model.to_rate.should be_within(0.001).of(new_avg)
    end

    it "should increase #from_amount" do
      lambda do
        MarketRate.add(model.galaxy_id, model.from_kind, model.to_kind,
          added_amount, added_rate)
        model.reload
      end.should change(model, :from_amount).by(added_amount)
    end

    it "should save record" do
      MarketRate.add(model.galaxy_id, model.from_kind, model.to_kind,
        added_amount, added_rate).should be_saved
    end
  end

  describe ".subtract" do
    let(:subtracted_amount) { model.from_amount / 2 }
    let(:cancellation_shift) { 5.0 }
    let(:cancellation_amount) { model.from_amount }
    let(:cancellation_total_amount) { model.from_amount * 3 }

    it "should get record by .get" do
      MarketRate.should_receive(:get).with(galaxy.id, from_kind, to_kind).
        and_return(model)
      MarketRate.subtract(galaxy.id, from_kind, to_kind, subtracted_amount,
        cancellation_shift, cancellation_amount, cancellation_total_amount).
        should == model
    end

    describe "#to_rate change" do
      let(:model) do
        Factory.create(:market_rate, :galaxy => galaxy, :from_kind => from_kind,
                       :to_kind => to_kind, :from_amount => 100_000,
                       :to_rate => 0.235)
      end

      before(:each) do
        @cancellation_amount = 2000
        @cancellation_total_amount = model.from_amount
        @old_rate = model.to_rate

        model = MarketRate.add(galaxy.id, from_kind, to_kind,
                               @cancellation_amount, 10)
        @cancellation_shift = (model.to_rate - @old_rate) * -1
      end

      describe "when total amount in market (without yours) keeps the same" do
        it "should not change when cancelling immediately" do
          MarketRate.subtract(
            galaxy.id, from_kind, to_kind, @cancellation_amount,
            @cancellation_shift, @cancellation_amount,
            @cancellation_total_amount
          ).to_rate.should be_within(SPEC_FLOAT_PRECISION).of(@old_rate)
        end

        it "should adjust rate if some part of your offer was bought" do
          amount_bought = 1340
          amount_left = @cancellation_amount - amount_bought
          MarketRate.subtract_amount(galaxy.id, from_kind, to_kind,
                                     amount_bought)

          model.reload
          model.to_rate.should be_within(SPEC_FLOAT_PRECISION).
            of(0.426470588235294)

          MarketRate.subtract(
            galaxy.id, from_kind, to_kind, amount_left,
            @cancellation_shift, @cancellation_amount,
            @cancellation_total_amount
          ).to_rate.should be_within(SPEC_FLOAT_PRECISION).
            #  model.to_rate + (
            #    @cancellation_shift * amount_left / @cancellation_amount
            #  )
            of(0.363285294117647)
        end
      end

      describe "when total amount in market increases" do
        before(:each) do
          MarketRate.add(galaxy.id, from_kind, to_kind, 5000, 8)
        end

        it "should adjust rate if nothing was bought from you" do
          model.reload
          model.to_rate.should be_within(SPEC_FLOAT_PRECISION).
            of(0.780373831775701)

          MarketRate.subtract(
            galaxy.id, from_kind, to_kind, @cancellation_amount,
            @cancellation_shift, @cancellation_amount,
            @cancellation_total_amount
          ).to_rate.should be_within(SPEC_FLOAT_PRECISION).
            of(0.59802089059923)
            # model.to_rate + (
            #   @cancellation_shift * @cancellation_total_amount /
            #     (model.from_amount - @cancellation_amount)
            # )
        end

        it "should adjust rate if some part of your offer was bought" do
          amount_bought = 894
          amount_left = @cancellation_amount - amount_bought
          MarketRate.subtract_amount(galaxy.id, from_kind, to_kind,
                                     amount_bought)

          model.reload
          model.to_rate.should be_within(SPEC_FLOAT_PRECISION).
            of(0.780373831775701)

          MarketRate.subtract(
            galaxy.id, from_kind, to_kind, amount_left,
            @cancellation_shift, @cancellation_amount,
            @cancellation_total_amount
          ).to_rate.should be_within(SPEC_FLOAT_PRECISION).of(0.679532655305113)
            # model.to_rate + (
            #   @cancellation_shift *
            #     amount_left / @cancellation_amount *
            #     @cancellation_total_amount / (model.from_amount - amount_left)
            # )
        end
      end

      describe "when total amount in market decreases" do
        before(:each) do
          MarketRate.subtract_amount(galaxy.id, from_kind, to_kind, 5000)
        end

        it "should adjust rate if nothing was bought from you" do
          model.reload
          model.to_rate.should be_within(SPEC_FLOAT_PRECISION).
            of(0.426470588235294)

          MarketRate.subtract(
            galaxy.id, from_kind, to_kind, @cancellation_amount,
            @cancellation_shift, @cancellation_amount,
            @cancellation_total_amount
          ).to_rate.should be_within(SPEC_FLOAT_PRECISION).
            of(0.224922600619195)
            # model.to_rate + (
            #   @cancellation_shift * @cancellation_total_amount /
            #     (model.from_amount - @cancellation_amount)
            # )
        end

        it "should adjust rate if some part of your offer was bought" do
          amount_bought = 894
          amount_left = @cancellation_amount - amount_bought
          MarketRate.subtract_amount(galaxy.id, from_kind, to_kind,
                                     amount_bought)

          model.reload
          model.to_rate.should be_within(SPEC_FLOAT_PRECISION).
            of(0.426470588235294)

          MarketRate.subtract(
            galaxy.id, from_kind, to_kind, amount_left,
            @cancellation_shift, @cancellation_amount,
            @cancellation_total_amount
          ).to_rate.should be_within(SPEC_FLOAT_PRECISION).of(0.315014551083591)
            # model.to_rate + (
            #   @cancellation_shift *
            #     amount_left / @cancellation_amount *
            #     @cancellation_total_amount / (model.from_amount - amount_left)
            # )
        end
      end
    end

    it "should decrease #from_amount" do
      lambda do
        MarketRate.subtract(
          model.galaxy_id, model.from_kind, model.to_kind, subtracted_amount,
          cancellation_shift, cancellation_amount, cancellation_total_amount
        )
        model.reload
      end.should change(model, :from_amount).by(- subtracted_amount)
    end

    it "should raise ArgumentError if subtracting more than we have" do
      lambda do
        MarketRate.subtract(
          model.galaxy_id, model.from_kind, model.to_kind,
          model.from_amount + 1, cancellation_shift, cancellation_amount,
          cancellation_total_amount
        )
      end.should raise_error(ArgumentError)
    end

    it "should save record" do
      MarketRate.subtract(
        model.galaxy_id, model.from_kind, model.to_kind,
        model.from_amount, cancellation_shift, cancellation_amount,
        cancellation_total_amount
      ).should be_saved
    end
  end

  describe ".subtract_amount" do
    let(:subtracted_amount) { model.from_amount / 2 }

    it "should get record by .get" do
      MarketRate.should_receive(:get).with(galaxy.id, from_kind, to_kind).
        and_return(model)
      MarketRate.subtract_amount(galaxy.id, from_kind, to_kind, subtracted_amount).
        should == model
    end

    it "should not change #to_rate" do
      lambda do
        MarketRate.subtract_amount(model.galaxy_id, model.from_kind, model.to_kind,
          subtracted_amount)
        model.reload
      end.should_not change(model, :to_rate)
    end

    it "should decrease #from_amount" do
      lambda do
        MarketRate.subtract_amount(model.galaxy_id, model.from_kind, model.to_kind,
          subtracted_amount)
        model.reload
      end.should change(model, :from_amount).by(- subtracted_amount)
    end

    it "should raise ArgumentError if subtracting more than we have" do
      lambda do
        MarketRate.subtract_amount(model.galaxy_id, model.from_kind, model.to_kind,
          model.from_amount + 1)
      end.should raise_error(ArgumentError)
    end

    it "should save record" do
      MarketRate.subtract_amount(model.galaxy_id, model.from_kind, model.to_kind,
        subtracted_amount).should be_saved
    end
  end
  
  describe ".adjust_rates" do
    shared_examples_for "stopping on existing offers" do |from_kind, to_kind|
      it "should not change #to_rate if market offers exist" do
        # Avoid modifying avg. rate.
        MarketRate.should_receive(:add).once.and_return(rate)
        Factory.create(
          :market_offer, galaxy: galaxy, from_kind: from_kind, to_kind: to_kind
        )
        lambda do
          MarketRate.adjust_rates!(galaxy.id)
          rate.reload
        end.should_not change(rate, :to_rate)
      end
    end

    MarketOffer::KINDS.each do |from_kind|
      MarketOffer::KINDS.each do |to_kind|
        next if from_kind == to_kind

        describe "#{from_kind} -> #{to_kind}" do
          let(:seed_rate) do
            seed_amount, seed_rate = Cfg.market_seed(from_kind, to_kind)
            seed_rate
          end

          describe "if avg. rate < seed rate" do
            let(:rate) do
              Factory.create(
                :market_rate, galaxy: galaxy, to_rate: seed_rate / 10,
                from_kind: from_kind, to_kind: to_kind
              )
            end

            it_should_behave_like "stopping on existing offers",
              from_kind, to_kind

            it "should increase avg. rate by diff percentage" do
              diff = (seed_rate - rate.to_rate) * Cfg.market_adjuster_percentage
              lambda do
                MarketRate.adjust_rates!(galaxy.id)
                rate.reload
              end.should change(rate, :to_rate).by(diff)
            end
          end

          describe "if avg. rate > seed rate" do
            let(:rate) do
              Factory.create(
                :market_rate, galaxy: galaxy, to_rate: seed_rate * 10,
                from_kind: from_kind, to_kind: to_kind
              )
            end

            it_should_behave_like "stopping on existing offers",
              from_kind, to_kind

            it "should decrease avg. rate by diff percentage" do
              diff = (rate.to_rate - seed_rate) * Cfg.market_adjuster_percentage
              lambda do
                MarketRate.adjust_rates!(galaxy.id)
                rate.reload
              end.should change(rate, :to_rate).by(-diff)
            end
          end

          describe "if avg. rate == seed_rate" do
            let(:rate) do
              Factory.create(
                :market_rate, galaxy: galaxy, to_rate: seed_rate,
                from_kind: from_kind, to_kind: to_kind
              )
            end

            it "should not change #to_rate" do
              lambda do
                MarketRate.adjust_rates!(galaxy.id)
                rate.reload
              end.should_not change(rate, :to_rate)
            end
          end
        end
      end
    end
  end
end