require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

class Building::ResourceManagerPartTest < Building
end

Factory.define :b_resource_manager_test, :parent => :b_trait_mock,
:class => Building::ResourceManagerPartTest do |m|; end

describe Building::ResourceManagerPartTest do
  %w{metal energy zetium}.each do |resource|
    it "should add storage diff for #{resource} on #on_upgrade_finished" do
      model = Factory.create :b_resource_manager_test, :level => 4
      resources_entry = model.planet.resources_entry

      lambda {
        model.send(:on_upgrade_finished)
        resources_entry.reload
      }.should change(
        resources_entry, "#{resource}_storage"
      ).by(
        # Upgrading will raise level by 1
        model.send("#{resource}_storage", model.level + 1) -
          model.send("#{resource}_storage")
      )
    end

    it "should reduce storage for #{resource} on #on_destroy" do
      model = Factory.create :b_resource_manager_test, :level => 4
      resources_entry = model.planet.resources_entry

      lambda {
        model.send(:on_destroy)
        resources_entry.reload
      }.should change(
        resources_entry, "#{resource}_storage"
      ).by(
        - model.send("#{resource}_storage")
      )
    end

    {
      'activate!' => [opts_inactive, 1],
      'deactivate!' => [opts_active, -1]
    }.each do |method, data|
      opts, modifier = data
      
      it "should add rate * #{modifier} in resources rate entry " +
      "on ##{method}" do
        model = Factory.create(:b_resource_manager_test,
          opts + {:level => 4})
        resources_entry = model.planet.resources_entry

        lambda {
          model.send(method)
          resources_entry.reload
        }.should change(
          resources_entry, "#{resource}_rate"
        ).by(model.send("#{resource}_rate") * modifier)
      end
    end
  end

  it "should respect energy mod" do
    mod = 12

    # build because create recalculates mods by tiles
    model_with_mod = Factory.build :b_resource_manager_test,
      opts_inactive + {:level => 4, :energy_mod => mod }

    model_without_mod = Factory.build :b_resource_manager_test,
      opts_inactive + {:level => 4, :energy_mod => 0 }

    model_with_mod.energy_generation_rate.should == \
      (
        model_without_mod.energy_generation_rate * (100.0 + mod) / 100
      )
  end

  before(:all) do
    @model = Factory.create :b_resource_manager_test
  end

  %w{metal energy zetium}.each do |resource|
    %w{generation usage}.each do |type|
      it "should have ##{resource}_#{type}_rate" do
        @model.should respond_to("#{resource}_#{type}_rate")
      end
    end

    it "should have ##{resource}_storage" do
      @model.should respond_to("#{resource}_storage")
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