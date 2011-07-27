# Use one of the SolarSystem::* classes. This serves as base class.
class SolarSystem < ActiveRecord::Base
  belongs_to :galaxy

  include Parts::CleanAsJson
  include Parts::Shieldable
  include Parts::Object
  include Zone

  # Regular kind of solar system
  KIND_NORMAL = 0
  # Wormhole solar system
  KIND_WORMHOLE = 1
  # Battleground solar system
  KIND_BATTLEGROUND = 2
  # Dead solar system
  KIND_DEAD = 3

  # Foreign keys take care of the destruction
  has_many :ss_objects
  has_many :planets, :class_name => "SsObject::Planet"
  has_many :asteroids, :class_name => "SsObject::Asteroid"
  has_many :jumpgates, :class_name => "SsObject::Jumpgate"
  has_many :fow_ss_entries

  validates_uniqueness_of :galaxy_id, :scope => [:x, :y],
    :message => "[galaxy_id, x, y] should be unique for SolarSystem."

  scope :in_galaxy, Proc.new { |galaxy|
    galaxy = galaxy.id if galaxy.is_a? Galaxy

    {:conditions => {:galaxy_id => galaxy}}
  }
  scope :in_zone, Proc.new { |x, y|
    {
      :conditions => [
        "x BETWEEN ? AND ? AND y BETWEEN ? AND ?",
        x.first, x.last, y.first, y.last
      ]
    }
  }

  def self.galaxy_battleground(galaxy_id)
    where(:galaxy_id => galaxy_id, :x => nil, :y => nil).first
  end

  # Is this solar system a global battleground?
  def main_battleground?; x.nil? && y.nil?; end
  
  def normal?; kind == KIND_NORMAL; end
  scope :normal, where(:kind => KIND_NORMAL)
  def battleground?; kind == KIND_BATTLEGROUND; end
  scope :battleground, where(:kind => KIND_BATTLEGROUND)
  def wormhole?; kind == KIND_WORMHOLE; end
  scope :wormhole, where(:kind => KIND_WORMHOLE)

  # Return +SolarSystemPoint+s where NPC units are standing.
  def npc_unit_locations
    Unit.connection.select_all("SELECT location_x, location_y
      FROM `#{Unit.table_name}`
      WHERE location_id=#{id}
      AND location_type=#{Location::SOLAR_SYSTEM}
      AND player_id IS NULL
      GROUP BY location_x, location_y"
    ).map do |row|
      SolarSystemPoint.new(id, row['location_x'].to_i,
        row['location_y'].to_i)
    end
  end

  # Returns +Array+ of _player_ visible +SolarSystem+s with their metadata
  # attached.
  #
  # Each array element is:
  # {:solar_system => +SolarSystem+, :metadata => FowSsEntry#merge_metadata}
  #
  def self.visible_for(player)
    solar_system_entries = {}

    FowSsEntry.for(player).each do |fse|
      solar_system_entries[fse.solar_system_id] ||= {}
      # It may be either player or alliance entry
      solar_system_entries[fse.solar_system_id][
        fse.player_id ? :player : :alliance
      ] = fse
    end

    SolarSystem.find(:all,
      :conditions => {:id => solar_system_entries.keys}
    ).map do |solar_system|
      entries = solar_system_entries[solar_system.id]

      {
        :solar_system => solar_system,
        :metadata => FowSsEntry.merge_metadata(
          entries[:player], entries[:alliance]
        )
      }
    end
  end

  # Find and return visible solar system by _id_ which is visible for
  # _player_. Raises ActiveRecord::RecordNotFound if solar system is not
  # visible.
  def self.find_if_visible_for(id, player)
    entries = FowSsEntry.for(player).where(:solar_system_id => id).count
    raise ActiveRecord::RecordNotFound if entries == 0

    ss = SolarSystem.find(id)
    raise ActiveRecord::RecordNotFound if ss.has_shield? &&
      ss.shield_owner_id != player.id

    ss
  end

  # Retrieves metadata for single solar system and player.
  def self.metadata_for(id, player)

    FowSsEntry.merge_metadata(
      entries.find { |entry| entry.player_id == player.id },
      # Try to find alliance entry if player is in alliance.
      player.alliance_id \
        ? entries.find { |entry| entry.alliance_id == player.alliance_id } \
        : nil
    )
  end

  # Returns player ids for those who can see this solar system.
  def self.observer_player_ids(id)
    FowSsEntry.observer_player_ids(id)
  end

  def as_json(options=nil)
    hash = defined?(super) ? super(options) : {}
    hash["id"] = id
    hash["x"] = x
    hash["y"] = y
    hash["kind"] = kind
    hash
  end

  # Used in SpaceMule to calculate traveling paths.
  def travel_attrs
    {
      :id => id,
      :x => x,
      :y => y,
      :galaxy_id => galaxy_id
    }
  end

  def galaxy_point
    GalaxyPoint.new(galaxy_id, x, y)
  end

  # How many orbits this SolarSystem has?
  def orbit_count
    SsObject.maximum(:position,
      :conditions => {:solar_system_id => id}) + 1
  end
  
  # Kill solar system. Turns it into dead solar system.
  def die!
    self.kind = KIND_DEAD
    save!
    delete_assets!
    fow_ss_entries.update_all(:enemy_planets => false, :enemy_ships => false)
    
    EventBroker.fire(self, EventBroker::CHANGED)
  end
  
  # Removes all ss_objects/wreckages/units in this solar system.
  def delete_assets!
    SsObject.in_solar_system(self).delete_all
    Wreckage.in_zone(self).delete_all
    Unit.in_zone(self).delete_all
  end

  def self.on_callback(id, event)
    case event
    when CallbackManager::EVENT_CHECK_INACTIVE_PLAYER
      check_player_activity(id)
    else
      raise CallbackManager::UnknownEvent.new(self, id, event)
    end
  end

  # Checks if player in +SolarSystem+ _id_ is active.
  def self.check_player_activity(id)
    player_ids = SsObject.connection.select_values(
      "SELECT DISTINCT(player_id) FROM `#{SsObject.table_name
        }` WHERE `solar_system_id`=#{id.to_i} AND `player_id` IS NOT NULL"
    )
    raise GameLogicError.new(
      "Cannot check player activity if more than one player exists in SS #{
      id}! Player IDs: #{player_ids.inspect}#") if player_ids.size > 1
    return if player_ids.size > 1

    player = Player.find(player_ids[0])
    if player.last_login.nil? || ! (
        player.points >= CONFIG['galaxy.player.inactivity_check.points'] ||
        player.last_login >= CONFIG.evalproperty(
        'galaxy.player.inactivity_check.last_login_in').ago)
      # This player is inactive. Destroy him.
      player.destroy
      
      # Change solar system into a dead one.
      find(id).die!
    end
   end
end
