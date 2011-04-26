require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Combat::LocationChecker do
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
        nil,
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
            {},
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
          response['outcomes'],
          response['statistics']
        )
        Combat::LocationChecker.check_location(@location)
      end
    end
  end
end