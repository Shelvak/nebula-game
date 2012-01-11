package models.notification.parts
{
   import config.Config;
   
   import controllers.alliances.AlliancesCommand;
   import controllers.alliances.actions.JoinActionParams;
   
   import flash.errors.IllegalOperationError;
   
   import models.ModelLocator;
   import models.alliance.MAlliance;
   import models.notification.INotificationPart;
   import models.notification.Notification;
   
   import utils.DateUtil;
   import utils.Objects;
   import utils.locale.Localizer;
   
   
   public class AllianceInvitation implements INotificationPart
   {
      private static const KEY_PART:String = "allianceInvitation";
      
      
      private function get ML() : ModelLocator
      {
         return ModelLocator.getInstance();
      }
      
      
      private var _notification:Notification;
      
      
      public function AllianceInvitation(notification:Notification)
      {
         super();
         _notification = Objects.paramNotNull("notification", notification);
         var alliance:Object = Objects.notNull(
            _notification.params.alliance, "[param notification.params.alliance] is required but was null"
         );
         allianceId = Objects.notNull(
            alliance.id, "[param notification.params.alliance.id] is required but was " + alliance.id
         );
         allianceName = Objects.notNull(
            alliance.name, "[param notification.params.alliance.name] is required but was " + alliance.name
         );
      }
      
      
      public function get title() : String
      {
         return getString("title." + KEY_PART);
      }
      
      
      public function get message() : String
      {
         return getString("message."  + KEY_PART, [allianceName]);
      }


       public function get innerMessage() : String
       {
           return getString("message."  + KEY_PART + (ML.player.canJoinAlliance
                     ? '.long'
                     : '.denied'),
                   [allianceName]);
       }
      
      
      public var allianceId:int;
      public var allianceName:String;
      
      
      private function getString(property:String, parameters:Array = null) : String
      {
         return Localizer.string("Notifications", property, parameters);
      }
      
      
      public function get joinRestrictionMessage() : String
      {
         if (ML.player.belongsToAlliance)
         {
            return getString(
               "message." + KEY_PART + ".alreadyInAlliance",
               [DateUtil.secondsToHumanString(Config.getAllianceLeaveCooldown())]
            );
         }
         else
         {
            return getString(
               "message." + KEY_PART + ".cooldown",
               [
                  DateUtil.secondsToHumanString(ML.player.allianceCooldown.occuresIn),
                  DateUtil.formatShortDateTime(ML.player.allianceCooldown.occuresAt)
               ]
            );
         }
      }
      
      
      public function joinAlliance() : void {
         if (ML.player.canJoinAlliance)
            new AlliancesCommand(AlliancesCommand.JOIN, new JoinActionParams(_notification.id)).dispatch();
         else {
            var errorMessage:String = "Unable to join the alliance '" + allianceName + "': "
            if (ML.player.belongsToAlliance)
               errorMessage += "player belongs to another alliance " + ML.player.allianceId;
            else
               errorMessage += "alliance cooldown is in effect until " + ML.player.allianceCooldown.occuresAt;
            throw new IllegalOperationError(errorMessage);
         }
      }
      
      /**
       * No-op.
       */
      public function updateLocationName(id:int, name:String) : void {}
   }
}