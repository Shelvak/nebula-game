# Routes controller. Routes are sent via index action after galaxies|select.
# Updated routes are sent via objects controller.
#
class RoutesController < GenericController
  # Return an array of all routes for current player and his alliance.
  #
  # Invocation: by server
  #
  # Params: None
  #
  # Response:
  # - routes (Route[])
  #
  ACTION_INDEX = 'routes|index'
  # Destroys a route stopping all units which belonged to it.
  #
  # Invocation: by client
  #
  # Parameters:
  # - id (Fixnum): Route id
  #
  # Response: None. However objects|destroyed will be pushed with Route.
  #
  ACTION_DESTROY = 'routes|destroy'

  def invoke(action)
    case action
    when ACTION_INDEX
      only_push!

      respond :routes => Route.where(:player_id => player.friendly_ids).all
    when ACTION_DESTROY
      param_options :required => %w{id}

      route = Route.where(:player_id => player.id).find(params['id'])
      route.destroy
    end
  end
end