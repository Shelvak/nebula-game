class DispatcherEventHandler::Handler
  # Helper function to create Parts::Object resolvers.
  OBJECTS_RESOLVER_CREATOR = lambda do |context, action, params_function|
    lambda do |dispatcher, objects, reason|
      dataset = DispatcherEventHandler::ObjectResolver.
        resolve(objects, reason, context)
      dataset.each do |data|
        params = params_function[data.objects, reason]
        data.player_ids.each do |player_id|
          dispatcher.push_to_player(player_id, action, params, data.filter)
        end
      end
    end
  end

  class << self
    def handle(dispatcher, objects, reason)
      resolvers = self.resolvers
      objects = objects.is_a?(Array) ? objects : [objects]

      resolved = objects.each_with_object({}) do |object, hash|
        kind, invoker = resolvers.find do |resolver_kind, _|
          object.is_a?(resolver_kind)
        end

        raise ArgumentError.new(
          "#{self} does not know how to handle #{object.inspect}!"
        ) if kind.nil?

        hash[kind] ||= {:invoker => invoker, :objects => []}
        hash[kind][:objects] << object
      end

      resolved.each do |_, data|
        data[:invoker].call(dispatcher, data[:objects], reason)
      end
    end

    protected

    def resolvers
      raise NotImplementedError
    end
  end
end