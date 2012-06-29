# Provides thread-local set scopes.
class GameConfig::ThreadLocal
  attr_reader :set_scope

  def initialize(global_config)
    @global_config = global_config
    @set_scope = GameConfig::DEFAULT_SET
  end

  # Global configuration shared across threads. Do not abuse this!
  def global
    @global_config
  end

  def [](key, set=nil)
    set ||= @set_scope
    @global_config[key, set]
  end

  def []=(key, value)
    set ||= @set_scope
    @global_config.store(key, set, value)
  end

  delegate :store, :to => :@global_config

  # Return random value by from config range.
  def hashrand(key, set=nil)
    range = self[key, set]
    Kernel.rangerand(range[0], range[1] + 1)
  end

  alias :random_from :hashrand

  # Same as #hashrand but evaluates range values.
  def eval_hashrand(key, set=nil)
    range = self[key, set]
    Kernel.rangerand(safe_eval(range[0]), safe_eval(range[1]) + 1)
  rescue Exception => e
    raise e.class,
      "Error while evaling hashrand for key '#{key}' in set '#{set}'",
      e.backtrace
  end

  alias :eval_rangerand :eval_hashrand

  # Return a Hash constructed by calling #each_matching
  def filter(regexp, set=nil)
    filtered = {}
    each_matching(regexp, set) do |key, value|
      filtered[key] = value
    end
    filtered
  end

  # Yield each _key_, _value_ for _set_ pair where key matches _regexp_.
  def each_matching(regexp, set=nil, &block)
    raise ArgumentError.new("Block required but not passed!") if block.nil?

    @global_config.each_key do |key|
      block.call(key, self[key, set]) unless key.match(regexp).nil?
    end
  end

  def with_set_scope(set)
    raise ArgumentError, "Block required but not passed!" unless block_given?

    prev_scope = @set_scope
    @set_scope = set
    value = yield
    @set_scope = prev_scope
    value
  end

  def damage(damage, armor)
    self["damages.#{damage}.#{armor}"] or \
      raise ArgumentError.new(
        "Unknown damage combo: dmg #{damage.inspect}, armor #{
        armor.inspect}"
      )
  end

  # Retrieve property by _key_ and evaluate it.
  def evalproperty(key, params={})
    safe_eval(self[key], params)
  end

  # Evaluate given _string_ safely adding speed to _params_.
  def safe_eval(string, params={})
    params.merge! 'speed' => self['speed']
    GameConfig.safe_eval(string, params)
  end

  # Replace all references of speed in formulas to constant.
  def constantize_speed(config)
    config.each do |key, value|
      if value.is_a?(String) && value.match(/\bspeed\b/)
        replaced = value.gsub(/\bspeed\b/, self['speed'].to_s)
        replaced = GameConfig.safe_eval(replaced) if replaced !~ /[a-z]/i
        config[key] = replaced
      end
    end
    config
  end
end