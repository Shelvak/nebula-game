# Monkey-patches for YAML.
module YAML
  class << self
    alias_method :dump_wo_encoding, :dump

    # Force dumped data into UTF-8 encoding.
    def dump(*args)
      dump_wo_encoding(*args).force_encoding(Encoding::UTF_8)
    end
  end
end

# Monkey-patches for ActiveRecord.
module ActiveRecord
  WC_CHECKING_OUT =
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
      name = Celluloid.actor? ? Celluloid::Actor.name : "main"

      synchronize do
        @wc_connections ||= {}
        @wc_connections[name] ||= 0
        @wc_connections[name] += 1
      end

      Thread.current[ActiveRecord::WC_CHECKING_OUT] = true
      unsafe_with_connection do
        # The connection has been checked out.
        Thread.current[ActiveRecord::WC_CHECKING_OUT] = false
        block.call
      end

      synchronize do
        @wc_connections[name] -= 1
      end
    rescue ActiveRecord::ConnectionTimeoutError => e
      synchronize do
        LOGGER.error("Connections: #{@wc_connections.inspect}")
      end
      raise e
    end
  end

  class Base
    class << self
      alias_method :unsafe_connection_id, :connection_id

      # Ensure Fiber safety for connections. Each fiber has its own thread
      # locals and Celluloid uses a lot of fibers...
      def connection_id
        id = unsafe_connection_id
        # Raise error if not checking connection out with #with_connection
        raise "Connection not checked out!" \
          unless Thread.current[ActiveRecord::WC_CHECKING_OUT] || ! id.nil? ||
            rake?
        id
      end
    end
  end
end

def raise_to_abort(*args)
  yield *args
rescue Exception => e
  abort e
end