class Galaxy < ActiveRecord::Base
  # Start position for layouts.
  START_POSITION = [0, 0]

  # This layout positions players in a random fashion from given start
  # position.
  LAYOUT_RANDOM = 0

  include Zone

  # FK :dependent => :delete_all
  has_many :fow_galaxy_entries
  # FK :dependent => :delete_all
  has_many :players
  # FK :dependent => :delete_all
  has_many :solar_systems

  # Returns visible units for _player_ in +Galaxy+.
  # TODO: spec
  def self.units(player)
    conditions = (
      [sanitize_sql_hash_for_conditions(
          {:player_id => player.friendly_ids},
          Unit.table_name
      )] +
        FowGalaxyEntry.for(player).all.map do |entry|
        sanitize_sql_for_conditions(
          [
            "(location_x BETWEEN ? AND ? AND location_y BETWEEN ? AND ?)",
            entry.x, entry.x_end,
            entry.y, entry.y_end
          ],
          Unit.table_name
        )
      end
    ).join(" OR ")

    Unit.find_by_sql(
      "SELECT * FROM `#{Unit.table_name}`
        WHERE #{
          sanitize_sql_hash_for_conditions({
            :location_type => Location::GALAXY,
            :location_id => player.galaxy_id
          }, Unit.table_name)
        } AND (#{conditions})"
    )
  end

  def self.create_player(galaxy_id, name, auth_token)
    find(galaxy_id).create_player(name, auth_token)
  end

  def create_player(name, auth_token)
    CONFIG.with_set_scope(ruleset) do
      player = players.build(:name => name, :auth_token => auth_token)
      player.save!

      player
    end
  end

  # Return solar system with coordinates x, y.
  def by_coords(x, y)
    solar_systems.find(:first, :conditions => {:x => x, :y => y})
  end

  def as_json(options=nil)
    attributes
  end

  # Find and assign free homeworld to given _player_
  def assign_homeworld(player)
    homeworld = nil

    CONFIG.with_set_scope(ruleset) do
      homeworld = SolarSystemsGenerator.new(id).create
    end

    homeworld.player = player
    homeworld.save!

    # Join new homeworld to other player maps
    solar_system = homeworld.solar_system
    join_new_homeworld(solar_system)

    # Activate each building
    homeworld.buildings.each do |building|
      unless building.npc?
        # Imitate building construction end.
        building.level -= 1
        building.send(:on_upgrade_finished)
        building.save!
      end
    end

    homeworld
  end

  private
  def join_new_homeworld(homeworld_ss)
    SolarSystem.in_zone(
      Galaxy.homeworld_zone(homeworld_ss.x, homeworld_ss.y)
    ).each do |solar_system|
      # Create FowSsEntries based of FowGalaxyEntries
      FowGalaxyEntry.scoped_by_galaxy_id(id).by_coords(
        solar_system.x, solar_system.y
      ).each do |entry|
        fse = FowSsEntry.new(
          :player_id => entry.player_id,
          :alliance_id => entry.alliance_id,
          :solar_system_id => solar_system.id,
          :counter => entry.counter
        )
        fse.save!
      end

      # Recalculate to ensure metadata integrity
      FowSsEntry.recalculate(solar_system.id)
    end
  end

  class << self
    def homeworld_zone(x, y)
      radius = CONFIG['galaxy.homeworld.zone_radius']
      [
        (x - radius)..(x + radius),
        (y - radius)..(y + radius)
      ]
    end
  end
end