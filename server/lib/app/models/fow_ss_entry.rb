# Fog of War solar system cache entry.
#
# This cache is used to speed up determination of what players see what solar
# systems in particular galaxy.
#
class FowSsEntry < ActiveRecord::Base
  include Parts::WithLocking

  # Used to pass scope for #recalculate.
  class RecalculateScope
    attr_reader :solar_system_id, :scope

    def initialize(solar_system_id, scope)
      typesig binding, Fixnum, ActiveRecord::Relation
      @solar_system_id = solar_system_id
      @scope = scope
    end
  end

  # FK :dependent => :destroy_all
  belongs_to :solar_system

  include Parts::FowEntry

  custom_serialize :alliance_planet_player_ids, :alliance_ship_player_ids,
    :serialize => lambda { |value|
      value.blank? ? nil : value.join(",")
    },
    :unserialize => lambda { |value|
      value.nil? ? [] : value.split(",").map(&:to_i)
    }

  def initialize(*args)
    super(*args)
    # Ensure they are not nils.
    self.alliance_planet_player_ids ||= []
    self.alliance_ship_player_ids ||= []
  end

  class << self
    # Returns +Player+ ids that observe _solar_system_id_.
    def observer_player_ids(solar_system_id)
      solar_system = without_locking { SolarSystem.find(solar_system_id) }
      if solar_system.main_battleground?
        ss_table = SolarSystem.table_name
        super(
          SolarSystem.sanitize_sql_for_conditions(
            :kind => SolarSystem::KIND_WORMHOLE
          ),
          "LEFT JOIN `#{ss_table}` ON `#{ss_table}`.`id`=`solar_system_id`"
        )
      else
        super(
          sanitize_sql_for_conditions(:solar_system_id => solar_system_id)
        )
      end
    end

    # Register change of planet owner.
    #
    # This updates visibility and status of +SolarSystem+ in which _planet_
    # is.
    #
    def change_planet_owner(planet, old_player, new_player, change=1)
      if old_player
        # Change visibility
        FowSsEntry.decrease(planet.solar_system_id, old_player, change)
      end

      if new_player
        # Change visibility
        FowSsEntry.increase(planet.solar_system_id, new_player, change)
      end
    end

    # Recalculate metadata for entries that cover _solar_system_id_.
    def recalculate(scope_or_ss_id, dispatch_event=true)
      typesig binding, [RecalculateScope, Fixnum], Boolean

      if scope_or_ss_id.is_a?(RecalculateScope)
        scope = scope_or_ss_id.scope
        solar_system_id = scope_or_ss_id.solar_system_id
      else
        scope = where(:solar_system_id => scope_or_ss_id)
        solar_system_id = scope_or_ss_id
      end

      LOGGER.block(
        "Recalculating metadata for #{solar_system_id}", :level => :debug
      ) do
        # Select data we need
        planet_player_ids = without_locking do
          SsObject.
            select("DISTINCT(player_id)").
            where(
              "solar_system_id=? AND player_id IS NOT NULL",
              solar_system_id
            ).
            c_select_values.map(&:to_i)
        end
        unit_player_ids = without_locking do
          Unit.
            select("DISTINCT(player_id)").
            where(
              "location_solar_system_id=? AND player_id IS NOT NULL",
              solar_system_id
            ).
            c_select_values.map(&:to_i)
        end
        planet_alliance_ids = without_locking do
          Player.
            select("DISTINCT(alliance_id)").
            where(:id => planet_player_ids).
            c_select_values.map(&:to_i)
        end
        unit_alliance_ids = without_locking do
          Player.
            select("DISTINCT(alliance_id)").
            where(:id => unit_player_ids).
            c_select_values.map(&:to_i)
        end

        changed = []

        # Find all entries that relate to that solar system.
        scope.each do |entry|
          if entry.player_id
            # It's a Player entry

            # Resolve planets
            entry.player_planets = planet_player_ids.include?(entry.player_id)
            entry.enemy_planets = !! (planet_player_ids.find do |id|
              id != entry.player_id
            end)
            entry.alliance_planet_player_ids = []
            entry.nap_planets = nil

            # Resolve ships
            entry.player_ships = unit_player_ids.include?(entry.player_id)
            entry.enemy_ships = !! (unit_player_ids.find do |id|
              id != entry.player_id
            end)
            entry.alliance_ship_player_ids = []
            entry.nap_ships = nil

          else
            # It's an Alliance entry
            alliance_player_ids = without_locking do
              Player.
                select("id").
                where(:alliance_id => entry.alliance_id).
                c_select_values.map(&:to_i)
            end

            # Get established naps.
            nap_ids = Nap.alliance_ids_for(
              entry.alliance_id, Nap::STATUS_ESTABLISHED
            ).to_a

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
          Event::FowChange::Recalculate.new(changed, solar_system_id),
          EventBroker::FOW_CHANGE,
          EventBroker::REASON_SS_ENTRY
        ) if dispatch_event && changed.present?

        ! changed.blank?
      end
    end

    # Returns +SolarSystemMetadata+ constructed from _fse_player_ and
    # _fse_alliance_.
    #
    # If coords ([x, y]) are given, they are also merged into metadata as
    # :x and :y.
    #
    # Same goes with kind, which must be Fixnum and player which must be
    # Player#minimal.
    #
    # Each entry is determined by merging player and alliance entries by
    # rules.
    #
    # _fse_player_ can be nil if player doesn't have direct visibility
    # in that zone.
    # _fse_alliance_ can be nil if player is not in alliance.
    #
    def merge_metadata(fse_player, fse_alliance, coords=nil, kind=nil,
        player=nil)
      typesig binding, [FowSsEntry, NilClass], [FowSsEntry, NilClass],
                       [Array, NilClass], [Fixnum, NilClass], [Hash, NilClass]

      # If player doesn't have visibility in that zone, then it's
      # their allies for sure.
      player_id = fse_player ? [fse_player.player_id] : []

      SolarSystemMetadata.new(
        :id => (fse_player || fse_alliance).solar_system_id,
        :x => coords.try(:[], 0),
        :y => coords.try(:[], 1),
        :kind => kind,
        :player => player,

        # Player may not have visibility of that SS, but alliance may have.
        :player_planets => !! (fse_player ? fse_player.player_planets : false),
        :player_ships => !! (fse_player ? fse_player.player_ships : false),

        # Alliance status overrides player status. Same player may be enemy
        # in pvp relationship, but an ally or nap in alliance relationship.
        :enemy_planets => !! (fse_alliance \
          ? fse_alliance.enemy_planets : fse_player.enemy_planets),
        :enemy_ships => !! (fse_alliance \
          ? fse_alliance.enemy_ships : fse_player.enemy_ships),

        # You can't see alliance stuff if you're not in one.
        :alliance_planets => !! (fse_alliance \
          ? (fse_alliance.alliance_planet_player_ids - player_id).present? \
          : false),
        :alliance_ships => !! (fse_alliance \
          ? (fse_alliance.alliance_ship_player_ids - player_id).present? \
          : false),

        # Same with naps.
        :nap_planets => !! (fse_alliance ? fse_alliance.nap_planets : false),
        :nap_ships => !! (fse_alliance ? fse_alliance.nap_ships : false)
      )
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
    # by _increment_.
    #
    # This also creates entry for +Alliance+ if _player_ is in one.
    def increase(solar_system_id, player, increment=1, should_dispatch=true)
      return if solar_system_id == Galaxy.battleground_id(player.galaxy_id)
      raise ArgumentError,
        "invalid increment 0 for ss #{solar_system_id}, player #{player}!" \
        if increment == 0

      # Recalculate, because if visibility increased/decreased there probably
      # were some changes that we need to send to other players who are also
      # spectating this solar system.
      #
      # This happens before increasing to prevent updates for player for whom
      # ss created will be dispatched.
      recalculate(solar_system_id, should_dispatch) if increment > 0

      # Actually increase visibility.
      status = increase_for_kind(
        solar_system_id, 'player_id', player.id, increment
      )
      alliance_status = increase_for_kind(
        solar_system_id, 'alliance_id', player.alliance_id, increment
      ) unless player.alliance_id.nil?

      # Or after if, to prevent updates for those, to whom destroyed would be
      # sent.
      recalculate(solar_system_id, should_dispatch) if increment < 0

      status_is = lambda do |wanted|
        status == wanted && (
          player.alliance_id.nil? || alliance_status == wanted
        )
      end

      return false unless should_dispatch
      if status_is[:destroyed]
        # Only dispatch destroyed if both alliance and player records has been
        # destroyed.
        event = Event::FowChange::SsDestroyed.new(
          solar_system_id, player.friendly_ids
        )
        EventBroker.fire(
          event, EventBroker::FOW_CHANGE, EventBroker::REASON_SS_ENTRY
        )

        should_dispatch
      elsif status_is[:created]
        scope = where(:solar_system_id => solar_system_id)
        scope = player.alliance_id.nil? \
          ? scope.where(:player_id => player.id) \
          : scope.where("player_id=? OR alliance_id=?",
            player.id, player.alliance_id
          )

        # Recalculate metadata for created fse, because it was not recalculated
        # before.
        recalculate(RecalculateScope.new(solar_system_id, scope), false)

        ss = without_locking { SolarSystem.find(solar_system_id) }
        fow_ss_entries = without_locking { scope.all.each(&:freeze) }

        event = Event::FowChange::SsCreated.new(
          ss.id, ss.x, ss.y, ss.kind, Player.minimal(ss.player_id),
          fow_ss_entries
        )
        EventBroker.fire(
          event, EventBroker::FOW_CHANGE, EventBroker::REASON_SS_ENTRY
        )

        should_dispatch
      else
        # Only an update, recalculate should have dispatched event for us.
        false
      end
    end

    # Deletes entry for _player_ at _solar_system_id_. Also removes entry
    # for +Alliance+ if _player_ is in one.
    def decrease(solar_system_id, player, decrement=1, should_dispatch=true)
      # Decrement counter
      increase(solar_system_id, player, -decrement, should_dispatch)
    end

    # Creates entries for _player_ for every +SolarSystem+ in _zone_.
    def increase_for_zone(zone, player, increment=1, should_dispatch=true)
      without_locking do
        SolarSystem.select("id").in_zone(*zone).
          where(galaxy_id: player.galaxy_id).c_select_values
      end.each do |solar_system_id|
        increase(solar_system_id, player, increment, should_dispatch)
      end
    end

    # Removes entries for _player_ for every +SolarSystem+ in _zone_.
    def decrease_for_zone(zone, player, decrement=1, should_dispatch=true)
      increase_for_zone(zone, player, -decrement, should_dispatch)
    end

    # Update player entries in alliance pool upon #assimilate_player or
    # #throw_out_player.
    def update_player(alliance_id, player_id, modifier)      
      without_locking do
        select("solar_system_id, counter").where(:player_id => player_id).
          c_select_all
      end.each do |row|
        increase_for_kind(
          row['solar_system_id'], 'alliance_id', alliance_id,
          row['counter'] * modifier
        )
        # Recalculate solar system metadata, because statuses have changed.
        # Do not dispatch events, because whole galaxy map will be resent
        # later.
        recalculate(row['solar_system_id'], false)
      end
    end

    # Add all entries currently belonging to player to alliance pool.
    #
    # Multiply _counter_ by _modifier_ before adding.
    def assimilate_player(alliance, player)
      update_player(alliance.id, player.id, 1)
    end

    # Remove all player entries from alliance pool.
    def throw_out_player(alliance, player)
      update_player(alliance.id, player.id, -1)
    end
  end
end
