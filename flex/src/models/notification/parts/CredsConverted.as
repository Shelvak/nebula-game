package models.notification.parts
{
   import models.notification.INotificationPart;
   import models.notification.Notification;

   import utils.locale.Localizer;
   
   
   public class CredsConverted implements INotificationPart
   {
      
      public function CredsConverted(notif:Notification = null) {
         super();
         if (notif != null)
         {
            var params:Object = notif.params;
            personalCreds = params['personalCreds'];
            totalAllianceCreds = params['totalAllianceCreds'];
            allianceCredsPerPlayer = params['allianceCredsPerPlayer'];
         }
      }

      public var personalCreds: int = 0;
      public var totalAllianceCreds: int = 0;
      public var allianceCredsPerPlayer: int = 0;
      
      public function get title() : String {
         return getString("title");
      }
      
      public function get message() : String {
         return getString("message");
      }

      public function get content() : String {
         return getString("label");
      }

      /**
       * No-op.
       */
      public function updateLocationName(id:int, name:String) : void {}

      private function getString(property:String, parameters:Array = null) : String {
         return Localizer.string("Notifications", property + '.credsConverted');
      }
   }
}