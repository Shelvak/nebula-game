package controllers.objects.actions.customcontrollers
{
   import controllers.startup.StartupInfo;

   import models.factories.NotificationFactory;

   public class NotificationController extends BaseObjectController
   {
      public function NotificationController() {
         super();
      }

      public override function objectCreated(objectSubclass: String,
                                             object: Object,
                                             reason: String): * {
         if (StartupInfo.getInstance().initializationComplete)
         {
            return NotificationFactory.fromObject(object);
         }
      }

      public override function objectDestroyed(objectSubclass: String,
                                               objectId: int,
                                               reason: String): void {
         if (StartupInfo.getInstance().initializationComplete)
         {
            ML.notifications.remove(objectId, true);
         }
      }
   }
}