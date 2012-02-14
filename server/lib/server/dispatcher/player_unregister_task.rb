module Dispatcher::PlayerUnregisterTask
  class << self
    def create(dispatcher_tag, player)
      Threading::Director::Task.new(
        "#{player} unregister in #{dispatcher_tag}"
      ) do |worker_name|
        ActiveRecord::Base.transaction(:joinable => false) do
          player.last_seen = Time.now
          player.save!

          # There is no point of notifying about leaves if server is shutdowning.
          # Also this generates NPE in buggy EM version.
          unless App.server_shutdowning?
            Chat::Pool.instance.hub_for(player).unregister(player)
          end
        end
      end
    end
  end
end