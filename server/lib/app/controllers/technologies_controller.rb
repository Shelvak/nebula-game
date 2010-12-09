class TechnologiesController < GenericController
  ACTION_INDEX = 'technologies|index'
  # Starts researching new technology (from level 0)
  #
  # Params:
  #   type: String, i.e. ZetiumExtraction
  #   planet_id: Fixnum, planet where to take resources from
  #   scientists: Fixnum, how many scientists should we assign
  #   speed_up: Boolean, should we speed up the research?
  #
  ACTION_NEW = 'technologies|new'
  # Upgrades existing technology
  #
  # Params:
  #   id: Fixnum, id of technology to upgrade
  #   planet_id: Fixnum, planet where to take resources from
  #   scientists: Fixnum, how many scientists should we assign
  #   speed_up: Boolean, should we speed up the research?
  #
  ACTION_UPGRADE = 'technologies|upgrade'
  ACTION_UPDATE = 'technologies|update'
  ACTION_PAUSE = 'technologies|pause'
  ACTION_RESUME = 'technologies|resume'

  def invoke(action)
    case action
    # Returns a list of player technologies
    when ACTION_INDEX
      only_push!
      respond :technologies => player.technologies
    when ACTION_NEW
      param_options :required => %w{type planet_id scientists speed_up}

      technology = Technology.new_by_type(params['type'], 
        :player => player, :planet_id => params['planet_id'], :level => 0,
        :scientists => params['scientists'],
        :speed_up => params['speed_up'])
      technology.upgrade!

      respond :technology => technology
    when ACTION_UPGRADE
      param_options :required => %w{id planet_id scientists speed_up}

      technology = player.technologies.find(params['id'])
      technology.scientists = params['scientists']
      technology.speed_up = params['speed_up']
      technology.planet_id = params['planet_id']
      technology.upgrade!

      respond :technology => technology
    # Change scientist count in curently upgrading technology.
    #
    # Params:
    #   id: Fixnum, id of technology to upgrade
    #   scientists: Fixnum, how many scientists should we assign
    #
    when ACTION_UPDATE
      param_options :required => %w{id}

      technology = player.technologies.find(params['id'])
      technology.scientists = params['scientists']
      technology.save!

      respond :technology => technology
    # Pauses upgrading technology
    #
    # Params:
    #   id: Fixnum, id of technology to upgrade
    #
    when ACTION_PAUSE
      param_options :required => %w{id}

      technology = player.technologies.find(params['id'])
      technology.pause!

      respond :technology => technology
    # Resumes paused technology
    #
    # Params:
    #   id: Fixnum, id of technology to upgrade
    #   scientists: Fixnum, how many scientists should we assign
    #
    when ACTION_RESUME
      param_options :required => %w{id scientists}

      technology = player.technologies.find(params['id'])
      technology.scientists = params['scientists']
      technology.resume!

      respond :technology => technology
    end
  end
end