class BuildingsController < GenericController
  ACTION_NEW = 'buildings|new'
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

  ACTION_UPGRADE = 'buildings|upgrade'
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
    respond :building => building.as_json
  end

  ACTION_ACTIVATE = 'buildings|activate'
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

  ACTION_DEACTIVATE = 'buildings|deactivate'
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

  ACTION_SELF_DESTRUCT = 'buildings|self_destruct'
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
  # - with_creds (Boolean): Should we use creds or normal rules?
  #
  # Response: None
  #
  # Pushes:
  # - objects|destroyed with +Building+
  # - objects|updated with +SsObject::Planet+.
  #
  def action_self_destruct
    param_options :required => %w{id with_creds}

    building = find_building
    building.self_destruct!(params['with_creds'])
  end

  # Accelerates whatever constructor is constructing.
  #
  # Parameters:
  # - id (Fixnum): ID of the constructor.
  # - index (Fixnum): Index of CONFIG["creds.upgradable.speed_up"] entry.
  #
  def action_accelerate_constructor
    param_options :required => %w{id index}

    building = find_building
    building.accelerate_construction!(params['index'])
  rescue ArgumentError => e
    # In case client provides invalid index.
    raise GameLogicError.new(e.message)
  end

  # Accelerates building upgrade.
  #
  # Parameters:
  # - id (Fixnum): ID of the building that will be accelerated.
  # - index (Fixnum): Index of CONFIG["creds.upgradable.speed_up"] entry.
  #
  def action_accelerate_upgrade
    param_options :required => %w{id index}

    building = find_building
    building.accelerate!(params['index'])
  rescue ArgumentError => e
    # In case client provides invalid index.
    raise GameLogicError.new(e.message)
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