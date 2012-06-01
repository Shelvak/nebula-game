require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

describe Cooldown do
  describe "notifier" do
    it_behaves_like "notifier",
      :build => lambda { Factory.build(:cooldown) },
      :change => lambda { |cooldown| cooldown.ends_at += 1.minute },
      :notify_on_update => true, :notify_on_destroy => false
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
    let(:galaxy) { Factory.create(:galaxy) }
    let(:x) { -20 }
    let(:y) { -14 }
    let(:location) { GalaxyPoint.new(galaxy.id, x, y) }
    let(:expires_at) { 5.minutes.from_now }
    let(:model) { Cooldown.create_or_update!(location, expires_at) }

    shared_examples_for "correct record" do
      it "should set #location" do
        model.location.should == location
      end

      it "should register to callback manager on expiration time" do
        model.
          should have_callback(CallbackManager::EVENT_DESTROY, model.ends_at)
      end
    end

    shared_examples_for "updated record" do
      it_should_behave_like "correct record"

      it "should set #ends_at" do
        model.ends_at.should be_within(SPEC_TIME_PRECISION).of(expires_at)
      end

      it "should save the record" do
        model.should be_saved
      end
    end

    describe "record does not exist" do
      it_should_behave_like "updated record"
    end

    describe "record already exists" do
      describe "#ends_at is in the past" do
        before(:each) do
          Cooldown.create_or_update!(location, expires_at - 2.minutes)
        end

        it_should_behave_like "updated record"
      end

      describe "#ends_at is in the future" do
        let(:old_time) { expires_at + 2.minutes }
        let(:old_model) do
          Cooldown.create_or_update!(location, old_time)
        end

        before(:each) { old_model }

        it_should_behave_like "correct record"

        it "should return same record" do
          model.should == old_model
        end

        it "should not update #ends_at" do
          lambda do
            model
            old_model.reload
          end.should_not change(old_model, :ends_at)
        end

        it "should still have old callback" do
          model.
            should have_callback(CallbackManager::EVENT_DESTROY, old_time)
        end
      end
    end
  end

  describe "callbacks" do
    describe ".destroy_callback" do
      let(:model) { Factory.create(:cooldown) }

      it "should have scope" do
        Cooldown::DESTROY_SCOPE
      end

      it "should delete the model" do
        Cooldown.destroy_callback(model)
        lambda do
          model.reload
        end.should raise_error(ActiveRecord::RecordNotFound)
      end

      it "should check location" do
        Combat::LocationChecker.should_receive(:check_location).
          with(model.location)
        Cooldown.destroy_callback(model)
      end
    end
  end
end