# Monolithic class for controlling server.
class ControlManager
  include Singleton

  # Create a new player in galaxy.
  # 
  # Parameters:
  # - galaxy_id (Fixnum)
  # - auth_token (String): 64 char authentication token
  # - name (String): player name
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
    when ACTION_CREATE_PLAYER
      action_create_player(io, message)
    end
  end

  def action_create_player(io, message)
    EventMachine.defer(
      lambda do
        Galaxy.create_player(message['galaxy_id'], message['name'],
          message['auth_token'])
      end,
      lambda do
        io.send_message :success => true
      end
    )
  end
end
