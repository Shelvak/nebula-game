class GameController < GenericController
  SENDABLE_RE = /^(
    alliances\.
    |
    combat\.
    |
    speed
    |
    ui\.
    |
    creds\.
    |
    market\.
    |
    battleground\.
    |
    raiding\.
    |
    buildings\.
    |
    technologies\.
    |
    guns\.
    |
    galaxy\.(
      player\.population\.max
      |
      apocalypse\.survival_bonus
    )
    |
    units\.
    |
    damages\.
    |
    planet\.validation\.
    |
    tiles\.exploration\.(scientists|time)
    |
    tiles\..+?\.mod\.
  )/x

  def initialize(*args)
    super(*args)
    @ruleset_configs = {}
  end

  ACTION_CONFIG = 'game|config'
  def action_config
    # Planet map editor requires configuration but does not login to server.
    ruleset = player.nil? ? 'default' : session[:ruleset]

    # Configuration tends to be huge - no need to litter logs with it.
    LOGGER.except(:traffic_debug) do
      respond :config => get_config(ruleset)
    end
  end

  private
  def get_config(ruleset)
    # Config will be scoped to ruleset right here, so no harm done
    # by not passing ruleset to it.
    @ruleset_configs[ruleset] ||= cache_config(ruleset)
  end

  # Cache current configuration replacing speed with constant.
  def cache_config(ruleset)
    CONFIG.constantize_speed(CONFIG.filter(SENDABLE_RE, ruleset))
  end
end