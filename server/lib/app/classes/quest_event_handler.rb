# Event handler that is responsible for 
class QuestEventHandler
  def initialize
    EventBroker.register(self)
  end

  def fire(objects, event, reason)
    objects = self.class.filter(objects)

    unless objects.blank?
      case event
      when EventBroker::CREATED
        handle_created(objects, reason)
      when EventBroker::CHANGED
        handle_changed(objects, reason)
      when EventBroker::DESTROYED
        handle_destroyed(objects, reason)
      end
    end
  end

  private
  # Filter down objects which will never be part of quests.
  def self.filter(objects)
    objects.reject do |object|
      case object
      when ObjectiveProgress, QuestProgress
        true
      else
        false
      end
    end
  end

  def handle_created(objects, reason)
    case reason
    when EventBroker::REASON_REWARD_CLAIMED
      Objective::HaveUpgradedTo.progress(objects)
    end
  end

  def handle_changed(objects, reason)
    case reason
    when EventBroker::REASON_UPGRADE_FINISHED
      Objective::UpgradeTo.progress(objects)
      Objective::HaveUpgradedTo.progress(objects)
    when EventBroker::REASON_OWNER_CHANGED
      Objective::AnnexPlanet.progress(objects)
      Objective::HavePlanets.progress(objects)
    end
  end

  def handle_destroyed(objects, reason)
    # Don't handle if it's not from combat.
    Objective::Destroy.progress(objects) if objects.is_a?(CombatArray)
    Objective::HaveUpgradedTo.regress(objects)
  end
end