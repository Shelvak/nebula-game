module Parts::WithLocking
  def self.locking=(value)
    Thread.current[:with_locking] = value
  end
  def self.locking?
    value = Thread.current[:with_locking]
    value.nil? ? true : value
  end

  def self.comment=(value)
    Thread.current[:comment] = value
  end

  def self.included(receiver)
    # Only lock records if we are in transaction.
    receiver.instance_eval do
      default_scope do
        if Parts::WithLocking.locking? && connection.open_transactions > 0
          thread_name = Logging::Logger.thread_name
          comment = "#{thread_name}: #{Thread.current[:sql_comment] || "nil"}"

          add_lock
          lock(true).where("?!=''", comment)
        end
      end
    end
  end
end