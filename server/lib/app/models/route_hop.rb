# Defines one hop in +Route+. +RouteHop+ is made with units to particular
# +LocationPoint+. After that +Route+ current +ClientLocation+ is updated.
#
# Following +Hash+ is sent to client:
# {
#   'route_id' => +Fixnum+,
#   'location' => +LocationPoint+,
#   'arrives_at' => +Time+,
#   'index' => +Fixnum+ (+RouteHop+ index in +Route+, starting from 0)
# }
#
class RouteHop < ActiveRecord::Base
  DScope = Dispatcher::Scope
  include Parts::WithLocking

  belongs_to :route
  composed_of :location, LocationPoint.composed_of_options(
    :location,
    LocationPoint::COMPOSED_OF_GALAXY,
    LocationPoint::COMPOSED_OF_SOLAR_SYSTEM,
    LocationPoint::COMPOSED_OF_SS_OBJECT
  )

  include Parts::InLocation

  default_scope :order => "`index` ASC"

  # Selects route hops marked as next.
  scope :next, where(:next => true)

  # TODO: index me, spec
  scope :for, Proc.new { |player_ids|
    player_ids = [player_ids] unless player_ids.is_a?(Array)

    {
      :conditions => [
        "next=? OR `#{Route.table_name}`.player_id IN (?)",
        true,
        player_ids
      ],
      :include => :route
    }
  }

  # Returns all visible hops for player. Hop is visible if there is an unit
  # belonging to route and the hop belongs to that route. Also the route
  # must belong to player or his alliance to return all hops. If the route
  # doesn't belong to player, only first hop is returned.
  #
  # Note that those units may only be in some +Zone+. If they are not in
  # +Zone+ this method may fail with unexpected behavior.
  #
  # TODO: index
  def self.find_all_for_player(player, zone, units)
    route_ids = units.map { |unit| unit.route_id }.compact
    unless route_ids.blank?
      player_ids = player.alliance_id \
        ? Player.select("id").where(:alliance_id => player.alliance_id).
          c_select_values \
        : [player.id]

      self.for(player_ids).in_zone(zone).where(:route_id => route_ids).all
    else
      []
    end
  end

  # Returns hops in zone for given route id.
  def self.hops_in_zone(route_id, zone)
    in_zone(zone).scoped_by_route_id(route_id).all
  end

  #noinspection RubyUnusedLocalVariable
  def as_json(options=nil)
    {
      "route_id" => route_id,
      "location" => location.as_json,
      "arrives_at" => arrives_at.as_json,
      "index" => index
    }
  end

  # Returns what hop type this is: :galaxy or :solar_system.
  def hop_type
    case location.type
    when Location::GALAXY
      :galaxy
    when Location::SOLAR_SYSTEM, Location::SS_OBJECT
      :solar_system
    else
      nil
    end
  end

  def move!
    route = self.route
    old_location = route.current

    Visibility.track_movement_changes(old_location, location) do
      route.current = location.client_location

      Unit.where(:route_id => route.id).update_all(
        "#{Unit.update_location_sql(location)}, #{
          Unit.set_flag_sql(:hidden, false)}")

      next_hop = route.hops.where(:index => index + 1).first
      if next_hop
        next_hop.next = true
        next_hop.save!

        CallbackManager.register(next_hop, CallbackManager::EVENT_MOVEMENT,
          next_hop.arrives_at)
      end

      event = Event::Movement.new(route, old_location, self, next_hop)
      zone_changed = Zone.different?(old_location, route.current)

      if zone_changed
        # Update Route#jumps_at when zone changes.
        route.jumps_at = without_locking do
          route.hops.where("location_#{route.current.type_column} IS NULL").
            select("arrives_at").c_select_value
        end
      end

      # Destroy this route hop. This is important to do before firing the
      # event, because otherwise this route hop would be included in zone
      # hops, event though it was just executed.
      destroy!

      # Fire event.
      EventBroker.fire(
        event,
        EventBroker::MOVEMENT,
        zone_changed \
          ? EventBroker::REASON_BETWEEN_ZONES \
          : EventBroker::REASON_IN_ZONE
      )

      # Saving/destroying route dispatches event that is transmitted to
      # Dispatcher. We need event to go in "movement, route" sequence, not
      # other way round

      if next_hop
        route.save!
      else
        route.completed = true
        route.destroy!
      end
    end
  end

  MOVEMENT_SCOPE = DScope.world
  def self.movement_callback(route_hop)
    # Lock location because otherwise this bug happens:
    #
    # Worker1: Jump from destination A to C.
    # Worker2: Jump from destination B to C.
    #
    # Because they both happen at same time, neither workers 1 or 2 are aware of
    # each others transaction changes. So 1 doesn't pick location changes of 2
    # and vice-versa, resulting with combat not happening.
    #
    # This lock ensures that these two movements are serialized.
    LocationLock.with_lock(route_hop.location) do
      route_hop.move!
      Combat::LocationCheckerAj.check_location(route_hop.location)
    end
  end
end
