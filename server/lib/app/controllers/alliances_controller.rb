class AlliancesController < GenericController
  # Creates an alliance.
  #
  # To create an alliance player must have Alliance technology researched.
  #
  # Invocation: by client
  #
  # Parameters:
  # - name (String): alliance name
  #
  # Response:
  # - id (Fixnum): alliance id
  #
  def action_new
    param_options :required => %w{name}
  end

  # Destroys an alliance. This action is only available for alliance owner.
  #
  # Its members are free to join other alliance as soon as this alliance is
  # destroyed.
  #
  # Invocation: by client
  #
  # Parameters: None
  #
  # Response: None
  #
  def action_destroy

  end

  # Edits an alliance.
  #
  # Only owner can do this. This action costs creds.
  #
  # Invocation: by client
  #
  # Parameters:
  # - name (String, Optional): new alliance name
  #
  # Response: None
  #
  def action_edit
    param_options :valid => %w{name}
  end

  # Shows an alliance.
  #
  # Includes alliance and it's players with ratings.
  #
  # Invocation: by client
  #
  # Parameters:
  # - id (Fixnum): alliance id
  #
  # Response:
  # - name (String)
  # - players (Player[]): array of Player#as_json in :ratings mode.
  #
  def action_show
    param_options :required => %w{id}

    alliance = Alliance.find(id)
    respond :name => alliance.name,
      :players => alliance.players.map { |p| p.as_json(:ratings) }
  end

  # Alliance ratings.
  #
  # Invocation: by client
  #
  # Parameters: None
  #
  # Response:
  # - ratings (Hash[]): Alliance#ratings
  #
  def action_ratings
    respond :ratings => Alliance.ratings(player.galaxy_id)
  end

  # Joins an alliance. Needs an notification ID to join. Destroys
  # notification upon successful join.
  #
  # Can fail if alliance has too much members already or player cooldown.
  #
  # Invocation: by client
  #
  # Parameters:
  # - notification_id (Fixnum)
  #
  # Response:
  # - success (Boolean): has a player successfully joined this alliance?
  # - error (String, Optional): Possible values:
  #   - 'cooldown': player is trying to join other alliance too soon.
  #   - 'full': this alliances has maxed out its player count.
  #
  def action_join

  end

  # Leaves current alliance. After leaving player will have a period of
  # time before he can join other alliance.
  #
  # Invocation: by client
  #
  # Parameters: None
  #
  # Response: None
  #
  def action_leave
    
  end

  # Kicks player out of alliance.
  #
  # You must be an alliance owner to do this. Kicked player is free to join
  # other alliance immediately after kick.
  #
  # Invocation: by client
  #
  # Parameters:
  # - player_id (Fixnum)
  #
  # Response: None
  #
  def action_kick

  end
end