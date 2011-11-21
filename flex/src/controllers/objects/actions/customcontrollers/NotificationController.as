package controllers.objects.actions.customcontrollers
{
   import controllers.navigation.MCMainArea;
   import controllers.screens.MainAreaScreens;

   import flash.external.ExternalInterface;

   import models.notification.Notification;
   import models.notification.NotificationType;
   import models.notification.parts.NotEnoughResources;
   import models.planet.MPlanet;
   import models.planet.MPlanetObject;

   import utils.Objects;


   public class NotificationController extends BaseObjectController
   {
      public function NotificationController() {
         super();
      }
      
      private var MA: MCMainArea = MCMainArea.getInstance();

      public override function objectCreated(objectSubclass: String,
                                             object: Object,
                                             reason: String): * {
         var notification: Notification = Objects.create(Notification, object);
         notification.isNew = true;
         ML.notifications.addItem(notification);
         if (MA.currentName != MainAreaScreens.NOTIFICATIONS) {
            if (ExternalInterface.available) {
               ExternalInterface.call(
                  "setUnreadNotifications", ML.notifications.unreadNotifsTotal
               );
            }
            ML.notificationAlerts.addItem(notification);
         }
         var planet: MPlanet = ML.latestPlanet;
         if (notification.event == NotificationType.NOT_ENOUGH_RESOURCES
                && planet != null
                && planet.definesLocation(NotEnoughResources(notification.customPart).location)) {
            for each (var coords: Array in object.params.coordinates) {
               var remove: MPlanetObject =
                      planet.getObject(coords[0], coords[1]);
               planet.removeObject(remove);
            }
         }
         return notification;
      }

      public override function objectDestroyed(objectSubclass: String,
                                               objectId: int,
                                               reason: String): void {
         ML.notifications.remove(objectId);
      }
   }
}