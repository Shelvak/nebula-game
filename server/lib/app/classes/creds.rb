# Various helpers for dealing with creds.
module Creds
  # Use this for time reduction if you want model to be instantly completed.
  ACCELERATE_INSTANT_COMPLETE = 0

  # Accelerate _model_ by _index_.
  #
  # _index_ is index of CONFIG['creds.upgradable.speed_up'].
  #
  def self.accelerate!(model, index)
    time, cost = resolve_accelerate_index(index)
    model.accelerate!(time, cost)
  end

  def self.accelerate_construction!(constructor, index)
    time, cost = resolve_accelerate_index(index)
    constructor.accelerate_construction!(time, cost)
  end

  def self.resolve_accelerate_index(index)
    entry = CONFIG['creds.upgradable.speed_up'][index]
    raise ArgumentError.new("Unknown speed up index #{index.inspect
      }, max index: #{CONFIG['creds.upgradable.speed_up'].size - 1}!") \
      if entry.nil?

    time, cost = entry
    time = CONFIG.safe_eval(time) # Evaluate because it contains speed.
    [time, cost]
  end
end
