# If you include this module new cooldown will be registered when old on
# expires. This imports resetable cooldown.
module Parts::LoopedCooldown
  def self.included(receiver)
    receiver.send :include, Parts::ResetableCooldown
    super(receiver)
  end

  def cooldown_expired!
    reset_cooldown!
  end
end
