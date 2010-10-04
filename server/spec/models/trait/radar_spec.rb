require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

class Building::RadarTraitMock < Building
  include Trait::Radar
end

Factory.define :b_radar_trait, :parent => :b_trait_mock,
  :class => Building::RadarTraitMock do |m|
end

describe Building::RadarTraitMock do
  describe "on activation" do
    it "should increase fow ss cache in zone" do
      building = Factory.create :b_radar_trait, opts_inactive
      FowSsEntry.should_receive(:increase_for_zone).with(
        building.radar_zone,
        building.planet.player,
        1,
        false
      )
      building.activate!
    end

    it "should increase fow galaxy cache in zone" do
      building = Factory.create :b_radar_trait, opts_inactive
      FowGalaxyEntry.should_receive(:increase).with(
        Trait::Radar.rectangle_from_zone(building.radar_zone),
        building.planet.player
      )
      building.activate!
    end
  end

  describe "on deactivation" do
    it "should reduce fow ss cache" do
      building = Factory.create :b_radar_trait, opts_active
      FowSsEntry.should_receive(:decrease_for_zone).with(
        building.radar_zone,
        building.planet.player,
        1,
        false
      )
      building.deactivate!
    end

    it "should reduce fow galaxy cache in zone" do
      building = Factory.create :b_radar_trait, opts_active
      FowGalaxyEntry.should_receive(:decrease).with(
        Trait::Radar.rectangle_from_zone(building.radar_zone),
        building.planet.player
      )
      building.deactivate!
    end
  end
end