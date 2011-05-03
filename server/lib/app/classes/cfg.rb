# Config shortcuts instead of using strings everywhere.
class Cfg; class << self
  # For how long planet is protected after protection is initiated?
  def planet_protection_duration
    CONFIG.evalproperty('combat.cooldown.protection.duration')
  end
end; end