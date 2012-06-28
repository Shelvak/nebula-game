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
   import models.notification.MNotificationEvent;
   import models.notification.Notification;
   import models.notification.NotificationType;
   import models.notification.parts.NotEnoughResources;
   import models.planet.MPlanet;
   import models.planet.MPlanetObject;

   import utils.Objects;
   import utils.locale.Localizer;

   public class NotificationFactory {
      public static function fromObject(data:Object) : Notification
      {
         var oldNotif: Notification = ML.notifications.find(data.id);
         if (oldNotif != null)
         {
            if (oldNotif.read != data.read || oldNotif.starred != data.starred)
            {
               Objects.throwStateOutOfSyncError(oldNotif, data);
            }
            return oldNotif;
         }
         var notification: Notification = Objects.create(Notification, data);
         notification.isNew = true;
         ML.notifications.addItem(notification);
         if (MA.currentName != MainAreaScreens.NOTIFICATIONS) {
            if (ExternalInterface.available) {
               var windowTitle: String = Localizer.string(
                  "Notifications", "windowTitle",
                  [ML.notifications.unreadNotifsTotal]
               );

               ExternalInterface.call("setUnreadNotifications", windowTitle);
            }
            new MNotificationEvent(notification);
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
