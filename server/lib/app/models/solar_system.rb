# Use one of the SolarSystem::* classes. This serves as base class.
class SolarSystem < ActiveRecord::Base
  belongs_to :galaxy

  include Zone

  # Foreign keys take care of the destruction
  has_many :ss_objects
  has_many :planets, :class_name => "SsObject::Planet"
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

  # Find and return visible solar system and its metadata by _id_
  # which is visible for _player_. Raises ActiveRecord::RecordNotFound if
  # solar system is not visible.
  def self.single_visible_for(id, player)
    [SolarSystem.find(id), metadata_for(id, player)]
  end

  # Retrieves metadata for single solar system and player.
  def self.metadata_for(id, player)
    entries = FowSsEntry.for(player).find(:all, :conditions => {
        :solar_system_id => id
    })
    raise ActiveRecord::RecordNotFound if entries.blank?

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

  # Returns closest jumpgate for solar system with given _id_ at given
  # _position_ and _angle_.
  def self.closest_jumpgate(id, position, angle)
    position = position.to_i
    angle = angle.to_i
    
    SsObject::Jumpgate.find(:first,
      :select => "*, SQRT(
        POW(position, 2) + POW(#{position}, 2)
          - 2 * position * #{position} * COS(RADIANS(angle - #{angle}))
      ) as distance",
      :conditions => {:solar_system_id => id},
      :order => "distance"
    )
  end

  # Returns random jumpgate for solar system with given _id_.
  def self.rand_jumpgate(id)
    SsObject::Jumpgate.find(:first, :conditions => {:solar_system_id => id},
      :order => "RAND()")
  end

  def as_json(options=nil)
    attributes.symbolize_keys
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

  # How many orbits this SolarSystem has?
  def orbit_count
    SsObject.maximum(:position,
      :conditions => {:solar_system_id => id}) + 1
  end
end
