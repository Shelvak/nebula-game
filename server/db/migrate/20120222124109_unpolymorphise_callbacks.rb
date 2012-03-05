class UnpolymorphiseCallbacks < ActiveRecord::Migration
  def self.up
    cache = {}

    # Ensure we have no missing entries.
    callbacks = connection.select_all("SELECT class, object_id FROM callbacks")
    size = callbacks.size
    callbacks.each_with_index do |row, index|
      name = "#{row['class']}(#{row['object_id']})"
      print "\rCallback: %10d/%-10d %40s " % [index + 1, size, name]

      klass = cache[row['class']] ||= row['class'].constantize
      unless klass.where(:id => row['object_id']).exists?
        puts "\nRemoving callback: #{name}"
        connection.execute("DELETE FROM callbacks WHERE class='#{row['class']
          }' AND object_id=#{row['object_id']}")
      end
    end
    puts

    CallbackManager::CLASS_TO_COLUMN.each do |klass, column|
      src_table = klass.to_s.underscore.pluralize

      add_column :callbacks, column, :integer
      add_index :callbacks, [column, :event], :unique => true,
        :name => "#{column}_uniq"
      add_fk src_table, :callbacks
    end

    CallbackManager::CLASS_TO_COLUMN.each do |klass, column|
      name = klass.to_s
      puts "Updating #{name} -> #{column}"

      connection.execute(
        "UPDATE callbacks SET #{column}=object_id WHERE class LIKE '#{name}%'"
      )
    end

    remove_index :callbacks, :name => :main
    remove_column :callbacks, :class
    remove_column :callbacks, :object_id
  end

  def self.down
    raise IrreversibleMigration
  end
end