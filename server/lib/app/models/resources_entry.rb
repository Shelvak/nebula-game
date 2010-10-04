class ResourcesEntry < ActiveRecord::Base
  set_primary_key :planet_id

  belongs_to :planet

  def to_s
    "<ResourcesEntry planet_id: #{planet_id},\n" +
      "  metal: #{metal}/#{metal_storage}, rate: #{metal_rate}\n" +
      "  energy: #{energy}/#{energy_storage}, rate: #{energy_rate}\n" +
      "  zetium: #{zetium}/#{zetium_storage}, rate: #{zetium_rate}\n" +
      ">"
  end

  def as_json(options=nil)
    attributes.except('id')
  end

  after_find :recalculate_if_unsynced!
  def recalculate_if_unsynced!
    if last_update and last_update.to_i < Time.now.to_i
      recalculate!
    end
  end

  # #metal=(value)
  # #energy=(value)
  # #zetium=(value)
  #
  # Don't allow setting more than storage and less than 0.
  #
  %w{metal energy zetium}.each do |resource|
    define_method("#{resource}=") do |value|
      name = "#{resource}_storage"
      storage = (send(name) * resource_modifier(name))

      if value > storage
        value = storage
      elsif value < 0
        value = 0
      end

      write_attribute(resource, value)
    end
  end

  # Increase resource rates and storages.
  def increase(options)
    options.symbolize_keys!

    [:metal, :energy, :zetium].each do |resource|
      [:storage, :rate].each do |type|
        name = "#{resource}_#{type}".to_sym
        send("#{name}=", send(name) + (options[name] || 0))
      end
    end
  end

  # #increase and #save!
  def increase!(options)
    increase(options)
    save!
  end

  # Ensures that energy rate in the planet is >= 0.
  def ensure_positive_energy_rate!
    changes = Reducer::EnergyUsersReducer.reduce(
      # Reject buildings which do not use energy
      Building.scoped_by_planet_id(planet_id).all.reject do |building|
        # Checking for inactive? because constructors does not use energy
        # for their operation.
        building.energy_usage_rate <= 0 or building.inactive?
      end,
      - energy_rate
    )

    reload

    changes
  end

  protected
  before_save :register_callbacks
  # Register callbacks if energy is diminishing.
  def register_callbacks
    if energy_rate < 0
      method = energy_diminish_registered? ? :update : :register

      CallbackManager.send(method,
        self,
        CallbackManager::EVENT_ENERGY_DIMINISHED,
        last_update + (energy / energy_rate).abs.ceil
      )

      self.energy_diminish_registered = true
    elsif energy_rate >= 0 and energy_diminish_registered?
      CallbackManager.unregister(self,
        CallbackManager::EVENT_ENERGY_DIMINISHED)
      
      self.energy_diminish_registered = false
    end

    true
  end

  def resource_modifier_technologies
    player_id = planet.player_id
    player_id ? Technology.find(:all, :conditions => [
      "type IN (?) AND player_id=? AND level > 0",
      self.class.modifiers,
      player_id
    ]) : []
  end

  # Get resource modifier for given _resource_.
  def resource_modifier(resource)
    (1 + resource_modifiers[resource.to_sym].to_f / 100)
  end

  # Get resource modifiers from technologies and cache them.
  def resource_modifiers(refresh=false)
    if not @resource_modifiers or refresh
      @resource_modifiers = {
        :metal => 0,
        :metal_storage => 0,
        :energy => 0,
        :energy_storage => 0,
        :zetium => 0,
        :zetium_storage => 0,
      }

      resource_modifier_technologies.each do |technology|
        technology.resource_modifiers.each do |type, modifier|
          @resource_modifiers[type] += modifier
        end
      end
    end

    @resource_modifiers
  end

  # Calculate new values.
  def recalculate
    now = Time.now
    time_diff = (now - last_update).to_i
    self.last_update = now
    [:metal, :energy, :zetium].each do |resource|
      value = send(resource)
      rate = send("#{resource}_rate")

      send(
        "#{resource}=",
        value + rate * time_diff * resource_modifier(resource)
      )
    end
  end

  # #recalculate and #save!
  def recalculate!
    recalculate
    save!
  end

  class << self
    def modifiers
      @modifiers ||= Set.new
    end

    def add_modifier(mod)
      modifiers.add mod
    end

    # Called back by CallbackManager when we run out of energy.
    #
    # It runs algorithm which disables energy using buildings in planet.
    #
    def on_callback(id, event)
      if event == CallbackManager::EVENT_ENERGY_DIMINISHED
        model = find(id)
        changes = model.ensure_positive_energy_rate!
        Notification.create_for_buildings_deactivated(
          model.planet, changes
        ) unless changes.blank?
        EventBroker.fire(model, EventBroker::CHANGED)
      else
        super
      end
    end

    # Increase rates and storages for _planet_id_.
    def increase(planet_id, options)
      model = find(planet_id)
      model.increase!(options)
      EventBroker.fire(model, EventBroker::CHANGED)
    end

    # Increases resources in the planet and fires EventBroker::CHANGED.
    def change_resources(planet_id, metal, energy, zetium)
      model = find(planet_id)
      model.metal += metal
      model.energy += energy
      model.zetium += zetium
      model.save!

      EventBroker.fire(model, EventBroker::CHANGED)
    end
  end
end