module Dispatcher::PlayerRegisterTask
  class << self
    def create(dispatcher_tag, player)
      Threading::Director::Task.new(
        "#{player} register in #{dispatcher_tag}"
      ) do |worker_name|
        ActiveRecord::Base.transaction(:joinable => false) do
          Chat::Pool.instance.hub_for(player).register(player)
        end
      end
    end
  end
end