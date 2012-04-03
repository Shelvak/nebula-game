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
  def object!
    LOGGER.debug "Resolving object.", tag
    object = @klass.find(@object_id)

    LOGGER.debug "Object resolved: #{object}", tag

    object
  rescue ActiveRecord::RecordNotFound => e
    LOGGER.info "Cannot resolve object: #{e.message}", tag

    nil
  end

  # Removes callback from the database.
  def destroy!; self.class.destroy!(@id); end

  # Removes callback from the database by id.
  def self.destroy!(id)
    ActiveRecord::Base.connection.execute(
      "DELETE FROM `callbacks` WHERE id=#{id}"
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