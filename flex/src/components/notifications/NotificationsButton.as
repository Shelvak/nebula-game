package components.notifications
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   
   import components.notifications.events.NotificationsButtonEvent;
   import components.skins.NotificationsButtonSkin;
   
   import models.ModelLocator;
   import models.notification.NotificationsCollection;
   import models.notification.events.NotificationsCollectionEvent;
   
   import mx.effects.Tween;
   
   import spark.components.Button;
   
   
   /**
    * Dispatched when any of custom notifications related properies have changed.
    * 
    * @eventType components.notifications.events.NotificationsButtonEvent.STATE_CHANGE
    */
   [Event(name="stateChange", type="components.notifications.events.NotificationsButtonEvent")]
   
   
   [ResourceBundle("Notifications")]
   
   
   public class NotificationsButton extends Button
   {
      private static const NOTIFS:NotificationsCollection = ModelLocator.getInstance().notifications;
      
      private static const UNREAD_COLOR: uint = 0xffea05;
      private static const NORMAL_COLOR: uint = 0xffffff;
      public static const NEW_COLORS_GRADIENT: Array = [0xffffff, 0xFFEBEA, 0xF7D0CD, 0xF7B6B2, 0xF48D86, 0xF4675D, 0xF23F32, 0xf01000];
      private static const NEW_BLINK_DURATION: Number = 0.6;
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      public function NotificationsButton()
      {
         NOTIFS.addEventListener(
            NotificationsCollectionEvent.COUNTERS_UPDATED,
            notifications_countersUpdatedHandler
         );
         setStyle('skinClass', NotificationsButtonSkin);
         updateLabel();
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
      public function get unreadNotifsTotal() : int
      {
         return NOTIFS.unreadNotifsTotal;
      }
      
      
      [Bindable(event="notifsStateChange")]
      public function get newNotifsTotal() : int
      {
         return NOTIFS.newNotifsTotal;
      }
      
      [Bindable]
      public var labelColor: uint;
      
      [Bindable]
      public var newColorIndex: int = -1;
      
      private var newTween: TweenLite = null;
      
      private var blink: Boolean = false;
      
      private function handleTweenComplete (): void
      {
         newTween.kill();
         if (blink)
         {
            newTween = new TweenLite(this, NEW_BLINK_DURATION, {'onComplete': handleTweenComplete, 
               'newColorIndex': NEW_COLORS_GRADIENT.length - 1,
               "ease": Linear.easeNone});
            blink = false;
         }
         else
         {
            newTween = new TweenLite(this, NEW_BLINK_DURATION, {'onComplete': handleTweenComplete, 
               'newColorIndex': 0,
               "ease": Linear.easeNone});
            blink = true;
         }
      }
      
      private function updateLabel() : void
      {
         if (newTween != null)
         {
            newTween.kill();
            newTween = null;
         }
         if (playerHasNewNotifs)
         {
            newColorIndex = 0;
            labelColor = NEW_COLORS_GRADIENT[newColorIndex];
            label = getLabel("hasNew", newNotifsTotal);
            
            if (newTween == null)
            {
               blink = false;
               newTween = new TweenLite(this, NEW_BLINK_DURATION, {"onComplete" : handleTweenComplete,
                  'newColorIndex': NEW_COLORS_GRADIENT.length - 1,
                  "ease": Linear.easeNone});
            }
            
         }
         else if (playerHasUnreadNotifs)
         {
            newColorIndex = -1;
            labelColor = UNREAD_COLOR;
            label = getLabel("hasUnread", unreadNotifsTotal);
         }
         else
         { 
            newColorIndex = -1;
            labelColor = NORMAL_COLOR;
            label = getLabel("normal", NOTIFS.notifsTotal);
         }
         invalidateSize();
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function getLabel(type:String, ... parameters) : String
      {
         return resourceManager.getString("Notifications", "label.notifications." + type, parameters);
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