class Callback
  attr_reader :id, :klass, :object_id, :event, :ruleset, :ends_at_str

  def initialize(id, klass, object_id, event, ruleset, ends_at_str)
    @id = id.to_i
    @klass = klass
    @object_id = object_id.to_i
    @event = event.to_i
    @ruleset = ruleset
    @ends_at_str = ends_at_str
  end

  def event_str
    CallbackManager::STRING_NAMES[@event]
  end

  def to_s
    "<Callback (#{@id}): #{event_str} on #{@klass} (#{@object_id}) @ #{
      @ends_at_str} (ruleset: #{@ruleset})>"
  end
end