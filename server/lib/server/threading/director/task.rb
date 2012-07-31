class Threading::Director::Task
  DEADLOCK_ERRORS = [
    "Deadlock found when trying to get lock",
    "Lock wait timeout exceeded"
  ]
  INFO_FROM_RETRY = 10 # From which retry should innodb info be included?
  MAX_RETRIES = 12
  SLEEP_RANGE = 100..500

  # Creates a task, which cannot fail and crash the worker. All exceptions are
  # catched and logged.
  def self.non_failing(description, short_description=nil, &block)
    new(description, short_description) do |worker_name|
      begin
        block.call(worker_name)
      rescue Exception => e
        # Unexpected exceptions - log error, however do not crash the worker.
        LOGGER.error "#{description} failed: #{Exception.to_log_str(e)}",
          worker_name
      end
    end
  end

  attr_reader :description, :short_description

  def initialize(description, short_description=nil, &block)
    @description = description
    @short_description = short_description
    @block = block
  end

  # Runs this task passing it worker name.
  def run(worker_name)
    Parts::WithLocking.sql_comment = @short_description || @description
    @block.call(worker_name)
  ensure
    Parts::WithLocking.sql_comment = nil
  end

  def to_s
    "<#{self.class.to_s} #{@description}>"
  end

  def self.retrying_transaction(worker_name, log_object)
    current_retry = 0
    begin
      DispatcherEventHandler::Buffer.instance.wrap do
        ActiveRecord::Base.transaction(joinable: false) do
          if current_retry >= INFO_FROM_RETRY
            begin
              old_value = Parts::WithLocking.track_locks?
              Parts::WithLocking.track_locks = true
              yield
            ensure
              Parts::WithLocking.track_locks = old_value
            end
          else
            yield
          end
        end
      end
    rescue ActiveRecord::StatementInvalid, ActiveRecord::JDBCError,
        Java::java.sql.SQLException => e
      if DEADLOCK_ERRORS.any? { |err| e.message.include?(err) }
        if current_retry >= INFO_FROM_RETRY
          innodb_info = ActiveRecord::Base.connection.
            select_one("SHOW ENGINE INNODB STATUS")["Status"]
          status_line = "\n\nInnoDB status:\n#{innodb_info}\n\nServer locks:\n#{
            Parts::WithLocking::LOCK_LIST.generate}"
          Parts::WithLocking::LOCK_LIST.clear
          log_method = :warn
        else
          status_line = ""
          log_method = :info
        end

        if current_retry < MAX_RETRIES
          current_retry += 1

          sleep_for = (
            (SLEEP_RANGE.first * current_retry)..
            (SLEEP_RANGE.last * current_retry)
          ).random_element / 1000.0
          LOGGER.send(
            log_method,
            %Q{Deadlock occurred for #{log_object}, retry #{current_retry
            }, retrying again in #{sleep_for}s: #{e.message}#{status_line}},
            worker_name
          )
          sleep sleep_for
          retry
        else
          raise e.class,
            "Deadlock unresolvable after #{MAX_RETRIES} retries for #{log_object
              }: #{e.message}#{status_line}"
        end
      else
        raise e
      end
    end
  end
end