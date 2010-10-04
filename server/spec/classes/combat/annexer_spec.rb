require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe "with owner (you)", :shared => true do
  it "should assign it to one of the enemies randomly" do
    [@enemy1, @enemy2].map(&:id).should include(@planet.player_id)
  end

  it "should leave ownership" do
    @planet.player_id.should_not == @you.id
  end

  it "should not change owner with alliance" do
    @planet.player_id.should_not == @ally.id
  end

  it "should not change owner with nap" do
    @planet.player_id.should_not == @nap.id
  end
end

describe Combat::Annexer do
  describe ".annex!" do
    before(:all) do
      galaxy = Factory.create(:galaxy)

      alliance = Factory.create(:alliance, :galaxy => galaxy)
      @you = Factory.create(:player, :alliance => alliance,
        :galaxy => galaxy)
      @ally = Factory.create(:player, :alliance => alliance,
        :galaxy => galaxy)

      enemy_alliance = Factory.create(:alliance, :galaxy => galaxy)
      @enemy1 = Factory.create(:player, :alliance => enemy_alliance,
        :galaxy => galaxy)
      @enemy2 = Factory.create(:player, :alliance => enemy_alliance,
        :galaxy => galaxy)

      nap_alliance = Factory.create(:alliance, :galaxy => galaxy)
      Factory.create(:nap, :initiator => alliance,
        :acceptor => nap_alliance)
      Factory.create(:nap, :initiator => enemy_alliance,
        :acceptor => nap_alliance)
      @nap = Factory.create(:player, :alliance => nap_alliance,
        :galaxy => galaxy)

      @players = [@you, @ally, @nap, @enemy1, @enemy2]
      @players_npc = [@you, nil]
      @alliances = Player.grouped_by_alliance(@players.map(&:id))
      @alliances_npc = Player.grouped_by_alliance(
        @players_npc.map { |player| player.nil? ? nil : player.id }
      )
      @outcomes_lose = {
        @you.id => Combat::Report::OUTCOME_LOSE,
        @ally.id => Combat::Report::OUTCOME_LOSE,
        @nap.id => Combat::Report::OUTCOME_WIN,
        @enemy1.id => Combat::Report::OUTCOME_WIN,
        @enemy2.id => Combat::Report::OUTCOME_WIN,
        nil => Combat::Report::OUTCOME_WIN,
      }
      @outcomes_win = {
        @you.id => Combat::Report::OUTCOME_WIN,
        @ally.id => Combat::Report::OUTCOME_WIN,
        @nap.id => Combat::Report::OUTCOME_WIN,
        @enemy1.id => Combat::Report::OUTCOME_LOSE,
        @enemy2.id => Combat::Report::OUTCOME_LOSE,
        nil => Combat::Report::OUTCOME_LOSE,
      }
      @statistics = {
        @you.id => 100,
        @ally.id => 200,
        @nap.id => 150,
        @enemy1.id => 100,
        @enemy2.id => 300,
        nil => 400,
      }
    end

    describe "no owner" do
      before(:each) do
        @planet = Factory.create(:planet, :player => nil)
      end

      describe "no conflict" do
        it "should assign it to one of the players randomly" do
          Combat::Annexer.annex!(@planet,
            Combat::CheckReport::NO_CONFLICT, @alliances, nil, nil)
          @players.map(&:id).should include(@planet.player_id)
        end
      end

      describe "conflict" do
        it "should assign it to one of the winners" do
          Combat::Annexer.annex!(@planet,
            Combat::CheckReport::CONFLICT, @alliances, @outcomes_lose,
            @statistics)
          [@nap, @enemy1, @enemy2].map(&:id).should include(
            @planet.player_id)
        end

        it "should not work without weigths" do
          lambda do
            Combat::Annexer.annex!(@planet,
              Combat::CheckReport::CONFLICT, @alliances, nil, nil)
          end.should raise_error
        end
      end

      describe "conflict (npc)" do
        it "should keep npc ownership" do
          lambda do
            Combat::Annexer.annex!(@planet,
              Combat::CheckReport::CONFLICT, @alliances_npc, @outcomes_lose,
              @statistics)
          end.should_not change(@planet, :player_id)
        end
      end
    end

    describe "with owner" do
      before(:each) do
        @planet = Factory.create(:planet, :player => @you)
      end

      describe "no conflict" do
        before(:each) do
          Combat::Annexer.annex!(@planet,
            Combat::CheckReport::NO_CONFLICT, @alliances, nil, nil)
        end

        it_should_behave_like "with owner (you)"
      end

      describe "conflict" do
        before(:each) do
          Combat::Annexer.annex!(@planet,
            Combat::CheckReport::CONFLICT, @alliances, @outcomes_lose,
            @statistics)
        end

        it "should not work without weigths" do
          lambda do
            Combat::Annexer.annex!(@planet,
              Combat::CheckReport::CONFLICT, @alliances, nil, nil)
          end.should raise_error
        end

        it_should_behave_like "with owner (you)"
      end

      describe "conflict (ally)" do
        it "should keep ally ownership" do
          lambda do
            Combat::Annexer.annex!(@planet,
              Combat::CheckReport::CONFLICT, @alliances, @outcomes_win,
              @statistics)
          end.should_not change(@planet, :player_id)
        end
      end
    end
  end
end