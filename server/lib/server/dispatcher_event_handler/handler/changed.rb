class DispatcherEventHandler::Handler::Changed < DispatcherEventHandler::Handler
  OBJECTS_RESOLVER = OBJECTS_RESOLVER_CREATOR.call(
    DispatcherEventHandler::ObjectResolver::CONTEXT_CHANGED,
    ObjectsController::ACTION_UPDATED,
    lambda { |objects, reason| {'objects' => objects, 'reason' => reason} }
  )

  RESOLVERS = [
    [SsObject::Planet, lambda do |dispatcher, planets, reason|
      if reason == EventBroker::REASON_OWNER_CHANGED
        planets.each do |planet|
          old_id, new_id = planet.player_id_change
          [old_id, new_id].each do |player_id|
            dispatcher.push_to_player(
              player_id, PlanetsController::ACTION_PLAYER_INDEX
            ) unless player_id.nil?
          end
        end
      end

      OBJECTS_RESOLVER.call(dispatcher, planets, reason)
    end],
    [Parts::Object, OBJECTS_RESOLVER],
    [Player, lambda do |dispatcher, players, reason|
      players.each do |player|
        if dispatcher.connected?(player.id)
          dispatcher.update_player(player)
          dispatcher.push_to_player(player.id, PlayersController::ACTION_SHOW)
        end
      end
    end],
    [Event::ConstructionQueue, lambda do |dispatcher, events, reason|
      events.each do |event|
        planet = event.constructor.planet
        dispatcher.push_to_player(
          planet.player_id,
          ConstructionQueuesController::ACTION_INDEX,
          {'constructor_id' => event.constructor_id},
          Dispatcher::PushFilter.ss_object(planet.id)
        )
      end
    end],
    [Event::StatusChange, lambda do |dispatcher, events, reason|
      events.each do |event|
        event.statuses.each do |player_id, changes|
          dispatcher.push_to_player(
            player_id, PlayersController::ACTION_STATUS_CHANGE,
            {'changes' => changes}, nil
          )
          dispatcher.push_to_player(player_id, RoutesController::ACTION_INDEX)
        end
      end
    end],
    [Technology, lambda do |dispatcher, events, reason|
      # Just silently ignore it, we pass stuff manually with this one.
    end]
  ]

  class << self
    protected
    def resolvers
      RESOLVERS
    end
  end
end