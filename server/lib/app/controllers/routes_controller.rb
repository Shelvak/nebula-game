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

  INDEX_OPTIONS = logged_in + only_push
  INDEX_SCOPE = scope.world
  def self.index_action(m)
    without_locking do
      routes = Route.where(:player_id => m.player.friendly_ids).all

      respond m,
        :routes => routes.map(&:as_json),
        :players => Player.minimal_from_objects(routes)
    end
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
  ACTION_DESTROY = 'routes|destroy'

  DESTROY_OPTIONS = logged_in + required(:id => Fixnum)
  DESTROY_SCOPE = scope.world
  def self.destroy_action(m)
    route = Route.where(:player_id => m.player.id).find(m.params['id'])
    route.destroy!
  end
end