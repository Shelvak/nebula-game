class DispatcherEventHandler::ObjectResolver
  # Objects were changed
  CONTEXT_CHANGED = :changed
  # Objects were destroyed
  CONTEXT_DESTROYED = :destroyed

  # For shorter access.
  LocationResolver = DispatcherEventHandler::LocationResolver

  class Data
    attr_reader :player_ids, :filter, :objects

    def initialize(player_ids, filter)
      @player_ids, @filter, @objects = player_ids, filter, []
    end

    def <<(object)
      @objects << object
    end

    def ==(other); eql?(other); end
    def eql?(other)
      other.is_a?(self.class) && @player_ids == other.player_ids &&
        @filter == other.filter && @objects == other.objects
    end
  end

  class << self
    # Resolves player ids that should be notified about _objects_ and that
    # object filter. First item will be used for resolving.
    #
    # Resolver behavior can be altered by providing different context.
    #
    # Returns Array of Data objects.
    #
    def resolve(objects, reason, context=nil)
      typesig binding, Enumerable, [NilClass, Symbol], [NilClass, Symbol]

      # Hash of {
      #   unique_key => {:player_ids => [], :filter => Symbol, :objects => []]}
      # } pairs.
      #
      # Use:
      # Imagine that objects is a unit array with different actual locations.
      # We need to group those units by their locations and resolve player_ids
      # and filter for each location. This hash allows us to to that
      # effectively by using keys as uniqueness checkers.
      #
      data = {}

      objects.each do |object|
        key, resolver = case object
        when Building, Tile
          planet(object.planet_id)
        when Unit, Wreckage, Cooldown
          location(object)
        when Route
          route(object, context)
        when SsObject
          if object.is_a?(SsObject::Planet) &&
              reason == EventBroker::REASON_OWNER_PROP_CHANGE
            # Only owner should know about this change.
            planet_owner_only(object)
          else
            solar_system(object.solar_system_id)
          end
        when ConstructionQueueEntry
          planet_owner_only(object.constructor.planet)
        when Notification, ClientQuest, QuestProgress, ObjectiveProgress,
             Technology
          player(object.player_id)
        when SolarSystem, SolarSystemMetadata
          ss = object.is_a?(SolarSystem) ? object : SolarSystem.find(object.id)

          solar_system_galaxy_point(ss)
        else
          raise ArgumentError.new(
            "Don't know how to resolve #{object.inspect}!"
          )
        end

        unless key.nil?
          unless data.has_key?(key)
            player_ids, filter = resolver.call
            data[key] = Data.new(player_ids, filter)
          end

          data[key] << object
        end
      end

      data.values
    end

    private
    def planet_owner_only(planet)
      return if planet.player_id.nil?
      [
        "Planet-#{planet.id}",
        # Planets belonging to player should be dispatched even if we
        # don't currently see them to update planet selector.
        lambda { [[planet.player_id], nil] }
      ]
    end

    def planet(planet_id)
      [
        "Location-#{planet_id}-#{Location::SS_OBJECT}-#{nil}-#{nil}",
        lambda { LocationResolver.resolve(LocationPoint.planet(planet_id)) }
      ]
    end

    def solar_system(solar_system_id)
      [
        "Location-#{solar_system_id}-#{Location::SOLAR_SYSTEM}-#{nil}-#{nil}",
        lambda {
          # We cannot create SolarSystemPoint with nil coordinates, so we
          # resort to this.
          [
            SolarSystem.observer_player_ids(solar_system_id),
            Dispatcher::PushFilter.solar_system(solar_system_id)
          ]
        }
      ]
    end

    def solar_system_galaxy_point(solar_system)
      [
        "Location-#{solar_system.galaxy_id}-#{Location::GALAXY}-#{
          solar_system.x}-#{solar_system.y}",
        lambda { LocationResolver.resolve(solar_system.galaxy_point) }
      ]
    end

    def location(object)
      [
        "Location-#{object.location_id}-#{object.location_type}-#{
          object.location_x}-#{object.location_y}",
        lambda { LocationResolver.resolve(object.location) }
      ]
    end

    def route(route, context)
      # NPC routes need no dispatching.
      return if route.player_id.nil?

      [
        "Route-#{route.id}",
        lambda {
          case context
          when CONTEXT_CHANGED
            [route.player.friendly_ids, nil]
          when CONTEXT_DESTROYED
            player_ids, _ = LocationResolver.resolve(route.current)
            player_ids |= route.player.friendly_ids
            # Don't use filter, because friendly destroy events should be
            # dispatched without any filter.
            [player_ids, nil]
          else
            raise ArgumentError.new(
              "Unknown Route context for objects resolver: #{context.inspect}"
            )
          end
        }
      ]
    end

    def player(player_id)
      [
        "Player-#{player_id}",
        lambda { [[player_id], nil] }
      ]
    end
  end
end