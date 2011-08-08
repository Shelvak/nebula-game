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
        :planet => @planet)
    end

    describe "#on_upgrade_finished" do
      it "should increase max population" do
        opts_upgrading.apply(@building)
        @building.level = 2
        lambda do
          @building.send(:on_upgrade_finished)
          @player.reload
        end.should change(@player, :population_max).by(
          @building.population(2) - @building.population(1))
      end
      
      it "should not fail if player is nil" do
        @planet.player = nil
        @planet.save!
        opts_upgrading.apply(@building)
        @building.level = 2
        lambda do
          @building.send(:on_upgrade_finished)
        end.should_not raise_error
      end
    end

    describe "#on_destroy" do
      it "should reduce max population" do
        @building.level = 2
        lambda do
          @building.destroy
          @player.reload
        end.should change(@player, :population_max).by(
          - @building.population(2))
      end
      
      it "should not fail if player is nil" do
        @planet.player = nil
        @planet.save!
        
        @building.level = 2
        lambda { @building.destroy }.should_not raise_error
      end
    end
  end
end