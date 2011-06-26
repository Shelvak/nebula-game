package models.notification.parts
{
   import models.BaseModel;
   import models.alliance.MAllianceMinimal;
   import models.notification.INotificationPart;
   import models.notification.Notification;
   import models.player.PlayerMinimal;
   
   import utils.locale.Localizer;
   
   
   public class AllianceJoined implements INotificationPart
   {
      private var _player:PlayerMinimal;
      private var _alliance:MAllianceMinimal;
      
      public function AllianceJoined(notif:Notification = null) {
         super();
         if (notif != null)
         {
            var params:Object = notif.params;
            _player = BaseModel.createModel(PlayerMinimal, params["player"]);
            _alliance = BaseModel.createModel(MAllianceMinimal, params["alliance"]);
         }
      }
      
      public function get title() : String {
         return getString("title");
      }
      
      public function get message() : String {
         return getString("message", [_player.name, _alliance.name]);
      }
      
      public function get content() : String {
         return getString("content", [_player.name, _alliance.name]);
      }
      
      private function getString(property:String, parameters:Array = null) : String {
         return Localizer.string("Notifications", property + ".allianceJoined", parameters);
      }
   }
}