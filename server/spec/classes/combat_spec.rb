require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Combat do
  describe "combat" do
    before(:each) do
      @alliance1 = Factory.create :alliance
      @nap = Factory.create :nap
      @alliance2 = @nap.initiator
      @alliance3 = @nap.acceptor

      @player1 = Factory.create :player, :alliance => @alliance1
      @player2 = Factory.create :player, :alliance => @alliance1

      @player3 = Factory.create :player, :alliance => @alliance2
      @player4 = Factory.create :player, :alliance => @alliance3

      @location = Factory.create(:planet, :player => @player1)
      @alliances = Player.grouped_by_alliance(
        [@player1.id, @player2.id, @player3.id, @player4.id]
      )

      @units = [
        Factory.create(:u_trooper, :hp => 100, :level => 1, :xp => 0,
          :flank => 0, :player => @player1),
        Factory.create(:u_trooper, :hp => 100, :level => 1, :xp => 0,
          :flank => 1, :player => @player1),
        Factory.create(:u_trooper, :hp => 100, :level => 1, :xp => 0,
          :flank => 1, :player => @player2),

        Factory.create(:u_trooper, :hp => 10, :level => 1, :xp => 0,
          :flank => 0, :player => @player3),
        Factory.create(:u_trooper, :hp => 80, :level => 1, :xp => 0,
          :flank => 1, :player => @player3),
        Factory.create(:u_trooper, :hp => 60, :level => 1, :xp => 0,
          :flank => 1, :player => @player4),
      ]

      @buildings = [
        Factory.create!(:b_vulcan, :planet => @location)
      ]

      @combat = Combat.new(
        @location,
        @alliances,
        Nap.get_rules(@alliances.keys.reject { |id| id < 1 }),
        @units,
        @buildings
      )
    end

    it "should return Combat::Assets" do
      assets = @combat.run
      assets.should be_instance_of(Combat::Assets)
    end

    it "should create notifications for every player" do
      @combat.run
      [@player1, @player2, @player3, @player4].each do |player|
        Notification.find_by_player_id_and_event(
          player.id, Notification::EVENT_COMBAT
        ).should_not be_nil
      end
    end

    it "should save updated units" do
      @combat.run
      [0, 1, 2].each do |i|
        @units[i].should_not be_changed
      end
    end

    it "should destroy dead units" do
      Unit.should_receive(:delete_all_units).with(
        [3, 4, 5].map { |i| @units[i] }, an_instance_of(Hash)
      )
      @combat.run
    end

#    it "should assign buildings to npc if planet doesn't have player_id" do
#      @location.player = nil
#      @location.save!
#      lambda do
#        @combat.run
#      end.should_not raise_error
#    end

    it "should create cooldown" do
      @combat.run
      Cooldown.in_location(@location.location_attrs).should_not be_nil
    end
  end

#  describe "two player crush bug" do
#    it "should not crash" do
#      galaxy = Factory.create(:galaxy)
#      player1 = Factory.create(:player, :galaxy => galaxy)
#      player2 = Factory.create(:player, :galaxy => galaxy)
#      solar_system = Factory.create(:solar_system, :galaxy => galaxy)
#      location = SolarSystemPoint.new(solar_system.id, 0, 0)
#
#      player1_units = [
#        Factory.create(:u_crow, :player => player1, :location => location)
#      ]
#      player2_units = [
#        Factory.create(:u_crow, :player => player2, :location => location),
#        Factory.create(:u_crow, :player => player2, :location => location),
#        Factory.create(:u_crow, :player => player2, :location => location),
#        Factory.create(:u_crow, :player => player2, :location => location),
#      ]
#
#      alliances = Player.grouped_by_alliance([player1.id, player2.id])
#      lambda do
#        combat = Combat.new(location, alliances, {},
#          player1_units + player2_units, [])
#        combat.run
#      end.should_not raise_error
#    end
#  end

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
      Combat.check_for_enemies(@route_hop.location).status ==
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
      Combat.check_for_enemies(@route_hop.location).status ==
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
      Combat.check_for_enemies(@route_hop.location).status ==
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
      Combat.check_for_enemies(@route_hop.location).status ==
        Combat::CheckReport::CONFLICT
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
      Combat.check_for_enemies(@route_hop.location).status ==
        Combat::CheckReport::CONFLICT
    end

    it "should return alliances" do
      player1 = Factory.create :player
      player2 = Factory.create :player
      Factory.create(:unit, :location => @route_hop.location,
        :player => player1)
      Factory.create(:unit, :location => @route_hop.location,
        :player => player2)
      Combat.check_for_enemies(@route_hop.location).alliances ==
        Player.grouped_by_alliance([player1.id, player2.id])
    end

    it "should return empty nap rules hash if only players are there" do
      player1 = Factory.create :player
      player2 = Factory.create :player
      Factory.create(:unit, :location => @route_hop.location,
        :player => player1)
      Factory.create(:unit, :location => @route_hop.location,
        :player => player2)
      Combat.check_for_enemies(@route_hop.location).nap_rules.should == {}
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

      Combat.check_for_enemies(@route_hop.location).nap_rules.should == \
        Nap.get_rules([alliance1.id, alliance2.id, alliance3.id])
    end
  end

  describe ".check_location" do
    before(:each) do
      @planet = Factory.create(:planet)
      @location = @planet.location_point
    end

    it "should return false if there is cooldown" do
      Cooldown.create_or_update!(@location, 1.minute.since)
      Combat.check_location(@location).should be_false
    end

    it "should return false if there are no opposing forces" do
      Combat.check_location(@location).should be_false
    end

    it "should invoke SS metadata recalc if location is ss point" do
      ssp = SolarSystemPoint.new(@planet.solar_system_id, 0, 0)
      check_report = Combat::CheckReport.new(
        Combat::CheckReport::CONFLICT, :alliances
      )
      Combat.stub!(:check_for_enemies).and_return(check_report)
      Combat.stub!(:run).and_return(true)
      FowSsEntry.should_receive(:recalculate).with(ssp.id)
      Combat.check_location(ssp)
    end

    it "should not invoke SS metadata recalc if location is not " +
    "a ss point" do
      check_report = Combat::CheckReport.new(
        Combat::CheckReport::CONFLICT, :alliances
      )
      Combat.stub!(:check_for_enemies).and_return(check_report)
      Combat.stub!(:run).and_return(true)
      FowSsEntry.should_not_receive(:recalculate)
      Combat.check_location(@planet)
    end

    it "should not invoke SS metadata recalc if no combat was ran" do
      check_report = Combat::CheckReport.new(
        Combat::CheckReport::CONFLICT, :alliances
      )
      Combat.stub!(:check_for_enemies).and_return(check_report)
      Combat.stub!(:run).and_return(nil)
      FowSsEntry.should_not_receive(:recalculate)
      Combat.check_location(
        SolarSystemPoint.new(@planet.solar_system_id, 0, 0)
      )
    end

    it "should invoke annexer if location is planet" do
      check_report = Combat::CheckReport.new(
        Combat::CheckReport::NO_CONFLICT, :alliances
      )
      Combat.stub!(:check_for_enemies).and_return(check_report)
      Combat::Annexer.should_receive(:annex!).with(
        @planet,
        check_report.status,
        check_report.alliances,
        nil,
        nil
      )
      Combat.check_location(@location)
    end

    it "should not invoke annexer otherwise" do
      Combat::Annexer.should_not_receive(:annex!)
      Combat.check_location(
        SolarSystemPoint.new(@planet.solar_system_id, 0, 0))
    end

    describe "opposing players" do
      before(:each) do
        @player1 = Factory.create :player
        @player2 = Factory.create :player
        @alliances = Player.grouped_by_alliance(
          [@planet.player_id, @player1.id, @player2.id]
        )
        @nap_rules = {}
        @units = [          
          Factory.create(:unit, :location => @location,
            :player => @player1),
          Factory.create(:unit, :location => @location,
            :player => @player2),
        ]
        @buildings = [
          Factory.create!(:b_vulcan, :planet => @planet, :x => 10),
          Factory.create!(:b_thunder, :planet => @planet, :x => 20),
        ]
      end

      it "should invoke combat in that location" do
        Combat.should_receive(:run).with(@planet, @alliances, @nap_rules,
          @units, @buildings).and_return(
          Combat::Assets.new(
            Combat::Report.new(@planet, @alliances, {}, [],
              {}, {}, {}),
            mock(CombatLog),
            {},
            nil
          )
        )
        Combat.check_location(@location)
      end

      it "should return true if there are opposing forces there" do
        Combat.check_location(@location).should be_true
      end

      it "should invoke annexer if location is planet" do
        check_report = Combat::CheckReport.new(
          Combat::CheckReport::CONFLICT, :alliances
        )
        Combat.stub!(:check_for_enemies).and_return(check_report)

        report = Combat::Report.new(:location, :alliances, :nap_rules, :log,
          {:points_earned => :points_earned}, :outcomes, :killed_by)

        assets = Combat::Assets.new(report, :log, :notification_ids, nil)
        Combat.stub!(:run).and_return(assets)
        Combat::Annexer.should_receive(:annex!).with(
          @planet,
          check_report.status,
          check_report.alliances,
          report.outcomes,
          report.statistics[:points_earned]
        )
        Combat.check_location(@location)
      end
    end
  end
end