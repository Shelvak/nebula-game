require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "respecting player", :shared => true do
  it "should not allow changing other player notifications" do
    @notification.player = Factory.create :player
    @notification.save!
    lambda do
      invoke @action, @params
    end.should raise_error(ActiveRecord::RecordNotFound)
  end
end

describe NotificationsController do
  include ControllerSpecHelper

  before(:each) do
    init_controller NotificationsController, :login => true
  end
  
  describe "notifications|index" do
    before(:each) do
      @action = "notifications|index"
      @notifications = [
        Factory.create(:notification, :player => player),
        Factory.create(:notification, :player => player),
        Factory.create(:notification, :player => player),
      ]
      @params = {}
    end
    
    it_should_behave_like "only push"

    it "should respond with player notifications" do
      should_respond_with :notifications => @notifications
      push @action, @params
    end
  end

  describe "notifications|read" do
    before(:each) do
      @action = "notifications|read"
      @notification = Factory.create :notification, :player => player
      @params = {'id' => @notification.id}
    end

    @required_params = %w{id}
    it_should_behave_like "with param options"

    it "should mark notification as read" do
      invoke @action, @params
      @notification.reload
      @notification.should be_read
    end

    it_should_behave_like "respecting player"
  end

  describe "notifications|star" do
    before(:each) do
      @action = "notifications|star"
      @notification = Factory.create :notification, :player => player
      @params = {'id' => @notification.id, 'mark' => true}
    end

    @required_params = %w{id mark}
    it_should_behave_like "with param options"

    [
      ['starred', :should, true],
      ['not starred', :should_not, false]
    ].each do |text, method, value|
      it "should mark notification as #{text}" do
        invoke @action, @params.merge('mark' => value)
        @notification.reload
        @notification.send(method, be_starred)
      end
    end

    it_should_behave_like "respecting player"
  end
end