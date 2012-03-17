class Threading::Director::Task
  DEADLOCK_ERROR =
    "ActiveRecord::JDBCError: Deadlock found when trying to get lock"
  LOCK_WAIT_ERROR =
    "ActiveRecord::JDBCError: Lock wait timeout exceeded"
  INFO_FROM_RETRY = 3 # From which retry should innodb info be included?
  MAX_RETRIES = 8
  SLEEP_RANGE = 100..500

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
      DispatcherEventHandler::Buffer.instance.wrap do
        ActiveRecord::Base.transaction(:joinable => false) do
          yield
        end
      end
    rescue ActiveRecord::StatementInvalid => e
      if current_retry >= INFO_FROM_RETRY
        innodb_info = ActiveRecord::Base.connection.
          select_one("SHOW ENGINE INNODB STATUS")["Status"]
        status_line = "\n\nInnoDB status:\n#{innodb_info}"
        log_method = :warn
      else
        status_line = ""
        log_method = :info
      end

      if (
        e.message.starts_with?(DEADLOCK_ERROR) ||
        e.message.starts_with?(LOCK_WAIT_ERROR)
      ) && current_retry < MAX_RETRIES
        current_retry += 1

        sleep_for = SLEEP_RANGE.random_element / 1000.0
        LOGGER.send(
          log_method,
          %Q{Deadlock occurred, retry #{current_retry}, retrying again in #{
          sleep_for}s: #{e.message}#{status_line}},
          worker_name
        )
        sleep sleep_for
        retry
      else
        raise e.class,
          "Deadlock unresolvable after #{MAX_RETRIES} retries: #{e.message}#{
            status_line}"
      end
    end
  end
end