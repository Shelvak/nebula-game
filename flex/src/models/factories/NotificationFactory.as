/**
 * Created by IntelliJ IDEA.
 * User: jho
 * Date: 3/9/12
 * Time: 6:17 PM
 * To change this template use File | Settings | File Templates.
 */
package models.factories {
   import controllers.navigation.MCMainArea;
   import controllers.screens.MainAreaScreens;

   import flash.external.ExternalInterface;

   import models.ModelLocator;
   import models.notification.Notification;
   import models.notification.NotificationType;
   import models.notification.parts.NotEnoughResources;
   import models.planet.MPlanet;
   import models.planet.MPlanetObject;

   import utils.Objects;

   public class NotificationFactory {
      public static function fromObject(data:Object) : Notification
      {
         var notification: Notification = Objects.create(Notification, data);
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
            for each (var coords: Array in data.params.coordinates) {
               var remove: MPlanetObject =
                      planet.getObject(coords[0], coords[1]);
               planet.removeObject(remove);
            }
         }
         return notification;
      }

      private static function get MA(): MCMainArea
      {
         return MCMainArea.getInstance();
      }

      private static function get ML(): ModelLocator
      {
         return ModelLocator.getInstance();
      }
   }
}
