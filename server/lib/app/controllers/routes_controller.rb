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
  ACTION_INDEX = 'routes|index'

  def self.index_options; logged_in + only_push; end
  def self.index_scope(message); scope.players(message.player.friendly_ids); end
  def self.index_action(m)
    routes = Route.where(:player_id => m.player.friendly_ids).all

    respond m,
      :routes => routes.map(&:as_json),
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
    route.destroy!
  end
end