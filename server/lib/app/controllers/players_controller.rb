class PlayersController < GenericController
  # Log player in.
  #
  # Parameters:
  # - auth_token (String): authentication token for player
  # - galaxy_id (Fixnum): galaxy ID player wants to log in to.
  #
  # Return message params:
  # - success (Boolean)
  def action_login
    param_options :required => %w{auth_token galaxy_id}

    player = Player.find(:first, :conditions => {
        :auth_token => params['auth_token'],
        :galaxy_id => params['galaxy_id']
      })
    if player
      login player
      Chat::Pool.instance.hub_for(player).register(player)

      %w{game|config players|show planets|player_index technologies|index
      quests|index notifications|index routes|index
      chat|index}.each do |action|
        push action
      end

      respond :success => true
    else
      respond :success => false
      disconnect
    end
  end

  ACTION_SHOW = 'players|show'
  def action_show
    only_push!
    respond :player => player.as_json
  end

  # Shows all player ratings on current players galaxy.
  #
  # Invocation: by client
  #
  # Parameters: None
  #
  # Response:
  # - ratings (Hash[]): Player#as_json array with :ratings
  #
  def action_ratings
    players = Player.where(:galaxy_id => player.galaxy_id).
      includes(:alliance)
    ratings = players.map { |player| player.as_json(:mode => :ratings) }
    respond :ratings => ratings
  end

  # Edits your properties.
  #
  # Invocation: by client
  #
  # Parameters:
  # - first_time (Boolean): should the first time screen be shown next time
  # player logs in?
  #
  def action_edit
    param_options :valid => %w{first_time}

    player = self.player
    player.first_time = params['first_time'] \
      unless params['first_time'].nil?

    player.save!
  end

  # Starts VIP status for you. This action costs creds!
  #
  # Invocation: by client
  #
  # Parameters:
  # - vip_level (Fixnum): 1 to CONFIG['creds.vip'].size
  #
  def action_vip
    param_options :required => %w{vip_level}

    player.vip_start!(params['vip_level'])
  rescue ArgumentError => e
    # VIP level was incorrect.
    raise GameLogicError.new(e)
  end
end