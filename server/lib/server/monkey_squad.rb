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

  class ConnectionAdapters::ConnectionPool
    def checkout_with_id
      connection = checkout
      connection_id = current_connection_id
      raise "Connection ID #{connection_id} is already checked out!" \
        if @reserved_connections.has_key?(connection_id)
      @reserved_connections[connection_id] = connection

      [connection, connection_id]
    end

    def current_connection_id
      ActiveRecord::Base.connection_id = Celluloid.actor? \
        ? Celluloid.current_actor.object_id \
        : Thread.current.object_id
    end

    # Ensures that new connection is checked out for the block. See GOTCHAS.md
    def with_new_connection
      connection = checkout
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