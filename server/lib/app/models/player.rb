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

  def self.notify_on_create?; false; end
  def self.notify_on_destroy?; false; end
  include Parts::Notifier

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

  # Prepare for serialization to JSON.
  #
  # options:
  # * :mode => :ratings - for showing in ratings table
  # * :mode => :minimal - for showing in minimal attributes
  #
  def as_json(options=nil)
    if options
      case options[:mode]
      when :ratings
        {
          "id" => id,
          "name" => name,
          "economy_points" => economy_points,
          "army_points" => army_points,
          "science_points" => science_points,
          "war_points" => war_points,
          "planets_count" => planets_count,
          "victory_points" => victory_points,
          "alliance" => alliance.as_json,
          "online" => Dispatcher.instance.connected?(id)
        }
      when :minimal
        {"id" => id, "name" => name}
      when nil
      else
        raise ArgumentError.new("Unknown mode: #{options[:mode].inspect}!")
      end
    else
      attributes.only(*%w{id name scientists scientists_total xp
        first_time economy_points army_points science_points war_points
        victory_points creds planets_count}
      )
    end
  end

  def to_s
    "<Player id: #{id}, galaxy_id: #{galaxy_id}, name: #{name.inspect
      }, creds: #{creds}>"
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

  # Array of all point attributes.
  POINT_ATTRIBUTES = %w{economy_points science_points army_points war_points}

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

  OBJECTIVE_ATTRIBUTES.each do |attr|
    klass = "Objective::Have#{attr.camelcase}".constantize
    # Progress +Objective::HavePoints+ if points changed.
    after_save :if => lambda { |p| p.send("#{attr}_changed?") } do
      klass.progress(self)
    end
  end

  after_destroy { ControlManager.instance.player_destroyed(self) }

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