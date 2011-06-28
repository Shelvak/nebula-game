# TODO: spec
module Parts::DelayedEventDispatcher
  def self.included(receiver)
    super(receiver)
    
    receiver.send(:after_save) do
      (@_delayed_events || []).each do |object, event, reason|
        EventBroker.fire(object, event, reason)
      end
      @_delayed_events = Set.new
    end
  end
  
  # Adds _object_ to delayed events list. They will be fired after object
  # is saved.
  def delayed_fire(object, event, reason=nil)
    @_delayed_events ||= Set.new
    @_delayed_events.add [object, event, reason]
  end
end
