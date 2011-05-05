require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

describe Combat::LocationCheckerAj do
  describe ".check_location" do
    before(:each) do
      @location = Factory.create(:planet)
      @location_point = @location.location_point
    end
    
    it "should create a cooldown if conflict" do
      check_report = Combat::CheckReport.new(
        Combat::CheckReport::CONFLICT, {}
      )
      Combat::LocationCheckerAj.stub!(:check_for_enemies).and_return(
        check_report)
      Combat::LocationCheckerAj.check_location(@location_point)
      @location.should have_cooldown(
        CONFIG['combat.cooldown.after_jump.duration'].from_now)
    end
    
    it "should not create a cooldown if no conflict" do
      check_report = Combat::CheckReport.new(
        Combat::CheckReport::NO_CONFLICT, {}
      )
      Combat::LocationCheckerAj.stub!(:check_for_enemies).and_return(
        check_report)
      Combat::LocationCheckerAj.check_location(@location_point)
      @location.should_not have_cooldown(
        CONFIG['combat.cooldown.after_jump.duration'].from_now)
    end

    it "should try to annex if no conflict" do
      check_report = Combat::CheckReport.new(
        Combat::CheckReport::NO_CONFLICT, {}
      )
      Combat::LocationCheckerAj.stub!(:check_for_enemies).and_return(
        check_report)
      Combat::Annexer.should_receive(:annex!)
      Combat::LocationCheckerAj.check_location(@location_point)
    end
    
    it "should not try to annex if conflict" do
      check_report = Combat::CheckReport.new(
        Combat::CheckReport::CONFLICT, {}
      )
      Combat::LocationCheckerAj.stub!(:check_for_enemies).and_return(
        check_report)
      Combat::Annexer.should_not_receive(:annex!)
      Combat::LocationCheckerAj.check_location(@location_point)
    end
  end
end