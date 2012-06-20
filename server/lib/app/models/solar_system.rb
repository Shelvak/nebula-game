# Use one of the SolarSystem::* classes. This serves as base class.
class SolarSystem < ActiveRecord::Base
  DScope = Dispatcher::Scope
  include Parts::WithLocking

  belongs_to :galaxy

  include Parts::Object
  include Zone

  # Regular kind of solar system
  KIND_NORMAL = 0
  # Wormhole solar system
  KIND_WORMHOLE = 1
  # Battleground solar system
  KIND_BATTLEGROUND = 2
  # Pooled homeworld system
  KIND_POOLED = 3

  # FK :dependent => :delete_all
  belongs_to :player

  # Foreign keys take care of the destruction
  has_many :ss_objects
  has_many :planets, :class_name => "SsObject::Planet"
  has_many :asteroids, :class_name => "SsObject::Asteroid"
  has_many :jumpgates, :class_name => "SsObject::Jumpgate"

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

  # Is this solar system detached from galaxy map?
  def detached?; x.nil? && y.nil?; end

  # Is this solar system a global battleground?
  def main_battleground?; x.nil? && y.nil? && battleground?; end
  
  def normal?; kind == KIND_NORMAL; end
  scope :normal, where(:kind => KIND_NORMAL)
  def battleground?; kind == KIND_BATTLEGROUND; end
  scope :battleground, where(:kind => KIND_BATTLEGROUND)
  def wormhole?; kind == KIND_WORMHOLE; end
  scope :wormhole, where(:kind => KIND_WORMHOLE)
  def pooled?; kind == KIND_POOLED; end
  scope :pooled, where(:kind => KIND_POOLED)

  def to_s
    "<SolarSystem(#{id} @ #{x},#{y}) gid: #{galaxy_id} kind: #{kind}>"
  end

  # Return +SolarSystemPoint+s where NPC units are standing.
  def npc_unit_locations
    fields = "location_x, location_y"
    without_locking do
      Unit.in_zone(self).select(fields).group(fields).where(:player_id => nil).
        c_select_all
    end.each_with_object(Set.new) do |row, set|
      set.add SolarSystemPoint.new(id, row['location_x'], row['location_y'])
    end
  end

  def as_json(options=nil)
    {
      "id" => id,
      "x" => x,
      "y" => y,
      "kind" => kind,
      "player" => player_id.nil? ? nil : Player.minimal(player_id)
    }
  end

  def galaxy_point
    GalaxyPoint.new(galaxy_id, x, y)
  end
  
  # Removes all ss_objects/wreckages/units in this solar system.
  def delete_assets!
    SsObject.in_solar_system(self).delete_all
    Wreckage.in_zone(self).delete_all
    Unit.in_zone(self).delete_all
  end

  # Spawns NPC units in random, unoccupied (meaning no NPC ships) sector if
  # free spots are available.
  #
  # Creates cooldown after spawning.
  def spawn!
    npc_taken_points = self.npc_unit_locations

    if npc_taken_points.size < Cfg.solar_system_spawn_max_spots(self)
      definition = Cfg.solar_system_spawn_units_definition(self)
      strategy = SsSpawnStrategy.new(self, npc_taken_points)
      location = strategy.pick

      spot = npc_taken_points.size + 1 # Because division by 0 is just not cool.
      units = UnitBuilder.from_random_ranges(
        definition, location, nil, spawn_counter, spot
      )
      Unit.save_all_units(units, nil, EventBroker::CREATED)
      self.spawn_counter += 1
      save!
      Cooldown.create_or_update!(location, Cfg.after_spawn_cooldown)
      
      location
    else
      nil
    end
  end

  # Detaches solar system from galaxy.
  def detach!
    raise RuntimeError.new(
      "Cannot detach already detached solar system #{self}!"
    ) if detached?

    raise RuntimeError.new(
      "Cannot detach non-home solar system #{self}!"
    ) if player_id.nil?

    raise RuntimeError.new(
      "Cannot detach solar system #{self} while player is connected!"
    ) if Celluloid::Actor[:dispatcher].player_connected?(player_id)

    # Deactivate radars.
    Building::Radar.for_player(player_id).active.each(&:deactivate!)

    # Remove this solar system from everyone except owner.
    # Needs to go before deletion so we could track who sees this solar system.
    EventBroker.fire(
      Event::FowChange::SsDestroyed.all_except(id, player_id),
      EventBroker::FOW_CHANGE,
      EventBroker::REASON_SS_ENTRY
    )

    # Set coordinates to detached state.
    self.x = self.y = nil
    save!
  end

  # Attaches solar system to the galaxy at specified coordinates.
  def attach!(x, y)
    raise RuntimeError.new(
      "Cannot attach #{self} to #{x},#{y} because it is already attached!"
    ) unless detached?

    raise RuntimeError.new(
      "Cannot attach non-home solar system #{self} to #{x},#{y}!"
    ) if player_id.nil?

    # DB index: lookup
    raise ArgumentError.new(
      "Cannot attach #{self} to #{x},#{y} because it is occupied!"
    ) if without_locking {
      self.class.where(:galaxy_id => galaxy_id, :x => x, :y => y).exists?
    }

    # Just a safety net, there should be none but if there is - fire up the
    # alarm bells.
    raise RuntimeError.new(
      "There are active radars in #{self
        }! Visibility will be inconsistent, cannot proceed!"
    ) if without_locking {
      Building::Radar.for_player(player_id).active.count
    } > 0

    metadatas = SolarSystem::Metadatas.new(id)
    players = without_locking do
      Player.find(
        FowGalaxyEntry.
          select("player_id").
          where(galaxy_id: galaxy_id).
          where("player_id != ?", player_id).
          where("? BETWEEN x AND x_end AND ? BETWEEN y AND y_end", x, y).
          c_select_values
      )
    end

    self.x, self.y = x, y
    save!

    unless players.blank?
      # Dispatch updates for other connected players. We don't dispatch to self
      # because this method does not work if player is logged in.
      EventBroker.fire(
        Event::FowChange::SsCreated.new(
          id, x, y, kind, Player.minimal(player_id), players, metadatas
        ),
        EventBroker::FOW_CHANGE,
        EventBroker::REASON_SS_ENTRY
      )
    end

    # Don't activate radars after attaching because this dispatches events
    # that should not be dispatched while logging in.

    true
  end

  SPAWN_SCOPE = DScope.world
  def self.spawn_callback(solar_system)
    solar_system.spawn!
    date = Cfg.solar_system_spawn_random_delay_date(solar_system)
    CallbackManager.register(solar_system, CallbackManager::EVENT_SPAWN, date)

    date
  end

  class << self
    # Does _player_ see any wormhole?
    def sees_wormhole?(player)
      friendly_ids = player.friendly_ids
      conditions = without_locking do
        FowGalaxyEntry.select(Rectangle::SELECT_FIELDS).
          where(player_id: friendly_ids).all
      end.map { |fge| fge.rectangle.to_sql(player.galaxy_id) }

      # No conditions = No FGEs = No wormhole
      return false if conditions.blank?

      SolarSystem.where(conditions.join(" OR ")).where(kind: KIND_WORMHOLE).
        exists?
    end

    # Returns +Array+ of _player_ visible +SolarSystem+s with their metadata
    # attached.
    #
    # Each array element is:
    # {:solar_system => +SolarSystem+, :metadata => +SolarSystemMetadata+}
    #
    def visible_for(player)
      friendly_ids = player.friendly_ids
      alliance_ids = player.alliance_ids
      conditions = []

      # Solar systems covered by radars.
      conditions += without_locking do
        FowGalaxyEntry.where(player_id: friendly_ids).all
      end.map { |fge| fge.rectangle.to_sql(player.galaxy_id) }

      # Solar systems where players have units.
      conditions += without_locking do
        Unit.
          select("DISTINCT(`location_solar_system_id`)").
          where(player_id: friendly_ids).
          where("`location_solar_system_id` IS NOT NULL").
          c_select_values
      end.map { |id| "`id`=#{id}" }

      # Solar systems where players have planets or units inside +SsObject+s.
      sso_ids = without_locking do
        Unit.
          select("DISTINCT(`location_ss_object_id`)").
          where(player_id: friendly_ids).
          where("`location_ss_object_id` IS NOT NULL").
          c_select_values
      end
      conditions += without_locking do
        SsObject::Planet.
          select("DISTINCT(`solar_system_id`)").
          where("`player_id` IN (?) OR `id` IN (?)", friendly_ids, sso_ids).
          c_select_values
      end.map { |id| "`id`=#{id}" }

      # No conditions = no solar systems.
      return [] if conditions.blank?

      conditions = conditions.join(" OR ")
      solar_systems = without_locking { SolarSystem.where(conditions).all }

      ss_ids = solar_systems.map(&:id)
      metadatas = SolarSystem::Metadatas.new(ss_ids)

      solar_systems.map do |solar_system|
        {
          solar_system: solar_system.freeze,
          metadata: metadatas.for_existing(
            solar_system.id, player.id, friendly_ids, alliance_ids
          )
        }
      end
    end

    # Determines if any of the _player_ids_ have visibility on SolarSystem
    # _solar_system_id_.
    def visible?(solar_system_id, player_ids)
      typesig binding, Fixnum, [Fixnum, Array]
      player_ids = Array(player_ids)

      raise ArgumentError,
        "Not all player ids were Fixnums: #{player_ids.inspect}" \
        unless player_ids.all? { |id| id.is_a?(Fixnum) }

      player_ids = "(#{player_ids.join(",")})"

      row = without_locking do
        SolarSystem.select("`galaxy_id`, `x`, `y`").
          where(id: solar_system_id).c_select_one
      end

      galaxy_id, x, y = row['galaxy_id'], row['x'], row['y']

      # Check for:
      # * Radar coverage
      # * Occupied planets
      # * Units inside solar system
      # * Units inside solar system objects
      connection.select_value(%Q{
SELECT
IF(
  (SELECT 1
    FROM `#{FowGalaxyEntry.table_name}`
    WHERE `galaxy_id`=#{galaxy_id}
      AND #{x} BETWEEN `x` and `x_end`
      AND #{y} BETWEEN `y` AND `y_end`
      AND `player_id` IN #{player_ids}
    LIMIT 1
  ) = 1,
  1,
IF(
  (SELECT 1
    FROM `#{SsObject.table_name}`
    WHERE `solar_system_id`=#{solar_system_id} AND `player_id` IN #{player_ids}
    LIMIT 1
  ) = 1,
  1,
IF(
  (SELECT 1
    FROM `#{Unit.table_name}`
    WHERE `player_id` IN #{player_ids}
      AND `location_solar_system_id`=#{solar_system_id}
    LIMIT 1
  ) = 1,
  1,
IF(
  (SELECT 1
    FROM `#{Unit.table_name}`
    WHERE `player_id` IN #{player_ids}
      AND `location_ss_object_id` IN (
        SELECT `id` FROM `#{SsObject.table_name}`
          WHERE `solar_system_id`=#{solar_system_id}
            AND `type`='#{SsObject::Planet.to_s.demodulize}'
      )
    LIMIT 1
  ) = 1,
  1,
  0
))))
      }).to_i == 1
    end

    # Find and return visible solar system by _id_ which is visible for
    # _player_. Raises ActiveRecord::RecordNotFound if solar system is not
    # viewable.
    #
    # Returns frozen solar system.
    def find_if_viewable_for(id, player)
      raise ActiveRecord::RecordNotFound unless visible?(id, player.friendly_ids)

      ss = without_locking { SolarSystem.find(id) }.freeze
      raise ActiveRecord::RecordNotFound \
        if ! ss.player_id.nil? && ss.player_id != player.id

      ss
    end

    # Returns player ids for those who can see this solar system.
    def observer_player_ids(solar_system_or_id)
      typesig binding, [Fixnum, SolarSystem]

      solar_system = solar_system_or_id.is_a?(Fixnum) \
        ? without_locking { find(solar_system_or_id).freeze } \
        : solar_system_or_id

      return [] if ! solar_system.main_battleground? && solar_system.detached?

      if solar_system.main_battleground?
        # This is a bit hacky. For speed purposes lets say that every player
        # that has FGE sees at least one wormhole.
        fge_condition = ""
      else
        fge_condition = %Q{
          AND #{solar_system.x} BETWEEN `x` AND `x_end`
          AND #{solar_system.y} BETWEEN `y` AND `y_end`
        }
      end

      # Select ids from:
      # * Radar coverage
      # * SSO ownership
      # * Unit ownership in solar system on SSOs inside of it
      player_ids = connection.select_values(%Q{
  SELECT DISTINCT(`player_id`)
  FROM `#{FowGalaxyEntry.table_name}`
  WHERE `galaxy_id`=#{solar_system.galaxy_id}
    #{fge_condition}
UNION
  SELECT DISTINCT(`player_id`)
  FROM `#{SsObject.table_name}`
  WHERE `player_id` IS NOT NULL
    AND `solar_system_id`=#{solar_system.id}
UNION
  SELECT DISTINCT(`player_id`)
  FROM `#{Unit.table_name}`
  WHERE `player_id` IS NOT NULL AND (
    `location_solar_system_id`=#{solar_system.id}
    OR `location_ss_object_id` IN (
      SELECT `id` FROM `#{SsObject.table_name}`
      WHERE `solar_system_id`=#{solar_system.id}
    )
  )
      })

      Player.join_alliance_ids(player_ids)
    end
  end
end
