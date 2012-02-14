class TechnologiesController < GenericController
  # Returns a list of player technologies.
  ACTION_INDEX = 'technologies|index'

  INDEX_OPTIONS = logged_in + only_push
  def self.index_scope(m); technologies_scope(m); end
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

  NEW_OPTIONS = logged_in + required(
    :type => String, :planet_id => Fixnum, :scientists => Fixnum,
    :speed_up => Boolean
  )
  def self.new_scope(m); technologies_scope(m); end
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
  ACTION_UPGRADE = 'technologies|upgrade'

  UPGRADE_OPTIONS = logged_in + required(
    :id => Fixnum, :planet_id => Fixnum, :scientists => Fixnum,
    :speed_up => Boolean
  )
  def self.upgrade_scope(m); technologies_scope(m); end
  def self.upgrade_action(m)
    technology = m.player.technologies.find(m.params['id'])
    technology.scientists = m.params['scientists']
    technology.speed_up = m.params['speed_up']
    technology.planet_id = m.params['planet_id']
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
  ACTION_UPDATE = 'technologies|update'

  UPDATE_OPTIONS = logged_in + required(:id => Fixnum, :scientists => Fixnum)
  def self.update_scope(m); technologies_scope(m); end
  def self.update_action(m)
    technology = m.player.technologies.find(m.params['id'])
    technology.scientists = m.params['scientists']
    technology.save!
  end

  # Pauses upgrading technology
  #
  # Params:
  # - id (Fixnum): id of technology to upgrade
  #
  ACTION_PAUSE = 'technologies|pause'

  PAUSE_OPTIONS = logged_in + required(:id => Fixnum)
  def self.pause_scope(m); technologies_scope(m); end
  def self.pause_action(m)
    technology = m.player.technologies.find(m.params['id'])
    technology.pause!
  end

  # Resumes paused technology
  #
  # Params:
  # - id (Fixnum): id of technology to upgrade
  # - scientists (Fixnum): how many scientists should we assign
  #
  ACTION_RESUME = 'technologies|resume'

  RESUME_OPTIONS = logged_in + required(:id => Fixnum, :scientists => Fixnum)
  def self.resume_scope(m); technologies_scope(m); end
  def self.resume_action(m)
    technology = m.player.technologies.find(m.params['id'])
    technology.scientists = m.params['scientists']
    technology.resume!
  end

  # Accelerates technology research.
  #
  # Parameters:
  # - id (Fixnum): ID of the technology that will be accelerated.
  # - index (Fixnum): Index of CONFIG["creds.upgradable.speed_up"] entry.
  #
  ACTION_ACCELERATE = 'technologies|accelerate'

  ACCELERATE_OPTIONS = logged_in + required(:id => Fixnum, :index => Fixnum)
  def self.accelerate_scope(m); technologies_scope(m); end
  def self.accelerate_action(m)
    technology = m.player.technologies.find(m.params['id'])
    begin
      Creds.accelerate!(technology, m.params['index'])
    rescue ArgumentError => e
      # In case client provides invalid index.
      raise GameLogicError, e.message, e.backtrace
    end
  end

  # Unlearns technology. Requires creds.
  #
  # Parameters:
  # - id (Fixnum): ID of the technology that will be unlearned.
  #
  # Response: None
  #
  ACTION_UNLEARN = 'technologies|unlearn'

  UNLEARN_OPTIONS = logged_in + required(:id => Fixnum)
  def self.unlearn_scope(m); technologies_scope(m); end
  def self.unlearn_action(m)
    technology = m.player.technologies.find(m.params['id'])
    technology.unlearn!
  end

  class << self
    private
    def technologies_scope(m); scope.player(m.player); end
  end
end