package models.notification
{
   import models.location.ILocationUser;

   public interface INotificationPart extends ILocationUser
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