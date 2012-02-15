module Dispatcher::CallbackTask
  class << self
    # Creates a task which is ran in one of the worker threads.
    def create(klass, method, callback)
      Threading::Director::Task.new(callback.to_s) do |worker_name|
        begin
          # Wrap our request in correct ruleset.
          CONFIG.with_set_scope(callback.ruleset) do
            # Ensure that if anything bad happens it would be rollbacked.
            ActiveRecord::Base.transaction(:joinable => false) do
              object = callback.object! or return

              # Destroy this callback in transaction. If anything fails while
              # working with the callback it will be restored back to life.
              callback.destroy!

              klass.send(method, object)
            end
          end

          LOGGER.info "Processed: #{callback}", worker_name
        rescue Exception => e
          # Unexpected exceptions - log error, however do not crash the worker.
          LOGGER.error "#{callback} failed: #{e.to_log_str}", worker_name
        end
      end
    end
  end
end