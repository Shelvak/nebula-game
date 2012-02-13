class Callback
  attr_reader :id, :class_name, :object_id, :event, :ruleset, :ends_at_str

  def initialize(id, class_name, object_id, event, ruleset, ends_at_str)
    @id = id.to_i
    @class_name = class_name
    @object_id = object_id.to_i
    @event = event.to_i
    @ruleset = ruleset
    @ends_at_str = ends_at_str
  end

  def klass
    @class_name.constantize
  end

  def object
    klass.find(@object_id)
  end

  def method_name
    CallbackManager::METHOD_NAMES[@event]
  end

  def to_s
    "<Callback (#{@id}): #{method_name} on #{@klass} (#{@object_id}) @ #{
      @ends_at_str} (ruleset: #{@ruleset})>"
  end
end