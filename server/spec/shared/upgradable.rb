describe "upgradable", :shared => true do
  describe ".on_upgrade_finished" do
    before(:each) do
      @klass = @model.class.to_s.split("::")[0].constantize
      @klass.stub!(:find).with(@model.id).and_return(@model)
    end

    it ".on_callback should call #on_upgrade_finished" do
      @model.should_receive(:on_upgrade_finished)
      @model.stub!(:save!)
      @klass.on_callback(@model.id,
        CallbackManager::EVENT_UPGRADE_FINISHED)
    end

    it "should dispatch changed (upgrade finished)" do
      opts_upgrading.apply(@model)
      should_fire_event(@model, EventBroker::CHANGED,
          EventBroker::REASON_UPGRADE_FINISHED) do
        @klass.on_callback(@model.id,
          CallbackManager::EVENT_UPGRADE_FINISHED)
      end
    end
  end
  
  describe "#upgrade" do
    it "should call #resume" do
      @model.should_receive(:resume)
      @model.upgrade
    end

    it "should raise exception if we're on max level" do
      @model.level = @model.max_level
      lambda { @model.upgrade }.should raise_error(GameLogicError)
    end

    it "should raise exception if we're currently upgrading" do
      @model.upgrade
      lambda { @model.upgrade }.should raise_error(GameLogicError)
    end

    it "should increase player points" do
      points = @model.points_on_upgrade
      player = @model.player

      lambda do
        @model.upgrade!
        player.reload
      end.should change(player, @model.points_attribute).by(points)
    end
  end

  describe "#upgrade_time" do
    it "should not allow returning < 1" do
      @model.stub!(:calculate_upgrade_time).and_return(0)
      @model.upgrade_time(1).should == 1
    end
  end

  describe "#accelerate!" do
    before(:each) do
      @time = 1.minute
      @values = {'creds.upgradable.speed_up' => [
          [@time, 10],
          [365.days, 10],
          [0, 10]]
      }
      @player.creds += 10
      @player.save!
      @model.upgrade!
      @model.reload
    end

    it "should complain about unknown index" do
      with_config_values(@values) do
        lambda do
          Creds.accelerate!(@model, 3)
        end.should raise_error(ArgumentError)
      end
    end

    it "should fail if we have not enough creds" do
      @player.creds -= 1
      @player.save!

      with_config_values(@values) do
        lambda do
          Creds.accelerate!(@model, 0)
        end.should raise_error(GameLogicError)
      end
    end

    it "should reduce time till upgrade finishes" do
      with_config_values(@values) do
        old_uea = @model.upgrade_ends_at
        Creds.accelerate!(@model, 0)
        @model.upgrade_ends_at.should be_close(
          old_uea - @time,
          SPEC_TIME_PRECISION
        )
      end
    end

    it "should return reduced seconds" do
      with_config_values(@values) do
        old_uea = @model.upgrade_ends_at
        seconds_reduced = Creds.accelerate!(@model, 0)
        (@model.upgrade_ends_at + seconds_reduced).should be_close(
          old_uea,
          SPEC_TIME_PRECISION
        )
      end
    end

    it "should record this acceleration" do
      CredStats.should_receive(:accelerate!).with(@model, @player.creds,
        Creds::ACCELERATE_INSTANT_COMPLETE, an_instance_of(Fixnum))
      @model.accelerate!(Creds::ACCELERATE_INSTANT_COMPLETE, @player.creds)
    end

    it "should dispatch changed" do
      with_config_values(@values) do
        should_fire_event(@model, EventBroker::CHANGED) do
          Creds.accelerate!(@model, 0)
        end
      end
    end

    it "should dispatch changed for player" do
      with_config_values(@values) do
        should_fire_event(@player, EventBroker::CHANGED,
            EventBroker::REASON_UPDATED) do
          Creds.accelerate!(@model, 0)
        end
      end
    end

    it "should complete if we accelerate too much" do
      with_config_values(@values) do
        Creds.accelerate!(@model, 1)
        @model.reload
        @model.should_not be_upgrading
      end
    end

    it "should unregister upgrade finished in CM" do
      with_config_values(@values) do
        Creds.accelerate!(@model, 1)
        @model.should_not have_callback(
          CallbackManager::EVENT_UPGRADE_FINISHED)
      end
    end

    it "should support insta-build" do
      with_config_values(@values) do
        Creds.accelerate!(@model, 2)
        @model.reload
        @model.should_not be_upgrading
      end
    end

    it "should fire changed" do
      with_config_values(@values) do
        should_fire_event(@model, EventBroker::CHANGED,
          EventBroker::REASON_UPGRADE_FINISHED
        ) do
          Creds.accelerate!(@model, 2)
        end
      end
    end

    it "should progress objective" do
      with_config_values(@values) do
        Objective::Accelerate.should_receive(:progress).with([@model])
        Creds.accelerate!(@model, 2)
      end
    end
  end

  describe "#destroy" do
    it "should decrease points for player" do
      points_attribute = @model.points_attribute
      player = @model.player
      player.send(:"#{points_attribute}=", 10000)
      player.save!
      lambda do
        @model.destroy
        player.reload
      end.should change(player, points_attribute).by(
        - @model.points_on_destroy)
    end
  end

  it "should set upgrade_ends_at to some time in #upgrade" do
    @model.upgrade_ends_at.should be_nil
    @model.upgrade
    @model.upgrade_ends_at.drop_usec.should == (
      Time.now + @model.upgrade_time(@model.level + 1)
    ).drop_usec
  end

  %w{metal energy zetium}.each do |resource|
    it "should ceil values in ##{resource}_cost" do
      base, name = @model.class.to_s.split("::").map(&:underscore)
      cfg = "#{base.pluralize}.#{name}"
      with_config_values "#{cfg}.#{resource}.cost" => "0.33 * level" do
        @model.send("#{resource}_cost", 1).should == 1
      end
    end

    it "should not allow upgrading if there are not enough #{resource}" do
      @planet.send(
        "#{resource}=",
        @model.send("#{resource}_cost", @model.level + 1) - 1
      )
      @planet.save!

      lambda do
        @model.upgrade!
      end.should raise_error(NotEnoughResources)
    end

    it "should reduce #{resource} on upgrade" do
      lambda do
        @model.upgrade!
        @planet.reload
      end.should change(@planet, resource).by(
        - @model.send("#{resource}_cost", @model.level + 1)
      )
    end

    it "should not reduce #{resource} on second save" do
      @model.upgrade!
      lambda { @model.save! }.should_not change(@planet, resource)
    end
  end

  it "should allow updating record if it's in upgrading state" do
    @model.save!
    @planet.metal = @model.metal_cost(@model.level + 1) - 1
    @planet.save!

    @model = @model.class.find(@model.id)
    @model.save!
  end

  %w{upgrade_ends_at}.each do |attr|
    it "should set #{attr} to nil in #on_upgrade_finished" do
      value = 1
      opts_upgrading.apply(@model)
      @model.send("#{attr}=", value)
      lambda do
        @model.send(:on_upgrade_finished)
      end.should change(@model, attr).from(value).to(nil)
    end
  end

  it "should upgrade level on finished models in #on_upgrade_finished" do
    opts_upgrading.apply(@model)
    lambda {
      @model.send(:on_upgrade_finished)
    }.should change(@model, :level).by(1)
  end

  it "should unregister from CallbackManager on #pause!" do
    CallbackManager.should_receive(:unregister).with(@model)
    @model.upgrade_ends_at = 5.minutes.since
    @model.pause!
  end

  %w{upgrade_ends_at}.each do |attr|
    it "should clear #{attr} on #pause" do
      @model.send("#{attr}=", 1)
      @model.upgrade_ends_at = 5.minutes.since
      lambda { @model.pause }.should change(@model, attr).to(nil)
    end
  end

  it "should store remaining time to pause_remainder on #pause" do
    @model.upgrade_ends_at = 5.minutes.since
    @model.pause
    @model.pause_remainder.should be_close(5.minutes, SPEC_TIME_PRECISION)
  end

  it "should register to CallbackManager on #resume!" do
    @model.pause_remainder = 100
    CallbackManager.should_receive(:register_or_update).with(@model)
    @model.resume!
  end

  it "should set upgrade_ends_at on #resume" do
    remainder = 5.minutes
    @model.pause_remainder = remainder
    @model.resume
    @model.upgrade_ends_at.drop_usec.should == remainder.since.drop_usec
  end

  it "should clear pause_remainder on #resume" do
    @model.pause_remainder = 1
    lambda { @model.resume }.should change(@model, :pause_remainder).to(nil)
  end
end