package controllers.objects.actions.customcontrollers
{
   import com.developmentarc.core.utils.SingletonFactory;
   
   import controllers.screens.MainAreaScreens;
   import controllers.screens.MainAreaScreensSwitch;
   
   import models.BaseModel;
   import models.notification.Notification;
   import models.planet.Planet;
   import models.planet.PlanetObject;
   
   
   public class NotificationController extends BaseObjectController
   {
      public static function getInstance() : NotificationController
      {
         return SingletonFactory.getSingletonInstance(NotificationController);
      }
      
      
      public function NotificationController()
      {
      }
      
      
      public override function objectCreated(objectSubclass:String, object:Object, reason:String) : void
      {
         var notification:Notification = BaseModel.createModel(Notification, object);
         notification.isNew = true;
         ML.notifications.addItem(notification);
         if (MainAreaScreensSwitch.getInstance().currentScreenName != MainAreaScreens.NOTIFICATIONS)
         {
            ML.notificationAlerts.addItem(notification);
         }
         var planet:Planet = ML.latestPlanet;
         if (notification.event == 0 && planet != null)
         {
            for each (var coords:Array in object.params.coordinates)
            {
               var remove:PlanetObject = planet.getObject(coords[0], coords[1]);
               planet.removeObject(remove);
            }
         }
      }
      
      
      public override function objectDestroyed(objectSubclass:String, objectId:int, reason:String) : void
      {
         ML.notifications.remove(objectId);
      }
   }
}