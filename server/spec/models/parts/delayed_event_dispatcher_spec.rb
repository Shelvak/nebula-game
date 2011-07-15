require File.expand_path(
  File.join(File.dirname(__FILE__), '..', '..', 'spec_helper.rb')
)

class DedTest < ActiveRecord::Base
  include Parts::DelayedEventDispatcher
end

describe Parts::DelayedEventDispatcher do
  before(:all) do
    ActiveRecord::Base.connection.execute "DROP TABLE IF EXISTS `ded_tests`"
    ActiveRecord::Base.connection.execute <<EOF
CREATE TABLE `ded_tests` (
  `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY
) ENGINE = MEMORY
EOF
    # Ensure that only SPEC_EVENT_HANDLER gets our test objects.
    handlers = nil
    EventBroker.class_eval do
      handlers = class_variable_get(:"@@handlers")
      class_variable_set(:"@@handlers", Set.new)
      register SPEC_EVENT_HANDLER
    end
    @handlers = handlers
  end
  
  describe "#delayed_fire" do
    before(:each) do
      @model = DedTest.new
    end
    
    it "should not fire immediately" do
      should_not_fire_event(@model, EventBroker::CHANGED) do
        @model.delayed_fire(@model, EventBroker::CHANGED)
      end
    end
    
    it "should fire that event after save" do
      @model.delayed_fire(@model, EventBroker::CHANGED)
      should_fire_event(@model, EventBroker::CHANGED) do
        @model.save!
      end
    end
    
    it "should not fire duplicate events" do
      @model.delayed_fire(@model, EventBroker::CHANGED)
      @model.delayed_fire(@model, EventBroker::CHANGED)
      
      SPEC_EVENT_HANDLER.clear_events!
      @model.save!
      SPEC_EVENT_HANDLER.events.size.should == 1
    end
  end
  
  after(:all) do
    # Restore original handlers
    EventBroker.send(:class_variable_set, :"@@handlers", @handlers)
    ActiveRecord::Base.connection.execute "DROP TABLE IF EXISTS `ded_tests`"
  end
end