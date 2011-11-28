require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Combat::Annexer do
  shared_examples_for "taking planet" do
    it "should not create protection cooldown" do
      Combat::Annexer.annex!(@planet, @check_report, @outcomes)
      @planet.should_not have_cooldown
    end

    it "should not created protection notification" do
      Notification.should_not_receive(:create_for_planet_protected)
      Combat::Annexer.annex!(@planet, @check_report, @outcomes)
    end

    it "should take ownership of the planet" do
      lambda do
        Combat::Annexer.annex!(@planet, @check_report, @outcomes)
        @planet.reload
      end.should change(@planet, :player).to(nil)
    end

    it "should create planet annexed notifications" do
      @alliances.values.flatten.compact.each do |player|
        Notification.should_receive(:create_for_planet_annexed).
          with(player.id, @planet, @outcomes[player.id])
      end
      Combat::Annexer.annex!(@planet, @check_report, @outcomes)
    end
  end

  describe ".annex!" do
    before(:all) do
      @alliances = {
        -1 => [Factory.create(:player, :planets_count => 4), 
               Factory.create(:player)],
        -2 => [Factory.create(:player), Factory.create(:player)],
        -3 => [nil]
      }
    end
    
    describe "when planet is free (no conflict)" do
      before(:each) do
        @planet = Factory.create(:planet)
        @check_report = Combat::CheckReport.new(
          Combat::CheckReport::NO_CONFLICT, 
          @alliances,
          {}
        )
        @outcomes = nil
      end
    
      it "should create notifications for each player in that planet" do
        @alliances.values.flatten.compact.each do |player|
          Notification.should_receive(:create_for_planet_annexed).
            with(player.id, @planet, nil)
        end
        Combat::Annexer.annex!(@planet, @check_report, @outcomes)
      end
    end
    
    describe "when planet is occupied (combat)" do
      before(:each) do
        @owner = @alliances[-1][0]
        @planet = Factory.create(:planet, :player => @owner)
        @check_report = Combat::CheckReport.new(
          Combat::CheckReport::COMBAT,
          @alliances,
          {}
        )
        @outcomes = @alliances.values.flatten.inject({}) do |hash, player|
          hash[player ? player.id : nil] = Combat::OUTCOME_LOSE
          hash
        end
      end
      
      describe "when no shots were shot" do
        before(:each) do
          @outcomes = nil
        end
        
        it "should not change planet ownership" do
          lambda do
            Combat::Annexer.annex!(@planet, @check_report, @outcomes)
            @planet.reload
          end.should_not change(@planet, :player)
        end
      end
      
      describe "when owner won" do
        before(:each) do
          @outcomes[@owner.id] = Combat::OUTCOME_WIN
        end
        
        it "should not change planet ownership" do
          lambda do
            Combat::Annexer.annex!(@planet, @check_report, @outcomes)
            @planet.reload
          end.should_not change(@planet, :player)
        end
        
        it "should not create any annexation notifications" do
          Notification.should_not_receive(:create_for_planet_annexed)
          Combat::Annexer.annex!(@planet, @check_report, @outcomes)
        end
      end
      
      describe "when owner lost" do
        describe "if the planet is protected" do
          before(:each) do
            @owner.planets_count = Cfg.player_protected_planets
            @owner.save!
          end
          
          it "should create a protection cooldown" do
            Combat::Annexer.annex!(@planet, @check_report, @outcomes)
            @planet.should have_cooldown(
              Cfg.planet_protection_duration(@planet.solar_system.galaxy).
                from_now
            )
          end
          
          it "should create protection notifications" do
            duration = Cfg.
              planet_protection_duration(@planet.solar_system.galaxy)

            @alliances.values.flatten.compact.each do |player|
              Notification.should_receive(:create_for_planet_protected).
                with(player.id, @planet, @outcomes[player.id], duration)
            end
            Combat::Annexer.annex!(@planet, @check_report, @outcomes)
          end

          describe "when in battleground solar system" do
            before(:each) do
              ss = @planet.solar_system
              ss.kind = SolarSystem::KIND_BATTLEGROUND
              ss.save!
            end

            it_should_behave_like "taking planet"
          end

          describe "when apocalypse has started" do
            before(:each) do
              @owner.galaxy.stub(:apocalypse_started?).and_return(true)
            end

            it_should_behave_like "taking planet"
          end
        end
        
        describe "when it's not the last planet" do
          before(:each) do
            @owner.planets_count = 4
            @owner.save!
          end

          it_should_behave_like "taking planet"
        end
      end
    end
  end
end