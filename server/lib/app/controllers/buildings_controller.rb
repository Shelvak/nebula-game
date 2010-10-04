class BuildingsController < GenericController
  # Start construction of new building in a planet that player owns.
  #
  # Parameters:
  # - planet_id
  # - constructor_id - building id that constructs this building
  # - x
  # - y
  # - type - string of building type, e.g. SolarPlant
  #
  # Response:
  # - :construction_queue_entry => queue entry if building was queued.
  #
  ACTION_NEW = 'buildings|new'
  ACTION_UPGRADE = 'buildings|upgrade'
  ACTION_ACTIVATE = 'buildings|activate'
  ACTION_DEACTIVATE = 'buildings|deactivate'

  def invoke(action)
    case action
    when ACTION_NEW
      param_options :required => %w{constructor_id x y type}

      constructor = Building.find(params['constructor_id'],
        :include => :planet)
      raise ActiveRecord::RecordNotFound \
        if constructor.planet.player_id != player.id

      constructor.construct!("Building::#{params['type']}",
        :x => params['x'], :y => params['y'])

      # Flag the message as handled.
      true
    when ACTION_UPGRADE, ACTION_ACTIVATE, ACTION_DEACTIVATE
      param_options :required => %w{id}

      building = Building.find(params['id'], :include => :planet)
      raise ActiveRecord::RecordNotFound \
        unless building.planet.player_id == player.id

      case action
      # Upgrade a building in planet.
      #
      # Params:
      #   id
      #
      # Return:
      #   building
      #
      when ACTION_UPGRADE
        building.upgrade!
        respond :building => building
      # Activate a building in planet.
      #
      # Params:
      #   id
      #
      # Return:
      #   nothing - updated building will be pushed via buildings|updated
      #
      when ACTION_ACTIVATE
        building.activate!
      # Deactivate a building in planet.
      #
      # Params:
      #   id
      #
      # Return:
      #   nothing - updated building will be pushed via buildings|updated
      #
      when ACTION_DEACTIVATE
        building.deactivate!
      end

      # Mark as handled
      true
    end
  end
end