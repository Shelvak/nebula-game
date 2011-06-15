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
  # - id (Fixnum): alliance id or 0 if name is not unique.
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
  rescue ActiveRecord::RecordNotUnique
    respond :id => 0
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

    alliance = get_owned_alliance
    
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

  # Leaves current alliance. After leaving player will have to wait for
  # a period of time before he can join other alliance.
  #
  # If alliance owner leaves the alliance, alliance is destroyed. Its
  # members are free to join other alliance as soon as this alliance is
  # destroyed.
  #
  # Invocation: by client
  #
  # Parameters: None
  #
  # Response: None
  #
  def action_leave
    alliance = get_alliance

    player.alliance_cooldown_ends_at = CONFIG.evalproperty(
      'alliances.leave.cooldown').from_now
    player.save!

    if alliance.owner_id == player.id
      alliance.destroy
    else
      alliance.throw_out(player)
    end
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
    param_options :required => %{player_id}

    alliance = get_owned_alliance
    raise GameLogicError.new("Current player is not in alliance!") \
      if alliance.nil?

    member = Player.where(:alliance_id => alliance.id).find(
      params['player_id'])
    raise GameLogicError.new("Cannot kick yourself!") \
      if member.id == player.id
    alliance.throw_out(member)
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
  # - description (String)
  # - owner_id (Fixnum): ID of the alliance owner.
  # - players (Hash[]): Alliance#player_ratings
  # - victory_points (Fixnum): number of alliance victory points
  #
  def action_show
    param_options :required => %w{id}

    alliance = Alliance.find(params['id'])
    respond :name => alliance.name,
      :description => alliance.description,
      :owner_id => alliance.owner_id,
      :players => alliance.player_ratings,
      :victory_points => alliance.victory_points
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

    alliance = get_owned_alliance
    creds_needed = CONFIG['creds.alliance.change']
    raise GameLogicError.new(
      "Player tried to change alliance, not enough creds! Needed: #{
      creds_needed}, had: #{player.creds}"
    ) if player.creds < creds_needed

    player.creds -= creds_needed
    alliance.name = params['name'] if params['name']

    ActiveRecord::Base.transaction do
      alliance.save!
      player.save!
      CredStats.alliance_change!(player)
    end
  end

  # Edits an alliance description. Only owner can do this.
  #
  # Invocation: by client
  #
  # Parameters:
  # - description (String): new alliance description
  #
  # Response: None
  #
  def action_edit_description
    param_options :required => %w{description}

    alliance = get_owned_alliance
    alliance.description = params['description']
    alliance.save!
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

  private
  def get_alliance
    alliance = player.alliance
    raise GameLogicError.new("Current player is not in alliance!") \
      if alliance.nil?
    alliance
  end

  def get_owned_alliance
    alliance = get_alliance
    raise GameLogicError.new("Current player is not an alliance owner!") \
      unless alliance.owner_id == player.id
    alliance
  end
end
