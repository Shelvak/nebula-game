# Models should fire events to this class instead of working with handlers
# directly.
class EventBroker
  CREATED = :created
  CHANGED = :changed
  DESTROYED = :destroyed
  REASON_DEACTIVATED = :deactivated
  REASON_ACTIVATED = :activated
  REASON_UPDATED = :updated
  REASON_CONSTRUCTABLE_CHANGED = :constructable_changed
  REASON_UPGRADE_FINISHED = :upgrade_finished
  # Units were loaded into other unit.
  REASON_LOADED = :loaded
  # Units were unloaded to planet.
  REASON_UNLOADED = :unloaded
  # Units are being moved.
  MOVEMENT = :movement
  # Units are being prepared for movement.
  MOVEMENT_PREPARE = :movement_prepare
  # Units are being moved between different zones.
  REASON_BETWEEN_ZONES = :between_zones
  # Units are being moved in same zone.
  REASON_IN_ZONE = :in_zone
  # FOW entries changed
  FOW_CHANGE = :fow_change
  # FOW entry changed was galaxy entry
  REASON_GALAXY_ENTRY = :galaxy_entry
  # FOW entry changed was solar system entry
  REASON_SS_ENTRY = :ss_entry
  # Planet owner has changed
  REASON_OWNER_CHANGED = :owner_changed
  # Player has claimed his reward
  REASON_REWARD_CLAIMED = :reward_claimed

  @@handlers = Set.new

  def self.register(handler)
    @@handlers.add(handler)
  end

  def self.unregister(handler)
    @@handlers.delete(handler)
  end

  def self.fire(object, event_name, reason=nil)
    object = prepare(object, event_name)

    LOGGER.block("EB: '#{event_name}' fired for #{object.to_s}, reason: #{
      reason}",
    :level => :debug) do
      @@handlers.each do |handler|
        handler.fire(object, event_name, reason)
      end
    end
  end

  # Wraps _object_ in Array if it is not Array and _event_name_ is
  # +CREATED+, +CHANGED+ or +DESTROYED+.
  def self.prepare(object, event_name)
    if (event_name == CREATED || event_name == CHANGED ||
        event_name == DESTROYED)
      if object.is_a?(ActiveRecord::Relation)
        object = object.all
      elsif ! object.is_a?(Array)
        object = [object]
      end
    end

    object
  end
end
