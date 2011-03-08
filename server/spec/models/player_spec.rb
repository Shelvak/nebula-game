require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Player do
  it "should not allow creating two players in same galaxy" do
    p1 = Factory.create(:player)
    p2 = Factory.build(:player, :galaxy_id => p1.galaxy_id,
      :auth_token => p1.auth_token)
    lambda do
      p2.save!
    end.should raise_error(ActiveRecord::RecordNotUnique)
  end

  describe "#as_json" do
    before(:all) do
      @model = Factory.create(:player)
    end

    fields = Player.columns.map(&:name)

    describe ":ratings mode" do
      before(:all) do
        @options = {:mode => :ratings}
      end

      @required_fields = %w{id name alliance army_points war_points
        economy_points science_points planets_count victory_points online}
      @ommited_fields = fields - @required_fields
      it_should_behave_like "to json"

      it "should set online" do
        Dispatcher.instance.should_receive(:connected?).with(@model.id).
          and_return(:online)
        @model.as_json(@options)[:online].should == :online
      end
    end

    describe ":minimal mode" do
      before(:all) do
        @options = {:mode => :minimal}
      end

      @required_fields = %w{id name}
      @ommited_fields = fields - @required_fields
      it_should_behave_like "to json"
    end

    describe "normal mode" do
      @required_fields = %w{id name scientists scientists_total xp
        first_time economy_points army_points science_points war_points
        victory_points planets_count}
      @ommited_fields = fields - @required_fields
      it_should_behave_like "to json"
    end
  end

  describe "points" do
    point_types = %w{war_points army_points science_points economy_points}

    point_types.each do |type|
      it "should progress have points objective if #{type} changed" do
        player = Factory.create(:player)
        Objective::HavePoints.should_receive(:progress).with(player)
        player.send("#{type}=", player.send(type) + 100)
        player.save!
      end

      it "should be summed into #points" do
        player = Factory.create(:player)
        player.send("#{type}=", 10)
        player.points.should == 10
      end

      it "should not allow setting it below 0" do
        player = Factory.build(:player)
        player.send("#{type}=", -10)
        player.save!
        player.send(type).should == 0
      end
    end

    it "should not progress have points objective if xp is changed" do
      player = Factory.create(:player)
      Objective::HavePoints.should_not_receive(:progress)
      player.xp += 100
      player.save!
    end
  end

  (Player::OBJECTIVE_ATTRIBUTES - ["points"]).each do |attr|
    it "should progress #{attr} when it is changed" do
      player = Factory.create(:player)
      klass = "Objective::Have#{attr.camelcase}".constantize
      klass.should_receive(:progress).with(player)
      player.send("#{attr}=", player.send(attr) + 100)
      player.save!
    end
  end

  describe ".minimal" do
    before(:all) do
      @player = Factory.create(:player)
    end

    it "should return id" do
      Player.minimal(@player.id)[:id].should == @player.id
    end

    it "should return name" do
      Player.minimal(@player.id)[:name].should == @player.name
    end

    it "should return nil if id is nil" do
      Player.minimal(nil).should be_nil
    end
  end

  describe "#change_scientist_count!" do
    before(:each) do
      @player = Factory.create(:player)
    end

    describe "positive count" do
      before(:each) do
        @scientists = 10
      end

      it "should add scientists to player" do
        lambda do
          @player.change_scientist_count!(@scientists)
        end.should change(@player, :scientists).by(@scientists)
      end

      it "should add scientists_total to player" do
        lambda do
          @player.change_scientist_count!(@scientists)
        end.should change(@player, :scientists_total).by(@scientists)
      end
    end

    describe "negative count" do
      before(:each) do
        @scientists = -10
      end

      it "should subtract scientists from player" do
        lambda do
          @player.change_scientist_count!(@scientists)
        end.should change(@player, :scientists).by(@scientists)
      end

      it "should subtract scientists_total from player" do
        lambda do
          @player.change_scientist_count!(@scientists)
        end.should change(@player, :scientists_total).by(@scientists)
      end

      it "should call player.ensure_free_scientists!" do
        @player.should_receive(:ensure_free_scientists!).with(- @scientists)
        @player.change_scientist_count!(@scientists)
      end
    end
  end

  describe "#friendly_ids" do
    before(:all) do
      @alliance = Factory.create :alliance
      @you = Factory.create :player, :alliance => @alliance
      @ally = Factory.create :player, :alliance => @alliance
      @enemy = Factory.create :player
    end

    it "should include your id even if you're not in alliance" do
      @enemy.friendly_ids.should == [@enemy.id]
    end

    it "should include your id" do
      @you.friendly_ids.should include(@you.id)
    end

    it "should include ally id" do
      @you.friendly_ids.should include(@ally.id)
    end

    it "should not include enemy id" do
      @you.friendly_ids.should_not include(@enemy.id)
    end
  end

  describe "#nap_ids" do
    before(:all) do
      @alliance = Factory.create :alliance
      @you = Factory.create :player, :alliance => @alliance
      @nap_alliance = Factory.create :alliance
      @nap = Factory.create(:nap, :initiator => @alliance,
        :acceptor => @nap_alliance)

      @nap_player = Factory.create :player, :alliance => @nap_alliance
      @enemy = Factory.create :player
    end

    it "should return [] if no naps" do
      @enemy.nap_ids.should == []
    end

    it "should include nap id" do
      @you.nap_ids.should include(@nap_player.id)
    end

    it "should not include enemy id" do
      @you.nap_ids.should_not include(@enemy.id)
    end

    it "should not include cancelled nap ids" do
      @nap.status = Nap::STATUS_CANCELED
      @nap.save!

      @you.nap_ids.should_not include(@nap_player.id)
    end
  end

  describe ".grouped_by_alliance" do
    it "should return hash of grouped players" do
      p1 = Factory.create :player
      p2 = Factory.create :player, :alliance => Factory.create(:alliance)
      p3 = Factory.create :player
      p4 = Factory.create :player, :alliance => p2.alliance
      p5 = Factory.create :player, :alliance => Factory.create(:alliance)

      Player.grouped_by_alliance(
        [p1.id, p2.id, p3.id, p4.id, p5.id]
      ).should == {
        p2.alliance_id => [p2, p4],
        p5.alliance_id => [p5],
        -1 => [p1],
        -2 => [p3]
      }
    end

    it "should support npc players" do
      p1 = Factory.create :player
      Player.grouped_by_alliance([p1.id, nil]).should == {
        -1 => [p1],
        -2 => [Combat::NPC]
      }
    end

    it "should support only npc player" do
      Player.grouped_by_alliance([nil]).should == {
        -1 => [Combat::NPC]
      }
    end
  end

  it "should validate uniqueness of auth_token/galaxy_id" do
    model = Factory.create :player
    lambda do
      Factory.create(:player, :galaxy => model.galaxy,
        :auth_token => model.auth_token)
    end.should raise_error(ActiveRecord::RecordNotUnique)
  end

  it "should set player_id to nil on planets on destruction" do
    player = Factory.create :player
    planet = Factory.create(:planet, :player => player)
    player.destroy
    planet.reload
    planet.player_id.should be_nil
  end

  describe "#ensure_free_scientists!" do
    describe "technologies" do
      before(:each) do
        @player = Factory.create :player, :scientists => 0
        # Scrambling and sorting to ensure that our code sorts things in a
        # right way
        @technologies = [
          Factory.create(:technology_upgrading_larger, :scientists => 1000,
            :player => @player),
          Factory.create(:technology_upgrading, :scientists => 60,
            :player => @player),
          Factory.create(:technology_upgrading_t2, :scientists => 20,
            :player => @player),
          Factory.create(:technology_upgrading_t3, :scientists => 40,
            :player => @player),
          Factory.create(:technology_upgrading_t4, :scientists => 80,
            :player => @player)
        ].sort_by { |technology| technology.scientists }
        @total_extras = @technologies.inject(0) do |sum, technology|
          sum + (technology.scientists - technology.scientists_min)
        end
      end

      describe "extras handling" do
        before(:each) do
          @extras = 10
        end

        it "should not change techs while there are with extras" do
          lambda do
            @player.ensure_free_scientists!(@extras)
            @technologies[0].reload
          end.should_not change(@technologies[0], :scientists)
        end

        it "should reduce extras in technologies" do
          lambda do
            @player.ensure_free_scientists!(@extras)
            @technologies[1].reload
          end.should change(@technologies[1], :scientists).by(-@extras)
        end

        it "should reduce to min scs if extras are not enough" do
          sc_min = @technologies[1].scientists_min
          extra_diff = @technologies[1].scientists - sc_min

          lambda do
            @player.ensure_free_scientists!(@extras + extra_diff)
            @technologies[1].reload
          end.should change(@technologies[1], :scientists).to(sc_min)
        end

        it "should reduce next technology if extras are not enough" do
          sc_min = @technologies[1].scientists_min
          extra_diff = @technologies[1].scientists - sc_min

          lambda do
            @player.ensure_free_scientists!(@extras + extra_diff)
            @technologies[2].reload
          end.should change(@technologies[2], :scientists).by(-@extras)
        end
      end

      describe "pausing" do
        it "should pause all technologies starting from the one with least" +
        " scientists" do
          @player.ensure_free_scientists!(@total_extras +
              @technologies[0].scientists_min)

          @technologies[0].reload
          @technologies[0].should be_paused
          @player.scientists.should == 340
        end

        it "should pause until required number of scientists are freed" do
          @player.ensure_free_scientists!(@total_extras +
              @technologies[0].scientists_min +
              @technologies[1].scientists_min)

          @player.scientists.should == 360
          @technologies[0].reload
          @technologies[0].should be_paused
          @technologies[1].reload
          @technologies[1].should be_paused
          @technologies[2].reload
          @technologies[2].should be_upgrading
        end
      end

      describe "unpausing" do
        it "should try to unpause technologies starting with the one with" +
        " most scientists" do
          @player.ensure_free_scientists!(@total_extras +
              @technologies[4].scientists_min)

          @player.scientists.should == 1120
          @technologies[0].reload
          @technologies[0].should be_upgrading
          @technologies[1].reload
          @technologies[1].should be_upgrading
          @technologies[2].reload
          @technologies[2].should be_upgrading
          @technologies[3].reload
          @technologies[3].should be_upgrading
          @technologies[4].reload
          @technologies[4].should be_paused
        end

        it "should leave unused scientists" do
          free_scientists = 5
          @player.ensure_free_scientists!(@total_extras +
              @technologies[0].scientists_min - free_scientists)

          @player.scientists.should == 340
          @technologies[0].reload
          @technologies[0].should be_paused
        end
      end

      it "should try to rewind extras state if possible" do
        @player.ensure_free_scientists! 560

        @player.scientists.should == 1000
        @technologies[0].reload
        @technologies[0].should be_upgrading
        @technologies[0].scientists.should == 20
        @technologies[1].reload
        @technologies[1].should be_upgrading
        @technologies[1].scientists.should == 40
        @technologies[2].reload
        @technologies[2].should be_upgrading
        @technologies[2].scientists.should == 60
        @technologies[3].reload
        @technologies[3].should be_upgrading
        @technologies[3].scientists.should == 80
        @technologies[4].reload
        @technologies[4].should be_paused
      end

      it "should dispatch changed technologies" do
        Reducer::ScientistsReducer.stub!(:reduce).and_return([
          [@technologies[0], Reducer::CHANGED, 20],
          [@technologies[3], Reducer::CHANGED, 30],
        ])
        should_fire_event([@technologies[0], @technologies[3]],
            EventBroker::CHANGED) do
          @player.ensure_free_scientists! 20
        end
      end

      it "should not crash if there are no changes" do
        Reducer::ScientistsReducer.stub!(:reduce).and_return([])
        EventBroker.should_not_receive(:fire)
        @player.ensure_free_scientists! 20
      end

      it "should not do anything is enough scientists are available" do
        player = Factory.create :player, :scientists => 100
        technology = Factory.create(:technology_upgrading_larger,
          :scientists => 1000,
          :player => player)

        player.ensure_free_scientists! 80
        player.scientists.should == 100

        technology.reload
        technology.scientists.should == 1000
      end
    end

    describe "exploration" do
      before(:each) do
        @player = Factory.create(:player, :scientists => 100,
          :scientists_total => 100)
        x = 10; y = 15
        @planet = Factory.create(:planet, :player => @player)
        Factory.create(:t_folliage_6x6, :planet => @planet, :x => x,
          :y => y)
        @planet.explore!(x, y)
      end

      it "should cancel explorations if there is not enough scientists" do
        @player.ensure_free_scientists! 100
        @planet.reload
        @planet.should_not be_exploring
      end

      it "should not cancel exploration if it's possible to not to" do
        planet = Factory.create(:planet, :player => @player)
        x = 5; y = 2
        Factory.create(:t_folliage_3x3, :planet => planet, :x => x, :y => y)
        planet.explore!(x, y)
        ensured = 100 - planet.exploration_scientists
        @player.ensure_free_scientists!(ensured)
        planet.reload
        planet.should be_exploring
      end

      it "should correctly free scientists" do
        @player.ensure_free_scientists! 100
        @player.scientists.should == 100
      end
    end
  end

  describe "notifier" do
    before(:all) do
      @build = lambda { Factory.create(:player) }
      @change = lambda { |player| player.scientists += 1 }
    end

    @should_not_notify_create = true
    @should_not_notify_destroy = true
    it_should_behave_like "notifier"
  end
end