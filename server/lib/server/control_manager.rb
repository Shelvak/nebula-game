require 'net/http'
require 'uri'



# Monolithic class for controlling server.
class ControlManager
  class Error < RuntimeError; end

  TAG = "ControlManager"

  include Singleton

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

  def player_referral_points_reached(player)
    only_in_production("points_collected invoked for #{player}") do
      response = post_to_web(player.galaxy.callback_url,
        "points_collected",
        'player_id' => player.id,
        'web_user_id' => player.web_user_id
      )

      check_response(response)
    end
  end

  # Notify web that this player is dead. Transfer _amount_ of creds back
  # to the web.
  def player_death(player, amount)
    only_in_production("player_death invoked for #{player}") do
      response = post_to_web(player.galaxy.callback_url,
        "player_death",
        'player_id' => player.id,
        'web_user_id' => player.web_user_id,
        'creds' => amount
      )

      check_response(response)
    end
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

  def alliance_owner_changed(alliance, new_owner)
    only_in_production(
      "alliance_owner_changed invoked for #{alliance}, new owner: #{new_owner}"
    ) do
      response = post_to_web(alliance.galaxy.callback_url,
        "alliance_owner_changed",
        'galaxy_id' => alliance.galaxy_id,
        'alliance_id' => alliance.id,
        'new_owner_name' => new_owner.name
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

  def post_to_web(callback_url, path, params={})
    uri = web_uri_for(callback_url, path)
    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 2
    http.read_timeout = 5

    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data(
      params.merge('secret_key' => CONFIG['control']['token'])
    )

    response = http.request(request)
    response
  rescue Timeout::Error
    raise Error.new("Timeout hit while posting to web: #{callback_url}")
  end

  def web_uri_for(callback_url, path)
    URI.parse((CONFIG['control']['web_url'] % callback_url) + "/#{path}")
  end

  def only_in_production(message)
    LOGGER.block(message, :component => TAG) do
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
