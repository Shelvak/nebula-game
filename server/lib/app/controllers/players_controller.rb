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

    player = Player.where(
      :auth_token => params['auth_token'],
      :galaxy_id => params['galaxy_id']
    ).first
    if player
      login player

      ["game|config", "players|show", "planets|player_index", 
        "technologies|index", "quests|index", "notifications|index", 
        RoutesController::ACTION_INDEX, 
        ChatController::ACTION_INDEX, 
        GalaxiesController::ACTION_SHOW
      ].each { |action| push action }
      
      # Dispatch current announcement if we have one.
      ends_at, announcement = AnnouncementsController.get
      unless ends_at.nil?
        push AnnouncementsController::ACTION_NEW,
          {'ends_at' => ends_at, 'message' => announcement}
      end
      
      push DailyBonusController::ACTION_SHOW \
        if player.daily_bonus_available?

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

  # Shows player profile.
  #
  # Invocation: by client
  #
  # Parameters:
  # - id (Fixnum): player id in this galaxy.
  #
  # Response:
  # - player (Hash): Player#ratings Hash
  # - achievements (Hash[]): Quest#achievements_by_player_id
  #
  def action_show_profile
    param_options :required => %w{id}

    player_hash = Player.ratings(self.player.galaxy_id,
      Player.where(:id => params['id']))[0]

    raise ActiveRecord::RecordNotFound.new("Cannot find player with id #{
      params['id']} in galaxy #{self.player.galaxy_id}!") if player_hash.nil?

    respond \
      :player => player_hash,
      :achievements => Quest.achievements_by_player_id(params['id'])
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
    respond :ratings => Player.ratings(player.galaxy_id)
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

  ACTION_STATUS_CHANGE = 'players|status_change'
  # Informs client that status of player has changed.
  #
  # Invocation: by server
  #
  # Parameters:
  # - changes (Array)
  #
  # Response:
  # - changes (Array): array of [player_id, status] pairs where:
  #   - player_id (Fixnum): id of +Player+ for which status is being changed
  #   - status (Fixnum): new status of player
  #
  def action_status_change
    param_options :required => %w{changes}
    only_push!

    respond :changes => params['changes']
  end

  # Convert creds from VIP creds to normal creds.
  # 
  # Rate is determined by your VIP level. See Player#vip_conversion_rate
  # 
  # Invocation: by client
  # 
  # Parameters:
  # - amount (Fixnum): number of VIP creds to convert
  # 
  # Response: None
  #
  def action_convert_creds
    param_options :required => {:amount => Fixnum}
    
    player.vip_convert(params['amount'])
    player.save!
  end
end
