/**
 * Created with IntelliJ IDEA.
 * User: jho
 * Date: 7/2/12
 * Time: 2:47 PM
 * To change this template use File | Settings | File Templates.
 */
package models.notification.parts
{
   import models.BaseModel;
   import models.location.Location;
   import models.notification.INotificationPart;
   import models.notification.Notification;
   import models.player.PlayerMinimal;

   import utils.Objects;
   import utils.locale.Localizer;

   public class AllyReinitiateCombat extends BaseModel implements INotificationPart
   {
      public function AllyReinitiateCombat(notif:Notification=null)
      {
         super();
         var params:Object = notif.params;
         location = Objects.create(Location, params["planet"]);
         reinitiator = Objects.create(PlayerMinimal, params["reinitiator"]);
      }

      public var reinitiator: PlayerMinimal;

      public var location: Location;

      public function updateLocationName(id:int, name:String) : void {
         Location.updateName(location, id, name);
      }

      public function get title() : String
      {
         return Localizer.string("Notifications", "title.allyReinitiateCombat");
      }

      public function get message() : String
      {
         return Localizer.string("Notifications", "message.allyReinitiateCombat",
            [location.name]);
      }

      public function get content() : String
      {
         return Localizer.string('Notifications', 'label.allyReinitiateCombat',
            [reinitiator.name]);
      }
   }
}