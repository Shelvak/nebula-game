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
      should_fire_event(@model, EventBroker::CHANGED,
          EventBroker::REASON_UPGRADE_FINISHED) do
        @klass.on_callback(@model.id,
          CallbackManager::EVENT_UPGRADE_FINISHED)
      end
    end
  end

  describe "#update_upgrade_properties!" do
    it "should return correct time diff to block" do
      @model.level = 1
      @model.last_update = 5.seconds.ago.drop_usec
      @model.upgrade_ends_at = 10.minutes.since.drop_usec

      @model.send(:update_upgrade_properties!) do |now, diff|
        diff.should == 5
      end
    end

    it "should return correct time diff if Time.now > upgrade_ends_at" do
      @model.level = 1
      @model.last_update = 5.seconds.ago.drop_usec
      @model.upgrade_ends_at = 2.seconds.ago.drop_usec

      @model.send(:update_upgrade_properties!) do |now, diff|
        diff.should == 3
      end
    end
  end

  it "should call #resume on #upgrade" do
    @model.should_receive(:resume)
    @model.upgrade
  end

  it "should raise exception if we're on max level in #upgrade" do
    @model.level = @model.max_level
    lambda { @model.upgrade }.should raise_error(GameLogicError)
  end

  it "should raise exception if we're currently upgrading in #upgrade" do
    @model.upgrade
    lambda { @model.upgrade }.should raise_error(GameLogicError)
  end

  %w{last_update}.each do |attr|
    it "should set #{attr} to NOW in #upgrade" do
      @model.upgrade
      @model.send(attr).drop_usec.should == Time.now.drop_usec
    end
  end

  describe "#upgrade_time" do
    it "should not allow returning < 1" do
      @model.stub!(:calculate_upgrade_time).and_return(0)
      @model.upgrade_time(1).should == 1
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

  %w{last_update pause_remainder upgrade_ends_at}.each do |attr|
    it "should set #{attr} to nil in #on_upgrade_finished" do
      value = 1
      @model.send("#{attr}=", value)
      lambda do
        @model.send(:on_upgrade_finished)
      end.should change(@model, attr).from(value).to(nil)
    end
  end

  it "should upgrade level on finished models in #on_upgrade_finished" do
    lambda {
      @model.send(:on_upgrade_finished)
    }.should change(@model, :level).by(1)
  end

  it "should #update_upgrade_properties! if it needs update after_find" do
    @model.last_update = 5.seconds.ago
    @model.upgrade_ends_at = 10.minutes.since
    @model.should_receive(:update_upgrade_properties!)
    @model.run_callbacks(:find)
  end

  it "should not #update_upgrade_properties! " +
  "if it's not upgrading after_find" do
    @model.upgrade_ends_at = nil
    @model.should_not_receive(:update_hp!)
    @model.run_callbacks(:find)
  end

  it "should not #update_upgrade_properties! " +
  "if it's already updated after_find" do
    @model.last_update = Time.now
    @model.upgrade_ends_at = 10.minutes.since
    @model.should_not_receive(:update_hp!)
    @model.run_callbacks(:find)
  end

  it "should unregister from CallbackManager on #pause!" do
    CallbackManager.should_receive(:unregister).with(@model)
    @model.last_update = Time.now
    @model.upgrade_ends_at = 5.minutes.since
    @model.pause!
  end

  %w{last_update upgrade_ends_at}.each do |attr|
    it "should clear #{attr} on #pause" do
      @model.send("#{attr}=", 1)
      @model.last_update = Time.now
      @model.upgrade_ends_at = 5.minutes.since
      lambda { @model.pause }.should change(@model, attr).to(nil)
    end
  end

  it "should store remaining time to pause_remainder on #pause" do
    @model.last_update = Time.now
    @model.upgrade_ends_at = 5.minutes.since
    @model.pause
    @model.pause_remainder.should == 5.minutes
  end

  it "should register to CallbackManager on #resume!" do
    @model.pause_remainder = 100
    CallbackManager.should_receive(:register).with(@model)
    @model.resume!
  end

  it "should set last_update on #resume" do
    @model.pause_remainder = 100
    @model.resume
    @model.last_update.drop_usec.should == Time.now.drop_usec
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