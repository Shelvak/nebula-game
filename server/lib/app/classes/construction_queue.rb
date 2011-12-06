# Class for managing ConstructionQueueEntry objects.
#
# Use this in things that need queueing.
#
class ConstructionQueue
  # Count items in queue for _constructor_id_.
  def self.count(constructor_id)
    ConstructionQueueEntry.sum(:count,
      :conditions => {:constructor_id => constructor_id})
  end

  # Pushes new entry to the end of a queue.
  #
  # If type parameters matches count will be increased on last entry.
  # Else create new entry with position + 1.
  #
  # @param constructor_id [Fixnum]
  # @param constructable_type [String]
  # @param prepaid [TrueClass|FalseClass]
  # @param count [Fixnum]
  # @param params [Hash|NilClass]
  def self.push(
    constructor_id, constructable_type, prepaid, count=1, params=nil
  )
    typesig binding,
            Fixnum, String, Boolean, Fixnum, [Hash, NilClass]
    raise ArgumentError.new("count must be greater than 0!") if count < 1

    # Find last entry in constructor queue.
    model = ConstructionQueueEntry.where(:constructor_id => constructor_id).
      except(:order).order("position DESC").first
    position = model ? model.position + 1 : 0

    new_model = ConstructionQueueEntry.new(
      :constructor_id => constructor_id,
      :constructable_type => constructable_type,
      :count => count,
      :position => position,
      :prepaid => prepaid,
      # This is used for FK relation with player.
      :player_id => params.nil? ? nil : params[:player_id],
      :params => params
    )

    return_value = nil
    if model and model.can_merge?(new_model)
      model.reduce_resources!(count) if prepaid
      model.merge!(new_model)
      return_value = model
    else
      new_model.reduce_resources!(count) if prepaid
      new_model.save!
      return_value = new_model
    end

    EventBroker.fire(
      Event::ConstructionQueue.new(constructor_id), EventBroker::CHANGED
    )

    return_value
  end

  # Shift one item from constructors queue.
  def self.shift(constructor_id)
    model = ConstructionQueueEntry.where(:constructor_id => constructor_id).
      first

    reduce(model, 1, false) unless model.nil?

    model
  end

  # Clear constructor queue.
  def self.clear(constructor_id)
    ConstructionQueueEntry.where(:constructor_id => constructor_id).each do
      |entry|

      entry.return_resources!(entry.count) if entry.prepaid?
      entry.destroy!
    end
  end

  # Reduce _count_ from given _model_ or _model_id_. Return resources for
  # prepaid entries.
  #
  # Destroy model if after that count is 0.
  def self.reduce(model_or_id, count=1, return_resources=true)
    model = resolve_model(model_or_id)

    raise GameLogicError.new(
      "Cannot reduce more (#{count}) than model has (#{model.count})!"
    ) if count > model.count

    model.return_resources!(count) if return_resources && model.prepaid?
    if count == model.count
      model.destroy!
      merge_outer(model.constructor_id, model.position)
    else
      model.reduce!(count)
    end

    EventBroker.fire(
      Event::ConstructionQueue.new(model.constructor_id),
      EventBroker::CHANGED
    )

    model
  end

  # Moves _model_ to _position_ shifting all other entries accordingly.
  #
  # If there is model with same _constructable_type_
  #
  def self.move(model_or_id, position, count=nil)
    raise GameLogicError.new("Position must be positive, #{position
      } given!") if position < 0
    model = resolve_model(model_or_id)

    # Not moving anywhere
    return if model.position == position
    old_position = model.position

    # Try to find entry we can merge with (in destination)
    merge_target = ConstructionQueueEntry.find(:first, :conditions =>
        create_conditions_for_merge_target(model, position)
    )

    # Default to move operation
    count ||= model.count

    # Move operation
    if model.count == count
      if merge_target
        merge_target.merge!(model)
      else
        # If we didn't find anything to merge with - move the item.

        # Moving right
        if position > model.position
          ConstructionQueueEntry.update_all(
            "position=position-1",
            [
              "constructor_id=? AND position BETWEEN ? AND ?",
              model.constructor_id,
              model.position + 1,
              position - 1
            ]
          )
          # Move one position to left actually.
          position -= 1
        # Moving left
        elsif position < model.position
          ConstructionQueueEntry.update_all(
            "position=position+1",
            [
              "constructor_id=? AND position BETWEEN ? AND ?",
              model.constructor_id,
              position,
              model.position - 1
            ]
          )
        end

        model.position = position
        model.save!
      end

      # Try to merge outer ones after moving or merging
      merge_outer(model.constructor_id, old_position)
    # Split operation
    else
      model.count -= count
      model.save!

      if merge_target
        merge_target.count += count
        merge_target.save!
      else
        target = ConstructionQueueEntry.new(
          :constructor_id => model.constructor_id,
          :constructable_type => model.constructable_type,
          :params => model.params,
          :position => position,
          :count => count
        )
        target.save!
      end
    end

    EventBroker.fire(
      Event::ConstructionQueue.new(model.constructor_id),
      EventBroker::CHANGED)

    model
  end

  protected
  def self.resolve_model(model_or_id)
    model_or_id.is_a?(ConstructionQueueEntry) \
      ? model_or_id : ConstructionQueueEntry.find(model_or_id)
  end

  def self.merge_outer(constructor_id, old_position)
    # Because entry has been moved out or merged, all entries are shifted
    # left. We now need to check if there is no two items that we can merge.
    # The check must be done in both sides of item to be sure there is
    # nothing to merge.
    [
      [old_position, old_position - 1], [old_position, old_position + 1]
    ].each do |positions|
      outer = ConstructionQueueEntry.where(
        :constructor_id => constructor_id,
        :position => positions
      ).all

      if outer.size == 2
        first, second = outer
        return first.merge!(second) if first.can_merge?(second)
      end
    end
  end

  def self.create_conditions_for_merge_target(model, position)
    condition = "id!=? AND constructor_id=? AND constructable_type=? AND " +
      "position IN (?)"
    args = [
      model.id,
      model.constructor_id,
      model.constructable_type,
      [position - 1, position]
    ]

    # Params is a serializable attribute
    if model.params.nil?
      condition += " AND params IS NULL"
    else
      condition += " AND params=?"
      args.push model.params.to_yaml
    end

    args.unshift condition

    args
  end
end