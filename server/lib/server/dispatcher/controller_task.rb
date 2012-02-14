module Dispatcher::ControllerTask
  class << self
    # Creates a task which is ran in one of the worker threads.
    def create(controller_class, action_method, message)
      Threading::Director::Task.new(message.to_s) do |worker_name|
        dispatcher = Celluloid::Actor[:dispatcher]
        exception = nil

        begin
          # Wrap our request in correct ruleset.
          ruleset = dispatcher.storage_get(message.client, :ruleset)
          ruleset ||= GameConfig::DEFAULT_SET

          CONFIG.with_set_scope(ruleset) do
            # Ensure that if anything bad happens it would be rollbacked.
            ActiveRecord::Base.transaction(:joinable => false) do
              controller_class.send(action_method, message)
            end
          end
        rescue Dispatcher::ClientDisconnected => e
          LOGGER.info "Dropping processing, client already disconnected.",
            worker_name
        rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid,
            ActiveRecord::RecordNotDestroyed, GameError => e
          # Expected exceptions - notify client that his action failed.
          LOGGER.info "#{message} failed: #{e.to_log_str}", worker_name
          exception = e
        rescue Exception => e
          # Unexpected exceptions - log error, however do not crash the worker.
          LOGGER.error "#{message} failed: #{e.to_log_str}", worker_name
          exception = e
        ensure
          # Confirm that our task has been successfully processed unless we are
          # pushing it or client has already disconnected.
          dispatcher.confirm_receive!(message, exception) \
            unless message.pushed? ||
              exception.is_a?(Dispatcher::ClientDisconnected)
        end
      end
    end
  end
end