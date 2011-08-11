package controllers.objects.actions.customcontrollers
{
   import controllers.screens.MainAreaScreens;
   import controllers.screens.MainAreaScreensSwitch;
   
   import flash.external.ExternalInterface;
   
   import models.BaseModel;
   import models.notification.Notification;
   import models.notification.NotificationType;
   import models.notification.parts.NotEnoughResources;
   import models.planet.Planet;
   import models.planet.PlanetObject;
   
   
   public class NotificationController extends BaseObjectController
   {
      public function NotificationController() {
         super();
      }
      
      
      public override function objectCreated(objectSubclass:String, object:Object, reason:String) : void {
         var notification:Notification = BaseModel.createModel(Notification, object);
         notification.isNew = true;
         ML.notifications.addItem(notification);
         if (MainAreaScreensSwitch.getInstance().currentScreenName != MainAreaScreens.NOTIFICATIONS) {
            if (ExternalInterface.available)
               ExternalInterface.call("setUnreadNotifications", ML.notifications.unreadNotifsTotal);
            ML.notificationAlerts.addItem(notification);
         }
         var planet:Planet = ML.latestPlanet;
         if (notification.event == NotificationType.NOT_ENOUGH_RESOURCES && planet != null &&
             planet.definesLocation(NotEnoughResources(notification.customPart).location)) {
            for each (var coords:Array in object.params.coordinates) {
               var remove:PlanetObject = planet.getObject(coords[0], coords[1]);
               planet.removeObject(remove);
            }
         }
      }
      
      public override function objectDestroyed(objectSubclass:String, objectId:int, reason:String) : void {
         ML.notifications.remove(objectId);
      }
   }
}