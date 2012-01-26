# Algorithm that reduces usage of some resource (resource, energy, etc)
# by minimal amount to provide enough available resource.
class Reducer
  # Resource was unchanged.
  UNCHANGED = :unchanged
  # All resource was released.
  RELEASED = :released
  # Resource has been changed to smaller value.
  CHANGED = :changed

  # Reduce _targets_ to provide _required_ amount of resource.
  #
  def self.reduce(targets, required)
    return [] unless required > 0
    @targets = targets
    @resource_needed = required

    # Create temporary states hash to prevent modifications to actual
    # targets until final changeset is known.
    @states = {}
    @targets.each do |target|
      # state, current value
      @states[target] = [UNCHANGED, get_resource(target)]
    end

    @target_count = @targets.size

    before_releasing

    # Release targets until we have required resource count
    index = 0

    # Create array for storing targets that are released
    released_targets = []

    while @resource_needed > 0 and index < @target_count
      target = @targets[index]
      target_resource = @states[target][1]
      @resource_needed -= target_resource

      @states[target] = [RELEASED, 0]
      released_targets.push target

      index += 1
    end

    # Try to acquire released targets from other way around
    index = released_targets.size - 1
    while @resource_needed < 0 and index >= 0
      target = released_targets[index]
      target_resource = get_resource(target)
      target_min_resource = get_min_resource(target)
      # Only unpause targets that we are capable to
      if @resource_needed + target_min_resource <= 0
        state = target_resource == target_min_resource \
          ? UNCHANGED : CHANGED
        @states[target] = [state, target_min_resource]
        @resource_needed += target_min_resource
      end

      index -= 1
    end

    after_releasing

    changes = []
    # Change target resource. This will update player resource
    # in the db making sure we don't go negative.
    @states.each do |target, data|
      state, target_resource = data
      case state
      when RELEASED
        changes.push [target, state]
        release_resource(target)
      when CHANGED
        current = get_resource(target)
        changes.push [target, state, current, target_resource]
        change_resource(target, target_resource)
      end
    end

    changes
  end

  def self.before_releasing
  end

  def self.after_releasing
  end

  # Get current resource aquisition.
  def self.get_resource(target)
    raise NotImplementedError.new(
      "Please subclass #{self.class
        } and implement static get_resource method!")
  end

  # Get minimal resource aquisition.
  def self.get_min_resource(target)
    raise NotImplementedError.new(
      "Please subclass #{self.class
        } and implement static get_min_resource method!")
  end

  def self.release_resource(target)
    raise NotImplementedError.new(
      "Please subclass #{self.class
        } and implement static release_resource method!")
  end

  def self.change_resource(target, target_resource)
    raise NotImplementedError.new(
      "Changing resource is not implemented! Please subclass #{self.class
        } and implement static change_resource method!")
  end
end
