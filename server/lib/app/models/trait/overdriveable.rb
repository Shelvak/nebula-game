module Trait::Overdriveable
  def activate_overdrive!
    raise GameLogicError.new("Cannot activate overdrive on #{self
      } because it's already on!") if overdriven?

    deactivate!
    self.overdriven = true
    activate!
  end

  def deactivate_overdrive!
    raise GameLogicError.new("Cannot deactivate overdrive on #{self
      } because it's already off!") unless overdriven?

    deactivate!
    self.overdriven = false
    activate!
  end
end