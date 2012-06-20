require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe SolarSystem::Metadatas do
  let(:alliance) { create_alliance }
  let(:galaxy) { alliance.galaxy }
  let(:solar_system) { Factory.create(:solar_system, galaxy: galaxy) }
  let(:metadatas) { SolarSystem::Metadatas.new(solar_system.id) }
  let(:player) { alliance.owner }
  let(:ally1) { Factory.create(:player, alliance: alliance) }
  let(:ally2) { Factory.create(:player, alliance: alliance) }
  let(:location) { SolarSystemPoint.new(solar_system.id, 0, 0) }

  describe "#player_planets?" do
    it "should return true if player has planets" do
      Factory.create(:planet, solar_system: solar_system, player: player)
      metadatas.player_planets?(solar_system.id, player.id).should be_true
    end

    it "should return false if player does not have planets" do
      Factory.create(:planet, solar_system: solar_system)
      metadatas.player_planets?(solar_system.id, player.id).should be_false
    end

    it "should raise error if requesting bad ss id" do
      lambda do
        metadatas.player_planets?(solar_system.id + 1, player.id)
      end.should raise_error(ArgumentError)
    end
  end

  describe "#player_ships?" do
    it "should return true if player has ships" do
      Factory.create(:u_crow, location: location, player: player)
      metadatas.player_ships?(solar_system.id, player.id).should be_true
    end

    it "should return false if player does not have ships" do
      Factory.create(:u_crow, location: location)
      metadatas.player_ships?(solar_system.id, player.id).should be_false
    end

    it "should raise error if requesting bad ss id" do
      lambda do
        metadatas.player_ships?(solar_system.id + 1, player.id)
      end.should raise_error(ArgumentError)
    end
  end

  describe "#enemies_with_planets" do
    it "should return array of Player#minimal with enemies" do
      p1 = Factory.create(:planet_with_player, solar_system: solar_system)
      p2 = Factory.create(:planet_with_player, solar_system: solar_system,
        position: 1)
      metadatas.enemies_with_planets(solar_system.id, player.friendly_ids).
        should == [
          p1.player.as_json(mode: :minimal),
          p2.player.as_json(mode: :minimal),
        ]
    end

    it "should return empty array if there are no enemies" do
      Factory.create(:planet, solar_system: solar_system, player: player)
      metadatas.enemies_with_planets(solar_system.id, player.friendly_ids).
        should == []
    end

    it "should raise error if requesting bad ss id" do
      lambda do
        metadatas.enemies_with_planets(solar_system.id + 1, player.friendly_ids)
      end.should raise_error(ArgumentError)
    end
  end

  describe "#enemies_with_ships" do
    it "should return array of Player#minimal with enemies" do
      u1 = Factory.create(:u_crow, location: location)
      u2 = Factory.create(:u_crow, location: location)
      metadatas.enemies_with_ships(solar_system.id, player.friendly_ids).
        should == [
          u1.player.as_json(mode: :minimal),
          u2.player.as_json(mode: :minimal),
        ]
    end

    it "should return empty array if there are no enemies" do
      Factory.create(:u_crow, location: location, player: player)
      metadatas.enemies_with_ships(solar_system.id, player.friendly_ids).
        should == []
    end

    it "should raise error if requesting bad ss id" do
      lambda do
        metadatas.enemies_with_ships(solar_system.id + 1, player.friendly_ids)
      end.should raise_error(ArgumentError)
    end
  end

  describe "#allies_with_planets" do
    it "should return array of Player#minimal with allies" do
      p1 = Factory.create(:planet, solar_system: solar_system, player: ally1)
      p2 = Factory.create(:planet, solar_system: solar_system, player: ally2,
        position: 1)
      metadatas.allies_with_planets(solar_system.id, player.alliance_ids).
        should == [
          p1.player.as_json(mode: :minimal),
          p2.player.as_json(mode: :minimal),
        ]
    end

    it "should return empty array if there are no allies" do
      Factory.create(:planet, solar_system: solar_system, player: player)
      metadatas.allies_with_planets(solar_system.id, player.alliance_ids).
        should == []
    end

    it "should raise error if requesting bad ss id" do
      lambda do
        metadatas.allies_with_planets(solar_system.id + 1, player.alliance_ids)
      end.should raise_error(ArgumentError)
    end
  end

  describe "#allies_with_ships" do
    it "should return array of Player#minimal with allies" do
      u1 = Factory.create(:u_crow, location: location, player: ally1)
      u2 = Factory.create(:u_crow, location: location, player: ally2)
      metadatas.allies_with_ships(solar_system.id, player.alliance_ids).
        should == [
          u1.player.as_json(mode: :minimal),
          u2.player.as_json(mode: :minimal),
        ]
    end

    it "should return empty array if there are no allies" do
      Factory.create(:u_crow, location: location, player: player)
      metadatas.allies_with_ships(solar_system.id, player.alliance_ids).
        should == []
    end

    it "should raise error if requesting bad ss id" do
      lambda do
        metadatas.allies_with_ships(solar_system.id + 1, player.alliance_ids)
      end.should raise_error(ArgumentError)
    end
  end

  describe "metadata methods" do
    let(:player_planets) { true }
    let(:player_ships) { true }
    let(:enemies_with_planets) do
      [Factory.create(:player).as_json(mode: :minimal)]
    end
    let(:enemies_with_ships) do
      [Factory.create(:player).as_json(mode: :minimal)]
    end
    let(:allies_with_planets) do
      [ally1, ally2].map { |p| p.as_json(mode: :minimal) }
    end
    let(:allies_with_ships) do
      [ally2].map { |p| p.as_json(mode: :minimal) }
    end

    def setup_expectations
      metadatas.should_receive(:player_planets?).
        with(solar_system.id, player.id).and_return(player_planets)
      metadatas.should_receive(:player_ships?).
        with(solar_system.id, player.id).and_return(player_ships)
      metadatas.should_receive(:enemies_with_planets).
        with(solar_system.id, player.friendly_ids).
        and_return(enemies_with_planets)
      metadatas.should_receive(:enemies_with_ships).
        with(solar_system.id, player.friendly_ids).
        and_return(enemies_with_ships)
      metadatas.should_receive(:allies_with_planets).
        with(solar_system.id, player.alliance_ids).
        and_return(allies_with_planets)
      metadatas.should_receive(:allies_with_ships).
        with(solar_system.id, player.alliance_ids).
        and_return(allies_with_ships)
    end

    describe "#for_created" do
      it "should return metadata for created solar system with player" do
        setup_expectations
        player_minimal = Factory.create(:player).as_json(mode: :minimal)

        metadatas.for_created(
          solar_system.id, player.id, player.friendly_ids, player.alliance_ids,
          solar_system.x, solar_system.y, solar_system.kind, player_minimal
        ).should == SolarSystemMetadata.new(
          id: solar_system.id, x: solar_system.x, y: solar_system.y,
          kind: solar_system.kind, player: player_minimal,
          player_planets: player_planets, player_ships: player_ships,
          enemies_with_planets: enemies_with_planets,
          enemies_with_ships: enemies_with_ships,
          allies_with_planets: allies_with_planets,
          allies_with_ships: allies_with_ships,
          # TODO: nap support
          naps_with_planets: [],
          naps_with_ships: []
        )
      end

      it "should return metadata for created solar system without player" do
        setup_expectations
        metadatas.for_created(
          solar_system.id, player.id, player.friendly_ids, player.alliance_ids,
          solar_system.x, solar_system.y, solar_system.kind, nil
        ).should == SolarSystemMetadata.new(
          id: solar_system.id, x: solar_system.x, y: solar_system.y,
          kind: solar_system.kind, player: nil,
          player_planets: player_planets, player_ships: player_ships,
          enemies_with_planets: enemies_with_planets,
          enemies_with_ships: enemies_with_ships,
          allies_with_planets: allies_with_planets,
          allies_with_ships: allies_with_ships,
          # TODO: nap support
          naps_with_planets: [],
          naps_with_ships: []
        )
      end
    end

    describe "#for_existing" do
      it "should return SolarSystemMetadata" do
        setup_expectations
        metadatas.for_existing(
          solar_system.id, player.id, player.friendly_ids, player.alliance_ids
        ).should == SolarSystemMetadata.existing(
          solar_system.id,
          player_planets: player_planets,
          player_ships: player_ships,
          enemies_with_planets: enemies_with_planets,
          enemies_with_ships: enemies_with_ships,
          allies_with_planets: allies_with_planets,
          allies_with_ships: allies_with_ships,
          # TODO: nap support
          naps_with_planets: [],
          naps_with_ships: []
        )
      end
    end

    describe "#for_destroyed" do
      it "should return SolarSystemMetadata" do
        metadatas.for_destroyed(solar_system.id).
          should == SolarSystemMetadata.destroyed(solar_system.id)
      end
    end
  end
end