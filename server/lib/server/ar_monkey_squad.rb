# Monkey-patches for active-record.
module ActiveRecord
  FIBER_SAFETY_KEY =
    "ActiveRecord::ConnectionAdapters::ConnectionPool.with_connection"

  # We don't need our #destroy, #save and #save! automatically wrapped under
  # transaction because we wrap whole request in one and can't use nested
  # transactions due to BulkSql.
  module Transactions
    def destroy; super; end
    def save(*); super; end
    def save!(*); super; end
  end

  # Fiber safety patches.

  class ConnectionAdapters::ConnectionPool
    alias_method :unsafe_with_connection, :with_connection

    def with_connection(&block)
      Thread.current[ActiveRecord::FIBER_SAFETY_KEY] = true
      unsafe_with_connection(&block)
    ensure
      Thread.current[ActiveRecord::FIBER_SAFETY_KEY] = false
    end
  end

  class Base
    class << self
      alias_method :unsafe_connection_id, :connection_id

      # Ensure Fiber safety for connections. Each fiber has its own thread locals
      # and Celluloid uses a lot of fibers...
      def connection_id
        id = unsafe_connection_id
        # Raise error if not checking connection out with #with_connection
        raise "Connection not checked out!" \
          if ! Thread.current[ActiveRecord::FIBER_SAFETY_KEY] && id.nil?
        id
      end
    end
  end
end