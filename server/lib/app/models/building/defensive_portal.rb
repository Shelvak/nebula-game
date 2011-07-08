class Building::DefensivePortal < Building
  # Raised when no units can be teleported for defense. For internal usage.
  class NoUnitsError < Exception; end

  # Array of [type, class] pairs for unit types that can be teleported via
  # portal.
  PORTAL_UNIT_TYPES = \
    Dir[File.join(ROOT_DIR, 'lib', 'app', 'models', 'unit', '*.rb')].map do
      |file|
      type = File.basename(file, '.rb').camelcase
      klass = "Unit::#{type}".constantize
      
      [type, klass]
    end.accept { |type, klass| klass.ground? && klass.can_fight? }

  # SQL string for ground unit types.
  PORTAL_UNIT_TYPES_SQL = PORTAL_UNIT_TYPES.map {
    |type, klass| "'#{type}'" }.join(",")

  # Hash of {type => volume} pairs.
  PORTAL_UNIT_VOLUMES = Hash[PORTAL_UNIT_TYPES.map do |type, klass|
    [type, klass.volume]
  end]

  # How much volume can this portal teleport,
  def teleported_volume; self.class.teleported_volume(level); end

  class << self
    # How much volume can this portal teleport,
    def teleported_volume(level)
      evalproperty("teleported_volume", 0, 'level' => level)
    end

    # Returns defender unit counts for _planet_.
    #
    # Returns Array of [type, count].
    #
    # E.g.:
    # [ ["Trooper", 3], ["Shocker", 5], ... ]
    #
    def portal_unit_counts_for(planet)
      player_ids, planet_ids = get_ids_from_planet(planet)
      total_unit_counts(player_ids, planet_ids)
    rescue NoUnitsError
      []
    end

    # Get defender units for _planet_.
    #
    # Returns array of units that will defend this planet.
    def portal_units_for(planet)
      player_ids, planet_ids = get_ids_from_planet(planet)
      volume = teleported_volume_for(planet)

      pick_units(player_ids, planet_ids, volume)
    rescue NoUnitsError
      []
    end

    # Get volume that teleporters can transport to _planet_.
    def teleported_volume_for(planet)
      where(
        :planet_id => planet.id, :state => Building::STATE_ACTIVE
      ).map { |building| building.teleported_volume }.sum
    end

    protected

    # Picks random units from planets with _planet_ids_ for _total_volume_.
    def pick_units(player_ids, planet_ids, total_volume)
      Unit.find(pick_unit_ids(player_ids, planet_ids, total_volume).to_a)
    end

    # Picks random units from planets with _planet_ids_ for _total_volume_.
    #
    # Returns Set of their ids.
    def pick_unit_ids(player_ids, planet_ids, total_volume)
      available = Unit.connection.select_all(%{
        SELECT id, type FROM `#{Unit.table_name}`
        WHERE #{condition(player_ids, planet_ids)}
      }).map do |row|
        [row['id'], PORTAL_UNIT_VOLUMES[row['type']]]
      end

      pick_unit_ids_from_list(available, total_volume)
    end

    # Get numbers of units in defense.
    #
    # Returns array of [type, total_count] pairs.
    #
    # E.g.:
    # [
    #   ["Trooper", 10],
    #   ["Shocker", 15],
    #   ...
    # ]
    #
    def total_unit_counts(player_ids, planet_ids)
      Unit.connection.select_all(%{
        SELECT type, COUNT(*) as count FROM `#{Unit.table_name}`
        WHERE #{condition(player_ids, planet_ids)}
        GROUP BY type
      }).map { |row| [row['type'], row['count']] }
    end

    # Return condition for selecting defender units.
    def condition(player_ids, planet_ids)
      player_ids = player_ids.map(&:to_i).join(",")
      planet_ids = planet_ids.map(&:to_i).join(",")

      "type IN (#{PORTAL_UNIT_TYPES_SQL}) AND
        location_type=#{Location::SS_OBJECT} AND
        location_id IN (#{planet_ids}) AND
        player_id IN (#{player_ids})"
    end

    # Returns friendly player ids and planet ids from given _planet_.
    def get_ids_from_planet(planet)
      player = planet.player
      raise NoUnitsError if player.nil?

      player_ids = player.friendly_ids
      planet_ids = SsObject::Planet.connection.select_values(%{
        SELECT id FROM `#{SsObject.table_name}`
        WHERE #{sanitize_sql_for_conditions(
          ["player_id IN (?) AND id != ?", player_ids, planet.id],
          SsObject::Planet.table_name
        )}
      })
      planet_ids.reject! do |planet_id|
        Building::DefensivePortal.active.where(:planet_id => planet_id).
          count == 0
      end
      raise NoUnitsError if planet_ids.blank?

      [player_ids, planet_ids]
    end

    # Pick unit ids from list of [id, volume] pairs.
    def pick_unit_ids_from_list(available, volume_left)
      unit_ids = Set.new
      while ! available.blank?
        id, volume = available.random_element
        if volume <= volume_left
          unit_ids.add(id)
          volume_left -= volume
        else
          # Filter units which will not fit.
          available.accept! { |id, volume| volume <= volume_left }
        end
      end

      unit_ids
    end
  end
end