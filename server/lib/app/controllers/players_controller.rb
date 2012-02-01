class PlayersController < GenericController
  # Log player in.
  #
  # Parameters:
  # - server_player_id (Fixnum): Player#id
  # - web_player_id (Fixnum): player id in the website
  #
  # Return message params:
  # - success (Boolean)
  # - required_version (String): version required for connection if client
  # is refused because of the old version.
  ACTION_LOGIN = 'players|login'

  def self.login_options
    required(
      :server_player_id => Fixnum,
      :web_player_id => Fixnum,
      :version => String
    )
  end

  def self.login_scope(message)
    player = Player.find(message.params['server_player_id'])
    scope.galaxy(player.galaxy_id)
  end

  def self.login_action(m)
    if ClientVersion.ok?(m.params['version'])
      player = Player.find(m.params['server_player_id'])
      if player.galaxy.dev? || ControlManager.instance.
          login_authorized?(player, params['web_player_id'])
        login player

        player.attach! if player.detached?

        ["game|config", "players|show", "planets|player_index",
          "technologies|index", "quests|index", "notifications|index",
          RoutesController::ACTION_INDEX,
          ChatController::ACTION_INDEX,
          PlayerOptionsController::ACTION_SHOW,
          GalaxiesController::ACTION_SHOW
        ].each { |action| push action }

        # Dispatch current announcement if we have one.
        ends_at, announcement = AnnouncementsController.get
        unless ends_at.nil?
          push AnnouncementsController::ACTION_NEW,
            {'ends_at' => ends_at, 'message' => announcement}
        end

        push m, DailyBonusController::ACTION_SHOW \
          if player.daily_bonus_available?

        respond m, :success => true
      else
        raise ActiveRecord::RecordNotFound
      end
    else
      respond m,
        :success => false, :required_version => Cfg.required_client_version
      disconnect
    end
  rescue ActiveRecord::RecordNotFound
    respond :success => false
    disconnect
  end

  ACTION_SHOW = 'players|show'
  def self.show_options; only_push; end
  def self.show_scope(message); scope.player(message.player.id); end
  def self.show_action(player, params); respond :player => player.as_json; end


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
  ACTION_SHOW_PROFILE = "players|show_profile"

  def self.show_profile_options; required(:id => Fixnum); end
  def self.show_profile_scope(message); scope.player(message.player.id); end
  def self.show_profile_action(player, params)
    player_hash = Player.ratings(self.player.galaxy_id,
      Player.where(:id => params['id']))[0]

    raise ActiveRecord::RecordNotFound.new("Cannot find player with id #{
      params['id']} in galaxy #{self.player.galaxy_id}!") if player_hash.nil?

    respond player, \
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
  ACTION_RATINGS = "players|ratings"
  def self.ratings_options; nil; end
  def self.ratings_scope(message); scope.galaxy(message.player.galaxy_id); end
  def self.ratings_action(player, params)
    respond player, :ratings => Player.ratings(player.galaxy_id)
  end


  # Edits your properties.
  #
  # Invocation: by client
  #
  # Parameters:
  # - first_time (Boolean): should the first time screen be shown next time
  # player logs in?
  # - portal_without_allies (Boolean): should alliance units be used when
  # attacked and sent to allies when they are attacked?
  #
  ACTION_EDIT = "players|edit"

  def self.edit_options; valid(%w{portal_without_allies}); end
  def self.edit_scope(message); scope.player(message.player.id); end
  def self.edit_action(player, params)
    player.first_time = params['first_time'] \
      unless params['first_time'].nil?
    player.portal_without_allies = params['portal_without_allies'] \
      unless params['portal_without_allies'].nil?

    player.save!
  end


  # Starts VIP status for you. This action costs creds!
  #
  # Invocation: by client
  #
  # Parameters:
  # - vip_level (Fixnum): 1 to CONFIG['creds.vip'].size
  #
  ACTION_VIP = "players|vip"

  def self.vip_options; required(:vip_level => Fixnum); end
  def self.vip_scope(message); scope.player(message.player.id); end
  def self.vip_action(player, params)
    player.vip_start!(params['vip_level'])
  rescue ArgumentError => e
    # VIP level was incorrect.
    raise GameLogicError.new(e)
  end


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
  ACTION_STATUS_CHANGE = 'players|status_change'

  def self.status_change_options; required(:changes => Array) + only_push; end
  def self.status_change_scope(message); scope.player(message.player.id); end
  def self.status_change_action(player, params)
    respond player, :changes => params['changes']
  end

  def self.scope_convert_creds(message)
    Dispatcher::Scope.player(message.player.id)
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

  def self.scope_edit(message)
    Dispatcher::Scope.player(message.player.id, message.params['target_id'])
  end

  # Returns multiplier for battle victory points when fighting against
  # targeted player.
  #
  # Invocation: by client
  #
  # Parameters:
  # - target_id (Fixnum): player id that you are targeting.
  #
  # Response:
  # - multiplier (Float): multiplier between [0, inf) for victory points. This
  # multiplier can be inserted into 'battleground.battle.victory_points' or
  # 'combat.battle.victory_points' config formulas as 'fairness_multiplier'
  # parameter.
  #
  def action_battle_vps_multiplier
    param_options :required => {:target_id => Fixnum}

    respond :multiplier =>
      Player.battle_vps_multiplier(player.id, params['target_id'])
  end
end
