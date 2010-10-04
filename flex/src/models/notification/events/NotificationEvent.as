package models.notification.events
{
   import flash.events.Event;
   
   public class NotificationEvent extends Event
   {
      public static const STARRED_CHANGE:String = "starredChange";
      public static const READ_CHANGE:String = "readChange";
      public static const ISNEW_CHANGE:String = "isNewChange";
      
      
      public function NotificationEvent(type:String)
      {
         super(type, false, false);
      }
   }
}