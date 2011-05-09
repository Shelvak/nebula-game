require 'rubygems'
require 'spork'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However, 
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.


  # Ensure that libs are loaded only one time per spec-run.
  if $SPEC_INITIALIZED.nil?
    ENV['environment'] = 'test'
    require File.join(File.dirname(__FILE__), '..', 'lib', 'initializer.rb')

    DEFAULT_SPEC_CLIENT_ID = -1
    SPEC_TIME_PRECISION = 2

    require 'spec'
    require 'pp'

    # Include helpers/shared
    glob = File.expand_path(
      File.join(File.dirname(__FILE__), '{helpers,shared}', '*.rb')
    )
    Dir[glob].each { |file| require file }

    # Include factories
    require 'factory_girl'
    glob = File.expand_path(
      File.join(File.dirname(__FILE__), 'factories', '*.rb')
    )
    Dir[glob].each { |file| require file }

    # Truncate test tables
    def cleanup_database
      ActiveRecord::Base.connection.tables.each do |table|
        ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
      end
    end

    $SPEC_INITIALIZED = true

    # Override Time so the god damn miliseconds don't get compared.
    class Time
      def ==(other)
        other.is_a?(self.class) &&
          year == other.year && month == other.month && day == other.day &&
          hour == other.hour && min == other.min && sec == other.sec
      end
    end

    def dispatcher_register_client(dispatcher, io)
      dispatcher.register io
      client_id = dispatcher.instance_variable_get("@io_to_client_id")[io]
      [io, client_id]
    end

    def dispatcher_register_player(dispatcher, io, player)
      io, client_id = dispatcher_register_client(dispatcher, io)
      dispatcher.change_player(client_id, player)
      [io, player.id]
    end

    def set_resources(planet, metal, energy, zetium,
        metal_storage=nil, energy_storage=nil, zetium_storage=nil)
      planet.metal_storage = metal_storage || metal
      planet.metal = metal
      planet.energy_storage = energy_storage || energy
      planet.energy = energy
      planet.zetium_storage = zetium_storage || zetium
      planet.zetium = zetium
      planet.save!
    end

    def with_config_values(values={})
      old_values = {}
      values.each do |key, value|
        old_values[key] = CONFIG[key]
        CONFIG[key] = value
      end

      yield

      old_values.each do |key, value|
        CONFIG[key] = value
      end
    end

    def stacktrace!
      raise "error"
    rescue Exception => e
      puts e.backtrace
    end

    # Build and stub out all unnecessary validation methods
    def Factory.build!(*args)
      model = Factory.build(*args)
      model.stub!(:validate_technologies).and_return(true)

      model
    end

    # Create but stub out all unnecessary validation methods
    def Factory.create!(*args)
      model = Factory.build(*args)
      model.stub!(:validate_technologies).and_return(true)
      model.save!

      model
    end
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
  ActiveRecord::Base.establish_connection(DB_CONFIG['test'])
  cleanup_database
  reload!

  SPEC_EVENT_HANDLER = SpecEventHandler.new
end

# --- Instructions ---
# - Sort through your spec_helper file. Place as much environment loading 
#   code that you don't normally modify during development in the 
#   Spork.prefork block.
# - Place the rest under Spork.each_run block
# - Any code that is left outside of the blocks will be ran during preforking
#   and during each_run!
# - These instructions should self-destruct in 10 seconds.  If they don't,
#   feel free to delete them.
#