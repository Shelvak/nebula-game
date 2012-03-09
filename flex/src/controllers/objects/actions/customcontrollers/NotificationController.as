package controllers.objects.actions.customcontrollers
{
   import models.factories.NotificationFactory;


   public class NotificationController extends BaseObjectController
   {
      public function NotificationController() {
         super();
      }

      public override function objectCreated(objectSubclass: String,
                                             object: Object,
                                             reason: String): * {
         return NotificationFactory.fromObject(object);
      }

      public override function objectDestroyed(objectSubclass: String,
                                               objectId: int,
                                               reason: String): void {
         ML.notifications.remove(objectId);
      }
   }
}