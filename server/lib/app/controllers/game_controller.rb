class GameController < GenericController
  SENDABLE_RE = /^(
    combat\.
    |
    speed
    |
    ui\.
    |
    creds\.
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

  def action_config
    # Configuration tend to be huge - no need to litter logs with it.
    LOGGER.suppress(:traffic_debug) do
      respond :config => get_config(session[:ruleset])
    end
  end

  private
  def get_config(ruleset)
    # Config will be scoped to ruleset right here, so no harm done
    # by not passing ruleset to it.
    @ruleset_configs[ruleset] ||= cache_config
  end

  # Cache current configuration replacing speed with constant.
  def cache_config
    CONFIG.constantize_speed(CONFIG.filter(SENDABLE_RE))
  end
end