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

  # Returns either object or nil if object cannot be found. If object cannot be
  # found automatically marks this callback as processed.
  def object!
    LOGGER.debug "Resolving object.", tag
    object = klass.where(:id => @object_id).first

    if object.nil?
      LOGGER.info "Callback #{self} cannot find its object. It must have " +
        "been destroyed. Marking callback as processed.", tag
      Celluloid::Actor[:callback_manager].processed!(self)
      return
    end

    LOGGER.debug "Object resolved: #{object}", tag

    object
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
    "<#{tag}: #{type} on #{@class_name} (#{@object_id}) @ #{
      @ends_at_str} (ruleset: #{@ruleset})>"
  end

  def tag
    "callback-#{@id}"
  end
end