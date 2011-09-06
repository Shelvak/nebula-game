class Cooldown < ActiveRecord::Base
  include Parts::InLocation
  include Parts::ByFowEntries
  include Parts::Object
  def self.notify_on_create?; true; end
  def self.notify_on_update?; false; end
  def self.notify_on_destroy?; false; end
  include Parts::Notifier

  composed_of :location, :class_name => 'LocationPoint',
    :mapping => LocationPoint.attributes_mapping_for(:location),
    :converter => LocationPoint::CONVERTER

  def as_json(options=nil)
    {
      'location' => location.as_json,
      'ends_at' => ends_at.as_json
    }
  end

  # Return Cooldown#ends_at for planet.
  def self.for_planet(planet)
    time = connection.select_value("SELECT `ends_at` FROM `#{
      table_name}` WHERE #{
      sanitize_sql_for_conditions(planet.location_attrs)}")
    # JRuby compatibility fix.
    time.is_a?(String) ? Time.parse(time) : time
  end

  # Create Cooldown identified by given _location_. If such record
  # already exists, update its _ends_at_.
  def self.create_unless_exists(location, ends_at)
    model = in_location(location.location_attrs).first

    unless model
      model = new(:location => location, :ends_at => ends_at)
      model.save!
      CallbackManager.register(model, CallbackManager::EVENT_DESTROY,
        ends_at)
    end

    model
  end

  def self.on_callback(id, event)
    case event
    when CallbackManager::EVENT_DESTROY
      model = find(id)
      model.destroy!
      Combat::LocationChecker.check_location(model.location)
    else
      raise CallbackManager::UnknownEvent.new(self, id, event)
    end
  end
end