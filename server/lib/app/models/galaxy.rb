class Galaxy < ActiveRecord::Base
  include Zone

  # FK :dependent => :delete_all
  has_many :fow_galaxy_entries
  # FK :dependent => :delete_all
  has_many :players
  # FK :dependent => :delete_all
  has_many :solar_systems

  # Returns ID of battleground solar system.
  def self.battleground_id(galaxy_id)
    SolarSystem.connection.select_value(
      "SELECT id FROM `#{SolarSystem.table_name
        }` WHERE galaxy_id=#{galaxy_id.to_i
        } AND x IS NULL and y IS NULL LIMIT 1"
    ).to_i
  end

  # Returns units visible for _player_ in +Galaxy+.
  def self.units(player, fow_entries=nil)
    fow_entries ||= FowGalaxyEntry.for(player)

    conditions = "(%s) OR (%s)" % [
      sanitize_sql_for_conditions(
        {
          :player_id => player.friendly_ids,
          :location_type => Location::GALAXY, 
          :location_id => player.galaxy_id
        },
        Unit.table_name
      ),
      FowGalaxyEntry.conditions(fow_entries)
    ]

    Unit.find_by_sql(
      "SELECT * FROM `#{Unit.table_name}` WHERE #{conditions}"
    )
  end

  # Returns closest wormhole which is near x, y point. Returns nil
  # if you do not see any wormholes.
  def self.closest_wormhole(galaxy_id, x, y)
    SolarSystem.where(
      :galaxy_id => galaxy_id, :kind => SolarSystem::KIND_WORMHOLE
    ).select(
      "*, SQRT(POW(x - #{x.to_i}, 2) + POW(y - #{y.to_i}, 2)) as distance"
    ).order("distance ASC").first
  end

  def self.create_galaxy(ruleset, callback_url)
    SpaceMule.instance.create_galaxy(ruleset, callback_url)
  end

  def self.create_player(galaxy_id, name, auth_token)
    find(galaxy_id).create_player(name, auth_token)
  end
  
  def self.on_callback(id, event)
    case event
    when CallbackManager::EVENT_SPAWN
      galaxy = find(id)
      galaxy.spawn_convoy!
      
      CONFIG.with_set_scope(galaxy.ruleset) do
        CallbackManager.register(galaxy, CallbackManager::EVENT_SPAWN,
          CONFIG.evalproperty('galaxy.convoy.time').from_now)
      end
    else
      raise ArgumentError.new("Don't know how to handle #{
        CallbackManager::STRING_NAMES[event]} (#{event})")
    end
  end
  
  # Spawns convoy traveling from one random wormhole to other.
  def spawn_convoy!
    total = solar_systems.wormhole.count
    return if total < 2
      
    CONFIG.with_set_scope(ruleset) do
      source = target = nil
      while source == target
        coords = (0...2).map do
          row = solar_systems.wormhole.select("x, y").
            limit("#{rand(total)}, 1").c_select_one

          GalaxyPoint.new(id, row["x"], row["y"])
        end

        source, target = coords
      end

      # Create units.
      transaction do
        units = []
        CONFIG['galaxy.convoy.units'].each do |count_from, count_to, type, flank|
          count = rand(count_from, count_to + 1)
          klass = "Unit::#{type}".constantize
          count.times do 
            unit = klass.new(:hp => klass.hit_points(1), :level => 1,
              :location => source, :galaxy_id => id, :flank => flank)
            units.push unit
          end
        end

        Unit.save_all_units(units, nil, EventBroker::CREATED)
        route = UnitMover.move(nil, units.map(&:id), source, target, false,
          CONFIG['galaxy.convoy.speed_modifier'])

        units.each do |unit|
          CallbackManager.register(unit, CallbackManager::EVENT_DESTROY, 
            route.arrives_at)
        end

        route 
      end
    end
  end

  def create_player(name, auth_token)
    # To expand * speed things
    CONFIG.with_set_scope(ruleset) do
      SpaceMule.instance.create_players(id, ruleset, {auth_token => name})
    end
  end

  # Return solar system with coordinates x, y.
  def by_coords(x, y)
    solar_systems.find(:first, :conditions => {:x => x, :y => y})
  end

  def as_json(options=nil)
    attributes
  end

  private
end