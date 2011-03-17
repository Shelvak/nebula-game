package models.notification.parts
{
   import models.BaseModel;
   import models.location.Location;
   import models.notification.INotificationPart;
   import models.player.PlayerMinimal;
   
   import utils.Localizer;
   
   public class PlanetAnnexed extends BaseModel implements INotificationPart
   {
      public function PlanetAnnexed(params:Object=null)
      {
         super();
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