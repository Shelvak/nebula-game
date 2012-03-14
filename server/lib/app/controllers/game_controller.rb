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

  ACTION_CONFIG = 'game|config'

  CONFIG_OPTIONS = no_options
  def self.config_scope(message); scope.player(message.player); end
  def self.config_action(m)
    # Planet map editor requires configuration but does not login to server.
    ruleset = m.player.nil? ? GameConfig::DEFAULT_SET : ruleset(m)

    # Configuration tends to be huge - no need to litter logs with it.
    LOGGER.except(:traffic_debug) do
      respond m, :config => get_config(ruleset)
    end
  end

  class << self
    # Ensure only one thread is modifying cached configs at one time.
    @@ruleset_mutex = Mutex.new

    private

    def get_config(ruleset)
      @@ruleset_mutex.synchronize do
        # Ensure duplicated controller instances have separate configurations
        # for testing. If we use @@ testing becomes impossible, because one
        # example intervenes with other.
        @ruleset_configs ||= {}
        @ruleset_configs[ruleset] ||= cache_config(ruleset)
      end
    end

    # Cache current configuration replacing speed with constant.
    def cache_config(ruleset)
      CONFIG.with_set_scope(ruleset) do
        filtered = CONFIG.filter(SENDABLE_RE, ruleset)
        CONFIG.constantize_speed(filtered)
      end
    end
  end
end