package components.notifications.parts
{
   import components.notifications.IRNotificationPartBase;
   import components.notifications.parts.skins.AllianceJoinedSkin;
   
   import models.notification.parts.AllianceJoined;
   
   import spark.components.Label;
   
   
   public class IRAllianceJoined extends IRNotificationPartBase
   {
      public function IRAllianceJoined() {
         super();
         setStyle("skinClass", AllianceJoinedSkin);
      }
      
      [SkinPart(required="true")]
      public var lblContent:Label;
      
      protected override function commitProperties() : void {
         super.commitProperties();
         if (f_NotificationPartChange)
            lblContent.text = AllianceJoined(notificationPart).content;
         f_NotificationPartChange = false;
      }
   }
}