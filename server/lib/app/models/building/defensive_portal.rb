class Building::DefensivePortal < Building
  # SQL string for ground unit types.
  PORTAL_UNIT_TYPES = \
    Dir[File.join(ROOT_DIR, 'lib', 'app', 'models', 'unit', '*.rb')].map do
      |file|
      type = File.basename(file, '.rb').camelcase
      klass = "Unit::#{type}".constantize
      
      [type, klass]
    end.accept { |type, klass| klass.ground? && klass.can_fight? }
  PORTAL_UNIT_TYPES_SQL = PORTAL_UNIT_TYPES.map {
    |type, klass| "'#{type}'" }.join(",")

  # Hash of {type => volume} pairs.
  PORTAL_UNIT_VOLUMES = Hash[PORTAL_UNIT_TYPES.map do |type, klass|
    [type, klass.volume]
  end]

  class << self
    # Returns defender units for _planet_.
    def portal_units_for(planet)
      player = planet.player
      return [] if player.nil?

      planet_ids = SsObject::Planet.connection.select_values(%{
        SELECT id FROM `#{SsObject.table_name}`
        WHERE #{sanitize_sql_for_conditions(
          ["type=? AND player_id IN (?) AND id != ?",
          'Planet', player.friendly_ids, planet.id],
          SsObject.table_name
        )}
      })
      volume = where(
        :planet_id => planet.id, :state => Building::STATE_ACTIVE
      ).map { |building| building.teleported_volume }.sum

      pick_units(planet_ids, volume)
    end

    # Picks random units from planets with _planet_ids_ for _total_volume_.
    def pick_units(planet_ids, total_volume)
      Unit.find(pick_unit_ids(planet_ids, total_volume).to_a)
    end

    # Picks random units from planets with _planet_ids_ for _total_volume_.
    #
    # Returns Set of their ids.
    def pick_unit_ids(planet_ids, total_volume)
      planet_ids = planet_ids.map(&:to_i).join(",")

      available = Unit.connection.select_all(%{
        SELECT id, type FROM `#{Unit.table_name}`
        WHERE type IN (#{PORTAL_UNIT_TYPES_SQL}) AND
          location_type=#{Location::SS_OBJECT} AND
          location_id IN (#{planet_ids})
      }).map do |row|
        [row['id'], PORTAL_UNIT_VOLUMES[row['type']]]
      end

      pick_unit_ids_from_list(available, total_volume)
    end

    protected
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