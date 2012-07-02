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

   public class PlanetBossSpawn extends BaseModel implements INotificationPart
   {
      public function PlanetBossSpawn(notif:Notification=null)
      {
         super();
         var params:Object = notif.params;
         location  = Objects.create(Location, params["planet"]);
         spawner     = Objects.create(PlayerMinimal, params["spawner"]);
      }

      public var spawner: PlayerMinimal;

      public var location: Location;

      public function updateLocationName(id:int, name:String) : void {
         Location.updateName(location, id, name);
      }

      public function get title() : String
      {
         return Localizer.string("Notifications", "title.planetBossSpawn");
      }

      public function get message() : String
      {
         return Localizer.string("Notifications", "message.planetBossSpawn",
                     [location.name]);
      }

      public function get content() : String
      {
         return Localizer.string('Notifications', 'label.planetBossSpawn',
                     [spawner.name]);
      }
   }
}