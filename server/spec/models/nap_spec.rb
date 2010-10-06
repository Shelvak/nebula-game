require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Nap do
  it "should not allow creating two naps for same alliances" do
    nap = Factory.create :nap
    lambda do
      Factory.create :nap, :initiator => nap.initiator,
        :acceptor => nap.acceptor
    end.should raise_error(ActiveRecord::RecordInvalid)
  end

  describe ".alliance_ids_for" do
    it "should return an array of ids filtered by status" do
      nap1 = Factory.create(:nap, :status => Nap::STATUS_ESTABLISHED)
      nap2 = Factory.create(:nap, :initiator => nap1.initiator,
        :status => Nap::STATUS_ESTABLISHED)
      nap3 = Factory.create(:nap, :acceptor => nap1.initiator,
        :status => Nap::STATUS_PROPOSED)
      nap4 = Factory.create(:nap, :acceptor => nap1.initiator,
        :status => Nap::STATUS_ESTABLISHED)
      
      Nap.alliance_ids_for(
        nap1.initiator_id, Nap::STATUS_ESTABLISHED
      ).sort.should == [
        nap1.acceptor_id, nap2.acceptor_id, nap4.initiator_id
      ].sort
    end

    it "should return empty array if no naps exist" do
      Nap.alliance_ids_for(0, Nap::STATUS_ESTABLISHED).should == []
    end
  end

  describe ".get_rules" do
    it "should return a hash of nap rules filtered by status" do
      alliance1 = Factory.create :alliance
      alliance2 = Factory.create :alliance
      alliance3 = Factory.create :alliance
      alliance4 = Factory.create :alliance

      Factory.create(:nap,
        :initiator => alliance1,
        :acceptor => alliance2,
        :status => Nap::STATUS_ESTABLISHED)
      Factory.create(:nap,
        :initiator => alliance3,
        :acceptor => alliance1,
        :status => Nap::STATUS_PROPOSED)
      Factory.create(:nap,
        :initiator => alliance3,
        :acceptor => alliance4,
        :status => Nap::STATUS_ESTABLISHED)
      Factory.create(:nap,
        :initiator => alliance1,
        :acceptor => alliance4,
        :status => Nap::STATUS_ESTABLISHED)

      result = Nap.get_rules(
        [alliance1.id, alliance2.id, alliance3.id, alliance4.id],
        Nap::STATUS_ESTABLISHED
      )
      result[alliance1.id].sort.should == [alliance2.id, alliance4.id].sort
      result[alliance2.id].sort.should == [alliance1.id]
      result[alliance3.id].sort.should == [alliance4.id]
      result[alliance4.id].sort.should == [alliance1.id, alliance3.id].sort
    end
  end

  describe "on creation" do
    it "should notify acceptor"
  end

  describe "cancelling" do
    before(:each) do
      @model = Factory.create :nap
    end

    it "should change status" do
      lambda do
        @model.cancel
      end.should change(@model, :status).to(Nap::STATUS_CANCELED)
    end

    it "should set expires_at" do
      @model.cancel
      @model.expires_at.to_s(:db).should == CONFIG.evalproperty(
        'alliances.naps.cancellation_time'
      ).since.to_s(:db)
    end

    it "should create notification"

    it "should register in callback manager" do
      @model.cancel
      @model.should have_callback(CallbackManager::EVENT_DESTROY,
        @model.expires_at)
    end
  end

  describe ".on_callback" do
    describe "cancellation" do
      it "should destroy nap"
    end

    describe "other" do
      it "should raise ArgumentError"
    end
  end

  describe "destruction" do
    it "should create notification"
    it "should recalculate SS metadata"
    it "should engage battles in space"
    it "should engage battles in planets"
  end
end