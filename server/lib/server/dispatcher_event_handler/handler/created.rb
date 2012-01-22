class DispatcherEventHandler::Handler::Created < DispatcherEventHandler::Handler
  RESOLVERS = [
    [Parts::Object, OBJECTS_RESOLVER_CREATOR.call(
      DispatcherEventHandler::ObjectResolver::CONTEXT_CHANGED,
      ObjectsController::ACTION_CREATED,
      lambda { |objects, reason| {'objects' => objects} }
    )],
    [Event::PlanetObserversChange, lambda do |dispatcher, events, reason|
      events.each do |event|
        filter = Dispatcher::PushFilter.ss_object(event.planet_id)

        event.non_observer_ids.each do |player_id|
          dispatcher.push_to_player(
            player_id, PlanetsController::ACTION_UNSET_CURRENT,
            {}, filter
          )
        end
      end
    end],
    [Event::ApocalypseStart, lambda do |dispatcher, events, reason|
      events.each do |event|
        params = {'start' => event.start}
        player_ids = Player.select("id").where(:galaxy_id => event.galaxy_id).
          c_select_values
        player_ids.each do |player_id|
          dispatcher.push_to_player(
            player_id, GalaxiesController::ACTION_APOCALYPSE,
            params, nil
          )
        end
      end
    end]
  ]

  class << self
    protected
    def resolvers
      RESOLVERS
    end
  end
end