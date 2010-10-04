package components.notifications.events
{
   import flash.events.Event;
   
   public class NotificationsButtonEvent extends Event
   {
      /**
       * @eventType notifsStateChange
       * 
       * @see components.notifications.NotificationsButton
       */      
      public static const STATE_CHANGE:String = "notifsStateChange";
      
      
      public function NotificationsButtonEvent(type:String)
      {
         super(type, false, false);
      }
   }
}