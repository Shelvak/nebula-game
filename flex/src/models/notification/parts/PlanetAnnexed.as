package models.notification.parts
{
   import components.notifications.parts.IRCombatLog;
   
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
         location = BaseModel.createModel(Location, params.planet);
         owner = params.owner?BaseModel.createModel(PlayerMinimal, params.owner):null;
         //if outcome is null this means there was no battle fought
         outcome = params.outcome==null?-1:params.outcome;
      }
      
      public var outcome: int;
      
      public var owner: PlayerMinimal;
      
      public var location: Location;
      
      public function updateLocationName(id:int, name:String) : void {
         Location.updateName(location, id, name);
      }
      
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
         return outcome == CombatOutcomeType.WIN || outcome == CombatOutcomeType.NO_COMBAT;
      }
      
      public function get notifText(): String
      {
         if (won)
         {
            if (owner != null)
            {
               return Localizer.string("Notifications", "label.planetAnnexed.win1");
            }
            else
            {
               if (outcome == CombatOutcomeType.NO_COMBAT)
               {
                  return Localizer.string("Notifications", "label.planetAnnexed.emptyWin",
                     [location.planetName]);
               }
               else
               {
                  return Localizer.string("Notifications", "label.planetAnnexed.npcWin",
                     [location.planetName]);
               }
            }
         }
         else
         {
            if (owner != null && owner.id == ML.player.id)
            {
               return Localizer.string("Notifications", "label.planetAnnexed.selfLose",
                  [location.planetName]);
            }
            else
            {
               return Localizer.string("Notifications", "label.planetAnnexed.allyLose",
                  [location.planetName]);
            }
         }
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