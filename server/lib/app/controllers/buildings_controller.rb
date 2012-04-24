class BuildingsController < GenericController
  # Needs to be defined in top of class, otherwise is not found when setting
  # constants.
  class << self
    private
    def find_building_options; required(:id => Fixnum); end

    def find_building(m)
      building = Building.find(m.params['id'], :include => :planet)
      raise ActiveRecord::RecordNotFound \
        unless building.planet.player_id == m.player.id

      building
    end

    def check_for_constructor!(building)
      raise GameLogicError.new("#{building} is not an constructor!") \
        unless building.constructor?
    end
  end

  # Show grouped unit counts for units garrisoned in that building.
  #
  # Invocation: by client
  #
  # Parameters:
  # - id (Fixnum) - building id which we want to view.
  #
  # Response:
  # - groups(Building#unit_groups) - units inside that building.
  #
  ACTION_SHOW_GARRISON_GROUPS = 'buildings|show_garrison_groups'

  SHOW_GARRISON_GROUPS_OPTIONS = logged_in + find_building_options
  SHOW_GARRISON_GROUPS_SCOPE = scope.world
  def self.show_garrison_groups_action(m)
    without_locking do
      building = find_building(m)
      units = building.unit_groups
      respond m, :groups => units
    end
  end

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

  SHOW_GARRISON_OPTIONS = logged_in + find_building_options
  SHOW_GARRISON_SCOPE = scope.world
  def self.show_garrison_action(m)
    without_locking do
      building = find_building(m)
      units = building.units
      respond m, :units => units.map(&:as_json)
    end
  end

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
  ACTION_NEW = 'buildings|new'

  NEW_OPTIONS = logged_in + required(
    :constructor_id => Fixnum, :x => Fixnum, :y => Fixnum, :type => String,
    :prepaid => Boolean
  )
  NEW_SCOPE = scope.world
  def self.new_action(m)
    raise GameLogicError.new(
      "Cannot build new building without resources unless VIP!"
    ) unless m.params['prepaid'] || m.player.vip?

    constructor = Building.find(
      m.params['constructor_id'], :include => :planet
    )
    check_for_constructor!(constructor)
    raise ActiveRecord::RecordNotFound \
      if constructor.planet.player_id != m.player.id

    constructor.construct!(
      "Building::#{m.params['type']}", m.params['prepaid'],
      :x => m.params['x'], :y => m.params['y']
    )
  end

  # Upgrade a building in planet.
  #
  # Params:
  # - id (Fixnum): ID of the building
  #
  # Return:
  # - building (Hash): Building#as_json
  #
  ACTION_UPGRADE = 'buildings|upgrade'

  UPGRADE_OPTIONS = logged_in + find_building_options
  UPGRADE_SCOPE = scope.world
  def self.upgrade_action(m)
    building = find_building(m)

    building.upgrade!
    respond m, :building => building.as_json
  end

  # Activate a building in planet.
  #
  # Parameters:
  # - id (Fixnum)
  #
  # Response: None
  #
  ACTION_ACTIVATE = 'buildings|activate'

  ACTIVATE_OPTIONS = logged_in + find_building_options
  ACTIVATE_SCOPE = scope.world
  def self.activate_action(m)
    building = find_building(m)
    building.activate!
  end

  # Deactivate a building in planet.
  #
  # Parameters:
  # - id (Fixnum)
  #
  # Response: None
  #
  ACTION_DEACTIVATE = 'buildings|deactivate'

  DEACTIVATE_OPTIONS = logged_in + find_building_options
  DEACTIVATE_SCOPE = scope.world
  def self.deactivate_action(m)
    building = find_building(m)
    building.deactivate!
  end

  # Turn overdrive on for particular building.
  #
  # Parameters:
  # - id (Fixnum)
  #
  # Response: None
  #
  ACTION_ACTIVATE_OVERDRIVE = 'buildings|activate_overdrive'

  ACTIVATE_OVERDRIVE_OPTIONS = logged_in + find_building_options
  ACTIVATE_OVERDRIVE_SCOPE = scope.world
  def self.activate_overdrive_action(m)
    building = find_building(m)
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
  ACTION_DEACTIVATE_OVERDRIVE = 'buildings|deactivate_overdrive'

  DEACTIVATE_OVERDRIVE_OPTIONS = logged_in + find_building_options
  DEACTIVATE_OVERDRIVE_SCOPE = scope.world
  def self.deactivate_overdrive_action(m)
    building = find_building(m)
    if building.is_a?(Trait::Overdriveable)
      building.deactivate_overdrive!
    else
      raise GameLogicError.new("#{building} is not overdriveable!")
    end
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
  # - with_creds (Boolean): Should we use creds or normal rules?
  #
  # Response: None
  #
  # Pushes:
  # - objects|destroyed with +Building+
  # - objects|updated with +SsObject::Planet+.
  # - objects|updated with +Player+. (if using creds)
  #
  ACTION_SELF_DESTRUCT = 'buildings|self_destruct'

  SELF_DESTRUCT_OPTIONS = logged_in + find_building_options +
    required(:id => Fixnum, :with_creds => Boolean)
  SELF_DESTRUCT_SCOPE = scope.world
  def self.self_destruct_action(m)
    building = find_building(m)
    building.self_destruct!(m.params['with_creds'])
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
  ACTION_MOVE = 'buildings|move'

  MOVE_OPTIONS = logged_in + find_building_options +
      required(:id => Fixnum, :x => Fixnum, :y => Fixnum)
  MOVE_SCOPE = scope.world
  def self.move_action(m)
    building = find_building(m)
    building.move!(m.params['x'].to_i, m.params['y'].to_i)
  end

  # Accelerates whatever constructor is constructing.
  #
  # Parameters:
  # - id (Fixnum): ID of the constructor.
  # - index (Fixnum): Index of CONFIG["creds.upgradable.speed_up"] entry.
  # 
  # Response: None
  #
  ACTION_ACCELERATE_CONSTRUCTOR = 'buildings|accelerate_constructor'

  ACCELERATE_CONSTRUCTOR_OPTIONS = logged_in + find_building_options +
    required(:id => Fixnum, :index => Fixnum)
  ACCELERATE_CONSTRUCTOR_SCOPE = scope.world
  def self.accelerate_constructor_action(m)
    building = find_building(m)
    check_for_constructor!(building)
    begin
      Creds.accelerate_construction!(building, m.params['index'])
    rescue ArgumentError => e
      # In case client provides invalid index.
      raise GameLogicError, e.message, e.backtrace
    end
  end

  # Constructs all units which constructor is currently building or has in
  # queue. Does not work with buildings.
  #
  # Parameters:
  # - id (Fixnum): ID of the constructor
  # - index (Fixnum): Index of CONFIG["creds.upgradable.speed_up"] entry.
  #
  # Response: None
  #
  ACTION_CONSTRUCT_ALL = 'buildings|construct_all'

  CONSTRUCT_ALL_OPTIONS = logged_in + find_building_options +
    required(:id => Fixnum, :index => Fixnum)
  CONSTRUCT_ALL_SCOPE = scope.world
  def self.construct_all_action(m)
    building = find_building(m)
    check_for_constructor!(building)
    Creds.mass_accelerate!(building, m.params['index'])
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
  ACTION_ACCELERATE_UPGRADE = 'buildings|accelerate_upgrade'

  ACCELERATE_UPGRADE_OPTIONS = logged_in + find_building_options +
    required(:id => Fixnum, :index => Fixnum)
  ACCELERATE_UPGRADE_SCOPE = scope.world
  def self.accelerate_upgrade_action(m)
    building = find_building(m)
    begin
      Creds.accelerate!(building, m.params['index'])
    rescue ArgumentError => e
      # In case client provides invalid index.
      raise GameLogicError, e.message, e.backtrace
    end
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
  ACTION_CANCEL_CONSTRUCTOR = 'buildings|cancel_constructor'

  CANCEL_CONSTRUCTOR_OPTIONS = logged_in + find_building_options
  CANCEL_CONSTRUCTOR_SCOPE = scope.world
  def self.cancel_constructor_action(m)
    constructor = find_building(m)
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
  ACTION_CANCEL_UPGRADE = 'buildings|cancel_upgrade'

  CANCEL_UPGRADE_OPTIONS = logged_in + find_building_options
  CANCEL_UPGRADE_SCOPE = scope.world
  def self.cancel_upgrade_action(m)
    building = find_building(m)
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
  ACTION_SET_BUILD_IN_2ND_FLANK = 'buildings|action_set_build_in_2nd_flank'

  SET_BUILD_IN_2ND_FLANK_OPTIONS = logged_in + find_building_options +
    required(:id => Fixnum, :enabled => Boolean)
  SET_BUILD_IN_2ND_FLANK_SCOPE = scope.world
  def self.set_build_in_2nd_flank_action(m)
    building = find_building(m)
    check_for_constructor!(building)
    building.build_in_2nd_flank = m.params['enabled']
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
  ACTION_SET_BUILD_HIDDEN = 'buildings|set_build_hidden'

  SET_BUILD_HIDDEN_OPTIONS = logged_in + find_building_options +
    required(:id => Fixnum, :enabled => Boolean)
  SET_BUILD_HIDDEN_SCOPE = scope.world
  def self.set_build_hidden_action(m)
    building = find_building(m)
    check_for_constructor!(building)
    building.build_hidden = m.params['enabled']
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
  #
  ACTION_REPAIR = 'buildings|repair'

  REPAIR_OPTIONS = logged_in + find_building_options
  REPAIR_SCOPE = scope.world
  def self.repair_action(m)
    building = find_building(m)
    building.repair!
  end

  # Starts mass repairs on the planet
  #
  # Invocation: by client
  #
  # Parameters:
  # - planet_id (Fixnum): ID of the planet.
  # - building_ids (Fixnum[]): IDs of repairable buildings.
  #
  # Response: None
  #
  ACTION_MASS_REPAIR = 'buildings|mass_repair'

  MASS_REPAIR_OPTIONS = logged_in +
    required(:planet_id => Fixnum, :building_ids => Array)
  MASS_REPAIR_SCOPE = scope.world
  def self.mass_repair_action(m)
    raise GameLogicError, "Only VIPs can do mass repair!" unless m.player.vip?

    planet = SsObject::Planet.where(:player_id => m.player.id).
      find(m.params['planet_id'])
    buildings = planet.buildings.find(m.params['building_ids'])
    planet.mass_repair!(buildings)
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
  ACTION_TRANSPORT_RESOURCES = 'buildings|transport_resources'
  
  TRANSPORT_RESOURCES_OPTIONS = logged_in + find_building_options + required(
    :id => Fixnum, :target_planet_id => Fixnum, :metal => Fixnum,
    :energy => Fixnum, :zetium => Fixnum
  )
  TRANSPORT_RESOURCES_SCOPE = scope.world
  def self.transport_resources_action(m)
    building = find_building(m)

    if building.is_a?(Building::ResourceTransporter)
      target = SsObject::Planet.find(m.params['target_planet_id'])
      building.transport!(
        target, m.params['metal'], m.params['energy'], m.params['zetium']
      )
    else
      raise GameLogicError.new("#{building} is not a resource transporter!")
    end
  rescue Building::ResourceTransporter::NoTransporterError
    respond m, :error => "no_transporter"
  end
end