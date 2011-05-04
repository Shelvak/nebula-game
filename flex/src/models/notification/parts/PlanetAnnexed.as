package models.notification.parts
{
   import models.BaseModel;
   import models.location.Location;
   import models.notification.INotificationPart;
   import models.notification.Notification;
   import models.player.PlayerMinimal;
   
   import utils.locale.Localizer;
   
   public class PlanetAnnexed extends BaseModel implements INotificationPart
   {
      public function PlanetAnnexed(notif:Notification=null)
      {
         super();
         var params: Object = notif.params;
         oldPlayer = params.oldPlayer?BaseModel.createModel(PlayerMinimal, params.oldPlayer):null;
         newPlayer = params.newPlayer?BaseModel.createModel(PlayerMinimal, params.newPlayer):null;
         location = BaseModel.createModel(Location, params.planet);
      }
      
      public var oldPlayer: PlayerMinimal;
      
      public var newPlayer: PlayerMinimal;
      
      public var location: Location;
      
      public function get title() : String
      {
         if (won)
         {
            return Localizer.string("Notifications", "title.planetAnnexed.win");
         }
         else
         {
            return Localizer.string("Notifications", "title.planetAnnexed.lose");
         }
      }
      
      public function get won(): Boolean
      {
         return newPlayer && newPlayer.id == ML.player.id;
      }
      
      
      public function get message() : String
      {
         if (won)
         {
            return Localizer.string("Notifications", "message.planetAnnexed.win", [location.planetName]);
         }
         else
         {
            return Localizer.string("Notifications", "message.planetAnnexed.lose", [location.planetName]);
         }
      }
   }
}