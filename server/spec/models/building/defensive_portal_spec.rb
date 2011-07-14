require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Building::DefensivePortal do
  describe ".get_ids_from_planet" do
    it "should raise error if planet is uninhabited" do
      planet = Factory.create(:planet)
      lambda do
        Building::DefensivePortal.send(:get_ids_from_planet, planet)
      end.should raise_error(Building::DefensivePortal::NoUnitsError)
    end

    it "should raise error if player does not have other planets" do
      planet = Factory.create(:planet_with_player)
      lambda do
        Building::DefensivePortal.send(:get_ids_from_planet, planet)
      end.should raise_error(Building::DefensivePortal::NoUnitsError)
    end

    it "should use player friendly ids for player ids" do
      planet = Factory.create(:planet_with_player)
      # Second planet for planet ids.
      Factory.create!(:b_defensive_portal, 
        opts_active + 
          {:planet => Factory.create(:planet, :player => planet.player)})
      player = planet.player
      player_ids = [player.id, 10, 20]
      player.should_receive(:friendly_ids).and_return(player_ids)
      Building::DefensivePortal.send(:get_ids_from_planet, planet)[0].
        should == player_ids
    end

    it "should use all friendly planet ids except original planet" do
      planet1 = Factory.create(:planet_with_player)
      planet2 = Factory.create(:planet, :player => planet1.player)
      Factory.create!(:b_defensive_portal, opts_active + {:planet => planet2})
      planet3 = Factory.create(:planet, :player => planet1.player)
      Factory.create!(:b_defensive_portal, opts_active + {:planet => planet3})
      Building::DefensivePortal.send(:get_ids_from_planet, planet1)[1].
        should == [planet2.id, planet3.id]
    end
    
    it "should not return planets which have no portals" do
      planet1 = Factory.create(:planet_with_player)
      planet2 = Factory.create(:planet, :player => planet1.player)
      planet3 = Factory.create(:planet, :player => planet1.player)
      Factory.create!(:b_defensive_portal, 
        opts_active + {:planet => planet3})
      Building::DefensivePortal.send(:get_ids_from_planet, planet1)[1].
        should == [planet3.id]
    end
    
    it "should not return planets without active portals" do
      planet1 = Factory.create(:planet_with_player)
      planet2 = Factory.create(:planet, :player => planet1.player)
      Factory.create!(:b_defensive_portal, 
        opts_inactive + {:planet => planet2})
      planet3 = Factory.create(:planet, :player => planet1.player)
      Factory.create!(:b_defensive_portal, 
        opts_active + {:planet => planet3})
      Building::DefensivePortal.send(:get_ids_from_planet, planet1)[1].
        should == [planet3.id]
    end
  end

  describe "grouped counts" do
    describe ".portal_unit_counts_for" do
      it "should return [] if planets is uninhabited" do
        planet = Factory.create(:planet)
        Building::DefensivePortal.should_receive(:get_ids_from_planet).
          with(planet).and_raise(Building::DefensivePortal::NoUnitsError)
        Building::DefensivePortal.portal_unit_counts_for(planet).should == []
      end

      it "should call .total_unit_counts with those values" do
        planet = Factory.create(:planet)
        Building::DefensivePortal.stub!(:get_ids_from_planet).with(planet).
          and_return([:player_ids, :planet_ids])
        Building::DefensivePortal.should_receive(:total_unit_counts).
          with(:player_ids, :planet_ids)
        Building::DefensivePortal.portal_unit_counts_for(planet)
      end
    end

    describe ".total_unit_counts" do
      it "should return total summed counts" do
        p1 = Factory.create(:planet_with_player)
        p2 = Factory.create(:planet)

        Factory.create!(:u_trooper, :player => p1.player, :location => p1)
        Factory.create!(:u_trooper, :player => p1.player, :location => p2)
        Factory.create!(:u_shocker, :player => p1.player, :location => p2)

        # Do not include from other p
        Building::DefensivePortal.send(:total_unit_counts,
          [p1.player.id], [p1.id, p2.id]
        ).sort.should == [["Trooper", 2], ["Shocker", 1]].sort
      end

      it "should not include units from other planets" do
        p1 = Factory.create(:planet_with_player)
        p2 = Factory.create(:planet)

        Factory.create!(:u_trooper, :player => p1.player, :location => p2)

        # Do not include from other p
        Building::DefensivePortal.send(:total_unit_counts,
          [p1.player.id], [p1.id]
        ).should be_blank
      end

      it "should not include enemy units in planets" do
        p1 = Factory.create(:planet_with_player)

        Factory.create!(:u_trooper, :location => p1)

        # Do not include from other p
        Building::DefensivePortal.send(:total_unit_counts,
          [p1.player.id], [p1.id]
        ).should be_blank
      end
    end
  end

  describe "portal units" do
    describe ".portal_units_for" do
      it "should return [] if planet is uninhabited" do
        planet = Factory.create(:planet)
        Building::DefensivePortal.should_receive(:get_ids_from_planet).
          with(planet).and_raise(Building::DefensivePortal::NoUnitsError)
        Building::DefensivePortal.portal_units_for(planet).should == []
      end

      it "should calculate total volume and call .pick_units" do
        planet = Factory.create(:planet)
        Building::DefensivePortal.stub!(:get_ids_from_planet).with(planet).
          and_return([:player_ids, :planet_ids])
        Building::DefensivePortal.stub!(:teleported_volume_for).
          with(planet).and_return(:volume)

        Building::DefensivePortal.should_receive(:pick_units).
          with(:player_ids, :planet_ids, :volume)
        Building::DefensivePortal.portal_units_for(planet)
      end
    end

    describe ".teleported_volume_for" do
      it "should calculate total volume" do
        planet = Factory.create(:planet)
        buildings = [
          Factory.create!(:b_defensive_portal, opts_active + {:level => 1,
            :planet => planet}),
          Factory.create!(:b_defensive_portal, opts_active + {:level => 1,
            :planet => planet, :x => 10}),
        ]
        # These should not get included.
        Factory.create!(:b_defensive_portal, opts_active + {:level => 1})
        Factory.create!(:b_defensive_portal, opts_inactive + {:level => 1,
          :planet => planet, :x => 20})

        Building::DefensivePortal.teleported_volume_for(planet).should ==
          buildings.map(&:teleported_volume).sum
      end
    end

    describe ".pick_units" do
      it "should return units" do
        units = [
          Factory.create(:unit),
          Factory.create(:unit),
          Factory.create(:unit),
        ]

        Building::DefensivePortal.should_receive(:pick_unit_ids).with(
          :player_ids, :planet_ids, :total_volume).
          and_return(Set.new(units.map(&:id)))
        Building::DefensivePortal.
          send(:pick_units, :player_ids, :planet_ids, :total_volume).
          should == units
      end
    end

    describe ".pick_unit_ids" do
      it "should call .pick_unit_ids_from_list with available unit ids" do
        volumes = Building::DefensivePortal::PORTAL_UNIT_VOLUMES

        player = Factory.create(:player)
        planet = Factory.create(:planet)
        t = Factory.create!(:u_trooper, :location => planet, :player => player)
        s = Factory.create!(:u_shocker, :location => planet, :player => player)

        Building::DefensivePortal.should_receive(:pick_unit_ids_from_list).
          with([
            [t.id, volumes["Trooper"]],
            [s.id, volumes["Shocker"]],
          ], :total_volume)
        Building::DefensivePortal.send(:pick_unit_ids, [player.id],
          [planet.id], :total_volume)
      end

      it "should not include enemy units" do
        player = Factory.create(:player)
        planet = Factory.create(:planet)
        Factory.create!(:u_trooper, :location => planet)

        Building::DefensivePortal.should_receive(:pick_unit_ids_from_list).
          with([], :total_volume)
        Building::DefensivePortal.send(:pick_unit_ids, [player.id],
          [planet.id], :total_volume)
      end

      it "should not include units on other planets" do
        player = Factory.create(:player)
        planet = Factory.create(:planet)
        Factory.create!(:u_trooper, :player => player,
          :location => Factory.create(:planet))

        Building::DefensivePortal.should_receive(:pick_unit_ids_from_list).
          with([], :total_volume)
        Building::DefensivePortal.send(:pick_unit_ids, [player.id],
          [planet.id], :total_volume)
      end
    end

    describe ".pick_unit_ids_from_list" do
      it "should not go overboard" do
        available = [[1, 10], [2, 20], [3, 30]]
        hash = Hash[available]
        Building::DefensivePortal.send(:pick_unit_ids_from_list,
          available, 40).map { |id| hash[id] }.sum.should_not > 40
      end

      it "should not fail if we have less than wanted volume" do
        lambda do
          Building::DefensivePortal.send(:pick_unit_ids_from_list,
            [[1, 10], [2, 20], [3, 30]], 100)
        end.should_not raise_error
      end
    end
  end
end