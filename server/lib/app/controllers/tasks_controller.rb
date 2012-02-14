class TasksController < GenericController
  # Reopens log files.
  #
  # Parameters: None
  #
  # Response:
  # - success (Boolean)
  #
  ACTION_REOPEN_LOGS = 'tasks|reopen_logs'

  def self.reopen_logs_options; control_token; end
  def self.reopen_logs_scope(m); scope.server; end
  def self.reopen_logs_action(m)
    LOGGER.info "Reopening log outputs."
    Celluloid::Actor[:log_writer].reopen!
    respond m, :success => true
  end

  # Applies hotfix. Only accepts this action if connected from localhost.
  #
  # Parameters:
  # - hotfix (String): code to be evaluated
  #
  # Response:
  # - success (Boolean)
  # - error (String): Error - if any.
  ACTION_APPLY_HOTFIX = 'tasks|apply_hotfix'

  def self.apply_hotfix_options
    control_token + required(:hotfix => String)
  end
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
      respond m, :success => true
    rescue Exception => e
      LOGGER.fatal("Applying hotfix failed!\n\n#{e.to_log_str}")
      respond m, :success => false, :error => e.to_log_str
    end
  end

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
  ACTION_CREATE_GALAXY = 'tasks|create_galaxy'

  def self.create_galaxy_options
    control_token + required(:ruleset => String, :callback_url => String)
  end
  def self.create_galaxy_scope(m); scope.server; end
  def self.create_galaxy_action(m)
    galaxy_id = Galaxy.create_galaxy(
      m.params['ruleset'], m.params['callback_url']
    )
    respond m, :success => true, :galaxy_id => galaxy_id
  rescue Exception
    respond m, :success => false, :galaxy_id => nil
    raise
  end

  # Destroy an existing galaxy.
  #
  # Parameters:
  # - id (Fixnum): id of galaxy to be destroyed.
  #
  # Response:
  # - success (Boolean)
  #
  ACTION_DESTROY_GALAXY = 'tasks|destroy_galaxy'

  def self.destroy_galaxy_options; control_token + required(:id => Fixnum); end
  def self.destroy_scope(m); scope.galaxy(m.params['id']); end
  def self.destroy_galaxy_action(m)
    Galaxy.find(m.message['id']).destroy
    respond m, :success => true
  rescue ActiveRecord::RecordNotFound
    respond m, :success => true
  end

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
  ACTION_CREATE_PLAYER = 'tasks|create_player'

  # Destroy an existing player.
  #
  # Parameters:
  # - player_id (Fixnum): Player#id
  #
  # Response:
  # - success (Boolean)
  #
  ACTION_DESTROY_PLAYER = 'tasks|destroy_player'

  # Adds creds to player.
  #
  # Parameters:
  # - player_id (Fixnum): Player#id
  # - creds: (Fixnum): number of creds to add
  #
  # Response:
  # - success (Boolean)
  #
  ACTION_ADD_CREDS = 'tasks|add_creds'

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
  ACTION_STATS_PLAYERS = 'tasks|player_stats'

  # Return market rate for given resource pair in different galaxies.
  #
  # Parameters:
  # - from_kind (Fixnum)
  # - to_kind (Fixnum)
  #
  # Response:
  # - rates (Hash): +Hash+ of {galaxy_id => rate} pairs.
  #
  ACTION_STATS_MARKET_RATES = 'tasks|market_rates_stats'

  # Return number of market offers for given resource pair in different galaxies.
  #
  # Parameters:
  # - from_kind (Fixnum)
  # - to_kind (Fixnum)
  #
  # Response:
  # - counts (Hash): +Hash+ of {galaxy_id => count} pairs.
  #
  ACTION_STATS_MARKET_COUNTS = 'tasks|market_counts_stats'

  # Send announcement to all the connected players.
  #
  # Parameters:
  # - ends_at (Time): when should the announcement expire
  # - message (String): announcement text
  #
  # Response:
  # - success (Boolean)
  #
  ACTION_ANNOUNCE = 'tasks|announce'
end