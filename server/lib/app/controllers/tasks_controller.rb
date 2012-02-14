class TasksController < GenericController
  # Reopens log files.
  #
  # Parameters: None
  #
  # Response: None
  #
  ACTION_REOPEN_LOGS = 'tasks|reopen_logs'

  REOPEN_LOGS_OPTIONS = control_token
  def self.reopen_logs_scope(m); scope.server; end
  def self.reopen_logs_action(m)
    LOGGER.info "Reopening log outputs."
    Celluloid::Actor[:log_writer].reopen!
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
  def self.apply_hotfix_scope(m); scope.server; end
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

  # Create a new galaxy.
  #
  # Parameters:
  # - ruleset (String): ruleset for given galaxy
  # - callback_url (String): URL for callback
  #
  # Response:
  # - galaxy_id (Fixnum): ID of created galaxy
  #
  ACTION_CREATE_GALAXY = 'tasks|create_galaxy'

  CREATE_GALAXY_OPTIONS = control_token +
    required(:ruleset => String, :callback_url => String)
  def self.create_galaxy_scope(m); scope.server; end
  def self.create_galaxy_action(m)
    galaxy_id = Galaxy.create_galaxy(
      m.params['ruleset'], m.params['callback_url']
    )
    respond m, :galaxy_id => galaxy_id
  end

  # Destroy an existing galaxy.
  #
  # Parameters:
  # - id (Fixnum): id of galaxy to be destroyed.
  #
  # Response: None
  #
  ACTION_DESTROY_GALAXY = 'tasks|destroy_galaxy'

  DESTROY_GALAXY_OPTIONS = control_token + required(:id => Fixnum)
  def self.destroy_scope(m); scope.galaxy(m.params['id']); end
  def self.destroy_galaxy_action(m)
    Galaxy.find(m.message['id']).destroy!
  rescue ActiveRecord::RecordNotFound
    # If there is no galaxy, then there is no problem, right?
  end

  # Create a new player in galaxy.
  #
  # Parameters:
  # - galaxy_id (Fixnum)
  # - web_user_id (Fixnum)
  # - name (String): player name
  #
  # Response:
  # - player_id (Fixnum): Player#id
  #
  ACTION_CREATE_PLAYER = 'tasks|create_player'

  CREATE_PLAYER_OPTIONS = control_token + required(
    :galaxy_id => Fixnum, :web_user_id => Fixnum, :name => String
  )
  def self.create_player_scope(m); scope.galaxy(m.params['galaxy_id']); end
  def self.create_player_action(m)
    galaxy_id = m.params['galaxy_id']
    web_user_id = m.params['web_user_id']
    name = m.params['name']
		response = Galaxy.create_player(galaxy_id, web_user_id, name)

		respond m, :player_id => response[web_user_id]
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
  def self.destroy_player_scope(m); scope.player(m.params['player_id']); end
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

  ADD_CREDS_OPTIONS = control_token + required(:player_id => Fixnum)
  def self.add_creds_scope(m); scope.player(m.params['player_id']); end
  def self.add_creds_action(m)
    player = Player.find(m.params['player_id'])
    player.pure_creds += m.params['creds']
    player.save!
  end

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
  ACTION_PLAYER_STATS = 'tasks|player_stats'

  PLAYER_STATS_OPTIONS = control_token
  def self.player_stats_scope(m); scope.server; end
  def self.player_stats_actions(m)
    # Returns how much players were logged in in last _time_ seconds.
    get_player_count_in = lambda do |time|
      Player.where("last_seen >= ?", Time.now - time).count
    end

    stats = {
      :current => Celluloid::Actor[:dispatcher].logged_in_count,
      :"24h" => get_player_count_in[24.hours],
      :"48h" => get_player_count_in[48.hours],
      :"1w" => get_player_count_in[1.week],
      :"2w" => get_player_count_in[2.weeks],
      :total => Player.count,
    }

    respond m, stats
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
  def self.market_rates_stats_scope(m); scope.server; end
  def self.market_rates_stats_action(m)
    stats = Galaxy.select("id").c_select_values.inject({}) do |hash, galaxy_id|
      hash[galaxy_id] = MarketRate.
        average(galaxy_id, m.params['from_kind'], m.params['to_kind'])
      hash
    end

    respond m, stats
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
  def self.market_counts_stats_scope(m); scope.server; end
  def self.market_counts_stats_action(m)
    stats = Galaxy.select("id").c_select_values.inject({}) do |hash, galaxy_id|
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
  def self.announce_scope(m); scope.server; end
  def self.announce_action(m)
    time = Time.parse(m.params['ends_at'])
    raise ParamOpts::BadParams.new(
      "#{m.params['ends_at']} cannot be parsed as Time!"
    ) if time.nil?

    AnnouncementsController.set(time, m.params['message'])
  end
end