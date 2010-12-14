require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe Player do
  describe "#as_json" do
    before(:all) do
      @model = Factory.create(:player)
    end

    describe ":ratings mode" do
      before(:all) do
        @options = {:mode => :ratings}
      end

      @required_fields = %w{id name points}
      @ommited_fields = %w{xp scientists scientists_total galaxy_id
        auth_token}
      it_should_behave_like "to json"
    end

    describe "normal mode" do
      @required_fields = %w{id name scientists scientists_total xp}
      @ommited_fields = %w{galaxy_id auth_token}
      it_should_behave_like "to json"
    end
  end

  it "should progress have points objective if points changed" do
    player = Factory.create(:player)
    Objective::HavePoints.should_receive(:progress).with(player)
    player.points += 100
    player.save!
  end

  it "should progress have points objective" do
    player = Factory.create(:player)
    Objective::HavePoints.should_not_receive(:progress)
    player.xp += 100
    player.save!
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
    before(:each) do
      @player = Factory.create :player, :scientists => 0
      # Scrambling and sorting to ensure that our code sorts things in a
      # right way
      @technologies = [
        Factory.create(:technology_upgrading_larger, :scientists => 1000,
          :player => @player),
        Factory.create(:technology_upgrading, :scientists => 60,
          :player => @player),
        Factory.create(:technology_upgrading_t2,
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