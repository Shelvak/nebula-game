package components.notifications.parts
{
   import components.location.MiniLocationComp;
   import components.notifications.IRNotificationPartBase;
   import components.notifications.parts.skins.PlanetProtectedSkin;
   
   import models.notification.parts.PlanetProtected;
   
   import spark.components.Label;
   
   
   public class IRPlanetProtected extends IRNotificationPartBase
   {
      public function IRPlanetProtected()
      {
         super();
         setStyle("skinClass", PlanetProtectedSkin);
      };
      
      
      [SkinPart(required="true")]
      public var location:MiniLocationComp;
      
      [SkinPart(required="true")]
      public var lblInfo:Label;
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         if (fNotificationPartChange)
         {
            var part: PlanetProtected = PlanetProtected(notificationPart);
            location.location = part.location;
            lblInfo.text = part.labelText;
         }
         fNotificationPartChange = false;
      }
   }
}