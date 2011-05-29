# Player is association between User and Galaxy
#
# Having record associate those two means that User is enrolled and playing
# in Galaxy.
class Player < ActiveRecord::Base
  belongs_to :alliance
  belongs_to :galaxy
  # FK :dependent => :delete_all
  has_many :fow_ss_entries
  # FK :dependent => :delete_all
  has_many :fow_galaxy_entries
  # FK :dependent => :delete_all
  has_many :technologies
  # FK :dependent => :delete_all
  has_many :notifications
  # FK :dependent => :delete_all
  has_many :quest_progresses
  has_many :started_quests,
    :class_name => "Quest",
    :finder_sql => "SELECT q.* FROM `#{QuestProgress.table_name}` qp
      LEFT JOIN `#{Quest.table_name}` q ON qp.quest_id=q.id
      WHERE player_id=\#{id} AND status=#{QuestProgress::STATUS_STARTED}"
  # FK :dependent => :delete_all
  has_many :objective_progresses
  # FK :dependent => :nullify
  has_many :units
  # FK :dependent => :nullify
  has_many :planets, :class_name => "SsObject::Planet"
  # FK with NO ACTION, because we need to dispatch changed events in code
  # for alliance members.
  has_one :owned_alliance, :dependent => :destroy, 
    :class_name => "Alliance", :foreign_key => :owner_id
  # FK :dependent => :delete_all, beware this only includes unit entries
  # because buildings do not technically belong to a player, but instead to
  # a planet.
  has_many :construction_queue_entries

  def self.notify_on_create?; false; end
  def self.notify_on_destroy?; false; end
  include Parts::Notifier
  include Parts::PlayerVip

  # Given +Array+ with +Player+ ids returns a +Hash+ where players are
  # grouped by alliance ids. Players who are not in alliance get negative
  # alliance ids, starting from -1.
  def self.grouped_by_alliance(player_ids)
    not_allied_id = 0
    # Support for only-npc action.
    players = player_ids == [nil] \
      ? [] : Player.find(player_ids).hash_by(&:id)
    
    grouped = {}
    player_ids.map do |player_id|
      player = player_id.nil? ? nil : players[player_id]
      if player.nil? || player.alliance_id.nil?
        not_allied_id -= 1
        [not_allied_id, player]
      else
        [player.alliance_id, player]
      end
    end.each do |alliance_id, player|
      grouped[alliance_id] ||= []
      grouped[alliance_id].push player
    end

    grouped
  end

  def self.minimal(id)
    if id
      name = connection.select_one(
        "SELECT name FROM `#{table_name}` WHERE id=#{id.to_i}"
      )['name']
      {:id => id, :name => name}
    else
      nil
    end
  end

  # Return Hash of {player_id => Player#minimal} pairs from given _objects_.
  def self.minimal_from_objects(objects)
    objects.map(&:player_id).uniq.map_to_hash do |player_id|
      minimal(player_id)
    end
  end
  
  # Is daily bonus available for this player?
  def daily_bonus_available?
    daily_bonus_at.nil? || daily_bonus_at <= Time.now
  end
  
  # Set next daily bonus expiration. 
  # 
  # If it was nil, set it to CONFIG['daily_bonus.cooldown'] from now. 
  # 
  # If it was not nil, set it to closest future date to now by adding
  # CONFIG['daily_bonus.cooldown'] intervals to previous daily bonus date.
  def set_next_daily_bonus
    now = Time.now
    self.daily_bonus_at ||= now
    while self.daily_bonus_at <= now
      self.daily_bonus_at += CONFIG['daily_bonus.cooldown']
    end
    self.daily_bonus_at
  end
  
  def set_next_daily_bonus!
    set_next_daily_bonus
    save!
  end

  # Prepare for serialization to JSON.
  #
  # options:
  # * :mode => :minimal - for showing in minimal attributes
  #
  def as_json(options=nil)
    if options
      case options[:mode]
      when :minimal
        {"id" => id, "name" => name}
      when nil
      else
        raise ArgumentError.new("Unknown mode: #{options[:mode].inspect}!")
      end
    else
      json = attributes.only(*%w{id name scientists scientists_total xp
        first_time economy_points army_points science_points war_points
        victory_points creds population population_max planets_count
        alliance_id alliance_cooldown_ends_at
        vip_creds vip_level vip_until vip_creds_until
        daily_bonus_at}
      )
      unless alliance_id.nil?
        owner = id == alliance.owner_id
        json['alliance_owner'] = owner
        json['alliance_player_count'] = alliance.players.count if owner
      end

      json
    end
  end

  # Array of all point attributes.
  POINT_ATTRIBUTES = %w{economy_points science_points army_points war_points}

  RATING_ATTRIBUTES_SQL = (
    %w{id name victory_points planets_count} + POINT_ATTRIBUTES
  ).map { |attr| "`#{table_name}`.`#{attr}`" }.join(", ")

  # Returns ratings for _galaxy_id_. If _player_ids_ are given then
  # returns ratings only for those players.
  #
  # If _condition_ is passed it is used as +ActiveRecord::Relation+ for base
  # of ratings search.
  #
  # Results are +unordered+ by default!
  #
  # Returns Array of Hashes:
  # [
  #   {
  #     "id" => Fixnum (player ID),
  #     "name" => String (player name),
  #     "victory_points" => Fixnum,
  #     "planets_count" => Fixnum,
  #     "war_points" => Fixnum,
  #     "science_points" => Fixnum,
  #     "economy_points" => Fixnum,
  #     "army_points" => Fixnum,
  #     "alliance" => {"id" => Fixnum, "name" => String} | nil,
  #     "online" => Boolean,
  #   }
  # ]
  #
  def self.ratings(galaxy_id, condition=nil)
    p = table_name
    (condition.nil? ? self : condition).
      select(RATING_ATTRIBUTES_SQL + ", a.name AS a_name, a.id AS a_id").
      where(:galaxy_id => galaxy_id).
      joins("LEFT JOIN #{Alliance.table_name} AS a 
        ON `#{p}`.alliance_id=a.id").
      order("id").
      c_select_all.
      map do |row|
        alliance_id = row.delete('a_id')
        alliance_name = row.delete('a_name')
        row['alliance'] = alliance_id \
          ? {'id' => alliance_id, 'name' => alliance_name} \
          : nil
        row["online"] = Dispatcher.instance.connected?(row["id"])
        row
      end
  end

  def population_free; population_max - population; end

  def alliance_cooldown_expired?
    alliance_cooldown_ends_at.nil? || alliance_cooldown_ends_at < Time.now
  end

  def to_s
    "<Player(#{id}), pop: #{population}/#{population_max}, gid: #{
      galaxy_id}, name: #{name.inspect}, creds: #{creds}, VIP: #{
      vip_level}@#{vip_creds}/#{vip_creds_per_tick}>"
  end

  def inspect
    to_s
  end

  # Returns array of player ids which are friendly to this player (self and
  # alliance members).
  def friendly_ids
    alliance_id.nil? ? [id] : Alliance.player_ids_for(alliance_id)
  end

  # Returns array of player ids which are napped to this player.
  # Only established naps count.
  def nap_ids
    alliance_id.nil? ? [] : Alliance.player_ids_for(
      Nap.alliance_ids_for(alliance_id)
    )
  end

  # Make sure we don't get below 0 points.
  before_save do
    POINT_ATTRIBUTES.each do |attr|
      send(:"#{attr}=", 0) if send(attr) < 0
    end

    true
  end

  def points; POINT_ATTRIBUTES.map { |attr| send(attr) }.sum; end

  def points_changed?
    POINT_ATTRIBUTES.each { |attr| return true if send("#{attr}_changed?") }
    false
  end

  OBJECTIVE_ATTRIBUTES = %w{victory_points points} + POINT_ATTRIBUTES

  # Progress +Objective::HavePoints+ and friends if points changed.
  OBJECTIVE_ATTRIBUTES.each do |attr|
    klass = "Objective::Have#{attr.camelcase}".constantize
    after_save :if => lambda { |p| p.send("#{attr}_changed?") } do
      klass.progress(self)
    end
  end

  attr_accessor :invoked_from_control_manager
  
  # Destroy player in WEB unless this destroy was invoked from control
  # manager.
  after_destroy :unless => :invoked_from_control_manager do
    ControlManager.instance.player_destroyed(self)
  end

  # Update player in dispatcher if it is connected so alliance ids and other
  # things would be intact.
  #
  # This is why DataMapper is great - it keeps one object in memory for one
  # row in DB.
  after_update do
    dispatcher = Dispatcher.instance
    dispatcher.update_player(self) if dispatcher.connected?(id)
    hub = Chat::Pool.instance.hub_for(self)
    hub.on_alliance_change(self) if alliance_id_changed?
    hub.on_language_change(self) if language_changed?
  end

  # Increase or decrease scientist count.
  def change_scientist_count!(count)
    ensure_free_scientists!(- count) if count < 0

    self.scientists += count
    self.scientists_total += count
    self.save!
  end

  # Ensures that required number of free _scientists_ is available.
  #
  # It does this by pausing technologies and reducing
  # extra assigned scientists to technologies if needed.
  def ensure_free_scientists!(scientists)
    changed_technologies = Reducer::ScientistsReducer.reduce(
      technologies.upgrading.order('scientists ASC').all,
      scientists - self.scientists
    ).map do |technology, state, new_scientists|
      technology
    end
    EventBroker.fire(changed_technologies, EventBroker::CHANGED) \
      unless changed_technologies.blank?

    # Reload updated player
    reload

    # If we still don't have enough scientists start recalling explorations.
    if self.scientists < scientists
      planets.explored.each do |planet|
        scientists_exploring = planet.exploration_scientists
        planet.stop_exploration!
        self.scientists += scientists_exploring
        return if self.scientists >= scientists
      end
    end
  end
end