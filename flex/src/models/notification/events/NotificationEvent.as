package models.notification.events
{
   import flash.events.Event;
   
   public class NotificationEvent extends Event
   {
      /**
       * Dispatched when <code>Notification.starred</code> property changed.
       */
      public static const STARRED_CHANGE:String = "starredChange";
      
      /**
       * Dispatched when <code>Notification.read</code> property changed.
       */
      public static const READ_CHANGE:String = "readChange";
      
      /**
       * Dispatched when <code>Notification.isNew</code> property changed.
       */
      public static const IS_NEW_CHANGE:String = "isNewChange";
      
      /**
       * Dispatched when <code>Notification.message</code> property changed.
       */
      public static const MESSAGE_CHANGE:String = "messageChange";
      
      
      public function NotificationEvent(type:String)
      {
         super(type, false, false);
      }
   }
}