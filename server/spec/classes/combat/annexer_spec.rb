require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb'))

describe "with owner (you)", :shared => true do
  it "should assign it to one of the enemies randomly" do
    [@enemy1, @enemy2].map(&:id).should include(@planet.player_id)
  end

  it "should not leave ownership" do
    @planet.player_id.should_not == @you.id
  end

  it "should not change owner with alliance" do
    @planet.player_id.should_not == @ally.id
  end

  it "should not change owner with nap" do
    @planet.player_id.should_not == @nap.id
  end
end

describe "conflict no combat", :shared => true do
  it "should not change anything if no combat was ran" do
    lambda do
      Combat::Annexer.annex!(@planet,
        Combat::CheckReport::CONFLICT, @alliances, nil, nil)
    end.should_not change(@planet, :player_id)
  end
end

describe Combat::Annexer do
  describe ".annex!" do
    before(:each) do
      galaxy = Factory.create(:galaxy)

      alliance = Factory.create(:alliance, :galaxy => galaxy)
      @you = Factory.create(:player, :alliance => alliance,
        :galaxy => galaxy, :planets_count => 2)
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
      @players_npc = [@you, Combat::NPC]
      @players_1enemy = [@you, @enemy1]
      @alliances = Player.grouped_by_alliance(@players.map(&:id))
      @alliances_npc = Player.grouped_by_alliance(
        @players_npc.map do |player|
          player == Combat::NPC ? Combat::NPC : player.id
        end
      )
      @alliances_1enemy = Player.grouped_by_alliance(
        @players_1enemy.map(&:id))

      @outcomes_lose = {
        @you.id.to_s => Combat::OUTCOME_LOSE,
        @ally.id.to_s => Combat::OUTCOME_LOSE,
        @nap.id.to_s => Combat::OUTCOME_WIN,
        @enemy1.id.to_s => Combat::OUTCOME_WIN,
        @enemy2.id.to_s => Combat::OUTCOME_WIN,
        Combat::NPC_SM => Combat::OUTCOME_WIN,
      }
      @outcomes_win = {
        @you.id.to_s => Combat::OUTCOME_WIN,
        @ally.id.to_s => Combat::OUTCOME_WIN,
        @nap.id.to_s => Combat::OUTCOME_WIN,
        @enemy1.id.to_s => Combat::OUTCOME_LOSE,
        @enemy2.id.to_s => Combat::OUTCOME_LOSE,
        Combat::NPC_SM => Combat::OUTCOME_LOSE,
      }
      @outcomes_lose_1enemy = {
        @you.id.to_s => Combat::OUTCOME_LOSE,
        @enemy1.id.to_s => Combat::OUTCOME_WIN
      }
      @outcomes_lose_npc = {
        @you.id.to_s => Combat::OUTCOME_LOSE,
        Combat::NPC_SM => Combat::OUTCOME_WIN
      }
      @statistics = {
        @you.id.to_s => {'points_earned' => 100},
        @ally.id.to_s => {'points_earned' => 200},
        @nap.id.to_s => {'points_earned' => 150},
        @enemy1.id.to_s => {'points_earned' => 100},
        @enemy2.id.to_s => {'points_earned' => 300},
        Combat::NPC_SM => {'points_earned' => 400},
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

        it_should_behave_like "conflict no combat"
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

      describe "= 1 planet" do
        before(:each) do
          @you.planets_count = 1
          @you.save!
          @players = @alliances.values.flatten
        end

        it "should send notifications to everyone" do
          @players.each do |player|
            Notification.should_receive(:create_for_planet_protected).with(
              @planet, player)
          end
          Combat::Annexer.annex!(@planet,
            Combat::CheckReport::NO_CONFLICT, @alliances, nil, nil)
        end

        it "should add cooldown" do
          Combat::Annexer.annex!(@planet,
            Combat::CheckReport::NO_CONFLICT, @alliances, nil, nil)
          @planet.should have_cooldown(
            Cfg.planet_protection_duration.from_now)
        end
        
        it "should not fail if one of players is npc" do
          Combat::Annexer.annex!(@planet,
            Combat::CheckReport::NO_CONFLICT, @alliances_npc, nil, nil)
        end
      end

      describe "> 1 planet" do
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

          it "should assign it to npc if they won" do
            Combat::Annexer.annex!(@planet,
              Combat::CheckReport::CONFLICT, @alliances_npc,
              @outcomes_lose_npc,
              @statistics)
            @planet.player_id.should == nil
          end

          it_should_behave_like "with owner (you)"
          it_should_behave_like "conflict no combat"
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

    it "should create notification" do
      planet = Factory.create(:planet, :player => nil)
      Notification.should_receive(:create_for_planet_annexed).with(
        planet, nil, @enemy1
      )
      Combat::Annexer.annex!(planet,
            Combat::CheckReport::CONFLICT, @alliances_1enemy,
            @outcomes_lose_1enemy,
            @statistics)
    end
  end
end