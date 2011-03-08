# Controller that is responsible for pushing object updates to client.
class ObjectsController < GenericController
  ACTION_CREATED = 'objects|created'
  # Pushes information about newly created objects to client.
  #
  # Invocation: by server
  #
  # Params:
  # - objects (Object[]): objects that were created
  #
  # Response:
  # - objects (Hash): objects that were created:
  #   {
  #     "Unit::Trooper" => [Unit#as_json, ...],
  #     "class_name" => [object, ...]
  #   }
  #
  def action_created
    param_options :required => %w{objects}
    only_push!
    respond :objects => prepare(params['objects'])
  end

  ACTION_UPDATED = 'objects|updated'
  # Pushes information about updated objects to client.
  #
  # Invocation: by server
  #
  # Params:
  # - objects (Object[]): objects that are being updated
  # - reason (Symbol): reason why this object was updated
  #
  # Response:
  # - objects (Object[]): objects that are being updated
  #   {
  #     "Unit::Trooper" => [Unit#as_json, ...],
  #     "class_name" => [object, ...]
  #   }
  # - reason (String): reason why this object was updated
  #
  def action_updated
    param_options :required => %w{objects reason}
    only_push!
    respond :objects => prepare(params['objects']),
      :reason => params['reason'].to_s
  end

  ACTION_DESTROYED = 'objects|destroyed'
  # Pushes information about destroyed objects to client.
  #
  # Invocation: by server
  #
  # Parameters:
  # - objects (Object[]): objects that are being destroyed
  # - reason (String): why they were destroyed
  #
  # Response:
  # - object_ids (Fixnum[]): object ids that are being destroyed
  #   {
  #     "Unit::Trooper" => [1, ...],
  #     "class_name" => [id, ...]
  #   }
  # - reason (String): reason why this object were destroyed
  #
  def action_destroyed
    param_options :required => %w{objects reason}
    only_push!
    respond :object_ids => prepare_destroyed(params['objects']),
      :reason => params['reason']
  end

  protected
  def prepare(objects)
    resolver = StatusResolver.new(player)

    group_by_class(objects).map_values do |class_name, class_objects|
      cast_perspective(class_objects, resolver)
    end
  end
  
  def prepare_destroyed(objects)
    group_by_class(objects).map_values do |class_name, class_objects|
      class_objects.map(&:id)
    end
  end

  def group_by_class(objects)
    objects.group_to_hash { |object| object.class.to_s }
  end

  # Cast given objects to players perspective. E.g. If object is a planet
  # and that player owns it, it should get more data than the one that does
  # not own it.
  def cast_perspective(objects, resolver=nil)
    resolver ||= StatusResolver.new(player)
    
    objects.map do |object|
      case object
      when Unit
        object.as_json(:perspective => resolver)
      when SsObject::Planet
        object.as_json(
          :resources => object.can_view_resources?(player.id),
          :perspective => resolver
        )
      when SsObject::Asteroid
        object.as_json(:resources => true)
      else
        object.as_json
      end
    end
  end
end