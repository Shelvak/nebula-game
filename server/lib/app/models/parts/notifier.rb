# Include this if you want your models to notify EventBroker about changes.
#
# You can control what operations should be notified by defining
# self.notify_on_create?, self.notify_on_update? and
# self.notify_on_destroy? methods that return Boolean.
#
module Parts::Notifier
  def self.should_notify?(receiver, event)
    status = receiver.try_method(:"notify_on_#{event}?")
    status.nil? ? true : status
  end

  def self.included(receiver)
    super(receiver)
    receiver.after_create :notify_broker_create \
      if should_notify?(receiver, :create)
    receiver.after_update :notify_broker_update \
      if should_notify?(receiver, :update)
    receiver.after_destroy :notify_broker_destroy \
      if should_notify?(receiver, :destroy)
  end

  # Notify +EventBroker+ if the model has created.
  def notify_broker_create
    EventBroker.fire(self, EventBroker::CREATED)
    true
  end

  # Notify +EventBroker+ if the model has changed.
  def notify_broker_update
    EventBroker.fire(self, EventBroker::CHANGED,
      EventBroker::REASON_UPDATED)
    true
  end

  # Notify +EventBroker+ if the model has been destroyed.
  def notify_broker_destroy
    EventBroker.fire(self, EventBroker::DESTROYED)
    true
  end
end