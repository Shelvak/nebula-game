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

  # Report usage statistics.
  #
  # Parameters: None
  #
  # Response:
  # - current (Fixnum): no. of currently logged in players.
  # - 6h (Fixnum): no. of players logged in 6 hours.
  # - 12h (Fixnum): no. of players logged in 12 hours.
  # - 24h (Fixnum): no. of players logged in 24 hours.
  # - 48h (Fixnum): no. of players logged in 48 hours.
  # - total (Fixnum): total no. of players
  #
  ACTION_STATISTICS = 'statistics'

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
    when ACTION_STATISTICS
      action_statistics(io)
    end
  end

  def action_create_galaxy(io, message)
    galaxy_id = Galaxy.create_galaxy(message['ruleset'])
    io.send_message :galaxy_id => galaxy_id
  end

  def action_create_player(io, message)
		Galaxy.create_player(message['galaxy_id'], message['name'],
			message['auth_token'])
		io.send_message :success => true
  end

  def action_statistics(io)
    statistics = {
      :current => Dispatcher.instance.logged_in_count,
      :"6h" => get_player_count_in(6.hours),
      :"12h" => get_player_count_in(12.hours),
      :"24h" => get_player_count_in(24.hours),
      :"48h" => get_player_count_in(48.hours),
      :total => Player.count,
    }

    io.send_message statistics
  end

  # Returns how much players were logged in in last _time_ seconds.
  def get_player_count_in(time)
    Player.connection.select_value(
      "SELECT COUNT(*) FROM `#{Player.table_name}` WHERE last_login >= '#{
      (Time.now - time).to_s(:db)}'")
  end
end
