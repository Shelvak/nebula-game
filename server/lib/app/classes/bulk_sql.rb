class BulkSql
  class Connection
    def initialize
      @connection = ActiveRecord::Base.
        connection. # We can't use savepoints when using this.
        jdbc_connection
    end

    def create_statement
      @connection.create_statement
    end

    def execute(sql)
      #STDERR.puts sql
      create_statement.execute(sql)
    end

    def select_value(sql, key)
      #STDERR.puts sql
      statement = create_statement
      record_set = statement.execute_query(sql)
      record_set.next
      record_set.get_object(key)
    end
  end

  # This marks NULL when using LOAD DATA INFILE.
  NULL = "\\N"

  class << self
    # Saves a lot of objects really fast.
    def save(objects, klass)
      return true if objects.blank?

      raise "You forgot to initialize subclass based mutex for #{self}!" \
        if @mutex.nil?

      @mutex.synchronize do
        LOGGER.block("Running bulk updates for #{self}", :level => :debug) do
          connection = Connection.new

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

              # Mark as saved.
              object.changed_attributes.clear
            end
          end

          # Bulk insert/update.
          LOGGER.block(
            "Running updates for #{update_objects.size} objects",
            :level => :debug
          ) do
            execute_updates(
              connection, update_columns.to_a, update_objects, klass
            )
          end
          LOGGER.block(
            "Running inserts for #{insert_objects.size} objects",
            :level => :debug
          ) do
            execute_inserts(
              connection, insert_columns.to_a, insert_objects, klass
            )
          end

          true
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

    def execute_inserts(connection, columns, objects, klass, table_name=nil)
      return if objects.size == 0

      table_name ||= klass.table_name
      columns_str = create_columns_str(columns)

      builder = Java::java.lang.StringBuilder.new
      objects.each do |object|
        columns.each_with_index do |column, index|
          value = object[column]
          builder.append "\t" unless index == 0
          builder.append encode_value(value)
        end
        builder.append "\n"
      end

      input_stream = Java::org.apache.commons.io.IOUtils.
        to_input_stream(builder)

      # First create a statement off the connection
      statement = connection.create_statement

      # Setup our input stream as the source for the local infile
      statement.set_local_infile_input_stream(input_stream)

      # Execute the load infile
      statement_text = "LOAD DATA LOCAL INFILE 'file.txt' INTO TABLE `#{
        table_name}` (#{columns_str})"
      #STDERR.puts table_name
      #STDERR.puts columns_str
      #STDERR.puts builder.to_s
      statement.execute(statement_text)
    end

    def execute_updates(connection, columns, objects, klass)
      return if objects.size == 0

      primary_key = klass.primary_key
      table_name = klass.table_name
      tmp_table_name = "#{table_name}_bulk"

      # Drop temporary table if it exists
      connection.execute("DROP TEMPORARY TABLE IF EXISTS `#{tmp_table_name}`")

      # Create temporary table from original table definition and changed
      # fields.
      create_table = connection.select_value(
        "SHOW CREATE TABLE `#{table_name}`", "Create Table"
      )

      create_tmp_table = "CREATE TEMPORARY TABLE `#{tmp_table_name}` (\n"
      columns.each do |column|
        match = create_table.match(/^(\s+`#{column}`.*)$/)
        create_tmp_table += match[1] + "\n"
      end
      last_line = create_table.match(/^\)(.*)$/)[1]
      create_tmp_table += "PRIMARY KEY (`#{primary_key}`)\n)#{last_line}"

      connection.execute(create_tmp_table)

      # Use bulk insert to add data to temporary table
      execute_inserts(columns, objects, klass, tmp_table_name)

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
  end
end