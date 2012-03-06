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

  # Returns either object or nil if object cannot be found. If object cannot be
  # found automatically marks this callback as processed.
  #
  # If lock=false, then do not lock object for update when requiring it. This
  # is needed when looking up object for scope resolver.
  def object!(lock=true)
    LOGGER.debug "Resolving object.", tag
    object = lock \
     ? @klass.find(@object_id) \
     : @klass.unscoped { @klass.find(@object_id) }

    LOGGER.debug "Object resolved: #{object}", tag

    object
  rescue ActiveRecord::RecordNotFound
    LOGGER.info "Cannot resolve object (lock=#{lock})", tag

    false
  end

  # Removes callback from the database.
  def destroy!
    ActiveRecord::Base.connection.execute(
      "DELETE FROM `callbacks` WHERE id=#{@id}"
    )
  end

  def type
    CallbackManager::TYPES[@event]
  end

  def to_s
    "<#{tag}: #{type} on #{@klass.to_s} (#{@object_id}) @ #{
      @ends_at_str} (ruleset: #{@ruleset})>"
  end

  def tag
    "callback-#{@id}"
  end
end