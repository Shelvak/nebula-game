package models.notification.parts
{
   import models.BaseModel;
   import models.location.Location;
   import models.notification.INotificationPart;
   import models.notification.Notification;
   
   import utils.DateUtil;
   import utils.Objects;
   import utils.locale.Localizer;
   
   public class PlanetProtected extends BaseModel implements INotificationPart
   {
      //      # EVENT_PLANET_PROTECTED = 8
      //      #
      //      # params = {
      //         # :planet => ClientLocation#as_json,
      //         # :owner_id => Fixnum (ID of planet owner),
      //         # :duration => Fixnum (duration of protection)
      //         # :outcome => Fixnum (what was the outcome of that battle for you)
      //      # }
      public function PlanetProtected(notif:Notification=null)
      {
         super();
         var params: Object = notif.params;
         owner = params.ownerId == ML.player.id;
         duration = DateUtil.secondsToHumanString(params.duration);
         endsAt = new Date(notif.createdAt.time);
         endsAt.setSeconds(params.duration + notif.createdAt.seconds);
         location = Objects.create(Location, params.planet);
         outcome = params.outcome;
      }
      
      public var outcome: int;
      
      public var owner: Boolean;
      
      public var endsAt: Date;
      
      public var duration: String;
      
      public var location: Location;
      
      public function updateLocationName(id:int, name:String) : void {
         Location.updateName(location, id, name);
      }
      
      public function get title() : String
      {
         return Localizer.string("Notifications", "title.planetProtected");
      }
      
      public function get message() : String
      {
         return Localizer.string("Notifications", "message.planetProtected");
      }
      
      public function get labelText() : String
      {
         if (outcome == CombatOutcomeType.LOOSE)
         {
            if (owner)
            {
               return Localizer.string("Notifications", "label.planetProtected.yours", 
                  [duration, endsAt.toString()]);
            }
            else
            {
               return Localizer.string("Notifications", "label.planetProtected.ally", 
                  [duration, endsAt.toString()]);
            }
         }
         else
         {
            return Localizer.string("Notifications", "label.planetProtected.enemies", 
               [duration, endsAt.toString()]);
         }
      }
   }
}