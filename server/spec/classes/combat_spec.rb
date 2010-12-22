require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Combat do
  describe "combat" do
    before(:each) do
      @dsl = CombatDsl.new do
        location :planet do
          buildings { vulcan }
        end

        alliance do
          player :planet_owner => true do
            units { trooper; trooper :flank => 1 }
          end
          player { units { trooper } }
        end

        a2 = alliance do
          player do
            units { trooper :hp => 10; trooper :flank => 1, :hp => 10 }
          end
        end

        a3 = alliance do
          player { units { trooper :hp => 10 } }
        end

        nap(a2, a3)
      end

      @combat = @dsl.create
      @units = @dsl.units
      @players = @dsl.players
      @location = @dsl.location_container.location
    end

    it "should return Combat::Assets" do
      assets = @combat.run
      assets.should be_instance_of(Combat::Assets)
    end

    it "should create notifications for every player" do
      @combat.run
      @players.each do |player|
        Notification.find_by_player_id_and_event(
          player.id, Notification::EVENT_COMBAT
        ).should_not be_nil
      end
    end

    it "should increase points for every player" do
      old_points = @players.map(&:points)
      @combat.run
      new_points = @players.map do |player|
        player.reload
        player.points
      end

      (0...@players.size).each do |index|
        new_points[index] > old_points[index]
      end
    end

    it "should save updated units" do
      Unit.should_receive(:save_all_units).with(
        [0, 1, 2].map { |i| @units[i] }, EventBroker::REASON_COMBAT
      )
      @combat.run
    end

    it "should destroy dead units" do
      Unit.should_receive(:delete_all_units).with(
        [3, 4, 5].map { |i| @units[i] }, an_instance_of(Hash),
        EventBroker::REASON_COMBAT
      )
      @combat.run
    end

    it "should first delete then save units" do
      Unit.should_receive(:delete_all_units).ordered
      Unit.should_receive(:save_all_units).ordered
      @combat.run
    end

    it "should not create cooldown" do
      @combat.run
      Cooldown.in_location(@location.location_attrs).first.should be_nil
    end

    it "should create cooldown if battle ended in tie" do
      Combat::Integration.stub!(:has_tie?).and_return(true)
      @combat.run
      Cooldown.in_location(@location.location_attrs).first.should_not be_nil
    end
  end

  describe "combat check when one has space towers and other space units" do
    it "should be able to run combat" do
      combat = new_combat do
        location(:planet) { buildings { thunder } }
        player :planet_owner => true
        player { units { crow } }
      end
      
      combat.run.should_not be_nil
    end
  end

  it "should run combat if there is nothing to fire, but units " +
  "can be unloaded" do
    new_combat do
      location :planet
      player(:planet_owner => true) { units { mule { trooper } } }
      player { units { shocker } }
    end.run.should_not be_nil
  end

  it "should include buildings in alive/dead stats" do
    player = nil
    combat = new_combat do
      location(:planet) { buildings { thunder } }
      player = self.player :planet_owner => true
      player { units { crow } }
    end

    assets = combat.run
    notification = Notification.find(
      assets.notification_ids[player.player.id])
    notification.params[:units][:yours][:alive].should include(
      "Building::Thunder")
  end

  describe "teleported units" do
    before(:each) do
      player = nil
      planet = nil
      @combat = new_combat do
        planet = location(:planet).location
        player = self.player(:planet_owner => true) do
          units { mule { trooper; shocker :hp => 1 } }
        end
        player { units { shocker :hp => 1, :count => 2 } }
      end
      @player = player.player
      @planet = planet
    end

    it "should change teleported unit location" do
      @combat.run
      unit = Unit::Trooper.where(:player_id => @player.id).first
      unit.location.should == @planet.location_point
    end

    it "should destroy teleported dead units" do
      # Ensure Shocker gets it
      Unit::Trooper.where(:player_id => @player.id).first.destroy
      @combat.run
      Unit::Shocker.where(:player_id => @player.id).first.should be_nil
    end

    it "should include teleported units in alive/dead stats" do
      assets = @combat.run
      notification = Notification.find(
        assets.notification_ids[@player.id])
      notification.params[:units][:yours][:alive].should include(
        "Unit::Trooper")
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
      FowSsEntry.should_receive(:recalculate).with(ssp.id, true)
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