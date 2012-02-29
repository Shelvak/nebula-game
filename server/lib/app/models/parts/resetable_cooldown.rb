module Parts::ResetableCooldown
  def start_cooldown!
    reset_cooldown! if cooldown_ends_at.nil?
  end
  
  # Resets cooldown for this building.
  def reset_cooldown!
    self.cooldown_ends_at = cooldowns_at

    CallbackManager.register_or_update(
      self, CallbackManager::EVENT_COOLDOWN_EXPIRED, cooldown_ends_at
    )

    save!
    EventBroker.fire(self, EventBroker::CHANGED)
  end
end
