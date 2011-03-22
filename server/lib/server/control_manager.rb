require 'net/http'
require 'uri'

# Monolithic class for controlling server.
class ControlManager
  include Singleton

  # Create a new galaxy.
  #
  # Parameters:
  # - ruleset (String): ruleset for given galaxy
  #
  # Response:
  # - success (Boolean): Did creation succeeded?
  # - galaxy_id (Fixnum): ID of created galaxy
  #
  ACTION_CREATE_GALAXY = 'create_galaxy'

  # Destroy an existing galaxy.
  #
  # Parameters:
  # - id (Fixnum): id of galaxy to be destroyed.
  #
  # Response:
  # - success (Boolean)
  #
  ACTION_DESTROY_GALAXY = 'destroy_galaxy'

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

  # Destroy an existing player.
  #
  # Parameters:
  # - galaxy_id (Fixnum)
  # - auth_token (String): 64 char authentication token
  #
  # Response:
  # - success (Boolean)
  #
  ACTION_DESTROY_PLAYER = 'destroy_player'

  # Adds creds to player.
  #
  # Parameters:
  # - galaxy_id (Fixnum)
  # - auth_token (String): 64 char authentication token
  # - creds: (Fixnum): number of creds to add
  #
  # Response:
  # - success (Boolean)
  #
  ACTION_ADD_CREDS = 'add_creds'

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

  def player_destroyed(player)
    if ENV['environment'] == 'production'
      Net::HTTP.post_form(URI.parse(CONFIG['control']['web_url'] +
            '/remove_player_from_galaxy'),
            'player_auth_token' => player.auth_token,
            'server_galaxy_id' => player.galaxy_id,
            'secret_key' => CONFIG['control']['token'])
    end
  end

  private
  def process(io, message)
    case message['action']
    when ACTION_CREATE_GALAXY
      action_create_galaxy(io, message)
    when ACTION_DESTROY_GALAXY
      action_destroy_galaxy(io, message)
    when ACTION_CREATE_PLAYER
      action_create_player(io, message)
    when ACTION_DESTROY_PLAYER
      action_destroy_player(io, message)
    when ACTION_ADD_CREDS
      action_add_creds(io, message)
    when ACTION_STATISTICS
      action_statistics(io)
    end
  end

  def action_create_galaxy(io, message)
    galaxy_id = Galaxy.create_galaxy(message['ruleset'])
    io.send_message :success => true, :galaxy_id => galaxy_id
  rescue Exception => e
    io.send_message :success => false, :galaxy_id => nil
    raise e
  end

  def action_destroy_galaxy(io, message)
    Galaxy.find(message['id']).destroy
    io.send_message :success => true
  rescue ActiveRecord::RecordNotFound
    io.send_message :success => true
  rescue Exception => e
    io.send_message :success => false
    raise e
  end

  def action_create_player(io, message)
		Galaxy.create_player(message['galaxy_id'], message['name'],
			message['auth_token'])
		io.send_message :success => true
  rescue Exception => e
    io.send_message :success => false
    raise e
  end
  
  def action_destroy_player(io, message)
    player = find_player(message)
    if player
      player.destroy
      io.send_message :success => true
    else
      io.send_message :success => false
    end
  rescue Exception => e
    io.send_message :success => false
    raise e
  end

  def action_add_creds(io, message)
    player = find_player(message)
    if player
      player.creds += message['creds']
      player.save!
      io.send_message :success => true
    else
      io.send_message :success => false
    end
  rescue Exception => e
    io.send_message :success => false
    raise e
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

  private

  # Returns how much players were logged in in last _time_ seconds.
  def get_player_count_in(time)
    Player.connection.select_value(
      "SELECT COUNT(*) FROM `#{Player.table_name}` WHERE last_login >= '#{
      (Time.now - time).to_s(:db)}'")
  end

  def find_player(message)
    Player.where(:galaxy_id => message['galaxy_id'],
      :auth_token => message['auth_token']).first
  end
end
