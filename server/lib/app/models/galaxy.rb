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
    # To expand * speed things
    CONFIG.with_set_scope(ruleset) do
      SpaceMule.instance.create_players(id, ruleset, {name => auth_token})
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