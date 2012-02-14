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

  LOGIN_OPTIONS = required(
    :server_player_id => Fixnum,
    :web_player_id => Fixnum,
    :version => String
  )
  def self.login_scope(message)
    # Player login depends on galaxy scope because logging him in might reattach
    # him to the galaxy.
    player = Player.where(:id => message.params['server_player_id']).first
    # There might not be such player.
    scope.galaxy(player.try(:galaxy_id))
  end
  def self.login_action(m)
    if ClientVersion.ok?(m.params['version'])
      player = Player.find(m.params['server_player_id'])
      if player.galaxy.dev? || ControlManager.instance.
          login_authorized?(player, params['web_player_id'])
        login m, player

        # This must come before player.attach!
        push m, GameController::ACTION_CONFIG

        # This must be pushed before player is attached.
        push "game|config"

        player.attach! if player.detached?

        [
          ACTION_SHOW,
          PlanetsController::ACTION_PLAYER_INDEX,
          TechnologiesController::ACTION_INDEX,
          QuestsController::ACTION_INDEX,
          NotificationsController::ACTION_INDEX,
          RoutesController::ACTION_INDEX,
          ChatController::ACTION_INDEX,
          PlayerOptionsController::ACTION_SHOW,
          GalaxiesController::ACTION_SHOW
        ].each { |action| push m, action }

        # Dispatch current announcement if we have one.
        ends_at, announcement = AnnouncementsController.get
        unless ends_at.nil?
          push m, AnnouncementsController::ACTION_NEW,
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
      disconnect m
    end
  rescue ActiveRecord::RecordNotFound
    respond :success => false
    disconnect m
  end

  ACTION_SHOW = 'players|show'
  SHOW_OPTIONS = logged_in + only_push
  def self.show_scope(message); scope.player(message.player); end
  def self.show_action(m); respond m, :player => m.player.as_json; end

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

  SHOW_PROFILE_OPTIONS = logged_in + required(:id => Fixnum)
  def self.show_profile_scope(message); scope.player(message.player); end
  def self.show_profile_action(m)
    player_hash = Player.ratings(
      m.player.galaxy_id, Player.where(:id => m.params['id'])
    )[0]

    raise ActiveRecord::RecordNotFound.new("Cannot find player with id #{
      m.params['id']} in galaxy #{m.player.galaxy_id}!") if player_hash.nil?

    respond m, \
      :player => player_hash,
      :achievements => Quest.achievements_by_player_id(m.params['id'])
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

  RATINGS_OPTIONS = logged_in
  def self.ratings_scope(message); scope.galaxy(message.player.galaxy_id); end
  def self.ratings_action(m)
    respond m, :ratings => Player.ratings(m.player.galaxy_id)
  end


  # Edits your properties.
  #
  # Invocation: by client
  #
  # Parameters:
  # - portal_without_allies (Boolean): should alliance units be used when
  # attacked and sent to allies when they are attacked?
  #
  ACTION_EDIT = "players|edit"

  EDIT_OPTIONS = logged_in + valid(%w{portal_without_allies})
  def self.edit_scope(message); scope.player(message.player); end
  def self.edit_action(m)
    m.player.portal_without_allies = m.params['portal_without_allies'] \
      unless m.params['portal_without_allies'].nil?

    m.player.save!
  end


  # Starts VIP status for you. This action costs creds!
  #
  # Invocation: by client
  #
  # Parameters:
  # - vip_level (Fixnum): 1 to CONFIG['creds.vip'].size
  #
  ACTION_VIP = "players|vip"

  VIP_OPTIONS = logged_in + required(:vip_level => Fixnum)
  def self.vip_scope(message); scope.player(message.player); end
  def self.vip_action(player, params)
    player.vip_start!(params['vip_level'])
  rescue ArgumentError => e
    # VIP level was incorrect.
    raise GameLogicError, e.message, e.backtrace
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

  STATUS_CHANGE_OPTIONS = logged_in + only_push + required(:changes => Array)
  def self.status_change_scope(message); scope.player(message.player); end
  def self.status_change_action(m)
    respond m, :changes => m.params['changes']
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
  ACTION_CONVERT_CREDS = 'players|convert_creds'

  CONVERT_CREDS_OPTIONS = logged_in + required(:amount => Fixnum)
  def self.convert_creds_scope(message); scope.player(message.player); end
  def self.convert_creds_action(m)
    m.player.vip_convert(m.params['amount'])
    m.player.save!
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
  ACTION_BATTLE_VPS_MULTIPLIER = 'players|battle_vps_multiplier'

  BATTLE_VPS_MULTIPLIER_OPTIONS = logged_in + required(:target_id => Fixnum)
  def self.battle_vps_multiplier_scope(message)
    scope.players([message.player.id, message.params['target_id']])
  end
  def self.battle_vps_multiplier_action(m)
    respond m, :multiplier =>
      Player.battle_vps_multiplier(m.player.id, m.params['target_id'])
  end
end
