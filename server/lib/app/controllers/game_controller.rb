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

  # Ensure only one thread is modifying cached configs at one time.
  @@ruleset_mutex = Mutex.new
  @@ruleset_configs = {}

  ACTION_CONFIG = 'game|config'
  def self.config_options; no_options; end
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
    private

    def get_config(ruleset)
      @@ruleset_mutex.synchronize do
        # Config will be scoped to ruleset right here, so no harm done
        # by not passing ruleset to it.
        @@ruleset_configs[ruleset] ||= cache_config(ruleset)
      end
    end

    # Cache current configuration replacing speed with constant.
    def cache_config(ruleset)
      CONFIG.constantize_speed(CONFIG.filter(SENDABLE_RE, ruleset))
    end
  end
end