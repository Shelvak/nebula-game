module Dispatcher::PlayerUnregisterTask
  class << self
    def player(dispatcher_tag, player)
      name = "#{player} unregister in #{dispatcher_tag}"
      short_name = "#{player.name} unregister in #{dispatcher_tag}"

      Threading::Director::Task.non_failing(name, short_name) do |worker_name|
        Threading::Director::Task.retrying_transaction(worker_name, name) do
          player.last_seen = Time.now
          player.save!
        end
      end
    end

    def chat(dispatcher_tag, player)
      name = "#{player} chat unregister in #{dispatcher_tag}"
      short_name = "#{player.name} chat unregister in #{dispatcher_tag}"

      Threading::Director::Task.non_failing(name, short_name) do |worker_name|
        Chat::Pool.instance.hub_for(player).unregister(player)
      end
    end
  end
end