class ResourcesController < GenericController
  # Index of all resources in the planet.
  #
  # Invocation: by server.
  #
  # Parameters:
  # - resources_entry (SsObject::Planet)
  #
  # Response:
  # - resources_entry (SsObject::Planet)
  #
  ACTION_INDEX = 'resources|index'

  def invoke(action)
    case action
    when ACTION_INDEX
      param_options :required => %w{resources_entry}
      only_push!

      respond :resources_entry => params['resources_entry']
    end
  end
end