# Class that stores game config data.
class GameConfig
  require File.dirname(__FILE__) + '/game_config/creation'
  require File.dirname(__FILE__) + '/game_config/scala_wrapper'
  require File.dirname(__FILE__) + '/game_config/thread_local'
  require File.dirname(__FILE__) + '/game_config/thread_router'
  include GameConfig::Creation

  # Default config set name
  DEFAULT_SET = 'default'

  FormulaCalc = Java::spacemule.modules.config.objects.FormulaCalc

  def initialize
    set ||= DEFAULT_SET
    @keys = Set.new
    @data = {
      set => {}
    }
    @fallbacks = {}
  end

  def each_key(&block)
    @keys.each(&block)
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

  def add_set(set, fallback=nil)
    @data[set] ||= {}
    @fallbacks[set] = fallback unless fallback.nil?
  end

  # Store
  def store(key, set, value)
    ensure_setup!

    raise ArgumentError, "Unknown set #{set.inspect}" unless @data.has_key?(set)
    @keys.add(key)
    @data[set][key] = value
  end

  # Get
  def [](key, set)
    ensure_setup!

    raise ArgumentError.new("Unknown set #{set.inspect}") \
      unless @data.has_key?(set)

    value = @data[set][key]

    if value.nil? and @fallbacks.has_key?(set)
      self[key, @fallbacks[set]]
    else
      value
    end
  end

  # Evaluate a _string_ filtered by .filter_for_eval
  def self.safe_eval(formula, params={})
    typesig binding, [String, Fixnum, Float], [NilClass, Hash]

    # 60.seconds returns not pure Fixnum, but Duration object...
    formula = formula.to_f if formula.is_a?(ActiveSupport::Duration)

    FormulaCalc.calc(
      formula, params.map_values { |key, value| value.to_f }
    )
  end
end