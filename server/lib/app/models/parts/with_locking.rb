module Parts::WithLocking
  def self.included(receiver)
    # Only lock records if we are in transaction.
    receiver.instance_eval do
      default_scope { lock(true) if connection.open_transactions > 0 }
    end
  end
end