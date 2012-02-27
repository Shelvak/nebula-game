/**
 * Created by IntelliJ IDEA.
 * User: Jho
 * Date: 2/24/12
 * Time: 1:26 PM
 * To change this template use File | Settings | File Templates.
 */
package models.notification.parts
{
   import models.BaseModel;
   import models.notification.INotificationPart;
   import models.notification.Notification;

   import utils.locale.Localizer;


   public class PlayerAttached extends BaseModel implements INotificationPart
   {
      public function PlayerAttached(notif:Notification = null)
      {
         super();
      }


      public function get title() : String
      {
         return Localizer.string("Notifications", "title.playerAttached");
      }

      public function get message() : String
      {
         return Localizer.string("Notifications", "message.playerAttached");
      }

      /**
       * No-op.
       */
      public function updateLocationName(id:int, name:String) : void {}
   }
}