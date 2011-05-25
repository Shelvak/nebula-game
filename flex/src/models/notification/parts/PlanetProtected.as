package models.notification.parts
{
   import models.BaseModel;
   import models.location.Location;
   import models.notification.INotificationPart;
   import models.notification.Notification;
   
   import utils.DateUtil;
   import utils.locale.Localizer;
   
   public class PlanetProtected extends BaseModel implements INotificationPart
   {
      //      # EVENT_PLANET_PROTECTED = 8
      //      #
      //      # params = {
      //         # :planet => ClientLocation#as_json,
      //         # :owner_id => Fixnum (ID of planet owner),
      //         # :duration => Fixnum (duration of protection)
      //      # }
      public function PlanetProtected(notif:Notification=null)
      {
         super();
         var params: Object = notif.params;
         owner = params.ownerId == ML.player.id;
         duration = DateUtil.secondsToHumanString(params.duration);
         endsAt = new Date(notif.createdAt.time);
         endsAt.setSeconds(params.duration + notif.createdAt.seconds);
         location = BaseModel.createModel(Location, params.planet);
      }
      
      public var owner: Boolean;
      
      public var endsAt: Date;
      
      public var duration: String;
      
      public var location: Location;
      
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
         if (owner)
         {
            return Localizer.string("Notifications", "label.planetProtected.yours", 
               [duration, endsAt.toString()]);
         }
         else
         {
            return Localizer.string("Notifications", "label.planetProtected.enemies", 
               [duration, endsAt.toString()]);
         }
      }
   }
}