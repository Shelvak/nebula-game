# Class that stores game config data.
class GameConfig
  include GameConfig::Creation

  # Default config set name
  DEFAULT_SET = 'default'

  FormulaCalc = Java::spacemule.modules.config.objects.FormulaCalc

  attr_reader :set_scope, :scope

  def initialize
    set ||= DEFAULT_SET
    @keys = Set.new
    @data = {
      set => {}
    }
    @fallbacks = {}
    @scope = nil
    @galaxy_id_scope = nil
    @set_scope = DEFAULT_SET
  end

  def inspect
    str = "<GameConfig set=#{@set.inspect} scope=#{@scope.inspect}\n"
    @data.each do |set, entries|
      str += "  #{set.inspect}:\n"
      entries.keys.sort.each do |key|
        value = entries[key]
        str += "    #{key.inspect}: #{value.inspect}\n"
      end
    end
    str += "  >\n"

    str
  end

  # Merge _hash_ into _self_'s _set_.
  def merge!(hash, set=nil)
    hash.each do |key, value|
      self[key, set] = value
    end
  end

  def add_set(set, fallback=nil)
    @data[set] ||= {}
    @fallbacks[set] = fallback unless fallback.nil?
  end

  def scala_wrapper
    ScalaWrapper.new(self)
  end

  # Store
  def []=(key, set_or_value, value=nil)
    if value.nil?
      value = set_or_value
      set = DEFAULT_SET
    else
      set = set_or_value || DEFAULT_SET
    end

    # Add scope
    key = @scope.nil? ? key : "#{@scope}.#{key}"
    @keys.add(key)

    raise ArgumentError.new("Unknown set #{set.inspect}") \
      unless @data.has_key?(set)
    @data[set][key] = value
  end

  # Get
  def [](key, set=nil)
    set ||= @set_scope
    raise ArgumentError.new("Unknown set #{set.inspect}") \
      unless @data.has_key?(set)

    key = @scope.nil? ? key : "#{@scope}.#{key}"
    value = @data[set][key]

    if value.nil? and @fallbacks.has_key?(set)
      with_scope(nil) do |config|
        config[key, @fallbacks[set]]
      end
    else
      value
    end
  end

  # Calculates with _params_ and formula retrieved by _key_.
  def calculate(key, params={})
    self.class.safe_eval(self[key], params)
  end

  # Return random value by from config range.
  def hashrand(key, set=nil)
    range = self[key, set]
    Kernel.rangerand(range[0], range[1] + 1)
  end

  alias :rangerand :hashrand

  # Same as #hashrand but evaluates range values.
  def eval_hashrand(key, set=nil)
    range = self[key, set]
    Kernel.rangerand(safe_eval(range[0]), safe_eval(range[1]) + 1)
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

    @keys.each do |key|
      block.call(key, self[key, set]) unless key.match(regexp).nil?
    end
  end

  def with_set_scope(set, &block)
    raise ArgumentError.new("Block required but not passed!") if block.nil?

    prev_scope = @set_scope
    @set_scope = set
    value = block.call(self)
    @set_scope = prev_scope
    value
  end

  def with_scope(scope, &block)
    raise ArgumentError.new("Block required but not passed!") if block.nil?
    
    prev_scope = @scope
    @scope = scope
    value = block.call(self)
    @scope = prev_scope
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
    self.class.safe_eval(string, params)
  end

  # Replace all references of speed in formulas to constant.
  def constantize_speed(config)
    config.each do |key, value|
      if value.is_a?(String) && value.match(/\bspeed\b/)
        replaced = value.gsub(/\bspeed\b/, self['speed'].to_s)
        replaced = self.class.safe_eval(replaced) if replaced !~ /[a-z]/i
        config[key] = replaced
      end
    end
    config
  end

  # Evaluate a _string_ filtered by .filter_for_eval
  def self.safe_eval(formula, params={})
    typesig binding, [String, Fixnum, Float], [NilClass, Hash]

    FormulaCalc.calc(
      formula, params.map_values { |key, value| value.to_f }.to_scala
    )
  end
end