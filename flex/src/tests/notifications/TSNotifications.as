package tests.notifications
{
   import tests.notifications.tests.TCNotification;
   import tests.notifications.tests.TCNotificationsCollection;
   import tests.notifications.tests.actions.TCIndexAction;
   import tests.notifications.tests.actions.TCNewAction;
   import tests.notifications.tests.parts.TCBuildingsDeactivated;
   import tests.notifications.tests.parts.TCNotEnoughResources;

   [Suite]
   [RunWith("org.flexunit.runners.Suite")]
   public class TSNotifications
   {
      public var tcNotification:TCNotification;
      public var tcNotificationsCollection:TCNotificationsCollection;
      
      public var tcNewAction:TCNewAction;
      public var tcIndexAction:TCIndexAction;
      
      public var tcNotEnoughResources:TCNotEnoughResources;
      public var tcBuildingsDeactivated:TCBuildingsDeactivated;
   }
}