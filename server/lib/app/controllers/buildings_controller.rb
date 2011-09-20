class BuildingsController < GenericController
  ACTION_NEW = 'buildings|new'
  # Start construction of new building in a planet that player owns.
  #
  # Parameters:
  # - constructor_id (Fixnum): building id that constructs this building
  # - x (Fixnum)
  # - y (Fixnum)
  # - type (String): string of building type, e.g. SolarPlant
  #
  # Response: None
  #
  def action_new
    param_options :required => {:constructor_id => Fixnum, :x => Fixnum,
      :y => Fixnum, :type => String}

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
  # - id (Fixnum): ID of the building
  #
  # Return:
  # - building (Hash): Building#as_json
  #
  def action_upgrade
    building = find_building

    building.upgrade!
    respond :building => building.as_json
  end

  ACTION_ACTIVATE = 'buildings|activate'
  # Activate a building in planet.
  #
  # Parameters:
  # - id (Fixnum)
  #
  # Response: None
  #
  def action_activate
    building = find_building
    building.activate!
  end

  ACTION_DEACTIVATE = 'buildings|deactivate'
  # Deactivate a building in planet.
  #
  # Parameters:
  # - id (Fixnum)
  #
  # Response: None
  #
  def action_deactivate
    building = find_building
    building.deactivate!
  end

  # Turn overdrive on for particular building.
  #
  # Parameters:
  # - id (Fixnum)
  #
  # Response: None
  #
  def action_activate_overdrive
    building = find_building
    if building.is_a?(Trait::Overdriveable)
      building.activate_overdrive!
    else
      raise GameLogicError.new("Targeted building is not overdriveable!")
    end
  end

  # Turn overdrive off for particular building.
  #
  # Parameters:
  # - id (Fixnum)
  #
  # Response: None
  #
  def action_deactivate_overdrive
    building = find_building
    if building.is_a?(Trait::Overdriveable)
      building.deactivate_overdrive!
    else
      raise GameLogicError.new("Targeted building is not overdriveable!")
    end
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
  # - objects|updated with +Player+. (if using creds)
  #
  def action_self_destruct
    param_options :required => {:id => Fixnum, :with_creds => [TrueClass, FalseClass]}

    building = find_building
    building.self_destruct!(params['with_creds'])
  end

  # Moves building to another spot in the planet. Requires credits.
  #
  # Invocation: by client
  #
  # Parameters:
  # - id (Fixnum): ID of the building you want to move
  # - x (Fixnum): new X coordinate
  # - y (Fixnum): new Y coordinate
  #
  # Response: None
  #
  # Pushes:
  # - objects|updated with +Building+
  # - objects|updated with +Player+
  #
  def action_move
    param_options :required => {:id => Fixnum, :x => Fixnum, :y => Fixnum}

    building = find_building
    building.move!(params['x'].to_i, params['y'].to_i)
  end

  # Accelerates whatever constructor is constructing.
  #
  # Parameters:
  # - id (Fixnum): ID of the constructor.
  # - index (Fixnum): Index of CONFIG["creds.upgradable.speed_up"] entry.
  # 
  # Response: None
  #
  def action_accelerate_constructor
    param_options :required => {:id => Fixnum, :index => Fixnum}

    building = find_building
    Creds.accelerate_construction!(building, params['index'])
  rescue ArgumentError => e
    # In case client provides invalid index.
    raise GameLogicError.new(e.message)
  end

  # Accelerates building upgrade.
  #
  # Invocation: by client
  # 
  # Parameters:
  # - id (Fixnum): ID of the building that will be accelerated.
  # - index (Fixnum): Index of CONFIG["creds.upgradable.speed_up"] entry.
  #
  def action_accelerate_upgrade
    param_options :required => {:id => Fixnum, :index => Fixnum}

    building = find_building
    Creds.accelerate!(building, params['index'])
  rescue ArgumentError => e
    # In case client provides invalid index.
    raise GameLogicError.new(e.message)
  end

  # Cancels whatever constructor is constructing. Partially returns 
  # resources depending on how much of constructable has been built.
  # 
  # Invocation: by client
  # 
  # Parameters:
  # - id (Fixnum): ID of the constructor.
  # 
  # Response: None
  #
  def action_cancel_constructor
    constructor = find_building
    constructor.cancel_constructable!
  end
    
  # Cancels upgrade of the building. Partially returns 
  # resources depending on how much of the upgrade has been done.
  # 
  # Invocation: by client
  # 
  # Parameters:
  # - id (Fixnum): ID of the building.
  # 
  # Response: None
  #
  def action_cancel_upgrade
    building = find_building
    building.cancel!
  end
  
  private
  def find_building
    param_options :required => {:id => Fixnum}

    building = Building.find(params['id'], :include => :planet)
    raise ActiveRecord::RecordNotFound \
      unless building.planet.player_id == player.id

    building
  end
end