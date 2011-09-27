require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe Cooldown do
  describe "notifier" do
    it_behaves_like "notifier",
      :build => lambda { Factory.build(:cooldown) },
      :change => lambda { |cooldown| cooldown.ends_at += 1.minute },
      :notify_on_update => false, :notify_on_destroy => false
  end

  describe "#as_json" do
    required_fields = %w{location ends_at}
    it_behaves_like "as json", Factory.create(:cooldown), nil,
                    required_fields,
                    Cooldown.column_names - required_fields
  end

  describe ".for_planet" do
    it "should return nil if planet has no cooldown" do
      Cooldown.for_planet(Factory.create(:planet)).should be_nil
    end

    it "should return #ends_at if planet has a cooldown" do
      planet = Factory.create(:planet)
      cooldown = Factory.create(:cooldown, :location => planet)
      Cooldown.for_planet(planet).should == cooldown.ends_at
    end
  end

  describe ".create_or_update!" do
    before(:each) do
      @id = (Cooldown.maximum(:id) || 0) + 1
      @x = -20
      @y = -14
      @location = GalaxyPoint.new(@id, @x, @y)
      @expires_at = 5.minutes.since
    end

    it "should create new record if no such record exists" do
      model = Cooldown.create_unless_exists(@location, @expires_at)
      model.should_not be_new_record
    end

    it "should register to callback manager on expiration time" do
      CallbackManager.should_receive(:register).with(
        an_instance_of(Cooldown), CallbackManager::EVENT_DESTROY,
        @expires_at
      )
      Cooldown.create_unless_exists(@location, @expires_at)
    end
    
    it "should not do anything if record exists" do
      expires_at = @expires_at + 10.minutes
      original = Cooldown.create_unless_exists(@location, @expires_at)
      lambda do
        Cooldown.create_unless_exists(@location, expires_at)
        original.reload
      end.should_not change(original, :ends_at)
    end
  end

  describe ".on_callback" do
    it "should delete the model" do
      model = Factory.create(:cooldown)
      Cooldown.on_callback(model.id, CallbackManager::EVENT_DESTROY)
      lambda do
        model.reload
      end.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "should check location" do
      model = Factory.create(:cooldown)
      Combat::LocationChecker.should_receive(:check_location).with(
        model.location)
      Cooldown.on_callback(
        model.id,
        CallbackManager::EVENT_DESTROY
      )
    end

    it "should raise ArgumentError on unknown event" do
      lambda do
        Cooldown.on_callback(1,
          CallbackManager::EVENT_CONSTRUCTION_FINISHED)
      end.should raise_error(ArgumentError)
    end
  end
end