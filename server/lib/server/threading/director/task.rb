class Threading::Director::Task
  DEADLOCK_ERROR =
    "ActiveRecord::JDBCError: Deadlock found when trying to get lock"
  MAX_RETRIES = 10
  SLEEP_RANGE = 10..500

  def initialize(description, &block)
    @description = description
    @block = block
  end

  # Runs this task passing it worker name. Checks out DB connection before
  # running it.
  def run(worker_name)
    ActiveRecord::Base.connection_pool.with_connection do
      @block.call(worker_name)
    end
  end

  def to_s
    "<#{self.class.to_s} #{@description}>"
  end

  def self.retrying_transaction(worker_name)
    current_retry = 0
    begin
      ActiveRecord::Base.transaction(:joinable => false) do
        yield
      end
    rescue ActiveRecord::StatementInvalid => e
      LOGGER.error e.message
      if e.message.starts_with?(DEADLOCK_ERROR) && current_retry < MAX_RETRIES
        current_retry += 1

        sleep_for = SLEEP_RANGE.random_element / 1000.0
        LOGGER.info "Deadlock occurred, retry #{current_retry
          }, retrying again in #{sleep_for}s.", worker_name
        sleep sleep_for
        retry
      else
        raise e.class,
          "Deadlock unresolvable after #{MAX_RETRIES} retries: #{e.message}"
      end
    end
  end
end