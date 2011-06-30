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
  # - players (Hash): Player#minimal_from_objects. Used to show to
  # whom routes belong.
  #
  def action_index
    only_push!

    # TODO: include support in client
    #routes = Route.where(:player_id => player.friendly_ids).all
    routes = Route.where(:player_id => player.id).all

    respond :routes => routes.map(&:as_json),
      :players => Player.minimal_from_objects(routes)
  end

  # Destroys a route stopping all units which belonged to it.
  #
  # Invocation: by client
  #
  # Parameters:
  # - id (Fixnum): Route id
  #
  # Response: None. However objects|destroyed will be pushed with Route.
  #
  def action_destroy
    param_options :required => %w{id}

    route = Route.where(:player_id => player.id).find(params['id'])
    route.destroy
  end
end