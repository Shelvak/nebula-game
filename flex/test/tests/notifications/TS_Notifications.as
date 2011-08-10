package tests.notifications
{
   import tests.notifications.tests.TC_Notification;
   import tests.notifications.tests.TC_NotificationsCollection;
   import tests.notifications.tests.actions.TC_IndexAction;
   import tests.notifications.tests.parts.TCBuildingsDeactivated;
   import tests.notifications.tests.parts.TCNotEnoughResources;

   [Suite]
   [RunWith("org.flexunit.runners.Suite")]
   public class TS_Notifications
   {
      public var tc_Notification:TC_Notification;
      public var tc_NotificationsCollection:TC_NotificationsCollection;
      public var tc_IndexAction:TC_IndexAction;
      public var tc_NotEnoughResources:TCNotEnoughResources;
      public var tc_BuildingsDeactivated:TCBuildingsDeactivated;
   }
}