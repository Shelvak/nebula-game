require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper.rb'))

shared_examples_for "respecting player" do
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
      @limit = 2
      @notifications = [
        Factory.create(:notification, :player => player,
          :created_at => 7.minutes.ago, :starred => false, :read => true),
        Factory.create(:notification, :player => player,
          :created_at => 10.minutes.ago, :starred => false, :read => true),
        Factory.create(:notification, :player => player,
          :created_at => 9.minutes.ago, :starred => false, :read => true),
        Factory.create(:notification, :player => player,
          :created_at => 6.minutes.ago, :starred => false, :read => true),
      ]
      @params = {}
    end

    it_behaves_like "only push"
    it_should_behave_like "having controller action scope"

    it "should limit number of notifications sent" do
      with_config_values('notifications.limit' => @limit) do
        push @action, @params
        response[:notifications].size.should == @limit
      end
    end
    
    it "should include starred notifications over the limit" do
      with_config_values('notifications.limit' => @limit) do
        starred = @notifications[1]
        starred.update_row! ["`starred`=?", true]
        push @action, @params
        response[:notifications].should include(starred.as_json)
      end
    end
    
    it "should include unread notifications over the limit" do
      with_config_values('notifications.limit' => @limit) do
        unread = @notifications[1]
        unread.update_row! ["`read`=?", false]
        push @action, @params
        response[:notifications].should include(unread.as_json)
      end
    end

    it "should include alliance invitation notifications over the limit" do
      with_config_values('notifications.limit' => @limit) do
        invitation = @notifications[1]
        invitation.update_row! ["`event`=?",
                                Notification::EVENT_ALLIANCE_INVITATION]
        push @action, @params
        response[:notifications].should include(invitation.as_json)
      end
    end

    it "should order all notifications by created_at reversed" do
      with_config_values('notifications.limit' => @limit) do
        starred = @notifications[1]
        starred.update_row! ["`starred`=?", true]
        unread = @notifications[2]
        unread.update_row! ["`read`=?", false]
        
        notifications = @notifications.
          sort_by { |n| n.created_at }.reverse.map(&:as_json)

        push @action, @params
        response_should_include(:notifications => notifications)
      end
    end
  end

  describe "notifications|read" do
    before(:each) do
      @action = "notifications|read"
      @notification = Factory.create :notification, :player => player
      @params = {'ids' => [@notification.id]}
    end

    it_behaves_like "with param options", %w{ids}
    it_should_behave_like "having controller action scope"

    it "should mark notifications as read" do
      invoke @action, @params
      @notification.reload
      @notification.should be_read
    end

    it "should respect player" do
      @notification.player = Factory.create(:player)
      @notification.save!
      invoke @action, @params
      @notification.reload
      @notification.should_not be_read
    end
  end

  describe "notifications|star" do
    before(:each) do
      @action = "notifications|star"
      @notification = Factory.create :notification, :player => player
      @params = {'id' => @notification.id, 'mark' => true}
    end

    it_behaves_like "with param options", %w{id mark}
    it_should_behave_like "having controller action scope"

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

    it_behaves_like "respecting player"
  end
end