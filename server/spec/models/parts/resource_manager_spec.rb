require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

class Building::ResourceManagerPartTest < Building
end

Factory.define :b_resource_manager_test, :parent => :b_trait_mock,
:class => Building::ResourceManagerPartTest do |m|; end

describe Building::ResourceManagerPartTest do
  %w{metal energy zetium}.each do |resource|
    it "should add storage diff for #{resource} on #on_upgrade_finished" do
      model = Factory.create :b_resource_manager_test, opts_upgrading + {
        :level => 4}
      planet = model.planet

      lambda {
        model.send(:on_upgrade_finished)
        planet.reload
      }.should change(
        planet, "#{resource}_storage"
      ).by(
        # Upgrading will raise level by 1
        model.send("#{resource}_storage", model.level + 1) -
          model.send("#{resource}_storage")
      )
    end

    it "should reduce storage for #{resource} on #on_destroy" do
      model = Factory.create :b_resource_manager_test, :level => 4
      planet = model.planet

      lambda {
        model.destroy
        planet.reload
      }.should change(
        planet, "#{resource}_storage"
      ).by(
        - model.send("#{resource}_storage")
      )
    end

    {
      'activate!' => [opts_inactive, 1],
      'deactivate!' => [opts_active, -1]
    }.each do |method, data|
      opts, modifier = data
      
      %w{generation usage}.each do |kind|
        it "should add #{kind}_rate * #{modifier} in resources rate entry " +
        "on ##{method}" do
          res = "#{resource}_#{kind}_rate"
          
          planet = Factory.create(:planet, res => 10000)
          model = Factory.create(:b_resource_manager_test,
            opts + {:level => 4, :planet => planet})

          lambda {
            model.send(method)
            planet.reload
          }.should change(planet, res).by(model.send(res) * modifier)
        end
      end
    end
  end

  it "should respect energy mod" do
    mod = 12

    # build because create recalculates mods by tiles
    model = Factory.build :b_resource_manager_test,
      opts_inactive + {:level => 4, :energy_mod => mod }

    model.energy_rate.should == \
      (
        model.class.energy_generation_rate(model.level) * (100.0 + mod)/ 100
      ).to_f.round(ROUNDING_PRECISION) - model.class.energy_usage_rate(
        model.level)
  end

  it "should not crash if energy mod is nil" do
    model = Factory.build :b_resource_manager_test,
      opts_inactive + {:level => 4, :energy_mod => nil }
    model.energy_rate
  end

  before(:all) do
    @model = Factory.create :b_resource_manager_test
  end

  %w{metal energy zetium}.each do |resource|
    [
      ["generation", "generate"],
      ["usage", "use"]
    ].each do |type, cfg_type|
      it "should round ##{resource}_#{type}_rate" do
        key = "buildings.resource_manager_part_test.#{resource}.#{cfg_type}"
        rate = 0.3336233463
        with_config_values key => rate do
          @model.send("#{resource}_#{type}_rate").should == rate.round(
            ROUNDING_PRECISION)
        end
      end
    end

    it "should round ##{resource}_storage" do
      key = "buildings.resource_manager_part_test.#{resource}.store"
      storage = 333.6233463
      with_config_values key => storage do
        @model.send("#{resource}_storage").should == storage.round(
          ROUNDING_PRECISION)
      end
    end

    it "should have ##{resource}_rate" do
      @model.should respond_to("#{resource}_rate")
    end
  end

  describe "resource accessors" do
    it "should return value if it's defined" do
      @model.metal_generation_rate.should == @model.send(
        :evalproperty, 'metal.generate')
    end

    it "should return 0 if it's not defined" do
      with_config_values "#{@model.class.config_name}.metal.use" => nil do
        @model.metal_usage_rate.should == 0
      end
    end
  end
end