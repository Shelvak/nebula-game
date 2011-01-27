package components.notifications.parts
{
   import components.location.MiniLocationComp;
   import components.notifications.IRNotificationPartBase;
   import components.notifications.parts.skins.BuildingsDeactivatedSkin;
   
   import models.notification.parts.BuildingsDeactivated;
   
   import spark.components.DataGroup;
   import spark.components.Label;
   
   
   public class IRBuildingsDeactivated extends IRNotificationPartBase
   {
      public function IRBuildingsDeactivated()
      {
         super();
         setStyle("skinClass", BuildingsDeactivatedSkin);
      };
      
      
      [SkinPart(required="true")]
      public var location:MiniLocationComp;
      
      
      [SkinPart(required="true")]
      public var buildings:DataGroup;
      
      
      [SkinPart(required="true")]
      public var message:Label;
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         if (fNotificationPartChange)
         {
            var part:BuildingsDeactivated = BuildingsDeactivated(notificationPart);
            buildings.dataProvider = part.buildings;
            location.location = part.location;
            message.text = part.message;
         }
         fNotificationPartChange = false;
      }
   }
}