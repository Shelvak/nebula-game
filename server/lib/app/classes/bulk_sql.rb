# Reference SpaceMule to get our Java support loaded
SpaceMule

class BulkSql
  # This marks NULL when using LOAD DATA INFILE.
  NULL = "\\N"

  class << self
    # Saves a lot of objects really fast.
    # WARNING: not thread safe!
    def save(objects, klass)
      return true if objects.blank?

      LOGGER.block("Running bulk updates for #{self}", :level => :debug) do
        # Get a lock on a table to ensure no one else is writing to it.
        connection.execute("LOCK TABLES `#{klass.table_name}` WRITE")
        begin
          primary_key = klass.primary_key.to_sym
          last_pk = klass.maximum(primary_key) || 0

          # Create the data holders.
          insert_objects = Java::java.util.LinkedList.new
          insert_columns = Set.new([primary_key])

          update_objects = Java::java.util.LinkedList.new
          update_columns = Set.new([primary_key])

          # Gather the data.
          objects.each do |object|
            pk = object[primary_key]

            changes = object.changed
            unless changes.blank?
              if pk.nil?
                # Simulate record save.
                last_pk += 1
                object[primary_key] = last_pk
                object.instance_variable_set(:"@new_record", false)

                changes.each { |column| insert_columns.add(column.to_sym) }
                insert_objects.push object
              else
                changes.each { |column| update_columns.add(column.to_sym) }
                update_objects.push object
              end
            end

            # Mark as saved.
            object.changed_attributes.clear
          end

          # Bulk insert/update.
          LOGGER.block(
            "Running updates for #{update_objects.size} objects",
            :level => :debug
          ) { execute_updates(update_columns.to_a, update_objects, klass) }
          LOGGER.block(
            "Running inserts for #{insert_objects.size} objects",
            :level => :debug
          ) { execute_inserts(insert_columns.to_a, insert_objects, klass) }

          true
        ensure
          connection.execute("UNLOCK TABLES")
        end
      end
    end

    protected

    # Class that is being inserted.
    def klass
      raise NotImplementedError
    end

    private

    def encode_value(value)
      case value
      when nil then NULL
      when true then "1"
      when false then "0"
      else value.to_s
      end
    end

    def execute_inserts(columns, objects, klass, table_name=nil, update=false)
      return if objects.size == 0

      table_name ||= klass.table_name
      columns_str = create_columns_str(columns)

      builder = Java::java.lang.StringBuilder.new
      objects.each do |object|
        # Run callbacks to simulate proper save.
        object.run_callbacks(update ? :update : :create) do
          object.run_callbacks(:save) do
            columns.each_with_index do |column, index|
              value = object[column]
              builder.append "\t" unless index == 0
              builder.append encode_value(value)
            end
            builder.append "\n"
          end
        end
      end

      tempfile = Tempfile.new("bulk_sql-ruby")
      begin
        content = builder.to_s
        tempfile.write(content)
        tempfile.flush # Ensure file is fully written.
        File.chmod(0644, tempfile.path) # Ensure mysql daemon can read it.

        # Execute the load infile. Use file version, because stream version
        # silently ignores errors.
        filename = tempfile.path.gsub("\\", "/") # Win32 support.
        sql = "LOAD DATA INFILE '#{filename}' INTO TABLE `#{table_name
          }` (#{columns_str})"
        #STDERR.puts table_name
        #STDERR.puts columns_str
        #STDERR.puts builder.to_s
        connection.execute(sql)
      rescue Exception => e
        raise ArgumentError,
          "#{e.message}\nData was:\n#{columns_str}\n#{content}", e.backtrace
      ensure
        tempfile.close!
      end
    end

    def execute_updates(columns, objects, klass)
      return if objects.size == 0

      primary_key = klass.primary_key
      table_name = klass.table_name
      tmp_table_name = "#{table_name}_bulk"

      # Drop temporary table if it exists
      connection.execute("DROP TEMPORARY TABLE IF EXISTS `#{tmp_table_name}`")

      # Create temporary table from original table definition and changed
      # fields.
      create_table = connection.
        select_one("SHOW CREATE TABLE `#{table_name}`")["Create Table"]

      create_tmp_table = "CREATE TEMPORARY TABLE `#{tmp_table_name}` (\n"
      columns.each do |column|
        match = create_table.match(/^(\s+`#{column}`.*)$/)
        create_tmp_table += match[1] + "\n"
      end
      last_line = create_table.match(/^\)(.*)$/)[1]
      create_tmp_table += "PRIMARY KEY (`#{primary_key}`)\n)#{last_line}"

      connection.execute(create_tmp_table)

      # Use bulk insert to add data to temporary table
      execute_inserts(columns, objects, klass, tmp_table_name, true)

      # Execute mass update from temporary table to the original table.
      # Exclude first column that is always ID.
      set_str = columns[1..-1].
        map { |c| "`dst`.`#{c}`=`src`.`#{c}`" }.join(", ")
      update_sql = %Q{
        UPDATE `#{table_name}` AS dst
        INNER JOIN `#{tmp_table_name}` AS src
        ON dst.`#{primary_key}` = src.`#{primary_key}`
        SET #{set_str}
      }
      connection.execute(update_sql)

      # Drop temporary table.
      connection.execute("DROP TEMPORARY TABLE `#{tmp_table_name}`")
    end

    def create_columns_str(columns)
      columns.map { |c| "`#{c}`" }.join(", ")
    end

    def connection
      ActiveRecord::Base.connection
    end
  end
end