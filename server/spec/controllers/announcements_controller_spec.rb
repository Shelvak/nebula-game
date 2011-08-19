require File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')
)

describe AnnouncementsController do
  include ControllerSpecHelper

  before(:each) do
    init_controller AnnouncementsController, :login => true
  end
  
  describe ".set" do
    before(:each) do
      @ends_at = 5.minutes.from_now
      @message = "Hey!"
    end
    
    it "should set announcement" do
      AnnouncementsController.set(@ends_at, @message)
      AnnouncementsController.get.should == [@ends_at, @message]
    end
    
    it "should push it to logged in players" do
      Dispatcher.instance.should_receive(:push_to_logged_in).
        with(AnnouncementsController::ACTION_NEW, 
          {'ends_at' => @ends_at, 'message' => @message})
      AnnouncementsController.set(@ends_at, @message)
    end
    
    it "should clean it up after a while" do
      AnnouncementsController.set(1.second.from_now, @message)
      sleep 2
      AnnouncementsController.get.should == [nil, nil]
    end
    
    it "should not clean it if another announcement uses it" do
      ends_at = 10.seconds.from_now
      message = @message + "!"
      AnnouncementsController.set(1.second.from_now, @message)
      AnnouncementsController.set(ends_at, message)
      sleep 2
      AnnouncementsController.get.should == [ends_at, message]
    end
  end
  
  describe "announcements|new" do
    before(:each) do
      @action = "announcements|new"
      @params = {'message' => "Good day.", 'ends_at' => 5.minutes.from_now}
      @method = :push
    end
    
    @required_params = %w{message ends_at}
    it_should_behave_like "with param options"
    it_should_behave_like "only push"
    
    %w{message ends_at}.each do |attr|
      it "should respond with #{attr}" do
        push @action, @params
        response_should_include(attr.to_sym => @params[attr])
      end
    end
  end
end