module Parts::WithLocking
  def self.locking=(value)
    Thread.current[:with_locking] = value
  end
  def self.locking?
    value = Thread.current[:with_locking]
    value.nil? ? true : value
  end

  def self.included(receiver)
    # Only lock records if we are in transaction.
    receiver.instance_eval do
      default_scope do
        lock(true) if Parts::WithLocking.locking? &&
          connection.open_transactions > 0
      end
    end
  end
end