require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

class Building::OverdriveableTraitMock < Building
  include Trait::Overdriveable
end

Factory.define :b_overdriveable_trait, :parent => :b_trait_mock,
:class => Building::OverdriveableTraitMock do |m|
  opts_active.apply m
end

describe Building::OverdriveableTraitMock do
  describe "#activate_overdrive!" do
    it "should raise error if already overdriven" do
      model = Factory.create(:b_overdriveable_trait, :overdriven => true)
      lambda do
        model.activate_overdrive!
      end.should raise_error(GameLogicError)
    end

    it "should deactivate, set attribute and activate" do
      model = Factory.create(:b_overdriveable_trait, :overdriven => false)
      model.should_receive(:deactivate!).ordered.and_return do
        model.should_not be_overdriven
        true
      end
      model.should_receive(:activate!).ordered.and_return do
        model.should be_overdriven
        true
      end
      model.activate_overdrive!
    end
  end

  describe "#deactivate_overdrive!" do
    it "should raise error unless overdriven" do
      model = Factory.create(:b_overdriveable_trait, :overdriven => false)
      lambda do
        model.deactivate_overdrive!
      end.should raise_error(GameLogicError)
    end

    it "should deactivate, set attribute and activate" do
      model = Factory.create(:b_overdriveable_trait, :overdriven => true)
      model.should_receive(:deactivate!).ordered.and_return do
        model.should be_overdriven
        true
      end
      model.should_receive(:activate!).ordered.and_return do
        model.should_not be_overdriven
        true
      end
      model.deactivate_overdrive!
    end
  end
end