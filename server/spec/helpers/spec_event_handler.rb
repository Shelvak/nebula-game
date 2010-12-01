class SpecEventHandler
  attr_reader :events

  def initialize
    EventBroker.register(self)
    clear_events!
  end

  def clear_events!
    @events = []
  end

  def fire(object, event_name, reason)
    @events.push [object, event_name, reason]
  end

  def fired?(object, event_name, reason=nil)
    object = EventBroker.prepare(object, event_name)
    # Use find to support an_instance_of()
    ! @events.find do |e_object, e_event_name, e_reason|
      object == e_object && event_name == e_event_name && reason == e_reason
    end.nil?
  end
end
  
SPEC_EVENT_HANDLER = SpecEventHandler.new

def should_fire_event(object, event_name, reason=nil)
  SPEC_EVENT_HANDLER.clear_events!
  yield
  SPEC_EVENT_HANDLER.should have_fired_event(object, event_name, reason)
end

def should_not_fire_event(object, event_name, reason=nil)
  SPEC_EVENT_HANDLER.clear_events!
  yield
  SPEC_EVENT_HANDLER.should_not have_fired_event(object, event_name, reason)
end

Spec::Matchers.define :have_fired_event do |object, event_name, reason|
  match do |handler|
    handler.fired?(object, event_name, reason)
  end

  failure_message_for_should do |handler|
    "#{object} should have fired event '#{event_name}' (reason: #{
    reason}) but it didn't"
  end
  failure_message_for_should_not do |handler|
    "#{object} should have not fired event '#{event_name}' (reason: #{
    reason}) but it did"
  end
  description do
    "Registers if event has been fired."
  end
end