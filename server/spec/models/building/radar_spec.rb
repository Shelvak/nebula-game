require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

describe Building::Radar do
  describe "#activate" do
    it "should activate if in normal solar system" do
      radar = Factory.build!(:b_radar, opts_inactive)
      lambda do
        radar.activate
      end.should change(radar, :state).to(Building::STATE_ACTIVE)
    end

    it "should not activate if in detached solar system" do
      solar_system = Factory.build(:ss_detached)
      planet = Factory.build(:planet, :solar_system => solar_system)
      radar = Factory.build!(:b_radar, opts_inactive + {:planet => planet})
      lambda do
        radar.activate
      end.should_not change(radar, :state).to(Building::STATE_ACTIVE)
    end
  end
end