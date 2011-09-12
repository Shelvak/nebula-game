require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe MarketRate do
  let(:galaxy) { Factory.create(:galaxy) }
  let(:from_kind) { MarketOffer::KIND_METAL }
  let(:to_kind) { MarketOffer::KIND_ENERGY }
  let(:model) { Factory.create(:market_rate) }

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

    it "should get record by .get" do
      MarketRate.should_receive(:get).with(galaxy.id, from_kind, to_kind).
        and_return(model)
      MarketRate.subtract(galaxy.id, from_kind, to_kind, subtracted_amount).
        should == model
    end

    it "should not change #to_rate" do
      lambda do
        MarketRate.subtract(model.galaxy_id, model.from_kind, model.to_kind,
          subtracted_amount)
        model.reload
      end.should_not change(model, :to_rate)
    end

    it "should decrease #from_amount" do
      lambda do
        MarketRate.subtract(model.galaxy_id, model.from_kind, model.to_kind,
          subtracted_amount)
        model.reload
      end.should change(model, :from_amount).by(- subtracted_amount)
    end

    it "should raise ArgumentError if subtracting more than we have" do
      lambda do
        MarketRate.subtract(model.galaxy_id, model.from_kind, model.to_kind,
          model.from_amount + 1)
      end.should raise_error(ArgumentError)
    end

    it "should save record" do
      MarketRate.subtract(model.galaxy_id, model.from_kind, model.to_kind,
        subtracted_amount).should be_saved
    end
  end
end