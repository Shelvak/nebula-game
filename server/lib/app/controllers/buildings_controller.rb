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
  # Response: None
  #
  def action_new
    param_options :required => %w{constructor_id x y type}

    constructor = Building.find(params['constructor_id'],
      :include => :planet)
    raise ActiveRecord::RecordNotFound \
      if constructor.planet.player_id != player.id

    constructor.construct!("Building::#{params['type']}",
      :x => params['x'], :y => params['y'])
  end

  # Upgrade a building in planet.
  #
  # Params:
  #   id
  #
  # Return:
  #   building
  #
  def action_upgrade
    building = find_building

    building.upgrade!
    respond :building => building
  end

  # Activate a building in planet.
  #
  # Params:
  #   id
  #
  # Return:
  #   nothing - updated building will be pushed via buildings|updated
  #
  def action_activate
    building = find_building
    building.activate!
  end
  
  # Deactivate a building in planet.
  #
  # Params:
  #   id
  #
  # Return:
  #   nothing - updated building will be pushed via buildings|updated
  #
  def action_deactivate
    building = find_building
    building.deactivate!
  end

  # Initiates self-destruct on +Building+ in +SsObject::Planet+.
  #
  # You must check planets #can_destroy_building_at attribute (see how in
  # SsObject::Planet#can_destroy_building?) to make sure you are allowed to
  # initiate self-destruct.
  #
  # Invocation: by client
  #
  # Parameters:
  # - id (Fixnum): Building id.
  #
  # Response: None
  #
  # Pushes:
  # - objects|destroyed with +Building+
  # - objects|updated with +SsObject::Planet+.
  #
  def action_self_destruct
    building = find_building
    building.self_destruct!
  end

  private
  def find_building
    param_options :required => %w{id}

    building = Building.find(params['id'], :include => :planet)
    raise ActiveRecord::RecordNotFound \
      unless building.planet.player_id == player.id

    building
  end
end