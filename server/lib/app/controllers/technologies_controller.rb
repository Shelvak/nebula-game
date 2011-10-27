class TechnologiesController < GenericController
  # Returns a list of player technologies
  def action_index
    only_push!
    respond :technologies => player.technologies.map(&:as_json)
  end

  # Starts researching new technology (from level 0)
  #
  # Params:
  #   type: String, i.e. ZetiumExtraction
  #   planet_id: Fixnum, planet where to take resources from
  #   scientists: Fixnum, how many scientists should we assign
  #   speed_up: Boolean, should we speed up the research?
  #
  def action_new
    param_options :required => %w{type planet_id scientists speed_up}

    technology = Technology.new_by_type(params['type'],
      :player => player, :planet_id => params['planet_id'], :level => 0,
      :scientists => params['scientists'],
      :speed_up => params['speed_up'])
    technology.upgrade!

    respond :technology => technology.as_json
  end

  # Upgrades existing technology
  #
  # Params:
  #   id: Fixnum, id of technology to upgrade
  #   planet_id: Fixnum, planet where to take resources from
  #   scientists: Fixnum, how many scientists should we assign
  #   speed_up: Boolean, should we speed up the research?
  #
  def action_upgrade
    param_options :required => {:id => Fixnum, :planet_id => Fixnum,
      :scientists => Fixnum, :speed_up => [TrueClass, FalseClass]}

    technology = player.technologies.find(params['id'])
    technology.scientists = params['scientists']
    technology.speed_up = params['speed_up']
    technology.planet_id = params['planet_id']
    technology.upgrade!

    respond :technology => technology.as_json
  end

  # Change scientist count in curently upgrading technology.
  #
  # Params:
  #   id: Fixnum, id of technology to upgrade
  #   scientists: Fixnum, how many scientists should we assign
  #
  def action_update
    param_options :required => %w{id}

    technology = player.technologies.find(params['id'])
    technology.scientists = params['scientists']
    technology.save!

    respond :technology => technology.as_json
  end

  # Pauses upgrading technology
  #
  # Params:
  # - id (Fixnum): id of technology to upgrade
  #
  def action_pause
    param_options :required => {:id => Fixnum}

    technology = player.technologies.find(params['id'])
    technology.pause!

    respond :technology => technology.as_json
  end

  # Resumes paused technology
  #
  # Params:
  # - id (Fixnum): id of technology to upgrade
  # - scientists (Fixnum): how many scientists should we assign
  #
  def action_resume
    param_options :required => {:id => Fixnum, :scientists => Fixnum}

    technology = player.technologies.find(params['id'])
    technology.scientists = params['scientists']
    technology.resume!

    respond :technology => technology.as_json
  end

  # Accelerates technology research.
  #
  # Parameters:
  # - id (Fixnum): ID of the technology that will be accelerated.
  # - index (Fixnum): Index of CONFIG["creds.upgradable.speed_up"] entry.
  #
  def action_accelerate
    param_options :required => {:id => Fixnum, :index => Fixnum}

    technology = player.technologies.find(params['id'])
    Creds.accelerate!(technology, params['index'])
	
    respond :technology => technology.as_json
  rescue ArgumentError => e
    # In case client provides invalid index.
    raise GameLogicError.new(e.message)
  end

  # Unlearns technology. Requires creds.
  #
  # Parameters:
  # - id (Fixnum): ID of the technology that will be unlearned.
  #
  # Response: None
  #
  def action_unlearn
    param_options :required => {:id => Fixnum}

    technology = player.technologies.find(params['id'])
    technology.unlearn!
  end
end