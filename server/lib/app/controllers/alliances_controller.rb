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
  ACTION_NEW = 'alliances|new'

  NEW_OPTIONS = logged_in + required(:name => String)
  def self.new_scope(m) end # TODO
  def self.new_action(m)
    raise GameLogicError.new(
      "Cannot create alliance if cooldown hasn't expired yet!"
    ) unless m.player.alliance_cooldown_expired?(nil)
    raise GameLogicError.new("Cannot create alliance without technology!") \
      unless Technology::Alliances.where(:player_id => m.player.id).
        where("level > 0").exists?

    alliance = Alliance.new(
      :name => m.params['name'], :galaxy_id => m.player.galaxy_id,
      :owner_id => m.player.id
    )
    alliance.save!
    alliance.accept(m.player)

    respond m, :id => alliance.id
  rescue ActiveRecord::RecordNotUnique
    respond m, :id => 0
  end

  # Invites a person to join alliance. You can only invite a person if you
  # see his occupied planet. Battleground planets do not count.
  #
  # Invitation is sent as a notification.
  #
  # Invocation: by client
  #
  # Parameters:
  # - player_id (Fixnum): ID of a player with visible planet or home solar
  # system.
  #
  # Response: None
  #
  ACTION_INVITE = 'alliances|invite'

  INVITE_OPTIONS = logged_in + required(:player_id => Fixnum)
  def self.invite_scope(m) end #TODO
  def self.invite_action(m)
    alliance = get_owned_alliance(m)

    visible_player_ids = Alliance.visible_enemy_player_ids(alliance.id)
    raise GameLogicError.new(
      "Cannot invite if you do not see that player!"
    ) unless visible_player_ids.include?(m.params['player_id'])

    raise GameLogicError.new(
      "Cannot invite because alliance has max players!"
    ) if alliance.full?

    player = Player.find(m.params['player_id'])
    Notification.create_for_alliance_invite(alliance, player)
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
  ACTION_JOIN = 'alliances|join'

  JOIN_OPTIONS = logged_in + required(:notification_id => Fixnum)
  def self.join_scope(m) end #TODO
  def self.join_action(m)
    notification = Notification.where(:player_id => m.player.id).find(
      m.params['notification_id'])
    alliance = Alliance.find(notification.params[:alliance]['id'])

    raise GameLogicError.new(
      "Cannot join alliance if cooldown hasn't expired yet!"
    ) unless m.player.alliance_cooldown_expired?(alliance.id)

    if alliance.full?
      respond m, :success => false
    else
      alliance.accept(m.player)
      notification.destroy!
      EventBroker.fire(notification, EventBroker::DESTROYED)
      Notification.create_for_alliance_joined(alliance, m.player)
      respond m, :success => true
    end
  end

  # Leaves current alliance. After leaving player will have to wait for
  # a period of time before he can join other alliance.
  #
  # If alliance owner leaves the alliance, he resigns alliance ownership to
  # his successor. If none is found - alliance is destroyed. Its
  # members are free to join other alliance as soon as this alliance is
  # destroyed.
  #
  # Invocation: by client
  #
  # Parameters: None
  #
  # Response: None
  #
  ACTION_LEAVE = 'alliances|leave'

  LEAVE_OPTIONS = logged_in
  def self.leave_scope(m) end #TODO
  def self.leave_action(m)
    m.player.leave_alliance!
  end

  # Kicks player out of alliance.
  #
  # You must be an alliance owner to do this. Kicked player is free to join
  # other alliance immediately after kick but cannot rejoin this one for
  # same cooldown as if he left.
  #
  # Invocation: by client
  #
  # Parameters:
  # - player_id (Fixnum)
  #
  # Response: None
  #
  ACTION_KICK = 'alliances|kick'

  KICK_OPTIONS = logged_in + required(:player_id => Fixnum)
  def self.kick_scope(m) end # TODO
  def self.kick_action(m)
    alliance = get_owned_alliance(m)
    raise GameLogicError.new("Current player is not in alliance!") \
      if alliance.nil?

    member = Player.where(:alliance_id => alliance.id).
      find(m.params['player_id'])
    raise GameLogicError.new("Cannot kick yourself!") \
      if member.id == m.player.id
    alliance.kick(member)
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
  # Only if alliance owner:
  # - invitable_players (Hash[]]): Player#ratings with players that you can
  # invite to alliance.
  #
  ACTION_SHOW = 'alliances|show'
  
  SHOW_OPTIONS = logged_in + required(:id => Fixnum)
  def self.show_scope(m) end # TODO
  def self.show_action(m)
    alliance = Alliance.find(m.params['id'])
    response = {
      :name => alliance.name,
      :description => alliance.description,
      :owner_id => alliance.owner_id,
      :players => alliance.player_ratings,
      :victory_points => alliance.victory_points,
    }
    if alliance.owner_id == m.player.id
      response[:invitable_players] = alliance.invitable_ratings
    end

    respond m, response
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
  # Response:
  # - if successful: None
  # - if failed:
  #
  ACTION_EDIT = 'alliances|edit'

  EDIT_OPTIONS = logged_in + valid(:name => String)
  def self.edit_scope(m) end # TODO
  def self.edit_action(m)
    alliance = get_owned_alliance(m)
    creds_needed = CONFIG['creds.alliance.change']
    raise GameLogicError.new(
      "Player tried to change alliance, not enough creds! Needed: #{
      creds_needed}, had: #{m.player.creds}"
    ) if m.player.creds < creds_needed

    stats = CredStats.alliance_change(m.player)
    m.player.creds -= creds_needed
    alliance.name = m.params['name'] if m.params['name']

    alliance.save!
    m.player.save!
    stats.save!
  rescue ActiveRecord::RecordNotUnique
    respond m, :error => 'not_unique'
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
  ACTION_EDIT_DESCRIPTION = 'alliances|edit_description'

  EDIT_DESCRIPTION_OPTIONS = logged_in + required(:description => String)
  def self.edit_description_scope(m) end #TODO
  def self.edit_description_action(m)
    alliance = get_owned_alliance(m)
    alliance.description = m.params['description']
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
  ACTION_RATINGS = 'alliances|ratings'

  RATINGS_OPTIONS = logged_in
  def self.ratings_scope(m) end # TODO
  def seld.ratings_action(m)
    respond m, :ratings => Alliance.ratings(m.player.galaxy_id)
  end

  # Takes over alliance control. You can only do this if:
  #
  # 1) You are a member of that alliance.
  # 2) Owner has not connected for some time.
  # 3) You have sufficient alliance technology level.
  #
  # Invocation: by client
  #
  # Parameters: None
  #
  # Response: None
  #
  ACTION_TAKE_OVER = 'alliances|take_over'

  TAKE_OVER_OPTIONS = logged_in
  def self.take_over_scope(m) end # TODO
  def self.take_over_action(m)
    alliance = m.player.alliance
    raise GameLogicError.new(
      "You must be in alliance to take ownership of one!"
    ) if alliance.nil?

    alliance.take_over!(m.player)

    push m, ACTION_SHOW, :id => alliance.id
  end

  # Gives away alliance ownership to other player.
  #
  # He must:
  # 1) Be a member of same alliance.
  # 2) Have sufficient alliance technology level.
  #
  # Invocation: by client
  #
  # Parameters:
  # - player_id (Fixnum): player that you are giving ownership too.
  #
  # Response:
  # - status (String): "success" | "technology_level_too_low"
  #
  ACTION_GIVE_AWAY = 'alliances|give_away'

  GIVE_AWAY_OPTIONS = logged_in + required(:player_id => Fixnum)
  def self.give_away_scope(m) end # TODO
  def self.give_away_action(m)
    alliance = m.player.alliance
    raise GameLogicError.new(
      "You must be in alliance give away ownership of one!"
    ) if alliance.nil?

    raise GameLogicError.new(
      "You must be alliance owner to give away ownership!"
    ) unless alliance.owner_id == m.player.id

    new_owner = Player.find(m.params['player_id'])

    alliance.transfer_ownership!(new_owner)

    respond m, :status => 'success'
    push m, ACTION_SHOW, :id => alliance.id
  rescue Alliance::TechnologyLevelTooLow
    respond m, :status => 'technology_level_too_low'
  end

  class << self
    private
    def get_alliance(m)
      alliance = m.player.alliance
      raise GameLogicError.new("Current player is not in alliance!") \
        if alliance.nil?
      alliance
    end

    def get_owned_alliance(m)
      alliance = get_alliance(m)
      raise GameLogicError.new("Current player is not an alliance owner!") \
        unless alliance.owner_id == m.player.id
      alliance
    end
  end
end
