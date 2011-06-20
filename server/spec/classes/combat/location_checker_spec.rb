require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

klass = Combat::LocationChecker

describe klass do
  describe ".check_location" do
    before(:each) do
      @planet = Factory.create(:planet)
      @location = @planet.location_point
    end

    it "should return false if there is cooldown" do
      Cooldown.create_or_update!(@location, 1.minute.since)
      Combat::LocationChecker.check_location(@location).should be_false
    end

    it "should return false if there are no opposing forces" do
      Combat::LocationChecker.check_location(@location).should be_false
    end

    it "should invoke SS metadata recalc if location is ss point" do
      ssp = SolarSystemPoint.new(@planet.solar_system_id, 0, 0)
      check_report = Combat::CheckReport.new(
        Combat::CheckReport::CONFLICT, {}
      )
      Combat::LocationChecker.stub!(:check_for_enemies).and_return(check_report)
      Combat.stub!(:run).and_return(true)
      FowSsEntry.should_receive(:recalculate).with(ssp.id, true)
      Combat::LocationChecker.check_location(ssp)
    end

    it "should not invoke SS metadata recalc if location is not " +
    "a ss point" do
      check_report = Combat::CheckReport.new(
        Combat::CheckReport::CONFLICT, {}
      )
      Combat::LocationChecker.stub!(:check_for_enemies).and_return(check_report)
      Combat.stub!(:run).and_return(true)
      FowSsEntry.should_not_receive(:recalculate)
      Combat::LocationChecker.check_location(@planet)
    end

    it "should not invoke SS metadata recalc if no combat was ran" do
      check_report = Combat::CheckReport.new(
        Combat::CheckReport::CONFLICT, {}
      )
      Combat::LocationChecker.stub!(:check_for_enemies).
        and_return(check_report)
      Combat.stub!(:run).and_return(nil)
      FowSsEntry.should_not_receive(:recalculate)
      Combat::LocationChecker.check_location(
        SolarSystemPoint.new(@planet.solar_system_id, 0, 0)
      )
    end

    it "should invoke annexer if location is planet" do
      check_report = Combat::CheckReport.new(
        Combat::CheckReport::NO_CONFLICT, :alliances
      )
      Combat::LocationChecker.stub!(:check_for_enemies).
        and_return(check_report)
      Combat::Annexer.should_receive(:annex!).with(
        @planet,
        check_report.status,
        check_report.alliances,
        nil
      )
      Combat::LocationChecker.check_location(@location)
    end

    it "should not invoke annexer otherwise" do
      Combat::Annexer.should_not_receive(:annex!)
      Combat::LocationChecker.check_location(
        SolarSystemPoint.new(@planet.solar_system_id, 0, 0))
    end

    describe "opposing players" do
      before(:each) do
        @player1 = Factory.create :player
        @player2 = Factory.create :player
        @players = [@planet.player, @player1, @player2].compact
        @alliances = Player.grouped_by_alliance(
          [@planet.player_id, @player1.id, @player2.id]
        )
        @nap_rules = {}
        @units = [          
          Factory.create(:unit, :location => @location,
            :player => @player1, :level => 1),
          Factory.create(:unit, :location => @location,
            :player => @player2, :level => 1),
        ]
        @buildings = [
          Factory.create!(:b_vulcan, :planet => @planet, :x => 10,
            :state => Building::STATE_ACTIVE, :level => 1),
          Factory.create!(:b_thunder, :planet => @planet, :x => 20,
            :state => Building::STATE_ACTIVE, :level => 1),
        ]
      end

      describe "invocation" do
        before(:each) do
          @stubbed_assets = Combat::Assets.new(
            {'outcomes' => {}, 'statistics' => {}},
            mock(CombatLog),
            {},
            nil
          )
        end

        it "should invoke combat in that location" do
          Combat.should_receive(:run).with(@planet, @players, @nap_rules,
            @units, @buildings).and_return(@stubbed_assets)
          Combat::LocationChecker.check_location(@location)
        end

        it "should include defensive portal units" do
          portal_units = [
            Factory.create(:unit, :player => @planet.player),
            Factory.create(:unit, :player => Factory.create(:player)),
          ]
          Building::DefensivePortal.should_receive(:portal_units_for).
            with(@planet).and_return(portal_units)

          units = @units + portal_units
          players = Player.find(units.map(&:player_id).uniq.compact)
          Combat.should_receive(:run).with(@planet, players, @nap_rules,
            units, @buildings).and_return(@stubbed_assets)
          Combat::LocationChecker.check_location(@location)
        end

        it "should not include units with level 0" do
          unit = Factory.create(:unit, :location => @location, :level => 0,
            :player => @player1)
          Combat.stub!(:run).and_return do
            |planet, alliances, nap_rules, units, buildings|
            units.should_not include(unit)
            @stubbed_assets
          end
          Combat::LocationChecker.check_location(@location)
        end

        it "should not include buildings that are not active" do
          building = Factory.create!(:b_vulcan, :planet => @planet,
            :x => 30, :state => Building::STATE_INACTIVE)
          Combat.stub!(:run).and_return do
            |planet, alliances, nap_rules, units, buildings|
            buildings.should_not include(building)
            @stubbed_assets
          end
          Combat::LocationChecker.check_location(@location)
        end
      end

      it "should return true if there are opposing forces there" do
        Combat::LocationChecker.check_location(@location).should be_true
      end

      it "should invoke annexer if location is planet" do
        check_report = Combat::CheckReport.new(
          Combat::CheckReport::CONFLICT, {}
        )
        Combat::LocationChecker.stub!(:check_for_enemies).
          and_return(check_report)

        response = {
          'outcomes' => :outcomes,
          'statistics' => :statistics
        }
        assets = Combat::Assets.new(response, :log, :notification_ids, nil)
        Combat.stub!(:run).and_return(assets)
        Combat::Annexer.should_receive(:annex!).with(
          @planet,
          check_report.status,
          check_report.alliances,
          Combat::LocationChecker::CombatData.new(
            response['outcomes'],
            response['statistics']
          )
        )
        Combat::LocationChecker.check_location(@location)
      end
    end
  end

  describe ".check_player_locations" do
    before(:each) do
      @player = Factory.create(:player)
    end
    
    it "should check planets he owns" do
      planet = Factory.create(:planet, :player => @player)
      klass.should_receive(:check_location).with(planet.location_point)
      klass.check_player_locations(@player)
    end
    
    it "should check locations where player has units" do
      unit = Factory.create(:unit, :player => @player)
      klass.should_receive(:check_location).with(unit.location)
      klass.check_player_locations(@player)
    end
    
    it "should not check same location twice" do
      planet = Factory.create(:planet, :player => @player)
      unit = Factory.create(:unit, :player => @player, :location => planet)
      klass.should_receive(:check_location).with(planet.location_point).once
      klass.check_player_locations(@player)
    end
  end

  describe ".check_for_enemies" do
    before(:each) do
      @route_hop = Factory.create :route_hop
    end

    it "should return no conflict if there are no opposing players there" do
      player = Factory.create :player
      2.times do
        Factory.create(:unit, :location => @route_hop.location,
          :player => player)
      end
      Combat::LocationChecker.send(:check_for_enemies, @route_hop.location).status ==
        Combat::CheckReport::NO_CONFLICT
    end

    it "should return false if there are no opposing alliances there" do
      alliance = Factory.create :alliance
      player1 = Factory.create :player, :alliance => alliance
      player2 = Factory.create :player, :alliance => alliance
      Factory.create(:unit, :location => @route_hop.location,
          :player => player1)
      Factory.create(:unit, :location => @route_hop.location,
          :player => player2)
      Combat::LocationChecker.send(:check_for_enemies, @route_hop.location).status ==
        Combat::CheckReport::NO_CONFLICT
    end

    it "should return false if all alliances are napped" do
      alliance1 = Factory.create :alliance
      alliance2 = Factory.create :alliance
      Factory.create :nap, :initiator => alliance1, :acceptor => alliance2,
        :status => Nap::STATUS_ESTABLISHED

      player1 = Factory.create :player, :alliance => alliance1
      player2 = Factory.create :player, :alliance => alliance2
      Factory.create(:unit, :location => @route_hop.location,
        :player => player1)
      Factory.create(:unit, :location => @route_hop.location,
        :player => player2)
      Combat::LocationChecker.send(:check_for_enemies, @route_hop.location).status ==
        Combat::CheckReport::NO_CONFLICT
    end

    it "should not return false if there are enemies (alliances)" do
      alliance1 = Factory.create :alliance
      alliance2 = Factory.create :alliance
      alliance3 = Factory.create :alliance
      Factory.create :nap, :initiator => alliance1, :acceptor => alliance2,
        :status => Nap::STATUS_ESTABLISHED
      Factory.create :nap, :initiator => alliance2, :acceptor => alliance3,
        :status => Nap::STATUS_ESTABLISHED

      player1 = Factory.create :player, :alliance => alliance1
      player2 = Factory.create :player, :alliance => alliance2
      player3 = Factory.create :player, :alliance => alliance3
      Factory.create(:unit, :location => @route_hop.location,
        :player => player1)
      Factory.create(:unit, :location => @route_hop.location,
        :player => player2)
      Factory.create(:unit, :location => @route_hop.location,
        :player => player3)
      Combat::LocationChecker.send(:check_for_enemies, @route_hop.location).
        status == Combat::CheckReport::CONFLICT
    end

    it "should not return false if there are enemies (players)" do
      alliance1 = Factory.create :alliance

      player1 = Factory.create :player, :alliance => alliance1
      player2 = Factory.create :player, :alliance => alliance1
      player3 = Factory.create :player
      Factory.create(:unit,
        :location => @route_hop.location, :player => player1
      )
      Factory.create(:unit,
        :location => @route_hop.location, :player => player2
      )
      Factory.create(:unit,
        :location => @route_hop.location, :player => player3
      )
      Combat::LocationChecker.send(:check_for_enemies, @route_hop.location).status ==
        Combat::CheckReport::CONFLICT
    end

    it "should return alliances" do
      player1 = Factory.create :player
      player2 = Factory.create :player
      Factory.create(:unit, :location => @route_hop.location,
        :player => player1)
      Factory.create(:unit, :location => @route_hop.location,
        :player => player2)
      Combat::LocationChecker.send(:check_for_enemies, @route_hop.location).alliances ==
        Player.grouped_by_alliance([player1.id, player2.id])
    end

    it "should return empty nap rules hash if only players are there" do
      player1 = Factory.create :player
      player2 = Factory.create :player
      Factory.create(:unit, :location => @route_hop.location,
        :player => player1)
      Factory.create(:unit, :location => @route_hop.location,
        :player => player2)
      Combat::LocationChecker.send(:check_for_enemies, @route_hop.location).nap_rules.should == {}
    end

    it "should return nap rules" do
      alliance1 = Factory.create :alliance
      alliance2 = Factory.create :alliance
      alliance3 = Factory.create :alliance
      Factory.create :nap, :initiator => alliance1, :acceptor => alliance2,
        :status => Nap::STATUS_ESTABLISHED
      Factory.create :nap, :initiator => alliance2, :acceptor => alliance3,
        :status => Nap::STATUS_ESTABLISHED

      player1 = Factory.create :player, :alliance => alliance1
      player2 = Factory.create :player, :alliance => alliance2
      player3 = Factory.create :player, :alliance => alliance3
      Factory.create(:unit,
        :location => @route_hop.location, :player => player1
      )
      Factory.create(:unit,
        :location => @route_hop.location, :player => player2
      )
      Factory.create(:unit,
        :location => @route_hop.location, :player => player3
      )

      Combat::LocationChecker.send(:check_for_enemies, @route_hop.location).nap_rules.should == \
        Nap.get_rules([alliance1.id, alliance2.id, alliance3.id])
    end
  end

end
