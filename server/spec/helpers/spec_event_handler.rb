class SpecEventHandler
  attr_reader :events

  def initialize
    EventBroker.register(self)
    clear_events!
    @traces = []
  end

  def clear_events!
    @events = []
  end

  def fire(object, event_name, reason)
    @events.push [object, event_name, reason]
    if count(@traces, object, event_name, reason) > 0
      puts "FIRE on #{object} (#{event_name}, #{reason})"
      stacktrace!
    end
  end

  def fired?(object, event_name, reason=nil)
    count(@events, object, event_name, reason)
  end

  def trace!(object, event_name, reason=nil)
    object = EventBroker.prepare(object, event_name)
    @traces.push [object, event_name, reason]
  end

  private
  def count(source, object, event_name, reason)
    object = EventBroker.prepare(object, event_name)
    source.accept do |e_object, e_event_name, e_reason|
      object == e_object && event_name == e_event_name && reason == e_reason
    end.size
  end
end

def should_fire_event(object, event_name, reason=nil, count=nil)
  SPEC_EVENT_HANDLER.clear_events!
  yield
  SPEC_EVENT_HANDLER.should have_fired_event(object, event_name, reason,
    count)
end

def should_not_fire_event(object, event_name, reason=nil, count=nil)
  SPEC_EVENT_HANDLER.clear_events!
  yield
  SPEC_EVENT_HANDLER.should_not have_fired_event(object, event_name, reason,
    count)
end

Spec::Matchers.define :have_fired_event do 
  |object, event_name, reason, count|

  match do |handler|
    @times = handler.fired?(object, event_name, reason)
    @times == (count || 1)
  end

  failure_message_for_should do |handler|
    times = count.nil? ? "once" : "#{count} times"
    "#{object} should have fired event '#{event_name}' (reason: #{
    reason}) #{times} but it did it #{@times} times"
  end
  failure_message_for_should_not do |handler|
    times = count.nil? ? "once" : "#{count} times"

    "#{object} should not have fired event '#{event_name}' (reason: #{
    reason}) #{times} but it did fire it #{@times} times"
  end
  description do
    "Registers if event has been fired."
  end
end