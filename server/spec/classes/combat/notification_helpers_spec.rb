require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')

describe Combat::NotificationHelpers do
  describe ".alliances" do
    before(:all) do
      @alliance = Factory.create :alliance
      @players = [
        {:id => 10, :name => "orc"},
        {:id => 11, :name => "undead"},
        {:id => nil, :name => nil}
      ]
      input = {
        # Alliance (id 10)
        @alliance.id => {
          :players => @players,
          :flanks => {
            0 => [
              # Unit as returned from Combat::Participant#to_hash
              {
                :id => 10,
                :type => "Trooper",
                :kind => Combat::Participant::KIND_UNIT,
                :hp => 100
              }
            ],
            2 => [],
          }
        },
        -1 => {
          :players => {},
          :flanks => {}
        }
      }

      @output = Combat::NotificationHelpers.alliances(input)
    end

    it "should drop flanks information" do
      @output[@alliance.id].should_not include(:flanks)
    end

    it "should lookup name" do
      @output[@alliance.id][:name].should == @alliance.name
    end

    it "should set name to nil if player has no alliance" do
      @output[-1][:name].should be_nil
    end

    it "should keep players" do
      @output[@alliance.id][:players].should == @players
    end
  end

  describe ".classify_alliances" do
    before(:all) do
      @output = Combat::NotificationHelpers.classify_alliances(
        {
          20 => {
            :name => "Foobar Heroes",
            :players => [{:id => 10, :name => "orc"}]
          },
          21 => {
            :name => "Foobar Villains",
            :players => [{:id => 11, :name => "orc2"}]
          },
          22 => {
            :name => "The Neutrals",
            :players => [{:id => 12, :name => "orc3"}]
          }
        },
        10,
        20,
        {
          20 => [22],
          22 => [20]
        }
      )
    end

    it "should classify friends" do
      @output[20][:classification].should == \
        Combat::NotificationHelpers::CLASSIFICATION_FRIEND
    end

    it "should classify enemies" do
      @output[21][:classification].should == \
        Combat::NotificationHelpers::CLASSIFICATION_ENEMY
    end

    it "should classify naps" do
      @output[22][:classification].should == \
        Combat::NotificationHelpers::CLASSIFICATION_NAP
    end
  end

  describe ".statistics_for_player" do
    it "should return statistics Hash" do
      player_id = 10
      alliance_id = -2
      stats = {
        :damage_dealt_player => {player_id => 1},
        :damage_dealt_alliance => {alliance_id => 2},
        :damage_taken_player => {player_id => 3},
        :damage_taken_alliance => {alliance_id => 4},
        :xp_earned => {player_id => 5},
        :points_earned => {player_id => 6},
      }

      Combat::NotificationHelpers.statistics_for_player(
        stats, player_id, alliance_id
      ).should == {
        :damage_dealt_player => stats[:damage_dealt_player][player_id],
        :damage_dealt_alliance => stats[:damage_dealt_alliance][alliance_id],
        :damage_taken_player => stats[:damage_taken_player][player_id],
        :damage_taken_alliance => stats[:damage_taken_alliance][alliance_id],
        :xp_earned => stats[:xp_earned][player_id],
        :points_earned => stats[:points_earned][player_id]
      }
    end
  end

  describe ".group_units_by_player_id" do
    it "should return grouped units" do
      player1 = Factory.create :player
      player2 = Factory.create :player
      unit1 = Factory.create :unit, :player => player1
      unit2 = Factory.create :unit, :player => player2
      unit3 = Factory.create :unit, :player => player1

      Combat::NotificationHelpers.group_participants_by_player_id(
        [unit1, unit2, unit3]
      ).should == {
        player1.id => [unit1, unit3],
        player2.id => [unit2],
      }
    end
  end

  describe ".report_unit_counts" do
    it "should report grouped unit counts" do
      player1 = Factory.create :player
      player2 = Factory.create :player
      units = [
        Factory.create(:unit_built, :player => player1),
        Factory.create(:unit_built, :player => player1),
        Factory.create(:unit_dead, :player => player1),
        Factory.create(:unit_built, :player => player2),
        Factory.create!(:b_vulcan, :planet => Factory.create(:planet,
            :player => player2), :level => 1
        ),
        Factory.create(:unit_dead, :player => player2),
      ]

      Combat::NotificationHelpers.report_participant_counts(
        Combat::NotificationHelpers.group_participants_by_player_id(units)
      ).should == {
        player1.id => {
          :alive => {
            "Unit::TestUnit" => 2
          },
          :dead => {
            "Unit::TestUnit" => 1
          },
        },
        player2.id => {
          :alive => {
            "Unit::TestUnit" => 1,
            "Building::Vulcan" => 1
          },
          :dead => {
            "Unit::TestUnit" => 1
          },
        },
      }
    end
  end

  describe ".group_to_yane" do
    before(:all) do
      nap = Factory.create :nap

      you = Factory.create :player, :alliance => nap.initiator
      ally = Factory.create :player, :alliance => nap.initiator
      nap_player = Factory.create :player, :alliance => nap.acceptor
      enemy = Factory.create :player
      player_id_to_alliance_id = {
        you.id => you.alliance_id,
        ally.id => ally.alliance_id,
        nap_player.id => nap_player.alliance_id,
        enemy.id => -1
      }

      units = [
        Factory.create(:unit_built, :player => you),
        Factory.create(:unit_built, :player => you),
        Factory.create(:unit_dead, :player => you),
        Factory.create(:unit_built, :player => ally),
        Factory.create!(:b_vulcan, :planet => Factory.create(:planet,
            :player => ally), :level => 1
        ),
        Factory.create(:unit_built, :player => nap_player),
        Factory.create(:unit_dead, :player => nap_player),
        Factory.create(:unit_built, :player => enemy),
        Factory.create(:unit_dead, :player => enemy),
      ]

      @result = Combat::NotificationHelpers.group_to_yane(
        you.id,
        Combat::NotificationHelpers.report_participant_counts(
          Combat::NotificationHelpers.group_participants_by_player_id(units)
        ),
        player_id_to_alliance_id,
        Nap.get_rules([nap.initiator_id, nap.acceptor_id])
      )
    end

    it "should group units to Yours" do
      @result[:yours].should == {
        :alive => {"Unit::TestUnit" => 2},
        :dead => {"Unit::TestUnit" => 1},
      }
    end

    it "should group units to Alliance" do
      @result[:alliance].should == {
        :alive => {
          "Unit::TestUnit" => 1,
          "Building::Vulcan" => 1
        },
        :dead => {},
      }
    end

    it "should group units to Nap" do
      @result[:nap].should == {
        :alive => {"Unit::TestUnit" => 1},
        :dead => {"Unit::TestUnit" => 1},
      }
    end

    it "should group units to Enemy" do
      @result[:enemy].should == {
        :alive => {"Unit::TestUnit" => 1},
        :dead => {"Unit::TestUnit" => 1},
      }
    end
  end

  describe ".filter_leveled_up" do
    it "should return units which can level up" do
      unit1 = Factory.create :unit
      unit1.stub!(:can_upgrade_by).and_return(3)
      unit2 = Factory.create :unit
      unit2.stub!(:can_upgrade_by).and_return(0)
      unit3 = Factory.create :unit
      unit3.stub!(:can_upgrade_by).and_return(1)

      Combat::NotificationHelpers.filter_leveled_up(
        [unit1, unit2, unit3]
      ).should == [
        [unit1, unit1.can_upgrade_by],
        [unit3, unit3.can_upgrade_by],
      ]
    end
  end

  describe ".leveled_up_units" do
    it "should return units which can level up" do
      unit1 = Factory.create :unit, :stance => Combat::STANCE_DEFENSIVE
      unit1.stub!(:can_upgrade_by).and_return(3)
      unit2 = Factory.create :unit
      unit2.stub!(:can_upgrade_by).and_return(0)
      unit3 = Factory.create :unit, :stance => Combat::STANCE_AGGRESSIVE
      unit3.stub!(:can_upgrade_by).and_return(1)

      Combat::NotificationHelpers.leveled_up_units(
        [unit1, unit2, unit3]
      ).should == [
        {:type => "Unit::TestUnit", :hp => unit1.hp,
          :level => unit1.level + unit1.can_upgrade_by,
          :stance => unit1.stance},
        {:type => "Unit::TestUnit", :hp => unit3.hp,
          :level => unit3.level + unit3.can_upgrade_by,
          :stance => unit3.stance},
      ]
    end
  end

  describe ".resources" do
    before(:all) do
      @report = mock(Combat::Report)
      @report.stub!(:metal).and_return(100)
      @report.stub!(:energy).and_return(200)
      @report.stub!(:zetium).and_return(300)
      @result = Combat::NotificationHelpers.resources(@report)
    end

    %w{metal energy zetium}.each do |resource|
      it "should return a Hash with #{resource}" do
        @result[resource.to_sym].should == @report.send(resource)
      end
    end
  end
end