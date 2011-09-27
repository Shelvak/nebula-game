require 'net/http'
require 'uri'

# Monolithic class for controlling server.
class ControlManager
  class Error < RuntimeError; end

  TOKEN_KEY = 'token'
  TAG = "ControlManager"

  include Singleton

  # Reopens log files.
  #
  # Parameters: None
  #
  # Response:
  # - success (Boolean)
  #
  ACTION_REOPEN_LOGS = 'reopen_logs'

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
  # - web_user_id (Fixnum)
  # - name (String): player name
  #
  # Response:
  # - success (Boolean)
  # - player_id (Fixnum): Player#id
  #
  ACTION_CREATE_PLAYER = 'create_player'

  # Destroy an existing player.
  #
  # Parameters:
  # - player_id (Fixnum): Player#id
  #
  # Response:
  # - success (Boolean)
  #
  ACTION_DESTROY_PLAYER = 'destroy_player'

  # Adds creds to player.
  #
  # Parameters:
  # - player_id (Fixnum): Player#id
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
  ACTION_STATS_PLAYERS = 'stats|players'

  # Return market rate for given resource pair in different galaxies.
  #
  # Parameters:
  # - from_kind (Fixnum)
  # - to_kind (Fixnum)
  #
  # Response:
  # - rates (Hash): +Hash+ of {galaxy_id => rate} pairs.
  #
  ACTION_STATS_MARKET_RATES = 'stats|market_rates'

  # Return number of market offers for given resource pair in different galaxies.
  #
  # Parameters:
  # - from_kind (Fixnum)
  # - to_kind (Fixnum)
  #
  # Response:
  # - counts (Hash): +Hash+ of {galaxy_id => count} pairs.
  #
  ACTION_STATS_MARKET_COUNTS = 'stats|market_counts'
  
  # Send announcement to all the connected players.
  # 
  # Parameters:
  # - ends_at (Time): when should the announcement expire
  # - message (String): announcement text
  # 
  # Response:
  # - success (Boolean)
  #
  ACTION_ANNOUNCE = 'announce'

  def receive(io, message)
    if message[TOKEN_KEY] == Cfg.control_token
      process(io, message)
    else
      io.disconnect(GenericServer::REASON_AUTH_ERROR)
    end
  end

  # Checks if login was authorized by web.
  def login_authorized?(player, web_player_id)
    player_str = "#{player} (web_id: #{web_player_id.inspect})"
    only_in_production("authorization for #{player_str}") do
      response = post_to_web(player.galaxy.callback_url,
        "check_play_auth",
        'web_player_id' => web_player_id,
        'server_player_id' => player.id
      )

      check_response(response)
    end
  rescue Error => e
    LOGGER.warn("Login authorization for #{player_str} failed:\n\n#{e.message}")
    false
  end

  def player_destroyed(player)
    only_in_production("player_destroyed invoked for #{player}") do
      response = post_to_web(player.galaxy.callback_url, 
        "remove_player_from_galaxy",
        'player_id' => player.id,
        'web_user_id' => player.web_user_id
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
        'galaxy_id' => alliance.galaxy_id,
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
        'galaxy_id' => alliance.galaxy_id,
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
        'galaxy_id' => alliance.galaxy_id,
        'alliance_id' => alliance.id,
        'player_name' => player.name
      )

      check_response(response)
    end
  end

  private
  def process(io, message)
    case message['action']
    when ACTION_REOPEN_LOGS
      action_reopen_logs(io)
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
    when ACTION_STATS_PLAYERS
      action_stats_players(io)
    when ACTION_STATS_MARKET_COUNTS
      action_stats_market_counts(io, message)
    when ACTION_STATS_MARKET_RATES
      action_stats_market_rates(io, message)
    when ACTION_ANNOUNCE
      action_announce(io, message)
    else
      io.send_message(:success => false, :reason => "Action Unknown!")
    end
  end

  def action_reopen_logs(io)
    LOGGER.info "Got request to control manager, reopening log outputs."
    LOGGER.reopen!
    io.send_message :success => true
  end

  def action_create_galaxy(io, message)
    message.ensure_options! :required => {
      'ruleset' => String, 'callback_url' => String
    }
    galaxy_id = Galaxy.create_galaxy(message['ruleset'], 
      message['callback_url'])
    io.send_message :success => true, :galaxy_id => galaxy_id
  rescue Exception => e
    io.send_message :success => false, :galaxy_id => nil
    raise e
  end

  def action_destroy_galaxy(io, message)
    message.ensure_options! :required => {'id' => Fixnum}
    Galaxy.find(message['id']).destroy
    io.send_message :success => true
  rescue ActiveRecord::RecordNotFound
    io.send_message :success => true
  rescue Exception => e
    io.send_message :success => false
    raise e
  end

  def action_create_player(io, message)
    message.ensure_options! :required => {
      'galaxy_id' => Fixnum, 'web_user_id' => Fixnum, 'name' => String
    }
    galaxy_id = message['galaxy_id']
    web_user_id = message['web_user_id']
    name = message['name']
		response = Galaxy.create_player(galaxy_id, web_user_id, name)

		io.send_message :success => true,
                    :player_id => response.player_ids[web_user_id]
  rescue Exception => e
    io.send_message :success => false
    raise e
  end
  
  def action_destroy_player(io, message)
    message.ensure_options! :required => {'player_id' => Fixnum}
    player = Player.find(message['player_id'])
    player.invoked_from_control_manager = true
    player.destroy
    io.send_message :success => true
  rescue Exception => e
    io.send_message :success => false
    raise e
  end

  def action_add_creds(io, message)
    message.ensure_options! :required => {'player_id' => Fixnum}
    player = Player.find(message['player_id'])
    player.pure_creds += message['creds']
    player.save!
    io.send_message :success => true
  rescue Exception => e
    io.send_message :success => false
    raise e
  end

  def action_stats_players(io)
    stats = {
      :current => Dispatcher.instance.logged_in_count,
      :"24h" => get_player_count_in(24.hours),
      :"48h" => get_player_count_in(48.hours),
      :"1w" => get_player_count_in(1.week),
      :"2w" => get_player_count_in(2.weeks),
      :total => Player.count,
    }

    io.send_message stats
  end

  def action_stats_market_counts(io, message)
    message.ensure_options! :required => {
      'from_kind' => Fixnum, 'to_kind' => Fixnum
    }

    stats = Galaxy.select("id").c_select_values.inject({}) do |hash, galaxy_id|
      count = MarketOffer.where(:from_kind => message['from_kind'],
                                :to_kind => message['to_kind'],
                                :galaxy_id => galaxy_id).count
      hash[galaxy_id] = count
      hash
    end

    io.send_message stats
  end

  def action_stats_market_rates(io, message)
    message.ensure_options! :required => {
      'from_kind' => Fixnum, 'to_kind' => Fixnum
    }

    stats = Galaxy.select("id").c_select_values.inject({}) do |hash, galaxy_id|
      hash[galaxy_id] = MarketRate.
        average(galaxy_id, message['from_kind'], message['to_kind'])
      hash
    end

    io.send_message stats
  end
  
  def action_announce(io, message)
    message.ensure_options! :required => {
      'ends_at' => [String, Time], 'message' => String
    }

    unless message['ends_at'].is_a?(Time)
      parsed = Time.parse(message['ends_at'])
      if parsed
        message['ends_at'] = parsed
      else
        io.send_message 'success' => false, 
          :error => "#{message['ends_at'].inspect} is not Time!"
        return
      end
    end
      
    AnnouncementsController.set(message['ends_at'], message['message'])
    io.send_message 'success' => true
  end

  private

  # Returns how much players were logged in in last _time_ seconds.
  def get_player_count_in(time)
    Player.connection.select_value(
      "SELECT COUNT(*) FROM `#{Player.table_name}` WHERE last_login >= '#{
      (Time.now - time).to_s(:db)}'")
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
      if App.in_production?
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
    end
  end
end
