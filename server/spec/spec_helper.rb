# Ensure that libs are loaded only one time per spec-run.
if $SPEC_INITIALIZED.nil?
  ENV['environment'] = 'test'
  require File.join(File.dirname(__FILE__), '..', 'lib', 'initializer.rb')

  DEFAULT_SPEC_CLIENT_ID = -1

  require 'spec'

  # Include helpers/shared
  glob = File.expand_path(
    File.join(File.dirname(__FILE__), '{helpers,shared}', '*.rb')
  )
  Dir[glob].each { |file| require file }

  # Include factories
  require 'factory_girl'

  ActiveRecord::Base.establish_connection(DB_CONFIG['test'])
  # Truncate test tables
  def cleanup_database
    ActiveRecord::Base.connection.tables.each do |table|
      ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
    end
  end
  cleanup_database

  $SPEC_INITIALIZED = true

  def dispatcher_register_client(dispatcher, io)
    dispatcher.register io
    client_id = dispatcher.instance_variable_get("@io_to_client")[io]
    [io, client_id]
  end

  def dispatcher_register_player(dispatcher, io, player)
    io, client_id = dispatcher_register_client(dispatcher, io)
    dispatcher.associate_player(client_id, player)
    [io, client_id]
  end

  def set_resources(resource_entry, metal, energy, zetium)
    resource_entry.metal = resource_entry.metal_storage = metal
    resource_entry.energy = resource_entry.energy_storage = energy
    resource_entry.zetium = resource_entry.zetium_storage = zetium
    resource_entry.save!
  end

  def need_technology(technology, options=nil)
    options ||= {:level => 1}
    simple_matcher(
      "need #{technology.to_s} (#{options.inspect})"
    ) do |klass|
      klass.needed_technologies[technology] == options
    end
  end

  def manage_resources
    simple_matcher("manage resources") do |klass|
      klass.manages_resources?
    end
  end

  def be_included_in(target)
    simple_matcher("included in #{target.inspect}") do |given|
      target.include?(given)
    end
  end

  def be_in_config_range(key)
    be_included_in(CONFIG["#{key}.from"]..CONFIG["#{key}.to"])
  end

  def be_lesser_than(target)
    simple_matcher("lesser than #{target}") do |given|
      given < target
    end
  end

  def be_lesser_or_equal_to(target)
    simple_matcher("lesser or equal to #{target}") do |given|
      given <= target
    end
  end

  def be_greater_than(target)
    simple_matcher("greater than #{target}") do |given|
      given > target
    end
  end

  def be_greater_or_equal_to(target)
    simple_matcher("greater or equal to #{target}") do |given|
      given >= target
    end
  end

  def have_callback(event, time)
    simple_matcher("be registered in CallbackManager with event #{
        CallbackManager::STRING_NAMES[event]} @ #{time.to_s(:db)}"
    ) do |given|
      CallbackManager.has?(given, event, time)
    end
  end

  Spec::Matchers.define :equal_to_hash do |target|
    match do |actual|
      actual == target
    end
    failure_message_for_should do |actual|
      msg = "target and actual hashes should have been equal but these " +
        "differences were found:\n\n"

      target.each do |key, value|
        unless target[key] == actual[key]
          msg += "Key             : #{key.inspect}\n"
          msg += "Should have been: #{target[key].inspect}\n"
          msg += "But was         : #{actual[key].inspect}\n"
          msg += "\n"
        end
      end

      msg
    end
    failure_message_for_should_not do |player|
      "target and actual hashes should have not been equal but they were"
    end
    description do
      "Matches two hashes and displays differences if they are not equal."
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

  # Create but stub out all unnecessary validation methods
  def Factory.create!(*args)
    model = Factory.build(*args)
    model.stub!(:validate_technologies).and_return(true)
    model.save!

    model
  end
end