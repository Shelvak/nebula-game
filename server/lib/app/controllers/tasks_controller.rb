class TasksController < GenericController
  # Reopens log files.
  #
  # Parameters: None
  #
  # Response: None
  #
  ACTION_REOPEN_LOGS = 'tasks|reopen_logs'

  REOPEN_LOGS_OPTIONS = control_token
  REOPEN_LOGS_SCOPE = scope.world
  def self.reopen_logs_action(m)
    LOGGER.info "Reopening log outputs."
    Logging::Writer.instance.reopen!
  end

  # Applies hotfix. Only accepts this action if connected from localhost.
  #
  # Parameters:
  # - hotfix (String): code to be evaluated
  #
  # Response:
  # - error (String | nil): Error - if any.
  ACTION_APPLY_HOTFIX = 'tasks|apply_hotfix'

  APPLY_HOTFIX_OPTIONS = control_token + required(:hotfix => String)
  APPLY_HOTFIX_SCOPE = scope.world
  # TODO: spec
  def self.apply_hotfix_action(m)
    unless m.client.host == '127.0.0.1'
      LOGGER.fatal(%Q{Somebody tried to apply hotfix not from localhost!

Connection made from #{m.client}

Message was:
#{m}"})
      respond m, :success => false, :error => "Please go away."
      return
    end

    LOGGER.fatal(%Q{Applying hotfix!

==== HOTFIX CODE ====

#{m.params['hotfix']}

==== HOTFIX CODE ====
})

    begin
      eval m.params['hotfix'], ROOT_BINDING
      respond m, :error => nil
    rescue Exception => e
      LOGGER.fatal("Applying hotfix failed!\n\n#{e.to_log_str}")
      respond m, :error => e.to_log_str
    end
  end

  # Create a new player in galaxy.
  #
  # Parameters:
  # - galaxy_id (Fixnum)
  # - web_user_id (Fixnum)
  # - name (String): player name
  # - trial (Boolean): is this a trial player?
  #
  # Response:
  # - player_id (Fixnum): Player#id
  #
  ACTION_CREATE_PLAYER = 'tasks|create_player'

  CREATE_PLAYER_OPTIONS = control_token + required(
    :galaxy_id => Fixnum, :web_user_id => Fixnum, :name => String,
    :trial => Boolean
  )
  CREATE_PLAYER_SCOPE = scope.slow
  def self.create_player_action(m)
		player = Galaxy.create_player(
      m.params['galaxy_id'], m.params['web_user_id'], m.params['name'],
      m.params['trial']
    )

		respond m, :player_id => player.id
  end

  # Destroy an existing player.
  #
  # Parameters:
  # - player_id (Fixnum): Player#id
  #
  # Response: None
  #
  ACTION_DESTROY_PLAYER = 'tasks|destroy_player'

  DESTROY_PLAYER_OPTIONS = control_token + required(:player_id => Fixnum)
  DESTROY_PLAYER_SCOPE = scope.world
  def self.destroy_player_action(m)
    player = Player.find(m.params['player_id'])
    player.invoked_from_web = true
    player.destroy!
  rescue ActiveRecord::RecordNotFound
    # If its not there, there is nothing to destroy, is it?
  end

  # Adds creds to player.
  #
  # Parameters:
  # - player_id (Fixnum): Player#id
  # - creds: (Fixnum): number of creds to add
  #
  # Response: None
  #
  ACTION_ADD_CREDS = 'tasks|add_creds'

  ADD_CREDS_OPTIONS = control_token +
    required(:player_id => Fixnum, :creds => Fixnum)
  ADD_CREDS_SCOPE = scope.world
  def self.add_creds_action(m)
    player = Player.find(m.params['player_id'])
    player.pure_creds += m.params['creds']
    player.save!
  end

  # Called by website to notify that trial user has registered.
  #
  # Parameters:
  # - player_id (Fixnum): Player#id
  # - name (String): New player name.
  #
  # Response: None
  #
  ACTION_PLAYER_REGISTERED = 'tasks|player_registered'

  PLAYER_REGISTERED_OPTIONS = control_token +
    required(:player_id => Fixnum, :name => String)
  PLAYER_REGISTERED_SCOPE = scope.world
  def self.player_registered_action(m)
    player = Player.where(Player.trial_condition).find(m.params['player_id'])
    player.trial = false
    player.name = m.params['name']
    player.save!
    EventBroker.fire(
      Event::PlayerRename.new(player.id, player.name), EventBroker::CREATED
    )
  end

  # Allows checking if player is connected.
  #
  # Parameters:
  # - player_id (Fixnum): Player#id
  #
  # Response:
  # - connected (Boolean): is this player currently connected?
  #
  ACTION_IS_PLAYER_CONNECTED = 'tasks|is_player_connected'

  IS_PLAYER_CONNECTED_OPTIONS = control_token + required(:player_id => Fixnum)
  IS_PLAYER_CONNECTED_SCOPE = scope.world
  def self.is_player_connected_action(m)
    connected = Celluloid::Actor[:dispatcher].
      player_connected?(m.params['player_id'])

    respond m, connected: connected
  end

  # Report usage statistics.
  #
  # Parameters: None
  #
  # Response:
  # - current (Fixnum): no. of currently logged in players.
  # - in_1d (Fixnum): no. of players logged in 1 day.
  # - in_2d (Fixnum): no. of players logged in 2 days.
  # - in_3d (Fixnum): no. of players logged in 3 days.
  # - in_4d (Fixnum): no. of players logged in 4 days.
  # - in_5d (Fixnum): no. of players logged in 5 days.
  # - in_6d (Fixnum): no. of players logged in 6 days.
  # - in_7d (Fixnum): no. of players logged in 7 days.
  # - total (Fixnum): total no. of players
  #
  ACTION_PLAYER_STATS = 'tasks|player_stats'

  PLAYER_STATS_OPTIONS = control_token
  PLAYER_STATS_SCOPE = scope.world
  # TODO: spec better
  def self.player_stats_action(m)
    without_locking do
      # Returns how much players were logged in in last _time_ seconds.
      get_player_count_in = lambda do |time|
        Player.where("last_seen >= ?", Time.now - time).count
      end

      # The following describes the name of the field:
      # The characters must be [a-zA-Z0-9_], while the first character must be
      # [a-zA-Z_].
      stats = {
        :current => Celluloid::Actor[:dispatcher].logged_in_count,
        :in_1d => get_player_count_in[1.day],
        :in_2d => get_player_count_in[2.days],
        :in_3d => get_player_count_in[3.days],
        :in_4d => get_player_count_in[4.days],
        :in_5d => get_player_count_in[5.days],
        :in_6d => get_player_count_in[6.days],
        :in_7d => get_player_count_in[7.days],
        :total => Player.count,
      }

      respond m, stats
    end
  end

  # Return market rate for given resource pair in different galaxies.
  #
  # Parameters:
  # - from_kind (Fixnum)
  # - to_kind (Fixnum)
  #
  # Response: +Hash+ of {galaxy_id => rate} pairs.
  #
  ACTION_MARKET_RATES_STATS = 'tasks|market_rates_stats'

  MARKET_RATES_STATS_OPTIONS = control_token +
    required(:from_kind => Fixnum, :to_kind => Fixnum)
  MARKET_RATES_STATS_SCOPE = scope.world
  # TODO: spec
  def self.market_rates_stats_action(m)
    without_locking do
      stats = Galaxy.select("id").c_select_values.inject({}) do
        |hash, galaxy_id|

        hash[galaxy_id] = MarketRate.
          average(galaxy_id, m.params['from_kind'], m.params['to_kind'])
        hash
      end

      respond m, stats
    end
  end

  # Return number of market offers for given resource pair in different galaxies.
  #
  # Parameters:
  # - from_kind (Fixnum)
  # - to_kind (Fixnum)
  #
  # Response: +Hash+ of {galaxy_id => count} pairs.
  #
  ACTION_MARKET_COUNTS_STATS = 'tasks|market_counts_stats'

  MARKET_COUNTS_STATS_OPTIONS = control_token +
    required(:from_kind => Fixnum, :to_kind => Fixnum)
  MARKET_COUNTS_STATS_SCOPE = scope.world
  # TODO: spec
  def self.market_counts_stats_action(m)
    without_locking do
      stats = Galaxy.select("id").c_select_values.inject({}) do
        |hash, galaxy_id|

        count = MarketOffer.where(
          :from_kind => m.params['from_kind'],
            :to_kind => m.params['to_kind'],
            :galaxy_id => galaxy_id
        ).count
        hash[galaxy_id] = count
        hash
      end

      respond m, stats
    end
  end

  # Send announcement to all the connected players.
  #
  # Parameters:
  # - ends_at (String): when should the announcement expire in human time
  # string.
  # - message (String): announcement text
  #
  # Response: None
  #
  ACTION_ANNOUNCE = 'tasks|announce'

  ANNOUNCE_OPTIONS = control_token +
    required(:ends_at => String, :message => String)
  ANNOUNCE_SCOPE = scope.world
  # TODO: spec
  def self.announce_action(m)
    time = Time.parse(m.params['ends_at'])
    raise ParamOpts::BadParams.new(
      "#{m.params['ends_at']} cannot be parsed as Time!"
    ) if time.nil?

    AnnouncementsController.set(time, m.params['message'])
  end
end