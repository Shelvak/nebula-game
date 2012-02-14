class TechnologiesController < GenericController
  # Returns a list of player technologies.
  ACTION_INDEX = 'technologies|index'

  def self.index_options; logged_in + only_push; end
  def self.index_scope(message); scope.player(message.player); end
  def self.index_action(m)
    respond m, :technologies => m.player.technologies.map(&:as_json)
  end

  # Starts researching new technology (from level 0)
  #
  # Invocation: by client
  #
  # Parameters:
  # - type (String): e.g. ZetiumExtraction
  # - planet_id (Fixnum): planet id from which resources are taken
  # - scientists (Fixnum): how many scientists should we assign
  # - speed_up (Boolean): should we speed up the research?
  #
  # Response: None.
  #
  ACTION_NEW = 'technologies|new'

  def self.new_options
    logged_in + required(
      :type => String, :planet_id => Fixnum, :scientists => Fixnum,
      :speed_up => Boolean
    )
  end
  def self.new_scope(m); scope.player(m.player); end
  def self.new_action(m)
    technology = Technology.new_by_type(
      m.params['type'],
      :player => m.player, :planet_id => m.params['planet_id'], :level => 0,
      :scientists => m.params['scientists'],
      :speed_up => m.params['speed_up']
    )
    technology.upgrade!
  end

  # Upgrades existing technology.
  #
  # Params:
  # - id (Fixnum): id of technology to upgrade
  # - planet_id (Fixnum): planet where to take resources from
  # - scientists (Fixnum): how many scientists should we assign
  # - speed_up (Boolean): should we speed up the research?
  #
  # Response: None.
  #
  def action_upgrade
    param_options :required => {:id => Fixnum, :planet_id => Fixnum,
      :scientists => Fixnum, :speed_up => Boolean}

    technology = player.technologies.find(params['id'])
    technology.scientists = params['scientists']
    technology.speed_up = params['speed_up']
    technology.planet_id = params['planet_id']
    technology.upgrade!
  end

  # Change scientist count in currently upgrading technology.
  #
  # Params:
  # - id (Fixnum): id of technology to upgrade
  # - scientists (Fixnum): how many scientists should we assign
  #
  # Response: None.
  #
  def action_update
    param_options :required => {:id => Fixnum, :scientists => Fixnum}

    technology = player.technologies.find(params['id'])
    technology.scientists = params['scientists']
    technology.save!
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