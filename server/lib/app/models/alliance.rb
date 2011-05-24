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

  validates_length_of :description,
    :maximum => CONFIG['alliances.validation.description.length.max']

  after_create do
    ControlManager.instance.alliance_created(self)
  end

  after_update do
    ControlManager.instance.alliance_renamed(self) if name_changed?
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

    ControlManager.instance.alliance_destroyed(self)
  end

  # Returns +Array+ of +Player+ ids who are in _alliance_ids_.
  # _alliance_ids_ can be Array or Fixnum.
  def self.player_ids_for(alliance_ids)
    Player.connection.select_values(%Q{
      SELECT id FROM `#{Player.table_name}` WHERE #{
        Player.sanitize_sql_hash_for_conditions(
          :alliance_id => alliance_ids
        )
      }
    }).map(&:to_i)
  end

  # Returns +Hash+ of {id => name} pairs.
  def self.names_for(alliance_ids)
    names = connection.select_values(%Q{
      SELECT name FROM `#{table_name}` WHERE #{
        sanitize_sql_hash_for_conditions(:id => alliance_ids)
      }
    })
    Hash[alliance_ids.zip(names)]
  end

  RATING_SUMS = \
    (Player::POINT_ATTRIBUTES + %w{victory_points planets_count}).map {
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
  # }
  #
  def self.ratings(galaxy_id)
    connection.select_all(
      """
      SELECT COUNT(*) as players_count, alliance_id, a.name as name,
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
      super(options)
    end
  end

  # Player#ratings for this alliance members.
  def player_ratings
    Player.ratings(galaxy_id, Player.where(:alliance_id => id))
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
    player.save!

    # Add solar systems visible to player to alliance visibility pool.
    # Order matters here, because galaxy entry dispatches event.
    FowSsEntry.assimilate_player(self, player)
    FowGalaxyEntry.assimilate_player(self, player)

    ControlManager.instance.player_joined_alliance(player, self)
    # Dispatch changed on owner because he has alliance_player_count
    EventBroker.fire(owner, EventBroker::CHANGED)

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

    ControlManager.instance.player_left_alliance(player, self)

    Combat::LocationChecker.check_player_locations(player)
    # Dispatch changed on owner because he has alliance_player_count
    EventBroker.fire(owner, EventBroker::CHANGED)

    true
  end
end