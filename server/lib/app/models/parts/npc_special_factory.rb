# Just a module to collect all needed modifications for NPC factories which
# stand in special planets.
module Parts::NpcSpecialFactory
  def self.included(receiver)
    receiver.send :include, Parts::WithCooldown
    receiver.send :include, Parts::ResetableCooldown
    receiver.send :include, Parts::LoopedCooldown
    receiver.send :include, Parts::UnitBonus
  end
end
