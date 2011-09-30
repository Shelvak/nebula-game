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
  belongs_to :route
  composed_of :location, :class_name => 'LocationPoint',
      :mapping => LocationPoint.attributes_mapping_for(:location)
  
  include Parts::InLocation

  default_scope :order => "`index` ASC"

  # Selects route hops marked as next.
  scope :next, {:conditions => {:next => true}}

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
        ? connection.select_values(
          "SELECT id FROM `#{Player.table_name}` WHERE #{
            sanitize_sql_hash_for_conditions(
              {:alliance_id => player.alliance_id},
              Player.table_name
            )
          }"
        ) \
        : [player.id]

      self.for(player_ids).in_zone(zone).find(
        :all, :conditions => {:route_id => route_ids}
      )
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
      "jumps_at" => jumps_at.as_json,
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

    SsObject::Planet.changing_viewable([old_location, location]) do
      transaction do
        route.current = location.to_client_location

        Unit.update_all(location.location_attrs, {:route_id => route.id})

        next_hop = self.class.find_by_route_id_and_index(route.id, index + 1)
        if next_hop
          next_hop.next = true
          next_hop.save!

          CallbackManager.register(next_hop, CallbackManager::EVENT_MOVEMENT,
            next_hop.arrives_at)
        end

        event = MovementEvent.new(route, old_location, self, next_hop)
        zone_changed = Zone.different?(old_location, route.current)
        EventBroker.fire(
          event,
          EventBroker::MOVEMENT,
          zone_changed \
            ? EventBroker::REASON_BETWEEN_ZONES \
            : EventBroker::REASON_IN_ZONE
        )

        self.class.handle_fow_change(event) if zone_changed

        # Saving/destroying route dispatches event that is transmitted to
        # Dispatcher. We need event to go in "movement, route" sequence, not
        # other way round

        # Flag route as being completed.
        route.completed = true
        next_hop ? route.save! : route.destroy!

        destroy!
      end
    end
  end

  def self.handle_fow_change(movement_event)
    # Increase/decrease FOW solar system cache counters upon units
    # changing zones.

    route = movement_event.route
    unit_count = route.cached_units.values.sum
    previous_location = movement_event.previous_location
    current_location = route.current

    if previous_location.type == Location::SOLAR_SYSTEM &&
        current_location.type == Location::SOLAR_SYSTEM
      raise ArgumentError.new(
        "Cannot hop from SS to SS directly, must be a bug in the code! #{
          movement_event.inspect}"
      )
    elsif previous_location.type == Location::GALAXY
      FowSsEntry.increase(current_location.id, route.player, unit_count)
    elsif current_location.type == Location::GALAXY
      FowSsEntry.decrease(previous_location.id, route.player, unit_count)
    elsif previous_location.type == Location::SS_OBJECT
      FowSsEntry.recalculate(current_location.id)
    elsif current_location.type == Location::SS_OBJECT
      FowSsEntry.recalculate(previous_location.id)
    end
  end

  def self.on_callback(id, event)
    if event == CallbackManager::EVENT_MOVEMENT
      hop = find(id)
      hop.move!
      Combat::LocationCheckerAj.check_location(hop.location)
    else
      raise CallbackManager::UnknownEvent.new(self, id, event)
    end
  end
end
