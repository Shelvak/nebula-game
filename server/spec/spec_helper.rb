# Ensure that libs are loaded only one time per spec-run.
if $SPEC_INITIALIZED.nil?
  ENV['environment'] = 'test'
  require File.join(File.dirname(__FILE__), '..', 'lib', 'initializer.rb')

  DEFAULT_SPEC_CLIENT_ID = -1

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

  ActiveRecord::Base.establish_connection(DB_CONFIG['test'])
  # Truncate test tables
  def cleanup_database
    ActiveRecord::Base.connection.tables.each do |table|
      ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
    end
  end
  cleanup_database

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

  def set_resources(planet, metal, energy, zetium)
    planet.metal = planet.metal_storage = metal
    planet.energy = planet.energy_storage = energy
    planet.zetium = planet.zetium_storage = zetium
    planet.save!
  end

  def have_callback(event, time)
    simple_matcher("be registered in CallbackManager with event #{
        CallbackManager::STRING_NAMES[event]} @ #{time.to_s(:db)}"
    ) do |given|
      CallbackManager.has?(given, event, time)
    end
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