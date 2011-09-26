require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

shared_examples_for "releasing scientists" do
  it "should set scientists to nil" do
    lambda do
      @model.send(@method)
    end.should change(@model, :scientists).to(nil)
  end

  it "should release scientists" do
    player = @model.player
    lambda do
      @model.send(@method)
      player.reload
    end.should change(player, :scientists).by(@model.scientists)
  end
end

describe Technology do
  it "should register to tech tracker if we have mods" do
    with_config_values 'technologies.test_technology_a.mod.armor' => '1' do
      class Technology::TestTechnologyA < Technology; end
      TechTracker.get('armor').should include(Technology::TestTechnologyA)
    end
  end

  describe "#as_json" do
    it_should_behave_like "as json",
      Factory.create(:technology),
      nil,
      %w{id upgrade_ends_at pause_remainder scientists level type
      pause_scientists speed_up},
      %w{player_id flags}
  end

  describe "#upgrade_time" do
    it "should floor value" do
      with_config_values(
        'technologies.test_technology.upgrade_time' => '3.6'
      ) do
        tech = Factory.create(:technology)
        tech.upgrade_time(1, tech.scientists_min).should == 3
      end
    end

    it "should reduce time by adding extra scientists" do
      with_config_values(
        'technologies.test_technology.upgrade_time' => '4000'
      ) do
        tech = Factory.create(:technology)
        tech.upgrade_time(1, tech.scientists_min * 2).should == \
          (4000.0 * (
            100 - 100 * CONFIG['technologies.scientists.additional']
          ) / 100).floor
      end
    end

    it "should not allow exceeding max time reduction" do
      with_config_values(
        'technologies.test_technology.upgrade_time' => '4000'
      ) do
        tech = Factory.create(:technology)
        tech.upgrade_time(1, tech.scientists_min * 100).should == \
          (4000.0 * (
            100 - CONFIG['technologies.scientists.additional.max_reduction']
          ) / 100).floor
      end
    end

    it "should reduce total time if overtime is forced" do
      with_config_values(
        'technologies.test_technology.upgrade_time' => '4000'
      ) do
        tech = Factory.create(:technology, :speed_up => true)
        tech.upgrade_time(1, tech.scientists_min).should == \
          (4000.0 / CONFIG['technologies.speed_up.time.mod']).floor
      end
    end
  end

  describe "#scientists_min" do
    it "should support formulas" do
      with_config_values(
        'technologies.test_technology.scientists.min' => '45 * level'
      ) do
        Factory.build(:technology).scientists_min(2).should == 90
      end
    end

    it "should eval with level + 1 at default" do
      technology = Factory.build(:technology, :level => 2)
      technology.scientists_min.should == technology.scientists_min(3)
    end

    it "should round value" do
      with_config_values(
        'technologies.test_technology.scientists.min' => '4.3 * level'
      ) do
        Factory.build(:technology).scientists_min(1).should == 4
      end
    end
  end

  it "should change player.scientists when model.scientists changes" do
    model = Factory.create :technology_upgrading
    player = model.player
    value = 10

    lambda do
      model.change_while_upgrading!(
        :scientists => model.scientists + value
      )
      player.reload
    end.should change(player, :scientists).by(-value)
  end

  it "should not allow create two same technologies for same player" do
    model = Factory.create :technology
    lambda do
      Factory.build(:technology, :player => model.player).save!
    end.should raise_error(ActiveRecord::StatementInvalid)
  end

  describe "#pause!" do
    before(:each) do
      @model = Factory.create :technology_upgrading
      @method = :pause!
    end

    it_behaves_like "releasing scientists"

    it "should store scientists to #pause_scientists" do
      lambda do
        @model.pause!
      end.should change(@model, :pause_scientists).from(nil).to(
        @model.scientists)
    end
  end

  describe "#resume" do
    it "should not allow resuming with less than scientists.min scs" do
      model = Factory.create :technology_paused
      model.scientists = model.scientists_min - 1
      model.resume
      model.should_not be_valid
    end

    it "should not allow resuming if there are not enough scientists" do
      model = Factory.create :technology_paused
      model.scientists = 50
      model.player.scientists = model.scientists - 1
      model.player.save!
      model.resume
      model.should_not be_valid
    end

    it "should take scientists" do
      model = Factory.create :technology_paused
      model.scientists = 50
      player = model.player
      lambda do
        model.resume!
        player.reload
      end.should change(player, :scientists).by(-model.scientists)
    end

    it "should set #pause_scientists to nil" do
      model = Factory.create :technology_paused
      model.scientists = 50
      lambda do
        model.resume!
      end.should change(model, :pause_scientists).from(50).to(nil)
    end

    it "should recalculate pause_remainder according to new scientists" do
      model = Factory.create :technology_paused
      model.scientists = model.pause_scientists * 2

      predicted_time = (
        Time.now + model.send(
          :calculate_new_pause_remainder,
          model.pause_remainder, model.pause_scientists, model.scientists
        )
      )

      model.resume!
      model.upgrade_ends_at.should be_within(SPEC_TIME_PRECISION).of(predicted_time)
    end

    it "should recalculate pause_remainder according to new scientists" +
    " and respect #speed_up" do
      model = Factory.create :technology_paused, :speed_up => true
      scientists = model.pause_scientists * 2

      pause_remainder = model.send(
        :calculate_new_pause_remainder,
        model.pause_remainder, model.pause_scientists, scientists
      )
      predicted_time = Time.now + pause_remainder

      model.reload
      model.scientists = scientists
      
      model.resume!
      model.upgrade_ends_at.should be_within(SPEC_TIME_PRECISION).of(predicted_time)
    end
  end

  describe "updating scientist count" do
    describe "while upgrading" do
      it "should change scientist diff in the player (reducing)" do
        model = Factory.create :technology_upgrading, :scientists => 50
        player = model.player
        lambda do
          model.scientists = model.scientists_min
          model.save!

          player.reload
        end.should change(player, :scientists).by(
          model.scientists - model.scientists_min
        )
      end

      it "should change scientist diff in the player (increasing)" do
        increasement = 10
        model = Factory.create :technology_upgrading, :scientists => 50
        player = model.player
        lambda do
          model.scientists += increasement
          model.save!

          player.reload
        end.should change(player, :scientists).by(-increasement)
      end

      it "should not allow updating if not enough scientists available" do
        model = Factory.create :technology_upgrading

        player = model.player
        player.scientists = 0
        player.save!

        model.scientists += 1
        model.should_not be_valid
      end

      it "should not allow setting scientists below minimum" do
        model = Factory.create :technology_upgrading

        model.scientists = model.scientists_min - 1
        model.should_not be_valid
      end

      it "should recalculate upgrade_ends_at" do
        model = Factory.build :technology_upgrading, :level => 0

        model.scientists = model.scientists_min

        time = model.upgrade_time
        model.upgrade_ends_at = Time.now + time
        model.save!

        model.scientists *= 2
        model.save!

        model.upgrade_ends_at.should be_within(SPEC_TIME_PRECISION).of((time / 2).since)
      end

      it "should update callback to the new time" do
        planet = Factory.create :planet_with_player
        model = Factory.build :technology,
          :level => 0, :planet_id => planet.id,
          :player => planet.player

        model.stub!(:check_upgrade!).and_return(true)
        model.scientists = model.scientists_min
        model.upgrade!

        model.scientists *= 2
        model.save!

        CallbackManager.has?(model,
          CallbackManager::EVENT_UPGRADE_FINISHED,
          model.upgrade_ends_at).should be_true
      end
    end

    describe "while paused" do
      it "should not be valid" do
        technology = Factory.create :technology_paused, :level => 1
        technology.scientists = 200
        technology.should_not be_valid
      end
    end

    describe "while stale" do
      it "should not be valid" do
        technology = Factory.create :technology, :level => 1
        technology.scientists *= 2
        technology.should_not be_valid
      end
    end
  end

  describe "upgradable" do
    before(:each) do
      @player = Factory.create(:player, :science_points => 10000)
      @planet = Factory.create :planet, :player => @player
      Factory.create(:b_research_center, :planet => @planet)
      @model = Factory.build :technology, :planet_id => @planet.id,
        :player => @player, :scientists => 100

      set_resources(@planet,
        @model.metal_cost(@model.level + 1),
        @model.energy_cost(@model.level + 1),
        @model.zetium_cost(@model.level + 1),
        1_000_000, 1_000_000, 1_000_000
      )
    end

    describe "#accelerate!" do
      before(:each) do
        @player.creds += 1000000
        @player.save!
        @model.upgrade!
      end

      it "should not fail scientists validation if upgrading" do
        @player.scientists = 0
        @player.save!
        lambda do
          Creds.accelerate!(@model, 0)
        end.should_not raise_error(ActiveRecord::RecordInvalid)
      end

      it "should not take scientists" do
        @player.reload
        lambda do
          Creds.accelerate!(@model, 0)
          @player.reload
        end.should_not change(@player, :scientists)
      end

      it "should not dispatch player changed twice" do
        should_fire_event(@player, EventBroker::CHANGED, 
          EventBroker::REASON_UPDATED, 1
        ) do
          @model.accelerate!(Creds::ACCELERATE_INSTANT_COMPLETE, 1)
        end
      end

      it "should dispatch event where both scientists and creds " +
      "are correct" do
        SPEC_EVENT_HANDLER.clear_events!
        @model.accelerate!(Creds::ACCELERATE_INSTANT_COMPLETE, 1)
        event = SPEC_EVENT_HANDLER.events.find do
          |e_object, e_event_name, e_reason|
          e_object == [@player] && e_event_name == EventBroker::CHANGED &&
            e_reason == EventBroker::REASON_UPDATED
        end

        @player.reload
        event_player = event[0][0]
        [event_player.scientists, event_player.scientists_total,
          event_player.creds].should == [@player.scientists,
          @player.scientists_total, @player.creds]
      end
    end

    it_behaves_like "upgradable"
  end

  describe "#upgrade" do
    before(:each) do
      @player = Factory.create(:player, 
        :war_points => Technology::TestTechnology.war_points_required(1))
      @planet = Factory.create :planet, :player => @player
      @rc = Factory.create(:b_research_center, :planet => @planet)
      @model = Factory.build :technology, :planet_id => @planet.id,
        :player => @planet.player
      
      set_resources(@planet,
        @model.metal_cost(@model.level + 1),
        @model.energy_cost(@model.level + 1),
        @model.zetium_cost(@model.level + 1)
      )
    end

    it "should require planet_id" do
      lambda do
        Factory.build(:technology).upgrade
      end.should raise_error(ArgumentError)
    end

    it "should not allow taking resources from planet player " +
    "doesn't own" do
      lambda do
        @model.player = Factory.create(:player)
        @model.upgrade
      end.should raise_error(GameLogicError)
    end

    it "should not allow upgrading if planet does not have a " +
    "research center" do
      @rc.destroy
      lambda do
        @model.upgrade
      end.should raise_error(GameLogicError)
    end
    
    it "should not allow upgrading if not enough war points" do
      @player.war_points -= 1
      @player.save!
      
      lambda do
        @model.upgrade
      end.should raise_error(GameLogicError)
    end

    it "should not allow resuming with less than scientists.min scs" do
      @model.scientists = @model.scientists_min - 1
      @model.upgrade
      @model.should_not be_valid
    end

    it "should not allow resuming if there are not enough scientists" do
      @model.scientists = 50
      @model.player.scientists = @model.scientists - 1
      @model.player.save!
      @model.upgrade
      @model.should_not be_valid
    end

    %w{metal energy zetium}.each do |resource|
      it "should multiply #{resource} need if overtime is forced" do
        resources_mod = CONFIG['technologies.speed_up.resources.mod']
        set_resources(
          @planet,
          @model.metal_cost(@model.level + 1) * resources_mod,
          @model.energy_cost(@model.level + 1) * resources_mod,
          @model.zetium_cost(@model.level + 1) * resources_mod
        )

        lambda do
          @model.speed_up = true
          @model.upgrade!
          @planet.reload
        end.should change(@planet, resource).to(0)
      end
    end
  end

  describe "#on_upgrade_finished" do
    before(:each) do
      @model = opts_just_upgraded | Factory.create(:technology)
      @method = :on_upgrade_finished
    end

    it_behaves_like "releasing scientists"

    it "should not raise exception when saved" do
      @model.send(@method)
      lambda { @model.save! }.should_not raise_error
    end
  end
end