class AlliancesController < GenericController
  # Creates an alliance.
  #
  # To create an alliance player must have Alliance technology researched.
  # Player cannot create a new alliance if he still has alliance cooldown.
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

    raise GameLogicError.new("Cannot create alliance if already in one!") \
      unless player.alliance_id.nil?
    raise GameLogicError.new(
      "Cannot create alliance if cooldown hasn't expired yet!") \
      unless player.alliance_cooldown_expired?
    raise GameLogicError.new("Cannot create alliance without technology!") \
      unless Technology::Alliances.exists?([
        "player_id=? AND level > 0", player.id])

    alliance = Alliance.new(:name => params['name'],
      :galaxy_id => player.galaxy_id, :owner_id => player.id)
    alliance.save!
    player.alliance = alliance
    player.save!

    respond :id => alliance.id
  end

  # Invites a person to join alliance. You can only invite a person if you
  # see his occupied planet. Battleground planets do not count.
  #
  # Invitation is sent as a notification.
  #
  # Invocation: by client
  #
  # Parameters:
  # - planet_id (Fixnum): ID of a visible planet
  #
  # Response: None
  #
  def action_invite
    param_options :required => %w{planet_id}

    alliance = player.alliance
    raise GameLogicError.new("Cannot invite if you're not in alliance!") \
      if alliance.nil?
    raise GameLogicError.new(
      "Cannot invite if you're not the owner of the alliance!"
    ) unless alliance.owner_id == player.id
    
    planet = SsObject::Planet.find(params['planet_id'])
    raise GameLogicError.new(
      "Cannot invite if you do not see that planet!"
    ) unless Location.visible?(player, planet)
    raise GameLogicError.new(
      "Cannot invite if planet is a battleground planet!"
    ) if planet.solar_system_id == Galaxy.battleground_id(player.galaxy_id)
    
    raise GameLogicError.new(
      "Cannot invite because alliance has max players!"
    ) if alliance.full?

    Notification.create_for_alliance_invite(alliance, planet.player)
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
  # Can fail if alliance has too much members already.
  #
  # Invocation: by client
  #
  # Parameters:
  # - notification_id (Fixnum)
  #
  # Response:
  # - success (Boolean): has a player successfully joined this alliance?
  #
  def action_join
    param_options :required => %w{notification_id}

    raise GameLogicError.new(
      "Cannot join alliance if cooldown hasn't expired yet!") \
      unless player.alliance_cooldown_expired?

    notification = Notification.where(:player_id => player.id).find(
      params['notification_id'])
    alliance = Alliance.find(notification.params[:alliance]['id'])
    if alliance.full?
      respond :success => false
    else
      alliance.accept(player)
      notification.destroy
      EventBroker.fire(notification, EventBroker::DESTROYED)
      respond :success => true
    end
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