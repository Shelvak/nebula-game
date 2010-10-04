class LoginController < GenericController
  def self.priority; -10; end

  # Log player in.
  #
  # Parameters:
  # - auth_token (String): authentification token for player
  # - galaxy_id (Fixnum): galaxy ID player wants to log in to.
  #
  # Return message params:
  # - success (Boolean)
  ACTION_LOGIN = 'players|login'
  ACTION_LOGOUT = 'players|logout'

  def invoke(action)
    case action
    when ACTION_LOGIN
      param_options :required => %w{auth_token galaxy_id}

      player = Player.find(:first, :conditions => {
          :auth_token => params['auth_token'],
          :galaxy_id => params['galaxy_id']
        })
      if player
        login player
        push GameController::ACTION_CONFIG
        push PlayersController::ACTION_SHOW
        push PlanetsController::ACTION_PLAYER_INDEX
        push TechnologiesController::ACTION_INDEX
        push QuestsController::ACTION_INDEX
        push NotificationsController::ACTION_INDEX
        push RoutesController::ACTION_INDEX
        respond :success => true
      else
        respond :success => false
        disconnect
      end
    when ACTION_LOGOUT
      disconnect
    when CombatLogsController::ACTION_SHOW
      # Do nothing, we allow to work without authorization with this one.
    else
      disconnect "Not logged in." unless logged_in?
    end
  end
end
