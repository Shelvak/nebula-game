# A +Route+ belonging to +Player+. A route has one or more units and moves
# them from _source_ to _target_ via route hops.
#
# Route has such attributes:
# - id (Fixnum)
# - player_id (Fixnum)
# - cached_units (Hash): Hash of units being moved. I.e. {"Mule" => 10}
# - first_hop (Time): time of the first hop
# - arrives_at (Time): arrival time
# - source_id (Fixnum)
# - source_type (Fixnum)
# - source_x (Fixnum)
# - source_y (Fixnum)
# - source_name (String)
# - source_variation (Fixnum)
# - source_solar_system_id (Fixnum)
#
# All of the source_* attributes are documented in Location#client_attrs.
#
# Route also has current_* and target_* attributes analoguous to source_*
# attributes.
#
# When sending to client +Route+ looks like this:
# {
#   :id => +Fixnum+,
#   :player_id => +Fixnum+,
#   :cached_units => +Hash+,
#   :arrives_at => +Time+,
#   :source => +ClientLocation+,
#   :current => +ClientLocation+,
#   :target => +ClientLocation+
# }
#
class Route < ActiveRecord::Base
  # FK :dependant => :delete_all
  belongs_to :player

  # :dependent => :delete_all provided by FK
  has_many :hops, :class_name => "RouteHop"
  # :dependent => :nullify provided by FK
  has_many :units
  serialize :cached_units

  [:source, :current, :target].each do |side|
    composed_of side, :class_name => 'ClientLocation',
      :mapping => ClientLocation.attributes_mapping_for(side)
  end

  include Parts::Object
  # Order matters here, notification control methods should be above
  # included module.

  # UnitsControler::ACTION_MOVEMENT_PREPARE takes care of that.
  def self.notify_on_create?; false; end
  include Parts::Notifier

  # Flags route as being completed. If this flag is set - when route destroyed
  # is dispatched to client, it has reason attached to it.
  attr_accessor :completed

  def notify_broker_destroy
    EventBroker.fire(self, EventBroker::DESTROYED,
      completed ? EventBroker::REASON_COMPLETED : nil)
    true
  end

  # Returns all the hops for current zone for this route if current
  # location is +GalaxyPoint+ or +SolarSystemPoint+. Returns [] otherwise.
  def hops_in_current_zone
    case current.type
    when Location::GALAXY, Location::SOLAR_SYSTEM
      hops_in_zone(current.object.zone)
    else
      # Other zones does not have route hops
      []
    end
  end

  # Returns route hops in given zone for this hop.
  def hops_in_zone(zone)
    RouteHop.hops_in_zone(id, zone)
  end

  # Return Hash for JSON serialization.
  #
  # If :mode is :normal, return all attributes.
  # If :mode is :enemy, only return id, player_id, first_hop and
  # current location.
  #
  def as_json(options=nil)
    options ||= {}
    options.reverse_merge! :mode => :normal

    case options[:mode]
    when :normal
      {
        :id => id,
        :player_id => player_id,
        :cached_units => cached_units,
        :first_hop => first_hop,
        :arrives_at => arrives_at,
        :source => source.as_json(options),
        :current => current.as_json(options),
        :target => target.as_json(options)
      }
    when :enemy
      {
        :id => id,
        :player_id => player_id,
        :first_hop => first_hop,
        :current => current.as_json(options)
      }
    else
      raise ArgumentError.new("Unknown options[:mode] #{
        options[:mode].inspect}!")
    end
  end

  # Subtracts _units_ from cached units and saves the Route. If there are
  # no more units after subtraction, the route is simply deleted because it
  # is useless now.
  # 
  # _unit_counts_ should be a Hash:
  #   {
  #     type => count,
  #     ...
  #   }
  #
  def subtract_from_cached_units!(unit_counts)
    # Reduce units from the route.
    unit_counts.each do |type, count|
      old_count = cached_units[type]
      unless old_count.nil?
        if old_count == count
          cached_units.delete type
        elsif old_count > count
          cached_units[type] -= count
        else
          raise ArgumentError.new(
            "Cannot reduce #{count} of #{type} because we only have #{
              old_count}!"
          )
        end
      end
    end

    if cached_units.blank?
      # No units - no route. Destroy self.
      destroy!
    else
      save!
    end
  end
end
