class Reducer::ScientistsReducer < Reducer  
  def self.before_releasing
    # Reduce extras if possible
    index = 0
    @downsized_targets = []
    while @resource_needed > 0 and index < @target_count
      target = @targets[index]
      target_resource = @states[target][1]
      min_resource = get_min_resource(target)
      if target_resource > min_resource
        # Reduce required scientist count (don't reduce more scs than we
        # need).
        reduce_by = [
          target_resource - min_resource, @resource_needed
        ].min
        @resource_needed -= reduce_by

        @states[target] = [CHANGED, target_resource - reduce_by]
        @downsized_targets.push [target, reduce_by]
      end

      index += 1
    end
  end

  def self.after_releasing
    # Try to restore downsized targets from other way around
    index = @downsized_targets.size - 1
    while @resource_needed < 0 and index >= 0
      target, reduced_by = @downsized_targets[index]
      state, target_resource = @states[target]

      # We can only restore changed targets
      if state == :changed and reduced_by <= -@resource_needed
        @states[target][1] += reduced_by
        @resource_needed += reduced_by
      end

      index -= 1
    end
  end

  def self.get_resource(target)
    target.scientists
  end

  def self.get_min_resource(target)
    target.scientists_min
  end

  def self.release_resource(target)
    target.pause!
  end

  def self.change_resource(target, target_resource)
    target.change_while_upgrading!(
      :scientists => target_resource
    )
  end
end
