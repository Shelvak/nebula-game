package controllers.objects.actions.customcontrollers
{
   import controllers.sounds.SoundsController;
   import controllers.startup.StartupInfo;

   import models.factories.NotificationFactory;
   import models.player.PlayerOptions;

   import utils.assets.AssetNames;

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
            if (PlayerOptions.soundForNotification != PlayerOptions.NO_SOUND)
            {
               SoundsController.playSoundByIndex(PlayerOptions.soundForNotification);
            }
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