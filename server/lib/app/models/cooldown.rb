class Cooldown < ActiveRecord::Base
  include Parts::InLocation

  composed_of :location, :class_name => 'LocationPoint',
    :mapping => LocationPoint.attributes_mapping_for(:location),
    :converter => LocationPoint::CONVERTER

  # Create Cooldown identified by given _location_. If such record
  # already exists, update its _expires_at_.
  def self.create_or_update!(location, expires_at)
    model = in_location(location.location_attrs).first

    if model
      CallbackManager.update(model, CallbackManager::EVENT_DESTROY,
        expires_at)
    else
      model = new(:location => location)
      model.save!
      CallbackManager.register(model, CallbackManager::EVENT_DESTROY,
        expires_at)
    end

    model
  end

  def self.on_callback(id, event)
    case event
    when CallbackManager::EVENT_DESTROY
      model = find(id)
      model.destroy
      Combat.check_location(model.location)
    else
      raise ArgumentError.new("Unknown event: #{
        CallbackManager::STRING_NAMES[event]} (#{event})"
      )
    end
  end
end