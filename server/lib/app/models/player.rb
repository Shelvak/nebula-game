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
    players = Player.find(player_ids).hash_by(&:id)
    
    grouped = {}
    player_ids.map do |player_id|
      player = players[player_id]
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

  def as_json(options=nil)
    if options && options[:mode] == :ratings
      {:id => id, :name => name, :points => points, 
        :alliance => alliance.as_json}
    else
      attributes.except('galaxy_id', 'auth_token').symbolize_keys
    end
  end

  def to_s
    "<Player id: #{id}, galaxy_id: #{galaxy_id}, name: #{name.inspect}>"
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

  # Progress +Objective::HavePoints+ if points changed.
  after_save :if => lambda { |p| p.points_changed? } do
    Objective::HavePoints.progress(self)
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
    changes = Reducer::ScientistsReducer.reduce(
      technologies.upgrading.find(:all, :order => 'scientists ASC'),
      scientists - self.scientists
    )
    EventBroker.fire(changes.map do |technology, state, new_scientists|
      technology
    end, EventBroker::CHANGED)

    # Reload updated player
    reload
  end
end