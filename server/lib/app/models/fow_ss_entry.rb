# Fog of War solar system cache entry.
#
# This cache is used to speed up determination of what players see what solar
# systems in particular galaxy.
#
class FowSsEntry < ActiveRecord::Base
  belongs_to :solar_system
  belongs_to :alliance
  belongs_to :player
  
  include Parts::FowEntry

  custom_serialize :alliance_planet_player_ids, :alliance_ship_player_ids,
    :serialize => Proc.new { |value|
      value.blank? ? nil : value.join(",")
    },
    :unserialize => Proc.new { |value|
      value.nil? ? [] : value.split(",").map(&:to_i)
    }

  class << self
    # Returns +Player+ ids that observe _solar_system_id_.
    def observer_player_ids(solar_system_id)
      super(
        sanitize_sql_for_conditions(:solar_system_id => solar_system_id)
      )
    end

    # Register change of planet owner.
    #
    # This updates visibility and status of +SolarSystem+ in which _planet_
    # is.
    #
    def change_planet_owner(planet, old_player, new_player)
      if old_player
        # Change visibility
        FowSsEntry.decrease(planet.solar_system_id, old_player)
      end

      if new_player
        # Change visibility
        FowSsEntry.increase(planet.solar_system_id, new_player)
      end
    end

    # Recalculate metadata for entries that cover _solar_system_id_.
    def recalculate(solar_system_id, dispatch_event=false)
      LOGGER.block("Recalculating metadata for #{solar_system_id}",
        :level => :debug) do
        # Select data we need
        planet_player_ids = connection.select_values(
          "SELECT DISTINCT(player_id) FROM `#{
            SsObject.table_name}` WHERE #{
            sanitize_sql_hash_for_conditions({
              :solar_system_id => solar_system_id
            }, SsObject.table_name)} AND player_id IS NOT NULL"
        ).map(&:to_i)
        unit_player_ids = connection.select_values(
          "SELECT DISTINCT(player_id) FROM `#{
            Unit.table_name}` WHERE #{
            sanitize_sql_hash_for_conditions({
              :location_type => Location::SOLAR_SYSTEM,
              :location_id => solar_system_id
            }, Unit.table_name)} AND player_id IS NOT NULL"
        ).map(&:to_i)
        planet_alliance_ids = connection.select_values(
          "SELECT DISTINCT(alliance_id) FROM `#{Player.table_name}` WHERE #{
            sanitize_sql_hash_for_conditions({
              :id => planet_player_ids
            }, Player.table_name)}"
        ).map(&:to_i)
        unit_alliance_ids = connection.select_values(
          "SELECT DISTINCT(alliance_id) FROM `#{Player.table_name}` WHERE #{
            sanitize_sql_hash_for_conditions({
              :id => unit_player_ids
            }, Player.table_name)}"
        ).map(&:to_i)

        changed = []

        # Find all entries that relate to that solar system.
        self.where(:solar_system_id => solar_system_id).each do |entry|
          # It's a Player entry
          if entry.player_id
            # Resolve planets
            entry.player_planets = planet_player_ids.include?(
              entry.player_id)
            entry.enemy_planets = !! planet_player_ids.find do |id|
              id != entry.player_id
            end
            entry.alliance_planet_player_ids = nil
            entry.nap_planets = nil

            # Resolve ships
            entry.player_ships = unit_player_ids.include?(entry.player_id)
            entry.enemy_ships = !! unit_player_ids.find do |id|
              id != entry.player_id
            end
            entry.alliance_ship_player_ids = nil
            entry.nap_ships = nil

          # It's an Alliance entry
          else
            alliance_player_ids = connection.select_values(
              "SELECT id FROM `#{Player.table_name}` WHERE #{
              sanitize_sql_hash_for_conditions({
                :alliance_id => entry.alliance_id
              }, Player.table_name)}"
            ).map(&:to_i)

            # Get established naps.
            nap_ids = Nap.alliance_ids_for(entry.alliance_id,
              Nap::STATUS_ESTABLISHED).to_a

            # Filter player ids to leave only those who are in our alliance
            #
            # We save player ids ant not just true/false flag because a
            # player will always be in his alliance, so even if he's the
            # only player there it would always show as if other alliance
            # ships are there too. To avoid that we later merge player
            # and alliance entries to get final result we feed to
            # the client.
            entry.alliance_planet_player_ids = \
              planet_player_ids & alliance_player_ids
            entry.alliance_ship_player_ids = \
              unit_player_ids & alliance_player_ids

            entry.nap_planets = (planet_alliance_ids & nap_ids).present?
            entry.nap_ships = (unit_alliance_ids & nap_ids).present?

            # If there are other players than our alliance or naps, those
            # must be our enemies
            entry.enemy_planets = (
              planet_alliance_ids - nap_ids - [entry.alliance_id]
            ).present?
            entry.enemy_ships = (
              unit_alliance_ids - nap_ids - [entry.alliance_id]
            ).present?
          end

          if entry.changed?
            changed.push entry
            entry.save!
          end
        end

        EventBroker.fire(
          FowChangeEvent::Recalculate.new(changed, solar_system_id),
          EventBroker::FOW_CHANGE,
          EventBroker::REASON_SS_ENTRY
        ) if dispatch_event

        ! changed.blank?
      end
    end

    # Returns +Hash+ of such structure:
    # 
    # {
    #   :player_planets => +Boolean+,
    #   :player_ships => +Boolean+,
    #   :enemy_planets => +Boolean+,
    #   :enemy_ships => +Boolean+,
    #   :alliance_planets => +Boolean+,
    #   :alliance_ships => +Boolean+,
    #   :nap_planets => +Boolean+,
    #   :nap_ships => +Boolean+,
    # }
    #
    # Each entry is determined by merging player and alliance entries by
    # rules.
    #
    # _fse_player_ can be nil if player doesn't have direct visibility
    # in that zone.
    # _fse_alliance_ can be nil if player is not in alliance.
    #
    def merge_metadata(fse_player, fse_alliance)
      # If player doesn't have visibility in that zone, then it's
      # their allies for sure.
      player_id = fse_player ? [fse_player.player_id] : []

      SolarSystemMetadata.new(
        # Player may not have visibility of that SS, but alliance may have.
        :player_planets => fse_player ? fse_player.player_planets : false,
        :player_ships => fse_player ? fse_player.player_ships : false,

        # Alliance status overrides player status. Same player may be enemy
        # in pvp relationship, but an ally or nap in alliance relationship.
        :enemy_planets => fse_alliance \
          ? fse_alliance.enemy_planets : fse_player.enemy_planets,
        :enemy_ships => fse_alliance \
          ? fse_alliance.enemy_ships : fse_player.enemy_ships,

        # You can't see alliance stuff if you're not in one.
        :alliance_planets => fse_alliance \
          ? (fse_alliance.alliance_planet_player_ids - player_id).present? \
          : false,
        :alliance_ships => fse_alliance \
          ? (fse_alliance.alliance_ship_player_ids - player_id).present? \
          : false,

        # Same with naps.
        :nap_planets => fse_alliance ? fse_alliance.nap_planets : false,
        :nap_ships => fse_alliance ? fse_alliance.nap_ships : false
      )
    end

    # Returns +Boolean+ if you are allowed to view details in this solar
    # system. _hash_ is obtained from #merge_metadata.
    #
    # You can view details if either you or your alliance has any planets or
    # ships in that solar system.
    #
    # Details include units, their movement and asteroid rates.
    #
    def can_view_details?(hash)
      return true
      return (hash[:player_planets] || hash[:player_ships] ||
          hash[:alliance_planets] || hash[:alliance_ships])
    end

    # Creation/deletion

    # Create or update row for _solar_system_id_ with _kind_ => _id_ and
    # increase counter by _increasement_.
    #
    # _kind_ can be either 'player_id' or 'alliance_id'.
    #
    def increase_for_kind(solar_system_id, kind, id, incrementation=1)
      check_params = {
        :solar_system_id => solar_system_id,
        kind => id
      }

      update_record(check_params, check_params, incrementation)
    end

    # Create an entry for _player_ at _solar_system_id_. Increase counter
    # by _increasement_.
    #
    # This also creates entry for +Alliance+ if _player_ is in one.
    def increase(solar_system_id, player, increasement=1,
        should_dispatch=true)
      dispatch_event = increase_for_kind(solar_system_id, 'player_id',
        player.id, increasement)
      increase_for_kind(solar_system_id, 'alliance_id',
        player.alliance_id, increasement) \
        unless player.alliance_id.nil?
      dispatch_event = recalculate(solar_system_id) || dispatch_event
      dispatch_event = dispatch_event && should_dispatch

      EventBroker.fire(
        FowChangeEvent::SolarSystem.new(solar_system_id),
        EventBroker::FOW_CHANGE,
        EventBroker::REASON_SS_ENTRY) if dispatch_event

      dispatch_event
    end

    # Deletes entry for _player_ at _solar_system_id_. Also removes entry
    # for +Alliance+ if _player_ is in one.
    def decrease(solar_system_id, player, decrement=1, should_dispatch=true)
      # Decrement counter
      increase(solar_system_id, player, -decrement, should_dispatch)
    end

    # Creates entries for _player_ for every +SolarSystem+ in _zone_.
    def increase_for_zone(zone, player, increment=1, should_dispatch=true)
      transaction do
        SolarSystem.in_zone(*zone).find_all_by_galaxy_id(
        player.galaxy_id).each do |solar_system|
          increase(solar_system.id, player, increment, should_dispatch)
        end
      end
    end

    # Removes entries for _player_ for every +SolarSystem+ in _zone_.
    def decrease_for_zone(zone, player, decrement=1, should_dispatch=true)
      increase_for_zone(zone, player, -decrement, should_dispatch)
    end

    # Update player entries in alliance pool.
    def update_player(alliance_id, player_id, modifier)      
      transaction do
        find(:all, :conditions => {:player_id => player_id}).each do |entry|
          increase_for_kind(entry.solar_system_id, 'alliance_id', alliance_id,
            entry.counter * modifier)
        end
      end
    end

    # Add all entries currently belonging to player to alliance pool.
    #
    # Multiply _counter_ by _modifier_ before adding.
    def assimilate_player(alliance, player, dispatch_event=true)
      update_player(alliance.id, player.id, 1)

      EventBroker.fire(FowChangeEvent.new(player, alliance),
        EventBroker::FOW_CHANGE,
        EventBroker::REASON_SS_ENTRY) if dispatch_event
    end

    # Remove all player entries from alliance pool.
    def throw_out_player(alliance, player, dispatch_event=true)
      update_player(alliance.id, player.id, -1)

      EventBroker.fire(FowChangeEvent.new(player, alliance),
        EventBroker::FOW_CHANGE,
        EventBroker::REASON_SS_ENTRY) if dispatch_event
    end
  end
end
