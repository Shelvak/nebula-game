class Building::DefensivePortal < Building
  # Raised when no units can be teleported for defense. For internal usage.
  class NoUnitsError < StandardError; end

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
    # Returns Hash:
    # {
    #   :your => [[type, count], ...],
    #   :alliance => [[type, count], ...]
    # }.
    #
    # E.g.:
    # {
    #   :your => [["Trooper", 3], ["Shocker", 5], ... ],
    #   :alliance => []
    # }
    #
    def portal_unit_counts_for(planet)
      player_id, ally_ids, planet_ids, ally_planet_ids =
        get_ids_from_planet(planet)

      {
        :your => total_unit_counts([player_id], planet_ids),
        :alliance => total_unit_counts(ally_ids, ally_planet_ids),
      }
    rescue NoUnitsError
      {:your => [], :alliance => []}
    end

    # Get defender units for _planet_.
    #
    # Returns array of units that will defend this planet.
    def portal_units_for(planet)
      player_id, ally_player_ids, planet_ids, ally_planet_ids =
        get_ids_from_planet(planet)
      volume = teleported_volume_for(planet)

      pick_units(
        player_id, planet_ids, ally_player_ids, ally_planet_ids, volume
      )
    rescue NoUnitsError
      []
    end

    # Get volume that teleporters can transport to _planet_.
    def teleported_volume_for(planet)
      where(
        :planet_id => planet.id, :state => Building::STATE_ACTIVE
      ).map(&:teleported_volume).sum
    end

    protected

    # Picks random units from planets with _planet_ids_ for _total_volume_.
    def pick_units(player_id, planet_ids, ally_player_ids, ally_planet_ids,
        total_volume)
      Unit.find(
        pick_unit_ids(
          player_id, planet_ids, ally_player_ids, ally_planet_ids, total_volume
        ).to_a
      )
    end

    # Picks random units from planets with _planet_ids_ for _total_volume_.
    #
    # Returns Set of their ids.
    def pick_unit_ids(player_id, planet_ids, ally_player_ids, ally_planet_ids,
        total_volume)
      relation = Unit.select("id, type")
      block = lambda do |row|
        [row['id'], PORTAL_UNIT_VOLUMES[row['type']]]
      end

      available_yours = planet_ids.blank? \
        ? [] \
        : relation.where(condition([player_id], planet_ids)).
            map(&block)
      available_ally = ally_player_ids.blank? || ally_planet_ids.blank? \
        ? [] \
        : relation.where(condition(ally_player_ids, ally_planet_ids)).
            map(&block)

      pick_unit_ids_from_list(available_yours, available_ally, total_volume)
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
      return [] if player_ids.blank? || planet_ids.blank?

      Unit.
        select("type, COUNT(*) as count").
        where(condition(player_ids, planet_ids)).
        group("type").
        c_select_all.
        map { |row| [row['type'], row['count']] }
    end

    # Return condition for selecting defender units.
    def condition(player_ids, planet_ids)
      player_ids = player_ids.map(&:to_i).join(",")
      planet_ids = planet_ids.map(&:to_i).join(",")

      "type IN (#{PORTAL_UNIT_TYPES_SQL}) AND
        location_type=#{Location::SS_OBJECT} AND
        location_id IN (#{planet_ids}) AND
        player_id IN (#{player_ids}) AND
        level > 0 AND #{Unit.not_hidden_condition}"
    end

    # Returns friendly player ids and planet ids from given _planet_.
    def get_ids_from_planet(planet)
      player = planet.player
      raise NoUnitsError if player.nil?

      ally_ids = player.portal_without_allies? || player.alliance_id.nil? \
        ? [] \
        : Player.
            select("id").
            not_portal_without_allies.
            where(:alliance_id => player.alliance_id).
            where("id != ?", player.id).
            c_select_values
      
      relation = SsObject::Planet.select("id").where("id != ?", planet.id)
      player_planet_ids = relation.where(:player_id => player.id).
        c_select_values

      ally_planet_ids = ally_ids.blank? \
        ? [] : relation.where(:player_id => ally_ids).c_select_values

      reject_block = lambda do |planet_id|
        Building::DefensivePortal.active.where(:planet_id => planet_id).
          count == 0
      end

      player_planet_ids.reject!(&reject_block)
      ally_planet_ids.reject!(&reject_block)

      raise NoUnitsError if player_planet_ids.blank? && ally_planet_ids.blank?

      [player.id, ally_ids, player_planet_ids, ally_planet_ids]
    end

    # Pick unit ids from list of [id, volume] pairs.
    def pick_unit_ids_from_list(available_yours, available_ally, volume_left)
      unit_ids = Set.new
      # Duplicate to prevent messing around with original arrays.
      [available_yours.dup, available_ally.dup].each do |available|
        while ! available.blank?
          index = rand(available.size)
          id, volume = available[index]
          if volume <= volume_left
            available.delete_at(index)
            unit_ids.add(id)
            volume_left -= volume
          else
            # Filter units which will not fit.
            available.accept! { |id, volume| volume <= volume_left }
          end
        end
      end

      unit_ids
    end
  end
end