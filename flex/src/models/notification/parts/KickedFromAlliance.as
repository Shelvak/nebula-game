package models.notification.parts
{
   import models.BaseModel;
   import models.alliance.MAlliance;
   import models.alliance.MAllianceMinimal;
   import models.notification.INotificationPart;
   import models.notification.Notification;
   
   import utils.locale.Localizer;
   
   
   public class KickedFromAlliance extends BaseModel implements INotificationPart
   { 
      public function KickedFromAlliance(notif:Notification = null)
      {
         super();
         if (notif != null)
         {
            alliance = BaseModel.createModel(MAllianceMinimal, notif.params);
         }
      }
      
      public var alliance: MAllianceMinimal;
      
      public function get title() : String
      {
         return Localizer.string("Notifications", "title.kickedFromAlliance");
      }
      
      public function get message() : String
      {
         return Localizer.string("Notifications", "message.kickedFromAlliance",
         [alliance.name]);
      }
      
      /**
       * No-op.
       */
      public function updateLocationName(id:int, name:String) : void {}
   }
}