require 'net/http'
require 'uri'

# Monolithic class for controlling server.
class ControlManager
  class Error < RuntimeError; end
  
  TAG = "ControlManager"

  include Singleton

  # Create a new galaxy.
  #
  # Parameters:
  # - ruleset (String): ruleset for given galaxy
  # - callback_url (String): URL for callback
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
  # - 24h (Fixnum): no. of players logged in 24 hours.
  # - 48h (Fixnum): no. of players logged in 48 hours.
  # - 1w (Fixnum): no. of players logged in 1 week.
  # - 2w (Fixnum): no. of players logged in 2 weeks.
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
    only_in_production("player_destroyed invoked for #{player}") do
      response = post_to_web(player.galaxy.callback_url, 
        "remove_player_from_galaxy",
        'player_auth_token' => player.auth_token,
        'galaxy_id' => player.galaxy_id
      )

      check_response(response)
    end
  end

  def alliance_created(alliance)
    only_in_production("alliance_created invoked for #{alliance}") do
      player = alliance.owner
      response = post_to_web(alliance.galaxy.callback_url,
        "alliance_created",
        'owner_name' => player.name,
        'galaxy_id' => alliance.galaxy_id,
        'alliance_id' => alliance.id,
        'name' => alliance.name
      )

      check_response(response)
    end
  end

  def alliance_renamed(alliance)
    only_in_production("alliance_renamed invoked for #{alliance}") do
      response = post_to_web(alliance.galaxy.callback_url,
        "alliance_renamed",
        'galaxy_id' => alliance.galaxy_id,
        'alliance_id' => alliance.id,
        'name' => alliance.name
      )

      check_response(response)
    end
  end

  def alliance_destroyed(alliance)
    only_in_production("alliance_destroyed invoked for #{alliance}") do
      response = post_to_web(alliance.galaxy.callback_url,
        "alliance_destroyed",
        'alliance_id' => alliance.id
      )

      check_response(response)
    end
  end

  def player_joined_alliance(player, alliance)
    only_in_production("player_joined_alliance invoked for #{player}, #{
        alliance}") do
      response = post_to_web(alliance.galaxy.callback_url,
        "player_joined_alliance",
        'alliance_id' => alliance.id,
        'player_name' => player.name
      )

      check_response(response)
    end
  end

  def player_left_alliance(player, alliance)
    only_in_production("player_left_alliance invoked for #{player}, #{
        alliance}") do
      response = post_to_web(alliance.galaxy.callback_url,
        "player_left_alliance",
        'alliance_id' => alliance.id,
        'player_name' => player.name
      )

      check_response(response)
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
    else
      io.send_message(:success => false, :reason => "Action Unknown!")
    end
  end

  def action_create_galaxy(io, message)
    galaxy_id = Galaxy.create_galaxy(message['ruleset'], 
      message['callback_url'])
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
      player.invoked_from_control_manager = true
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
      player.pure_creds += message['creds']
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
      :"24h" => get_player_count_in(24.hours),
      :"48h" => get_player_count_in(48.hours),
      :"1w" => get_player_count_in(1.week),
      :"2w" => get_player_count_in(2.weeks),
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

  def post_to_web(callback_url, path, params={})
    Net::HTTP.post_form(
      web_uri_for(callback_url, path),
      params.merge('secret_key' => CONFIG['control']['token'])
    )
  end

  def web_uri_for(callback_url, path)
    URI.parse((CONFIG['control']['web_url'] % callback_url) + "/#{path}")
  end

  def only_in_production(message)
    LOGGER.block(message, :server_name => TAG) do
      if ENV['environment'] == 'production'
        yield
      else
        LOGGER.info("Not in production, doing nothing.", TAG)
        true
      end
    end
  end

  def check_response(response)
    if response.body == "success"
      LOGGER.info("Success!", TAG)
      true
    else
      raise Error.new("Failure! Server said:\n\n#{response.body}")
      false
    end
  end
end
