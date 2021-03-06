# Tracks which technologies has which mods.
class TechTracker
  include Singleton
  include MonitorMixin

  # Regular expression for matching technologies.
  REGEXP = /^technologies\.\w+\.mod\./

  DAMAGE = 'damage'
  ARMOR = 'armor'
  CRITICAL = 'critical'
  ABSORPTION = 'absorption'
  SPEED = 'speed'
  METAL_GENERATE = 'metal.generate'
  METAL_STORE = 'metal.store'
  ENERGY_GENERATE = 'energy.generate'
  ENERGY_STORE = 'energy.store'
  ZETIUM_GENERATE = 'zetium.generate'
  ZETIUM_STORE = 'zetium.store'
  STORAGE = 'storage'

  MODS = [DAMAGE, ARMOR, CRITICAL, ABSORPTION, SPEED, METAL_GENERATE,
          METAL_STORE, ENERGY_GENERATE, ENERGY_STORE, ZETIUM_GENERATE,
          ZETIUM_STORE, STORAGE]

  def initialize
    # Hash of {name => Set} pairs.
    @tracker = {}
    super
  end

  def scan(force_rescan=false)
    synchronize do
      return if @scanned && ! force_rescan

      # Initialize technologies which have mods.
      CONFIG.each_matching(REGEXP) do |key, value|
        klass = "Technology::#{key.split(".")[1].camelcase}".constantize
        Technology::MODS.each do |name, property|
          register(property, klass) if klass.send(:"#{name}_mod?")
        end
      end

      @scanned = true
    end
  end

  def register(name, klass)
    check_name!(name)

    synchronize do
      @tracker[name] ||= Set.new
      @tracker[name].add klass
    end
  end

  # Returns technology classes for mod with _name_.
  def get(name)
    check_name!(name)
    scan

    synchronize do
      @tracker[name] || Set.new
    end
  end

  # Return technology classes for mods with _names_.
  def get_all(*names)
    set = Set.new
    names.each { |name| set.merge(get(name)) }
    set
  end

  # Return AREL query for technologies which have mods.
  def query(*names)
    Technology.where(
      type: get_all(*names).map { |klass| klass.to_s.demodulize }
    )
  end

  # Return AREL query for active technologies for player which have mods.
  def query_active(player_id, *names)
    query(*names).where("player_id=? AND level > 0", player_id)
  end

  class << self
    def method_missing(method, *args); instance.send(method, *args); end
  end

private

  def check_name!(name)
    raise ArgumentError,
      "Invalid key #{name.inspect}, allowed keys: #{MODS.inspect}" \
      unless MODS.include?(name)
  end

end