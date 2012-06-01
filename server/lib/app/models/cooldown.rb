class Cooldown < ActiveRecord::Base
  DScope = Dispatcher::Scope
  include Parts::WithLocking

  include Parts::InLocation
  include Parts::ByFowEntries
  include Parts::Object
  def self.notify_on_create?; true; end
  def self.notify_on_update?; true; end
  def self.notify_on_destroy?; false; end
  include Parts::Notifier

  composed_of :location, LocationPoint.composed_of_options(
    :location,
    LocationPoint::COMPOSED_OF_GALAXY,
    LocationPoint::COMPOSED_OF_SOLAR_SYSTEM,
    LocationPoint::COMPOSED_OF_SS_OBJECT
  )

  def as_json(options=nil)
    {
      'location' => location.as_json,
      'ends_at' => ends_at.as_json
    }
  end

  # Return Cooldown#ends_at for planet.
  def self.for_planet(planet)
    time = without_locking do
      select("ends_at").where(planet.location_attrs).c_select_value
    end
    # JRuby compatibility fix.
    time.is_a?(String) ? Time.parse(time) : time
  end

  # Create Cooldown identified by given _location_. If such record
  # already exists, update its _ends_at_.
  def self.create_or_update!(location, ends_at)
    model = new(:location => location, :ends_at => ends_at)
    begin
      model.save!
    rescue ActiveRecord::RecordNotUnique
      # Being multithreaded we cannot first ask and then do something.
      model = in_location(location).first
      model.ends_at = ends_at if ends_at > model.ends_at
      model.save!
    end

    CallbackManager.register_or_update(
      model, CallbackManager::EVENT_DESTROY, model.ends_at
    )

    model
  end

  DESTROY_SCOPE = DScope.world
  def self.destroy_callback(cooldown)
    cooldown.destroy!
    Combat::LocationChecker.check_location(cooldown.location)
  end
end