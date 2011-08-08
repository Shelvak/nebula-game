require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

class Building::PopulationManagerPartTest < Building
  include Parts::PopulationManager
end

Factory.define :b_population_manager_test, :parent => :b_trait_mock,
:class => Building::PopulationManagerPartTest do |m|; end

describe Building::PopulationManagerPartTest do
  describe ".manages_population?" do
    it "should return false if building does not manage population" do
      with_config_values(
        'buildings.population_manager_part_test.population' => nil
      ) do
        Building::PopulationManagerPartTest.manages_population?.should be_false
      end
    end

    it "should return true" do
      Building::PopulationManagerPartTest.manages_population?.should be_true
    end
  end

  describe "building" do
    before(:each) do
      @player = Factory.create(:player)
      @planet = Factory.create(:planet, :player => @player)
      @building = Factory.create(:b_population_manager_test,
        :planet => @planet, :level => 2)
    end

    describe "#on_activation" do
      before(:each) do
        opts_inactive.apply(@building)
      end
      
      it "should increase max population" do
        lambda do
          @building.activate!
          @player.reload
        end.should change(@player, :population_cap).by(@building.population)
      end
      
      it "should not fail if player is nil" do
        @planet.player = nil
        @planet.save!
        
        lambda { @building.activate! }.should_not raise_error
      end
    end

    describe "#on_deactivate" do
      before(:each) do
        opts_active.apply(@building)
      end
      
      it "should reduce max population" do
        lambda do
          @building.deactivate!
          @player.reload
        end.should change(@player, :population_cap).
          by(- @building.population)
      end
      
      it "should not fail if player is nil" do
        @planet.player = nil
        @planet.save!
        
        lambda { @building.deactivate! }.should_not raise_error
      end
    end
  end
end