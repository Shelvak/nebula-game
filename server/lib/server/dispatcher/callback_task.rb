module Dispatcher::CallbackTask
  class << self
    # Creates a task which is ran in one of the worker threads.
    def create(klass, method, callback)
      Threading::Director::Task.new(callback.to_s) do |worker_name|
        object = callback.object! or return

        begin
          # Wrap our request in correct ruleset.
          CONFIG.with_set_scope(callback.ruleset) do
            # Ensure that if anything bad happens it would be rollbacked.
            ActiveRecord::Base.transaction(:joinable => false) do
              klass.send(method, object)
            end
          end

          # Send off this callback as processed.
          Celluloid::Actor[:callback_manager].processed!(callback)
        rescue Exception => e
          # Unexpected exceptions - log error, however do not crash the worker.
          LOGGER.error "#{message} failed: #{e.to_log_str}", worker_name
        end
      end
    end
  end
end