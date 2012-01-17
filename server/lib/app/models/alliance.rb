class Alliance < ActiveRecord::Base
  # Foreign key
  belongs_to :galaxy
  # FK
  belongs_to :owner, :class_name => "Player"

  # FK :dependent => :nullify
  has_many :players
  # FK :dependent => :delete_all
  has_many :fow_ss_entries
  # FK :dependent => :delete_all
  has_many :fow_galaxy_entries
  
  has_many :naps, :finder_sql => proc { "SELECT * FROM `#{Nap.table_name
    }` WHERE initiator_id=#{id} OR acceptor_id=#{id}" },
    :dependent => :destroy

  validates_length_of :name,
    :minimum => CONFIG['alliances.validation.name.length.min'],
    :maximum => CONFIG['alliances.validation.name.length.max']
  before_validation do
    self.name = name.strip.gsub(/ {2,}/, " ")
  end

  # Raised when action requires some +Technology::Alliances+ level but this
  # condition is not satisfied.
  class TechnologyLevelTooLow < GameLogicError; end

  # Raised when no successor can be found in #resign_ownership!
  class NoSuccessorFound < GameError; end

  validates_length_of :description,
    :maximum => CONFIG['alliances.validation.description.length.max']

  after_create do
    ControlManager.instance.alliance_created(self) unless galaxy.dev?
    true
  end

  after_update do
    galaxy.check_if_finished!(victory_points) if victory_points_changed?

    ControlManager.instance.alliance_renamed(self) \
      if name_changed? && ! galaxy.dev?
  end

  # Dispatch changed for all alliance members. Before destroy because after
  # it players would be nil.
  before_destroy do
    @cached_players = self.players.all
    true
  end

  after_destroy do
    unless @cached_players.blank?
      @cached_players.each do |player|
        player.alliance = nil
        Chat::Pool.instance.hub_for(player).on_alliance_change(player)
      end
      EventBroker.fire(@cached_players, EventBroker::CHANGED)
    end      

    ControlManager.instance.alliance_destroyed(self) unless galaxy.dev?

    true
  end

  # Returns +Array+ of +Player+ ids who are in _alliance_ids_.
  # _alliance_ids_ can be Array or Fixnum.
  def self.player_ids_for(alliance_ids)
    Player.select("id").where(:alliance_id => alliance_ids).c_select_values.
      map(&:to_i)
  end

  # Returns +Hash+ of {id => name} pairs.
  def self.names_for(alliance_ids)
    select("id, name").where(:id => alliance_ids).c_select_all.
      each_with_object({}) do |row, hash|
        hash[row['id']] = row['name']
      end
  end

  # Returns non-ally players which own planets and we can see them for _player_.
  def self.visible_enemy_player_ids(alliance_id)
    ally_ids = player_ids_for(alliance_id)

    solar_system_ids = FowSsEntry.
      select("solar_system_id").
      where(:alliance_id => alliance_id, :enemy_planets => true).
      c_select_values
    player_ids = SsObject::Planet.
      select("DISTINCT(player_id)").
      where("player_id IS NOT NULL").
      where(:solar_system_id => solar_system_ids)
    player_ids = player_ids.where("player_id NOT IN (?)", ally_ids) \
      unless ally_ids.blank?
    player_ids = player_ids.c_select_values
    player_ids
  end

  # Returns visible non-napped alliance ids for alliance with ID _alliance_id_.
  def self.visible_enemy_alliance_ids(alliance_id)
    player_ids = visible_enemy_player_ids(alliance_id)
    alliance_ids = Player.
      select("DISTINCT(alliance_id)").
      where("alliance_id IS NOT NULL").
      where(:id => player_ids).
      c_select_values
    alliance_ids
  end

  RATING_SUMS = \
    (Player::POINT_ATTRIBUTES + %w{planets_count bg_planets_count}).map {
    |attr| "CAST(SUM(p.#{attr}) as SIGNED) as #{attr}" }.join(", ")

  # Returns array of Hashes:
  #
  # {
  #   'players_count'   => Fixnum, # Number of players in the alliance.
  #   'alliance_id'     => Fixnum, # ID of the alliance
  #   'name'            => String, # Name of the alliance
  #   'war_points',     => Fixnum, # Sum of alliance war points
  #   'army_points',    => Fixnum, # -""-
  #   'science_points', => Fixnum, # -""-
  #   'economy_points', => Fixnum, # -""-
  #   'victory_points', => Fixnum, # -""-
  #   'planets_count',  => Fixnum  # -""-
  #   'bg_planets_count',  => Fixnum  # -""-
  # }
  #
  def self.ratings(galaxy_id)
    connection.select_all(
      """
      SELECT COUNT(*) as players_count, alliance_id, a.name as name,
        a.victory_points as victory_points,
        #{RATING_SUMS} FROM `#{Player.table_name}` p
      LEFT JOIN `#{table_name}` a ON p.alliance_id=a.id
      WHERE p.galaxy_id=#{galaxy_id.to_i} AND alliance_id IS NOT NULL
      GROUP BY alliance_id
      """
    )
  end

  def as_json(options=nil)
    options ||= {}
    if options[:mode] == :minimal
      {'name' => name, 'id' => id}
    else
      attributes.except('galaxy_id')
    end
  end

  # Player#ratings for this alliance members.
  def player_ratings
    Player.ratings(galaxy_id, Player.where(:alliance_id => id))
  end

  # Player#ratings for players that can be invited to this alliance.
  def invitable_ratings
    Player.ratings(
      galaxy_id,
      Player.where(:id => self.class.visible_enemy_player_ids(id))
    )
  end

  # Returns +Player+ ids who are members of this +Alliance+.
  def member_ids
    self.class.player_ids_for([id])
  end

  # Returns +Technology::Alliances+ for this alliance.
  def technology
    technology = Technology::Alliances.where(:player_id => owner_id).first
    raise ArgumentError.new("Alliance cannot be without technology!") \
      if technology.nil?
    technology
  end

  # Returns if this alliance is full.
  def full?
    players.size >= technology.max_players
  end

  # Accepts _player_ into +Alliance+.
  def accept(player)
    raise GameLogicError.new("Cannot switch alliances (currently in: #{
      player.alliance_id})") unless player.alliance_id.nil?

    player.alliance = self
    player.alliance_vps = 0
    player.save!

    # Add solar systems visible to player to alliance visibility pool.
    # Order matters here, because galaxy entry dispatches event.
    FowSsEntry.assimilate_player(self, player)
    FowGalaxyEntry.assimilate_player(self, player)

    # Dispatch that this player joined the alliance, unless he is owner
    # of that alliance.
    ControlManager.instance.player_joined_alliance(player, self) \
      unless player.id == owner_id || galaxy.dev?
    # Dispatch changed on owner because he has alliance_player_count
    EventBroker.fire(owner, EventBroker::CHANGED)
    # Dispatch changed for status changed event
    event = Event::StatusChange::Alliance.new(self, player,
      Event::StatusChange::Alliance::ACCEPT)
    EventBroker.fire(event, EventBroker::CHANGED)

    true
  end

  # Removes _player_ from +Alliance+.
  def throw_out(player)
    raise GameLogicError.new(
      "Player is not in this alliance! (currently in: #{
      player.alliance_id}") unless player.alliance_id == id

    player.alliance = nil
    player.save!

    # Remove players visibility pool from alliance pool.
    # Order matters here, because galaxy entry dispatches event.
    FowSsEntry.throw_out_player(self, player)
    FowGalaxyEntry.throw_out_player(self, player)

    ControlManager.instance.player_left_alliance(player, self) \
      unless galaxy.dev?

    Combat::LocationChecker.check_player_locations(player)
    # Dispatch changed on owner because he has alliance_player_count
    EventBroker.fire(owner, EventBroker::CHANGED)
    # Dispatch changed for status changed event
    event = Event::StatusChange::Alliance.new(self, player,
      Event::StatusChange::Alliance::THROW_OUT)
    EventBroker.fire(event, EventBroker::CHANGED)

    true
  end

  # Kicks _player_ out of +Alliance+. Does not allow him to rejoin for specified
  # period of time.
  def kick(player)
    throw_out(player)

    player.alliance_cooldown_ends_at = Cfg.alliance_leave_cooldown.from_now
    player.alliance_cooldown_id = id
    player.save!

    Notification.create_for_kicked_from_alliance(self, player)
  end

  # Changes alliance ownership and makes _player_ new owner.
  #
  # He must:
  # 1) Be a member of this alliance.
  # 2) Have sufficient alliance technology level.
  def transfer_ownership!(player)
    raise GameLogicError.new(
      "Cannot transfer ownership to same player #{player}!"
    ) if owner_id == player.id

    raise GameLogicError.new(
      "Cannot transfer alliance ownership to player (#{player
      }) not from this alliance!"
    ) unless player.alliance_id == id

    technology = Technology::Alliances.where(:player_id => player.id).first
    raise TechnologyLevelTooLow.new(
      "#{player} does not have alliances technology!"
    ) if technology.nil?

    required_level = Technology::Alliances.
      required_level_for_player_count(players.size)
    raise TechnologyLevelTooLow.new(
      "#{player} only has level #{technology.level
      } of alliances technology but level #{required_level
      } is required to transfer alliance ownership."
    ) if technology.level < required_level

    transfer_ownership_impl!(player)
  end

  # In case alliance owner resigns and quits the alliance this method tries to
  # find another player from members which can take over this alliance.
  #
  # That member needs to have sufficient alliance technology level.
  #
  # Raises +Alliance::NoSuccessorFound+ if no such member can be found.
  def resign_ownership!
    potential_ids = member_ids - [owner_id]

    required_level = Technology::Alliances.
      required_level_for_player_count(potential_ids.size)

    successor_id = Technology::Alliances.
      select("player_id").
      where(:player_id => potential_ids).
      where("level >= ?", required_level).
      joins(:player).
      order("victory_points DESC").
      limit(1).
      c_select_value

    raise NoSuccessorFound.new(
      "Cannot find a successor for #{self}! Alliance technology level #{
      required_level} is needed but none of the members have it."
    ) if successor_id.nil?

    current_owner = owner
    new_owner = Player.find(successor_id)

    transfer_ownership_impl!(new_owner)
    throw_out(current_owner)

    true
  end

  # Takes over alliance control from current owner and gives it to _player_.
  # You can only do this if owner hasn't connected for some time.
  #
  # See #transfer_ownership! for more information.
  def take_over!(player)
    owner_inactive = owner.inactivity_time
    required_time = Cfg.alliance_take_over_owner_inactivity_time
    raise GameLogicError.new(
      "Alliance owner has to be inactive for #{required_time
      } seconds but he is only inactive for #{owner_inactive
      } seconds, takeover not possible!"
    ) if required_time > owner_inactive

    transfer_ownership!(player)
  end

  private
  # No-checks implementation of #transfer_ownership! used by it and
  # #resign_ownership!.
  def transfer_ownership_impl!(player)
    old_owner = Player.minimal(owner_id)
    self.owner = player
    save!

    as_json = self.as_json(:mode => :minimal)
    new_owner = player.as_json(:mode => :minimal)

    member_ids.each do |member_id|
      Notification.create_for_alliance_owner_changed(
        member_id, as_json, old_owner, new_owner
      )
    end

    ControlManager.instance.alliance_owner_changed(self, player)

    true
  end
end
