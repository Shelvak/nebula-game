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

    it "should use return allies in ally_ids" do
      alliance = create_alliance
      planet = Factory.create(:planet, :player => alliance.owner)
      Factory.create!(:b_defensive_portal, opts_active + {
        :planet => Factory.create(:planet, :player => alliance.owner)
      })
      ally1 = Factory.create(:player, :alliance => alliance)
      Factory.create!(:b_defensive_portal, opts_active + {
        :planet => Factory.create(:planet, :player => ally1)
      })
      ally2 = Factory.create(:player, :alliance => alliance)
      Factory.create!(:b_defensive_portal, opts_active + {
        :planet => Factory.create(:planet, :player => ally2)
      })
      
      player_id, ally_ids, _, _ = Building::DefensivePortal.
        send(:get_ids_from_planet, planet)
      player_id.should == alliance.owner_id
      ally_ids.should == [ally1.id, ally2.id]
    end

    it "should use all friendly planet ids except original planet" do
      alliance = create_alliance
      planet = Factory.create(:planet, :player => alliance.owner)
      portal1 = Factory.create!(:b_defensive_portal, opts_active + {
        :planet => Factory.create(:planet, :player => alliance.owner)
      })
      portal2 = Factory.create!(:b_defensive_portal, opts_active + {
        :planet => Factory.create(:planet, :player => alliance.owner)
      })
      ally = Factory.create(:player, :alliance => alliance)
      portal3 = Factory.create!(:b_defensive_portal, opts_active + {
        :planet => Factory.create(:planet, :player => ally)
      })

      _, _, planet_ids, ally_planet_ids = Building::DefensivePortal.
        send(:get_ids_from_planet, planet)
      planet_ids.should == [portal1.planet_id, portal2.planet_id]
      ally_planet_ids.should == [portal3.planet_id]
    end

    it "should not include allies if you don't want to" do
      alliance = Factory.create(:alliance)
      planet1 = Factory.create(
        :planet,
        :player => Factory.create(
          :player, :alliance => alliance, :portal_without_allies => true
        )
      )
      planet2 = Factory.create(
        :planet, :player => Factory.create(:player, :alliance => alliance)
      )
      Factory.create!(:b_defensive_portal, opts_active + {:planet => planet2})

      lambda do
        Building::DefensivePortal.send(:get_ids_from_planet, planet1)
      end.should raise_error(Building::DefensivePortal::NoUnitsError)
    end

    it "should not include allies which do not want to be involved" do
      alliance = Factory.create(:alliance)
      planet1 = Factory.create(
        :planet, :player => Factory.create(:player, :alliance => alliance)
      )
      planet2 = Factory.create(
        :planet,
        :player => Factory.create(
          :player, :alliance => alliance, :portal_without_allies => true
        )
      )
      Factory.create!(:b_defensive_portal, opts_active + {:planet => planet2})

      lambda do
        Building::DefensivePortal.send(:get_ids_from_planet, planet1)
      end.should raise_error(Building::DefensivePortal::NoUnitsError)
    end

    # Bugfix
    it "should not include enemy players/planets if you're not in alliance" do
      planet1 = Factory.create(:planet_with_player)
      planet2 = Factory.create(:planet_with_player)
      Factory.create!(:b_defensive_portal, opts_active + {:planet => planet2})
      planet3 = Factory.create(:planet_with_player)
      Factory.create!(:b_defensive_portal, opts_active + {:planet => planet3})

      lambda do
        Building::DefensivePortal.send(:get_ids_from_planet, planet1)
      end.should raise_error(Building::DefensivePortal::NoUnitsError)
    end
    
    it "should not return planets which have no portals" do
      planet1 = Factory.create(:planet_with_player)
      Factory.create(:planet, :player => planet1.player)
      planet3 = Factory.create(:planet, :player => planet1.player)
      Factory.create!(:b_defensive_portal, 
        opts_active + {:planet => planet3})
      _, _, planet_ids, _ = Building::DefensivePortal.
        send(:get_ids_from_planet, planet1)

      planet_ids.should == [planet3.id]
    end
    
    it "should not return planets without active portals" do
      planet1 = Factory.create(:planet_with_player)
      planet2 = Factory.create(:planet, :player => planet1.player)
      Factory.create!(:b_defensive_portal, 
        opts_inactive + {:planet => planet2})
      planet3 = Factory.create(:planet, :player => planet1.player)
      Factory.create!(:b_defensive_portal, 
        opts_active + {:planet => planet3})

      _, _, planet_ids, _ = Building::DefensivePortal.
        send(:get_ids_from_planet, planet1)

      planet_ids.should == [planet3.id]
    end
  end

  describe "grouped counts" do
    describe ".portal_unit_counts_for" do
      it "should return empty hash if planets is uninhabited" do
        planet = Factory.create(:planet)
        Building::DefensivePortal.should_receive(:get_ids_from_planet).
          with(planet).and_raise(Building::DefensivePortal::NoUnitsError)
        Building::DefensivePortal.portal_unit_counts_for(planet).
          should == {:your=>[], :alliance=>[]}
      end

      it "should call .total_unit_counts with those values" do
        planet = Factory.create(:planet)
        Building::DefensivePortal.stub!(:get_ids_from_planet).with(planet).
          and_return([:player_id, :ally_ids, :planet_ids, :ally_planet_ids])
        Building::DefensivePortal.should_receive(:total_unit_counts).
          with([:player_id], :planet_ids)
        Building::DefensivePortal.should_receive(:total_unit_counts).
          with(:ally_ids, :ally_planet_ids)
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
          and_return([:player_id, :planet_ids, :ally_ids, :ally_planet_ids])
        Building::DefensivePortal.stub!(:teleported_volume_for).
          with(planet).and_return(:volume)

        Building::DefensivePortal.should_receive(:pick_units).
          with(:player_id, :ally_ids, :planet_ids, :ally_planet_ids, :volume)
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

        Building::DefensivePortal.
          should_receive(:pick_unit_ids).
          with(:player_id, :planet_ids, :ally_ids, :ally_planet_ids,
               :total_volume).
          and_return(Set.new(units.map(&:id)))
        Building::DefensivePortal.
          send(:pick_units, :player_id, :planet_ids, :ally_ids,
               :ally_planet_ids,:total_volume).
          should == units
      end
    end

    describe ".pick_unit_ids" do
      it "should call .pick_unit_ids_from_list with available unit ids" do
        volumes = Building::DefensivePortal::PORTAL_UNIT_VOLUMES

        alliance = create_alliance
        player = alliance.owner
        planet = Factory.create(:planet)
        u1 = Factory.create!(:u_trooper, :location => planet, :player => player)
        u2 = Factory.create!(:u_shocker, :location => planet, :player => player)

        ally_player = Factory.create(:player, :alliance => alliance)
        ally_planet = Factory.create(:planet, :player => ally_player)
        ally_u1 = Factory.create!(:u_gnat, :location => ally_planet,
                                  :player => ally_player)
        ally_u2 = Factory.create!(:u_glancer, :location => ally_planet,
                                  :player => ally_player)

        Building::DefensivePortal.should_receive(:pick_unit_ids_from_list).
          with(
            [u1, u2].map { |unit| [unit.id, volumes[unit.type]] },
            [ally_u1, ally_u2].map { |unit| [unit.id, volumes[unit.type]] },
            :total_volume
          )
        Building::DefensivePortal.
          send(:pick_unit_ids, player.id, [planet.id],
               [ally_planet.id], [ally_player.id], :total_volume)
      end

      it "should not teleport non-combat types" do
        player = Factory.create(:player)
        planet = Factory.create(:planet, :player => player)
        Factory.create!(:u_mdh, :location => planet, :player => player)

        Building::DefensivePortal.should_receive(:pick_unit_ids_from_list).
          with([], [], :total_volume)
        Building::DefensivePortal.
          send(:pick_unit_ids, player.id, [planet.id], [], [], :total_volume)
      end

      it "should not teleport hidden units" do
        player = Factory.create(:player)
        planet = Factory.create(:planet, :player => player)
        Factory.create!(:u_trooper, :location => planet,
                        :player => player, :hidden => true)

        Building::DefensivePortal.should_receive(:pick_unit_ids_from_list).
          with([], [], :total_volume)
        Building::DefensivePortal.
          send(:pick_unit_ids, player.id, [planet.id], [], [], :total_volume)
      end

      it "should not include units under construction" do
        player = Factory.create(:player)
        planet = Factory.create(:planet, :player => player)
        Factory.create!(:u_trooper, :location => planet,
                        :player => player, :level => 0)

        Building::DefensivePortal.should_receive(:pick_unit_ids_from_list).
          with([], [], :total_volume)
        Building::DefensivePortal.
          send(:pick_unit_ids, player.id, [planet.id], [], [], :total_volume)
      end

      it "should not include enemy units" do
        player = Factory.create(:player)
        planet = Factory.create(:planet)
        Factory.create!(:u_trooper, :location => planet)

        Building::DefensivePortal.should_receive(:pick_unit_ids_from_list).
          with([], [], :total_volume)
        Building::DefensivePortal.
          send(:pick_unit_ids, player.id, [], [planet.id], [], :total_volume)
      end

      it "should not include units on other planets" do
        player = Factory.create(:player)
        planet = Factory.create(:planet)
        Factory.create!(:u_trooper, :player => player,
          :location => Factory.create(:planet))

        Building::DefensivePortal.should_receive(:pick_unit_ids_from_list).
          with([], [], :total_volume)
        Building::DefensivePortal.
          send(:pick_unit_ids, player.id, [], [planet.id], [], :total_volume)
      end
    end

    describe ".pick_unit_ids_from_list" do
      it "should not go overboard" do
        available_yours = [[1, 10], [2, 20], [3, 30]]
        available_ally = [[5, 10], [6, 20], [7, 30]]
        hash = Hash[available_yours + available_ally]
        Building::DefensivePortal.
          send(:pick_unit_ids_from_list, available_yours, available_ally, 40).
          map { |id| hash[id] }.sum.should_not > 40
      end

      it "should not duplicately pick same units" do
        available_yours = []
        1000.times { |i| available_yours.push [i + 1, 1] }
        Building::DefensivePortal.
          send(:pick_unit_ids_from_list, available_yours, [], 1000).size.
          should == 1000
      end

      it "should not include alliance units if you have enough units" do
        available_yours = [[1, 10], [2, 20], [3, 30]]
        available_ally = [[5, 10], [6, 20], [7, 30]]
        picked_ids = Building::DefensivePortal.
          send(:pick_unit_ids_from_list, available_yours, available_ally, 60).
          to_a
        (picked_ids & available_ally.map { |i| i[0] }).should be_blank
      end

      it "should pick alliance units if there are not enought of your units" do
        available_yours = [[1, 10], [2, 20], [3, 30]]
        available_ally = [[5, 10], [6, 20], [7, 30]]
        picked_ids = Building::DefensivePortal.
          send(:pick_unit_ids_from_list, available_yours, available_ally, 100).
          to_a
        (picked_ids & available_ally.map { |i| i[0] }).should_not be_blank
      end

      it "should not fail if we have less than wanted volume" do
        lambda do
          Building::DefensivePortal.
            send(:pick_unit_ids_from_list, [[1, 10], [2, 20]], [[3, 30]], 100)
        end.should_not raise_error
      end
    end
  end
end