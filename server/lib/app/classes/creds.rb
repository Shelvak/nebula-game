# Various helpers for dealing with creds.
module Creds
  # Use this for time reduction if you want model to be instantly completed.
  ACCELERATE_INSTANT_COMPLETE = 0

  # Accelerate _model_ by _index_.
  #
  # _index_ is index of CONFIG['creds.upgradable.speed_up'].
  #
  def self.accelerate!(model, index)
    time, cost = Cfg.creds_upgradable_speed_up_entry(index)
    model.accelerate!(time, cost)
  end

  def self.accelerate_construction!(constructor, index)
    time, cost = Cfg.creds_upgradable_speed_up_entry(index)
    constructor.accelerate_construction!(time, cost)
  end

  def self.mass_accelerate!(constructor, index)
    time, cost = Cfg.creds_upgradable_speed_up_entry(index)
    constructor.mass_accelerate!(time, cost)
  end
end

