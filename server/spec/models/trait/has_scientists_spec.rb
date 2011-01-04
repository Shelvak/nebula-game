require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

class Building::HasScientistsTraitMock < Building
  include Trait::HasScientists
end

Factory.define :b_has_scientists_trait_mock, :parent => :b_trait_mock,
:class => Building::HasScientistsTraitMock do |m|; end

describe Building::HasScientistsTraitMock do
  describe "#scientists" do
    it "should round scientist count" do
      with_config_values(
        'buildings.has_scientists_trait_mock.scientists' => '4.3'
      ) do
        Factory.create(:b_has_scientists_trait_mock).scientists.should == 4
      end
    end
  end

  describe "#activate!" do
    before(:each) do
      @rc = Factory.create :b_has_scientists_trait_mock, opts_inactive
      @player = @rc.planet.player
    end

    it "should call player.change_scientist_count!" do
      @rc.stub_chain(:planet, :player).and_return(@player)
      @player.should_receive(:change_scientist_count!).with(@rc.scientists)
      @rc.activate!
    end
  end

  describe "#deactivate!" do
    before(:each) do
      @rc = Factory.create :b_has_scientists_trait_mock, opts_active
      @player = @rc.planet.player
    end

    it "should call player.chance_scientist_count!" do
      @rc.stub_chain(:planet, :player).and_return(@player)
      @player.should_receive(:change_scientist_count!).with(-@rc.scientists)
      @rc.deactivate!
    end
  end
end