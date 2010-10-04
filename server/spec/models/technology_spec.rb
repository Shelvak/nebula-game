require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "releasing scientists", :shared => true do
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
  describe "#to_json" do
    before(:all) do
      @model = Factory.create :technology
    end

    @required_fields = %w{last_update upgrade_ends_at type pause_remainder
    scientists level id pause_scientists}
    @ommited_fields = %w{player_id}
    it_should_behave_like "to json"
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

    it_should_behave_like "releasing scientists"

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
      ).drop_usec

      model.resume!
      model.upgrade_ends_at.drop_usec.should == predicted_time
    end
  end

  describe "updating scientist count" do
    describe "while upgrading" do
      it "should change scientist diff in the player (reducing)" do
        model = Factory.create :technology_upgrading
        model.scientists = 50
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
        model = Factory.create :technology_upgrading
        model.scientists = 50
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
        model = Factory.build :technology_upgrading,
          :last_update => Time.now, :level => 0

        model.scientists = model.scientists_min

        time = model.upgrade_time
        model.upgrade_ends_at = Time.now + time
        model.save!

        model.scientists *= 2
        model.save!

        model.upgrade_ends_at.drop_usec.should == (time / 2).since.drop_usec
      end

      it "should update callback to the new time" do
        planet = Factory.create :planet_with_player
        model = Factory.build :technology,
          :level => 0, :planet_id => planet.id,
          :player => planet.player

        model.stub!(:validate_upgrade).and_return(true)
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
      @planet = Factory.create :planet_with_player
      @re = @planet.resources_entry
      @model = Factory.build :technology, :planet_id => @re.planet_id,
        :player => @planet.player

      set_resources(@re,
        @model.metal_cost(@model.level + 1),
        @model.energy_cost(@model.level + 1),
        @model.zetium_cost(@model.level + 1)
      )
    end

    it_should_behave_like "upgradable"
  end

  describe "#upgrade_time" do
    it "should respect scientists" do
      Factory.build(
        :technology, :scientists => 50, :level => 1
      ).upgrade_time.should_not == Factory.build(
        :technology, :scientists => 100, :level => 1
      ).upgrade_time
    end

    it "should never return negative or zero upgrade time" do
      Factory.build(
        :technology, :scientists => 500000, :level => 1
      ).upgrade_time.should == 1
    end
  end

  describe "#upgrade" do
    before(:each) do
      @planet = Factory.create :planet_with_player
      @re = @planet.resources_entry
      @model = Factory.build :technology, :planet_id => @planet.id,
        :player => @planet.player
      
      set_resources(@re,
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
          @re,
          @model.metal_cost(@model.level + 1) * resources_mod,
          @model.energy_cost(@model.level + 1) * resources_mod,
          @model.zetium_cost(@model.level + 1) * resources_mod
        )

        lambda do
          @model.speed_up = true
          @model.upgrade!
          @re.reload
        end.should change(@re, resource).to(0)
      end
    end

    it "should reduce total time if overtime is forced" do
      resources_mod = CONFIG['technologies.speed_up.resources.mod']
      set_resources(@re,
        @model.metal_cost(@model.level + 1) * resources_mod,
        @model.energy_cost(@model.level + 1) * resources_mod,
        @model.zetium_cost(@model.level + 1) * resources_mod
      )

      # speed_up = true changes formula calc
      time = @model.upgrade_time(@model.level + 1) /
        CONFIG['technologies.speed_up.time.mod']

      @model.speed_up = true
      @model.upgrade
      @model.upgrade_ends_at.drop_usec.should == (
        time.since.drop_usec
      )
    end
  end

  describe "#on_upgrade_finished" do
    before(:each) do
      @model = opts_just_upgraded | Factory.create(:technology)
      @method = :on_upgrade_finished
    end

    it_should_behave_like "releasing scientists"

    it "should not raise exception when saved" do
      @model.send(@method)
      lambda { @model.save! }.should_not raise_error
    end
  end
end