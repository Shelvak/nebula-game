class DispatcherEventHandler::Handler::Destroyed <
    DispatcherEventHandler::Handler

  RESOLVERS = [
    [Parts::Object, OBJECTS_RESOLVER_CREATOR.call(
      DispatcherEventHandler::ObjectResolver::CONTEXT_DESTROYED,
      ObjectsController::ACTION_DESTROYED,
      lambda { |objects, reason| {'objects' => objects, 'reason' => reason} }
    )],
  ]

  class << self
    protected
    def resolvers
      RESOLVERS
    end
  end
end