module Parts::ResetableCooldown
  # Resets cooldown for this building.
  def reset_cooldown!
    cooldown_registered = ! cooldown_expired?
    self.cooldown_ends_at = cooldowns_at

    event = CallbackManager::EVENT_COOLDOWN_EXPIRED

    transaction do
      if cooldown_registered
        CallbackManager.update(self, event, cooldown_ends_at)
      else
        CallbackManager.register(self, event, cooldown_ends_at)
      end

      save!
      EventBroker.fire(self, EventBroker::CHANGED)
    end
  end
end
