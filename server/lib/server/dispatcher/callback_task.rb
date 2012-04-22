module Dispatcher::CallbackTask
  class << self
    # Creates a task which is ran in one of the worker threads.
    def create(klass, method, callback)
      Threading::Director::Task.non_failing(callback.to_s) do |worker_name|
        # Wrap our request in correct ruleset.
        CONFIG.with_set_scope(callback.ruleset) do
          # Ensure that if anything bad happens it would be rollbacked.
          Threading::Director::Task.retrying_transaction(
            worker_name, callback.to_s
          ) do
            object = callback.object!

            # Object can be nil if somehow other thread deleted it. Then
            # we don't need to process the callback too.
            unless object.nil?
              klass.send(method, object)
            else
              LOGGER.info "Object gone, ignoring.", worker_name
            end

            # Destroy this callback after processing if it still exists (was
            # not replaced by some other event).
            callback.destroy!
          end
        end

        LOGGER.info "Processed: #{callback}", worker_name
      end
    end
  end
end