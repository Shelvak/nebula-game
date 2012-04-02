module Dispatcher::PlayerRegisterTask
  class << self
    def create(dispatcher_tag, player)
      Threading::Director::Task.non_failing(
        "#{player} register in #{dispatcher_tag}"
      ) do |worker_name|
        Chat::Pool.instance.hub_for(player).register(player)
        # Push chat index after registering.
        Celluloid::Actor[:dispatcher].
          push_to_player!(player.id, ChatController::ACTION_INDEX)
      end
    end
  end
end