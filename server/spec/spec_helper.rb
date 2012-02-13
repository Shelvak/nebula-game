if $SPEC_INITIALIZED.nil?
  # Stub for running code instead of benchmarking it.
  def benchmark(what); yield; end

  ENV['environment'] = 'test'
  require File.join(File.dirname(__FILE__), '..', 'lib', 'initializer.rb')

  DEFAULT_SPEC_CLIENT_ID = -1
  SPEC_TIME_PRECISION = 5
  SPEC_FLOAT_PRECISION = 0.0001

  require 'rspec'
  require 'pp'

  # Include helpers/shared
  glob = File.expand_path(
    File.join(File.dirname(__FILE__), '{helpers,shared}', '*.rb')
  )
  Dir[glob].each { |file| require file }

  # Truncate test tables
  def cleanup_database
    c = ActiveRecord::Base.connection
    c.execute("SET foreign_key_checks=0")
    c.tables.each do |table|
      c.execute("TRUNCATE `#{table}`")
    end
    c.execute("SET foreign_key_checks=1")
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

  class Object
    # Almost the same as #should_receive but instead actually executes
    # the call.
    #
    # If _return_method_call_value_ is set to true, it returns
    # [method_call_value, block_value] instead of just block_value.
    def should_execute(method_name, args=nil,
        return_method_call_value=false)
      # Save old method
      old_method = method(method_name)

      begin
        # Create new stub method that records the call.
        method_ran = false
        method_call_value = nil
        metaclass = class << self; self; end
        metaclass.instance_eval do
          define_method(method_name) do |*call_args|
            method_ran = args.nil? ? true : args == call_args
            method_call_value = old_method.call(*call_args)
          end
        end

        block_value = yield

        raise "#{self} expected to receive #{method_name} with args #{
          args.inspect}!" unless method_ran

        if return_method_call_value
          [method_call_value, block_value]
        else
          block_value
        end
      ensure
        define_method(method_name, &old_method)
      end
    end
  end

  class ActiveRecord::Base
    def update_row!(updates)
      self.class.update_all updates, ["id=?", id]
      reload
      self
    end
  end

  RSpec.configure do |config|
    def start_transaction
      conn = ActiveRecord::Base.connection
      conn.begin_db_transaction
      conn.increment_open_transactions
    end

    def break_transaction
      conn = ActiveRecord::Base.connection
      unless conn.open_transactions == 0
        conn.decrement_open_transactions
        conn.rollback_db_transaction
      end
    end

    def restore_logging
      Celluloid::Actor[:log_writer].level = Logging::Writer::LEVEL_DEBUG
    end

    config.before(:each) do
      App.server_state = App::SERVER_STATE_INITIALIZING
      start_transaction
    end

    config.after(:each) do
      break_transaction
    end
  end

  ActiveRecord::Base.establish_connection(DB_CONFIG['test'])
  cleanup_database

  # Include factories
  require 'factory_girl'
  FactoryGirl.definition_file_paths = [
    File.expand_path(File.join(File.dirname(__FILE__), 'factories'))
  ]
  FactoryGirl.find_definitions

  # Build and stub out all unnecessary validation methods
  def Factory.build!(*args)
    model = Factory.build(*args)
    model.stub!(:validate_technologies).and_return(true)

    model
  end

  # Create but stub out all unnecessary validation methods
  def Factory.create!(*args)
    model = Factory.build(*args)
    def model.validate_technologies; true; end
    model.save!

    model
  end

  SPEC_EVENT_HANDLER = RSpecEventHandler.new
end


