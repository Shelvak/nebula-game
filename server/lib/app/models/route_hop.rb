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

    SsObject::Planet.changing_viewable([old_location, location]) do
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
        self.class.handle_fow_change(event)
        # Update Route#jumps_at when zone changes.
        route.jumps_at = route.hops.
          where("location_type != ?", route.current.type).first.
          try(:arrives_at)
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
