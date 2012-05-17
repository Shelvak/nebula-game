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
end

def raise_to_abort(*args)
  yield *args
rescue Exception => e
  abort e
end