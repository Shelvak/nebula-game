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
            unless player_id.nil?
              typesig_bindless [["player_id", player_id]], Fixnum
              dispatcher.push_to_player!(
                player_id, PlanetsController::ACTION_PLAYER_INDEX
              )
            end
          end
        end
      end

      OBJECTS_RESOLVER.call(dispatcher, planets, reason)
    end],
    [Parts::Object, OBJECTS_RESOLVER],
    [Player, lambda do |dispatcher, players, reason|
      players.each do |player|
        if dispatcher.player_connected?(player.id)
          dispatcher.update_player!(player)
          typesig_bindless [["player.id", player.id]], Fixnum
          dispatcher.push_to_player!(player.id, PlayersController::ACTION_SHOW)
        end
      end
    end],
    [Event::ConstructionQueue, lambda do |dispatcher, events, reason|
      events.each do |event|
        planet = without_locking { event.constructor.planet }
        # Can be null if planet is not occupied.
        unless planet.player_id.nil?
          typesig_bindless [["planet.player_id", planet.player_id]], Fixnum
          dispatcher.push_to_player!(
            planet.player_id,
            ConstructionQueuesController::ACTION_INDEX,
            {'constructor_id' => event.constructor_id},
            Dispatcher::PushFilter.ss_object(planet.id)
          )
        end
      end
    end],
    [Event::StatusChange, lambda do |dispatcher, events, reason|
      events.each do |event|
        event.statuses.each do |player_id, changes|
          typesig_bindless [["player_id", player_id]], Fixnum
          dispatcher.push_to_player!(
            player_id, PlayersController::ACTION_STATUS_CHANGE,
            {'changes' => changes}, nil
          )
          dispatcher.push_to_player!(player_id, RoutesController::ACTION_INDEX)
        end
      end
    end],
  ]

  class << self
    protected
    def resolvers
      RESOLVERS
    end
  end
end