# Use one of the SolarSystem::* classes. This serves as base class.
class SolarSystem < ActiveRecord::Base
  belongs_to :galaxy

  include Parts::Object
  include Zone

  # Regular kind of solar system
  KIND_NORMAL = 0
  # Wormhole solar system
  KIND_WORMHOLE = 1
  # Battleground solar system
  KIND_BATTLEGROUND = 2

  belongs_to :player

  # Foreign keys take care of the destruction
  has_many :ss_objects
  has_many :planets, :class_name => "SsObject::Planet"
  has_many :asteroids, :class_name => "SsObject::Asteroid"
  has_many :jumpgates, :class_name => "SsObject::Jumpgate"
  has_many :fow_ss_entries

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

  def to_s
    "<SolarSystem(#{id} @ #{x},#{y}) gid: #{galaxy_id} kind: #{kind}>"
  end

  # Return +SolarSystemPoint+s where NPC units are standing.
  def npc_unit_locations
    lambda do
      fields = "location_x, location_y"
      Unit.in_zone(self).select(fields).group(fields).where(:player_id => nil).
        c_select_all
    end.call.inject(Set.new) do |set, row|
      set.add SolarSystemPoint.new(id, row['location_x'], row['location_y'])
      set
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
    raise ActiveRecord::RecordNotFound if ! ss.player_id.nil? &&
      ss.player_id != player.id

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

  # How many orbits this SolarSystem has?
  def orbit_count
    SsObject.maximum(:position,
      :conditions => {:solar_system_id => id}) + 1
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
  # Then checks that spot for combat.
  def spawn!
    npc_taken_points = self.npc_unit_locations

    if npc_taken_points.size < Cfg.solar_system_spawn_max_spots(self)
      definition = Cfg.solar_system_spawn_units_definition(self)
      strategy = SsSpawnStrategy.new(self, npc_taken_points)
      location = strategy.pick
      
      units = UnitBuilder.from_random_ranges(
        definition, galaxy_id, location, nil
      )
      Unit.save_all_units(units, nil, EventBroker::CREATED)
      Combat::LocationChecker.check_location(location)
      
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
    ) if Dispatcher.instance.connected?(player_id)

    # Deactivate radars.
    Building::Radar.for_player(player_id).active.each(&:deactivate!)

    # Remove this solar system from everyone except owner.
    # Needs to go before deletion so we could track who sees this solar system.
    EventBroker.fire(
      Event::FowChange::SsDestroyed.all_except(id, player_id),
      EventBroker::FOW_CHANGE,
      EventBroker::REASON_SS_ENTRY
    )
    # Remove fow ss entries for everyone except owner.
    fow_ss_entries.where("player_id != ?", player_id).delete_all

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
    ) if self.class.where(:galaxy_id => galaxy_id, :x => x, :y => y).exists?

    # Just a safety net, there should be none but if there is - fire up the
    # alarm bells.
    raise RuntimeError.new(
      "There are active radars in #{self
        }! Visibility will be inconsistent, cannot proceed!"
    ) if Building::Radar.for_player(player_id).active.count > 0

    owner_fse = fow_ss_entries.where(:player_id => player_id).first
    raise RuntimeError.new(
      "Cannot find owner FSE for player #{player_id}!"
    ) if owner_fse.nil?

    entries = FowGalaxyEntry.
      select("counter, player_id, alliance_id").
      where(:galaxy_id => galaxy_id).
      where("? BETWEEN x AND x_end AND ? BETWEEN y AND y_end", x, y).
      c_select_all.map do |row|
        # By idea player is not in the alliance so we don't need to create
        # alliance entries or view him from a different perspective instead of
        # enemy.
        FowSsEntry.new(
          :solar_system_id => id,
          :counter => row['counter'],
          :player_id => row['player_id'],
          :alliance_id => row['alliance_id'],
          :enemy_planets => owner_fse.player_planets,
          :enemy_ships => owner_fse.player_ships
        )
      end

    self.x, self.y = x, y
    save!

    unless entries.blank?
      BulkSql::FowSsEntry.save(entries)
      player = Player.minimal(player_id)
      # Dispatch updates for other connected players. We don't dispatch to self
      # because this method does not work if player is connected.
      EventBroker.fire(
        Event::FowChange::SsCreated.new(id, x, y, kind, player, entries),
        EventBroker::FOW_CHANGE,
        EventBroker::REASON_SS_ENTRY
      )
    end

    # Activate radars.
    Building::Radar.for_player(player_id).inactive.not_upgrading.
      each(&:activate!)

    true
  end

  def self.on_callback(id, event)
    case event
    when CallbackManager::EVENT_SPAWN
      solar_system = find(id)
      solar_system.spawn!
      date = Cfg.solar_system_spawn_random_delay_date(solar_system)
      CallbackManager.register(solar_system, event, date)
      date
    else
      raise CallbackManager::UnknownEvent.new(self, id, event)
    end
  end
end
