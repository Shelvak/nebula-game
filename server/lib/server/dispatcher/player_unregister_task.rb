module Dispatcher::PlayerUnregisterTask
  class << self
    def player(dispatcher_tag, player)
      Threading::Director::Task.new(
        "#{player} unregister in #{dispatcher_tag}"
      ) do |worker_name|
        ActiveRecord::Base.transaction(:joinable => false) do
          player.last_seen = Time.now
          player.save!
        end
      end
    end

    def chat(dispatcher_tag, player)
      Threading::Director::Task.new(
        "#{player} chat unregister in #{dispatcher_tag}"
      ) do |worker_name|
        Chat::Pool.instance.hub_for(player).unregister(player)
      end
    end
  end
end