# Controller that is responsible for pushing object updates to client.
class ObjectsController < GenericController
  # Pushes information about newly created objects to client.
  #
  # Invocation: by server
  #
  # Params:
  # - objects (Object[]): objects that were created
  #
  # Response:
  # - objects (Object[]): objects that were created
  # - class_name (String): class name of those objects (e.g.
  # "Unit::Trooper")
  #
  ACTION_CREATED = 'objects|created'
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
  # - class_name (String): class name of those objects (e.g.
  # "Unit::Trooper")
  # - reason (String): reason why this object was updated
  #
  ACTION_UPDATED = 'objects|updated'
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
  # - reason (String): reason why this object were destroyed
  # - class_name (String): class name of these objects (e.g.
  # "Unit::Trooper")
  #
  ACTION_DESTROYED = 'objects|destroyed'

  def invoke(action)
    case action
    when ACTION_CREATED
      param_options :required => %w{objects}
      only_push!
      respond :objects => params['objects'],
        :class_name => params['objects'][0].class.to_s
    when ACTION_UPDATED
      param_options :required => %w{objects reason}
      only_push!
      respond :objects => params['objects'],
        :reason => params['reason'].to_s,
        :class_name => params['objects'][0].class.to_s
    when ACTION_DESTROYED
      param_options :required => %w{objects reason}
      only_push!
      respond :object_ids => params['objects'].map(&:id),
        :class_name => params['objects'][0].class.to_s,
        :reason => params['reason']
    end
  end
end