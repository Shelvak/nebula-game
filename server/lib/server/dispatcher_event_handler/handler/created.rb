class DispatcherEventHandler::Handler::Created < DispatcherEventHandler::Handler
  RESOLVERS = [
    [Parts::Object, OBJECTS_RESOLVER_CREATOR.call(
      DispatcherEventHandler::ObjectResolver::CONTEXT_CHANGED,
      ObjectsController::ACTION_CREATED,
      lambda { |objects, reason| {'objects' => objects} }
    )],
    [Event::PlayerRename, lambda do |dispatcher, events, reason|
      events.each do |event|
        params = {'id' => event.player_id, 'name' => event.new_name}
        dispatcher.push_to_logged_in!(PlayersController::ACTION_RENAME, params)
      end
    end],
    [Event::PlanetObserversChange, lambda do |dispatcher, events, reason|
      events.each do |event|
        filter = Dispatcher::PushFilter.ss_object(event.planet_id)

        event.non_observer_ids.each do |player_id|
          typesig_bindless [["player_id", player_id]], Fixnum
          dispatcher.push_to_player!(
            player_id, PlanetsController::ACTION_UNSET_CURRENT,
            {}, filter
          )
        end
      end
    end],
    [Event::ApocalypseStart, lambda do |dispatcher, events, reason|
      events.each do |event|
        params = {'start' => event.start}
        player_ids = without_locking do
          Player.select("id").where(:galaxy_id => event.galaxy_id).
            c_select_values
        end
        player_ids.each do |player_id|
          typesig_bindless [["player_id", player_id]], Fixnum
          dispatcher.push_to_player!(
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