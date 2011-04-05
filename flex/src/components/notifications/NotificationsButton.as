package components.notifications
{
   import components.notifications.events.NotificationsButtonEvent;
   import components.skins.NotificationsButtonSkin;
   
   import flash.events.MouseEvent;
   
   import models.ModelLocator;
   import models.notification.NotificationsCollection;
   import models.notification.events.NotificationsCollectionEvent;
   
   import spark.components.Button;
   import spark.effects.CrossFade;
   import spark.effects.animation.RepeatBehavior;
   import spark.primitives.BitmapImage;
   
   import utils.locale.Localizer;
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   
   
   /**
    * Dispatched when any of custom notifications related properies have changed.
    * 
    * @eventType components.notifications.events.NotificationsButtonEvent.STATE_CHANGE
    */
   [Event(name="stateChange", type="components.notifications.events.NotificationsButtonEvent")]
   
   
   public class NotificationsButton extends Button
   {
      private static const NOTIFS:NotificationsCollection = ModelLocator.getInstance().notifications;
      private static const NEW_BLINK_DURATION: Number = 600;
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      public function NotificationsButton()
      {
         super();
         NOTIFS.addEventListener(
            NotificationsCollectionEvent.COUNTERS_UPDATED,
            notifications_countersUpdatedHandler
         );
         setStyle('skinClass', NotificationsButtonSkin);
         
      }
      
      protected override function partAdded(partName:String, instance:Object):void
      {
         super.partAdded(partName, instance);
         switch (instance)
         {
            case normalImage:
               fade = new CrossFade(normalImage);
               fade.bitmapFrom = ImagePreloader.getInstance().getImage(AssetNames.BUTTONS_IMAGE_FOLDER + 'notification_up');
               fade.bitmapTo = ImagePreloader.getInstance().getImage(AssetNames.BUTTONS_IMAGE_FOLDER + 'notification_important');
               fade.duration = NEW_BLINK_DURATION;
               fade.repeatBehavior = RepeatBehavior.REVERSE;
               fade.repeatCount = 0;
               updateLabel();
               addEventListener(MouseEvent.ROLL_OVER, function (e: MouseEvent): void
               {
                  fade.end();
               });
               addEventListener(MouseEvent.ROLL_OUT, function (e: MouseEvent): void
               {
                  updateLabel();
               });
               break;
         }
      }
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      [Bindable(event="notifsStateChange")]
      public function get playerHasUnreadNotifs() : Boolean
      {
         return NOTIFS.hasUnreadNotifs;
      }
      
      
      [Bindable(event="notifsStateChange")]
      public function get playerHasNewNotifs() : Boolean
      {
         return NOTIFS.hasNewNotifs;
      }
      
      
      [Bindable(event="notifsStateChange")]
      public function get noUnreadNotifs() : Boolean
      {
         return !(NOTIFS.hasNewNotifs || NOTIFS.hasUnreadNotifs);
      }
      
      
      [Bindable(event="notifsStateChange")]
      public function get unreadNotifsTotal() : int
      {
         return NOTIFS.unreadNotifsTotal;
      }
      
      
      [Bindable(event="notifsStateChange")]
      public function get newNotifsTotal() : int
      {
         return NOTIFS.newNotifsTotal;
      }
      
      [SkinPart (required='true')]
      public var normalImage: BitmapImage;
      
      private var fade: CrossFade;
      
      private function updateLabel() : void
      {
         if (playerHasNewNotifs)
         {
            label = getLabel("hasNew", newNotifsTotal);
            if (!fade.isPlaying)
            {
               fade.play();
            }
         }
         else if (playerHasUnreadNotifs)
         {
            if (fade.isPlaying)
            {
               fade.end();
            }
            label = getLabel("hasUnread", unreadNotifsTotal);
         }
         else
         { 
            if (fade.isPlaying)
            {
               fade.end();
            }
            label = getLabel("hasUnread", unreadNotifsTotal);
         }
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function getLabel(type:String, ... parameters) : String
      {
         return Localizer.string("Notifications", "label.notifications." + type, parameters);
      }
      
      
      /* ###################### */
      /* ### EVENT HANDLERS ### */
      /* ###################### */
      
      
      private function notifications_countersUpdatedHandler(event:NotificationsCollectionEvent) : void
      {
         dispatchStateChangeEvent();
         updateLabel();
      }
      
      
      /* ################################## */
      /* ### EVENTS DISPATCHING METHODS ### */
      /* ################################## */
      
      
      private function dispatchStateChangeEvent() : void
      {
         dispatchEvent(new NotificationsButtonEvent(NotificationsButtonEvent.STATE_CHANGE));
      }
   }
}