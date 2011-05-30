require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

class Building::RadarTraitMock < Building
  include Trait::Radar
end

Factory.define :b_radar_trait, :parent => :b_trait_mock,
  :class => Building::RadarTraitMock do |m|
end

describe Building::RadarTraitMock do
  describe ".increase_vision" do
    before(:each) do
      @zone = [0..10, 4..8]
      @player = Factory.create(:player)
    end

    it "should increase fow ss cache in zone" do
      FowSsEntry.should_receive(:increase_for_zone).with(@zone, @player,
        1, false)
      Trait::Radar.increase_vision(@zone, @player)
    end

    it "should increase fow galaxy cache in zone" do
      FowGalaxyEntry.should_receive(:increase).with(
        Trait::Radar.rectangle_from_zone(@zone),
        @player
      )
      Trait::Radar.increase_vision(@zone, @player)
    end
  end

  describe ".decrease_vision" do
    before(:each) do
      @zone = [0..10, 4..8]
      @player = Factory.create(:player)
    end

    it "should reduce fow ss cache" do
      FowSsEntry.should_receive(:decrease_for_zone).with(@zone, @player,
        1, false)
      Trait::Radar.decrease_vision(@zone, @player)
    end

    it "should reduce fow galaxy cache in zone" do
      FowGalaxyEntry.should_receive(:decrease).with(
        Trait::Radar.rectangle_from_zone(@zone),
        @player
      )
      Trait::Radar.decrease_vision(@zone, @player)
    end
  end

  describe "on activation" do
    it "should call #increase_vision if planet has player" do
      planet = Factory.create(:planet_with_player)
      building = Factory.create :b_radar_trait, opts_inactive + {
        :planet => planet
      }
      Trait::Radar.should_receive(:increase_vision).with(
        building.radar_zone,
        building.planet.player
      )
      building.activate!
    end

    it "should not call #increase_vision if does not have player" do
      planet = Factory.create(:planet)
      building = Factory.create :b_radar_trait, opts_inactive + {
        :planet => planet
      }
      Trait::Radar.should_not_receive(:increase_vision)
      building.activate!
    end
  end

  describe "on deactivation" do
    it "should call #decrease_vision if planet has player" do
      planet = Factory.create(:planet_with_player)
      building = Factory.create :b_radar_trait, opts_active + {
        :planet => planet
      }
      Trait::Radar.should_receive(:decrease_vision).with(
        building.radar_zone,
        building.planet.player
      )
      building.deactivate!
    end

    it "should not call #decrease_vision if does not have player" do
      planet = Factory.create(:planet)
      building = Factory.create :b_radar_trait, opts_active + {
        :planet => planet
      }
      Trait::Radar.should_not_receive(:decrease_vision)
      building.deactivate!
    end
  end
end