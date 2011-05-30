package components.notifications.parts
{
   import components.location.CLocation;
   import components.location.MiniLocationComp;
   import components.notifications.IRNotificationPartBase;
   import components.notifications.parts.skins.NotEnoughResourcesSkin;
   
   import models.notification.parts.NotEnoughResources;
   
   import spark.components.DataGroup;
   import spark.components.Label;
   
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   
   
   public class IRNotEnoughResources extends IRNotificationPartBase
   {
      public function IRNotEnoughResources()
      {
         super();
         setStyle("skinClass", NotEnoughResourcesSkin);
      };
      
      
      [SkinPart(required="true")]
      public var location:MiniLocationComp;
      
      
      [SkinPart(required="true")]
      public var constructables:DataGroup;
      
      
      [SkinPart(required="true")]
      public var message:Label;
      
      
      [SkinPart(required="true")]
      public var constructor:RingWithImage;
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         if (f_NotificationPartChange)
         {
            var part:NotEnoughResources = NotEnoughResources(notificationPart); 
            constructables.dataProvider = part.constructables;
            location.location = part.location;
            message.text = part.message;
            constructor.imageData =
               ImagePreloader.getInstance().getImage(AssetNames.getBuildingImageName(part.constructorType));
         }
         f_NotificationPartChange = false;
      }
   }
}