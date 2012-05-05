class BulkSql
  # This marks NULL when using LOAD DATA INFILE.
  NULL = "\\N"

  class << self
    # Saves a lot of objects really fast.
    def save(objects, klass)
      return true if objects.blank?

      LOGGER.block("Running bulk updates for #{self}", :level => :debug) do
        primary_key = klass.primary_key.to_sym

        # Create the data holders.
        insert_objects = Java::java.util.LinkedList.new
        insert_columns = Set.new

        update_objects = Java::java.util.LinkedList.new
        update_columns = Set.new([primary_key])

        # Gather the data.
        objects.each do |object|
          pk = object[primary_key]

          changes = object.changed
          unless changes.blank?
            if pk.nil?
              # Simulate record save.
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
          execute_updates(update_columns.to_a, update_objects, klass)
        end
        LOGGER.block(
          "Running inserts for #{insert_objects.size} objects",
          :level => :debug
        ) do
          execute_inserts(insert_columns.to_a, insert_objects, klass)
        end

        true
      end
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
      columns_str = create_columns_str(columns, update)
      batch_id = Java::spacemule.persistence.DB.batch_id

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
            unless update
              builder.append "\t"
              builder.append batch_id
              object[:batch_id] = batch_id
            end
            builder.append "\n"
          end
        end
      end

      tempfile = Tempfile.new("bulk_sql-ruby-#{table_name}")
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

        unless update
          # Assign primary keys.
          primary_key = klass.primary_key.to_sym
          ids = without_locking do
            klass.select(primary_key).where(:batch_id => batch_id).
              c_select_values
          end

          raise "Wanted to insert #{objects.size} rows, however only #{
            ids.size} rows inserted for #{table_name}!" \
            if objects.size != ids.size

          objects.each_with_index do |object, index|
            object[primary_key] = ids[index]
          end
        end
      rescue Exception => e
        raise e.class,
          "#{e.message}\nData was:\n#{columns_str}\n#{content}", e.backtrace
      ensure
        tempfile.close! unless ENV[
          Java::spacemule.persistence.DB.KeepTmpFilesEnvVar
        ] == "1"
      end
    end

    def execute_updates(columns, objects, klass)
      return if objects.size == 0

      primary_key = klass.primary_key
      table_name = klass.table_name
      # Generate thread-local temporary table.
      tmp_table_name = "#{table_name}_bulk_#{
        Thread.current.object_id.to_s(36)}_#{
        (Time.now.to_f * 1000).to_i.to_s(36)}_#{
        rand(10000).to_s(36)}"

      begin
        # Create temporary table from original table definition and changed
        # fields.
        create_table = connection.
          select_one("SHOW CREATE TABLE `#{table_name}`")["Create Table"]

        # No need to drop it explicitly after, because mysql drops temporary
        # tables when connection is closed anyhow.
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

        # Locking tables needs exact table names.
        dst, src = table_name, tmp_table_name
        set_str = columns[1..-1].
          map { |c| "`#{dst}`.`#{c}`=`#{src}`.`#{c}`" }.join(", ")
        update_sql = %Q{
          UPDATE `#{dst}`
          INNER JOIN `#{src}`
          ON `#{dst}`.`#{primary_key}` = `#{src}`.`#{primary_key}`
          SET #{set_str}
        }
        connection.execute(update_sql)
      end
    end

    def create_columns_str(columns, update)
      (
        columns + (update ? [] : ["batch_id"])
      ).map { |c| "`#{c}`" }.join(", ")
    end

    def connection
      ActiveRecord::Base.connection
    end
  end
end