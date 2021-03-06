require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Combat::Annexer do
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
        it "should not create cooldown" do
          Combat::Annexer.annex!(@planet, @check_report, @outcomes)
          @planet.should_not have_cooldown
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
    end
  end
end