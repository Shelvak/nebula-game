module Dispatcher::PlayerRegisterTask
  class << self
    def create(dispatcher_tag, player)
      Threading::Director::Task.non_failing(
        "#{player} register in #{dispatcher_tag}"
      ) do |worker_name|
        Chat::Pool.instance.hub_for(player).register(player)
      end
    end
  end
end