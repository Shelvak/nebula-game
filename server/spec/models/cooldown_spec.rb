require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe Cooldown do
  describe "#as_json" do
    before(:each) do
      @model = Factory.create(:cooldown)
    end

    @required_fields = %w{location ends_at}
    @ommited_fields = Cooldown.column_names - @required_fields
    it_should_behave_like "to json"
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
      model = Cooldown.create_or_update!(@location, @expires_at)
      model.should_not be_new_record
    end

    it "should register to callback manager on expiration time" do
      CallbackManager.should_receive(:register).with(
        an_instance_of(Cooldown), CallbackManager::EVENT_DESTROY,
        @expires_at
      )
      Cooldown.create_or_update!(@location, @expires_at)
    end

    it "should update at callback manager if being updated" do
      expires_at = @expires_at + 10.minutes
      original = Cooldown.create_or_update!(@location, @expires_at)
      CallbackManager.should_receive(:update).with(original,
        CallbackManager::EVENT_DESTROY, expires_at)
      Cooldown.create_or_update!(@location, expires_at)
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
      Combat.should_receive(:check_location).with(model.location)
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