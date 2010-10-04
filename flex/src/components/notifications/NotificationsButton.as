package components.notifications
{
   import components.notifications.events.NotificationsButtonEvent;
   
   import models.ModelLocator;
   import models.notification.NotificationsCollection;
   import models.notification.events.NotificationsCollectionEvent;
   
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
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      public function NotificationsButton()
      {
         NOTIFS.addEventListener(
            NotificationsCollectionEvent.COUNTERS_UPDATED,
            notifications_countersUpdatedHandler
         );
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
      
      
      private function updateLabel() : void
      {
         if (playerHasNewNotifs)
         {
            label = getLabel("hasNew", unreadNotifsTotal, newNotifsTotal);
         }
         else if (playerHasUnreadNotifs)
         {
            label = getLabel("hasUnread", unreadNotifsTotal);
         }
         else
         {
            label = getLabel("normal");
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