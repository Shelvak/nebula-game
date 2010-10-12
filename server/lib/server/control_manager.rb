# Monolithic class for controlling server.
class ControlManager
  include Singleton

  # Create a new galaxy.
  #
  # Parameters:
  # - ruleset (String): ruleset for given galaxy
  #
  # Response:
  # - galaxy_id (Fixnum): ID of created galaxy
  #
  ACTION_CREATE_GALAXY = 'create_galaxy'

  # Create a new player in galaxy.
  # 
  # Parameters:
  # - galaxy_id (Fixnum)
  # - auth_token (String): 64 char authentication token
  # - name (String): player name
  #
  # Response:
  # - success (Boolean)
  #
  ACTION_CREATE_PLAYER = 'create_player'

  def receive(io, message)
    if message['token'] == CONFIG['control']['token']
      process(io, message)
    else
      io.disconnect(GenericServer::REASON_AUTH_ERROR)
    end
  end

  private
  def process(io, message)
    case message['action']
    when ACTION_CREATE_GALAXY
      action_create_galaxy(io, message)
    when ACTION_CREATE_PLAYER
      action_create_player(io, message)
    end
  end

  def action_create_galaxy(io, message)
    galaxy = Galaxy.new
    galaxy.ruleset = message['ruleset']
    galaxy.save!

    io.send_message :galaxy_id => galaxy.id
  end

  def action_create_player(io, message)
		Galaxy.create_player(message['galaxy_id'], message['name'],
			message['auth_token'])
		io.send_message :success => true
  end
end
