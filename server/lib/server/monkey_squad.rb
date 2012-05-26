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
  # We don't need our #destroy, #save and #save! automatically wrapped under
  # transaction because we wrap whole request in one and can't use nested
  # transactions due to BulkSql.
  module Transactions
    def destroy; super; end
    def save(*); super; end
    def save!(*); super; end
  end

  class Migration
    def enum_for_classes(dir_name)
      puts "#{ROOT_DIR}/lib/app/models/#{dir_name}/*.rb"
      types = Dir[
        "#{ROOT_DIR}/lib/app/models/#{dir_name}/*.rb"
      ].sort.map do |name|
        "'#{File.basename(name, ".rb").camelcase}'"
      end.join(",")

      "ENUM(#{types})"
    end
  end

  module ConnectionAdapters::DatabaseStatements
    # Don't allow nesting transactions because we use DDL calls extensively and
    # they would fail anyway.
    def transaction_with_no_nesting(*args, &block)
      if open_transactions == 0
        @transaction_opened_by = ActiveRecord::Base.connection_id
        transaction_without_no_nesting(*args, &block)
      else
        raise "Nested transactions are not allowed! Connection ID: #{
          ActiveRecord::Base.connection_id}, transaction already opened by: #{
          @transaction_opened_by}" unless open_transactions == 0
      end
    end

    alias_method_chain :transaction, :no_nesting
  end

  class ConnectionAdapters::ConnectionPool
    def checkout_with_id
      synchronize do
        connection = checkout
        connection_id = Celluloid.actor? \
          ? Celluloid.current_actor.object_id \
          : Thread.current.object_id
        ActiveRecord::Base.connection_id = connection_id
        raise "Connection ID #{connection_id} is already checked out!" \
          if @reserved_connections.has_key?(connection_id)
        @reserved_connections[connection_id] = connection

        [connection, connection_id]
      end
    end

    private :checkout, :with_connection

    def current_connection_id
      ActiveRecord::Base.connection_id || raise("DB connection ID is not set!")
    end

    # Ensures that new connection is checked out for the block. See GOTCHAS.md
    def with_new_connection
      connection, _ = checkout_with_id
      yield
    ensure
      checkin(connection)
    end
  end
end

def raise_to_abort(*args)
  yield *args
rescue Exception => e
  abort e
end