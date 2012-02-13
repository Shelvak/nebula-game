class BuildingsController < GenericController
  # Show units garrisoned in building.
  #
  # Invocation: by client
  #
  # Parameters:
  # - id (Fixnum) - building id which we want to view.
  #
  # Response:
  # - units(Unit[]) - units inside that building.
  #
  ACTION_SHOW_GARRISON = 'buildings|show_garrison'

  def self.show_garrison_options; logged_in + required(:id => Fixnum); end
  def self.show_garrison_scope(m); scope.npc_building(m.params['id']); end
  def self.show_garrison_action(m)
    building = Building.find(m.params['id'])
    planet = building.planet
    raise GameLogicError.new("You cannot view NPC units in planet #{planet}!") \
      if planet.player_id != m.player.id

    units = building.units
    respond m, :units => units.map(&:as_json)
  end

  ACTION_NEW = 'buildings|new'
  # Start construction of new building in a planet that player owns.
  #
  # Parameters:
  # - constructor_id (Fixnum): building id that constructs this building
  # - x (Fixnum)
  # - y (Fixnum)
  # - type (String): string of building type, e.g. SolarPlant
  # - prepaid (Boolean): are these units paid for?
  #
  # Response: None
  #
  def action_new
    param_options :required => {
      :constructor_id => Fixnum, :x => Fixnum, :y => Fixnum,
      :type => String, :prepaid => Boolean
    }

    raise GameLogicError.new(
      "Cannot build new building without resources unless VIP!"
    ) unless params['prepaid'] || player.vip?

    constructor = Building.find(params['constructor_id'],
      :include => :planet)
    check_for_constructor!(constructor)
    raise ActiveRecord::RecordNotFound \
      if constructor.planet.player_id != player.id

    constructor.construct!(
      "Building::#{params['type']}", params['prepaid'],
      :x => params['x'], :y => params['y']
    )
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
      raise GameLogicError.new("#{building} is not overdriveable!")
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
      raise GameLogicError.new("#{building} is not overdriveable!")
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
    param_options :required => {:id => Fixnum, :with_creds => Boolean}

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
    check_for_constructor!(building)
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
    check_for_constructor!(constructor)
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

  # Sets constructor building in second flank.
  #
  # Invocation: by client
  #
  # Parameters:
  # - id (Fixnum): ID of the constructor.
  # - enabled (Boolean):
  #
  def action_set_build_in_2nd_flank
    param_options :required => {:id => Fixnum, :enabled => Boolean}

    building = find_building
    check_for_constructor!(building)
    building.build_in_2nd_flank = params['enabled']
    building.save!
  end

  # Sets constructor building hidden units.
  #
  # Invocation: by client
  #
  # Parameters:
  # - id (Fixnum): ID of the constructor.
  # - enabled (Boolean):
  #
  def action_set_build_hidden
    param_options :required => {:id => Fixnum, :enabled => Boolean}

    building = find_building
    check_for_constructor!(building)
    building.build_hidden = params['enabled']
    building.save!
  end

  # Starts repairs of the building.
  #
  # Invocation: by client
  #
  # Parameters:
  # - id (Fixnum): ID of the repaired building.
  #
  # Response: None
  def action_repair
    building = find_building
    building.repair!
  end

  # Transports resources via +Building::ResourceTransporter+ from source planet
  # (where building is standing) to a target planet. Target must be owned by
  # same player.
  #
  # Invocation: by client
  #
  # Parameters:
  # - id (Fixnum): ID of the resource transporter
  # - target_planet_id (Fixnum): ID of the target planet
  # - metal (Fixnum): amount of metal transported
  # - energy (Fixnum): amount of energy transported
  # - zetium (Fixnum): amount of zetium transported
  #
  # Response:
  #   If successful: None
  #   If something failed:
  #     - error (String): one of the
  #       "no_transporter" - if target planet didn't have active transporter
  #
  def action_transport_resources
    param_options :required => {:id => Fixnum, :target_planet_id => Fixnum,
      :metal => Fixnum, :energy => Fixnum, :zetium => Fixnum}

    building = find_building

    if building.is_a?(Building::ResourceTransporter)
      target = SsObject::Planet.find(params['target_planet_id'])
      building.transport!(
        target, params['metal'], params['energy'], params['zetium']
      )
    else
      raise GameLogicError.new("#{building} is not a resource transporter!")
    end
  rescue Building::ResourceTransporter::NoTransporterError
    respond :error => "no_transporter"
  end
  
  private
  def find_building
    param_options :required => {:id => Fixnum}

    building = Building.find(params['id'], :include => :planet)
    raise ActiveRecord::RecordNotFound \
      unless building.planet.player_id == player.id

    building
  end

  def check_for_constructor!(building)
    raise GameLogicError.new("#{building} is not an constructor!") \
      unless building.constructor?
  end
end