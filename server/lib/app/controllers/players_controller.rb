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
  LOGIN_SCOPE = scope.world
  def self.login_action(m)
    if ClientVersion.ok?(m.params['version'])
      player = without_locking { Player.find(m.params['server_player_id']) }
      if without_locking { player.galaxy.dev? } || ControlManager.instance.
          login_authorized?(player, m.params['web_player_id'])
        login m, player

        # This must come before player.attach!
        push m, GameController::ACTION_CONFIG

        player.attach! if player.detached?

        [
          ACTION_SHOW,
          PlanetsController::ACTION_PLAYER_INDEX,
          TechnologiesController::ACTION_INDEX,
          QuestsController::ACTION_INDEX,
          NotificationsController::ACTION_INDEX,
          RoutesController::ACTION_INDEX,
          PlayerOptionsController::ACTION_SHOW,
          ChatController::ACTION_INDEX,
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
    respond m, :success => false
    disconnect m
  end

  ACTION_SHOW = 'players|show'

  SHOW_OPTIONS = logged_in + only_push
  SHOW_SCOPE = scope.world
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
  SHOW_PROFILE_SCOPE = scope.world
  def self.show_profile_action(m)
    without_locking do
      player_hash = Player.ratings(
        m.player.galaxy_id, Player.where(:id => m.params['id'])
      )[0]

      raise ActiveRecord::RecordNotFound.new("Cannot find player with id #{
        m.params['id']} in galaxy #{m.player.galaxy_id}!") if player_hash.nil?

      respond m, \
        :player => player_hash,
        :achievements => Quest.achievements_by_player_id(m.params['id'])
    end
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
  RATINGS_SCOPE = scope.world
  def self.ratings_action(m)
    without_locking do
      respond m, :ratings => Player.ratings(m.player.galaxy_id)
    end
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
  EDIT_SCOPE = scope.world
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
  VIP_SCOPE = scope.world
  def self.vip_action(m)
    m.player.vip_start!(m.params['vip_level'])
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
  STATUS_CHANGE_SCOPE = scope.world
  def self.status_change_action(m)
    respond m, :changes => m.params['changes']
  end

  # Notifies client about player rename.
  #
  # Invocation: by server
  #
  # Parameters & response:
  # - id (Fixnum): player id
  # - name (String): new player name
  #
  ACTION_RENAME = 'players|rename'

  RENAME_OPTIONS = logged_in + only_push +
    required(:id => Fixnum, :name => String)
  RENAME_SCOPE = scope.world
  def self.rename_action(m)
    respond m, :id => m.params['id'], :name => m.params['name']
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
  CONVERT_CREDS_SCOPE = scope.world
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
  BATTLE_VPS_MULTIPLIER_SCOPE = scope.world
  def self.battle_vps_multiplier_action(m)
    respond m, :multiplier =>
      Player.battle_vps_multiplier(m.player.id, m.params['target_id'])
  end
end
