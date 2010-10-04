package models.notification
{
   public interface INotificationPart
   {
      /**
       * Custom title of notification.
       */
      function get title():String;
      
      /**
       * Custom message (description) of notification.
       */ 
      function get message() : String;
   }
}