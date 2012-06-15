require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe SolarSystemMetadata do
  it "should be object" do
    SolarSystemMetadata.should include(Parts::Object)
  end

  describe ".new" do
    let(:solar_system_id) { 15213 }
    let(:x) { 13 }
    let(:y) { -6 }
    let(:kind) { SolarSystem::KIND_BATTLEGROUND }
    let(:player) { Factory.create(:player).as_json(mode: :minimal) }

    it "should create metadata for new SolarSystem" do
      metadata = {
        id: solar_system_id, x: x, y: y, kind: kind, player: player,
        player_planets: true, player_ships: false,
        enemies_with_planets: [:enemies_with_planets],
        enemies_with_ships: [:enemies_with_ships],
        allies_with_planets: [:allies_with_planets],
        allies_with_ships: [:allies_with_ships],
        naps_with_planets: [:naps_with_planets],
        naps_with_ships: [:naps_with_ships]
      }
      SolarSystemMetadata.new(metadata).as_json.should == metadata
    end
  end

  describe ".existing" do
    let(:solar_system_id) { 15213 }

    it "should create metadata for existing SolarSystem" do
      metadata = {
        player_planets: true, player_ships: false,
        enemies_with_planets: [:enemies_with_planets],
        enemies_with_ships: [:enemies_with_ships],
        allies_with_planets: [:allies_with_planets],
        allies_with_ships: [:allies_with_ships],
        naps_with_planets: [:naps_with_planets],
        naps_with_ships: [:naps_with_ships]
      }
      SolarSystemMetadata.existing(solar_system_id, metadata).as_json.
        should == {id: solar_system_id, x: nil, y: nil, kind: nil, player: nil}.
          merge(metadata)
    end
  end

  describe ".destroyed" do
    let(:solar_system_id) { 15213 }

    it "should create metadata for destroyed SolarSystem" do
      metadata = {
        player_planets: true, player_ships: false,
        enemies_with_planets: [:enemies_with_planets],
        enemies_with_ships: [:enemies_with_ships],
        allies_with_planets: [:allies_with_planets],
        allies_with_ships: [:allies_with_ships],
        naps_with_planets: [:naps_with_planets],
        naps_with_ships: [:naps_with_ships]
      }
      SolarSystemMetadata.destroyed(solar_system_id).as_json.should == {
        id: solar_system_id, x: nil, y: nil, kind: nil, player: nil,
        player_planets: false, player_ships: false,
        enemies_with_planets: [], enemies_with_ships: [],
        allies_with_planets: [], allies_with_ships: [],
        naps_with_planets: [], naps_with_ships: []
      }
    end
  end
end