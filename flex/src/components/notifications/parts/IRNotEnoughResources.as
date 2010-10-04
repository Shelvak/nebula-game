package components.notifications.parts
{
   import components.location.CLocation;
   import components.notifications.IRNotificationPartBase;
   import components.notifications.parts.skins.NotEnoughResourcesSkin;
   
   import models.notification.parts.NotEnoughResources;
   
   import mx.collections.ArrayCollection;
   
   import spark.components.DataGroup;
   import spark.components.Label;
   
   
   [ResourceBundle("Notifications")]
   
   
   public class IRNotEnoughResources extends IRNotificationPartBase
   {
      public function IRNotEnoughResources()
      {
         super();
         setStyle("skinClass", NotEnoughResourcesSkin);
      };
      
      
      /* ############ */
      /* ### SKIN ### */
      /* ############ */
      
      
      [SkinPart(required="true")]
      public var location:CLocation;
      private function setLocationModel() : void
      {
         if (location)
         {
            location.location = notEnoughResources.location;
         }
      };
      
      
      [SkinPart(required="true")]
      public var constructables:DataGroup;
      private function setConstructablesDataProvider() : void
      {
         if (constructables)
         {
            constructables.dataProvider = notEnoughResources.constructables;
         }
      };
      
      
      [SkinPart(required="true")]
      public var message:Label;
      private function setMessageText() : void
      {
         if (message)
         {
            message.text = notEnoughResources.message;
         }
      };
      
      
      [SkinPart(required="true")]
      public var constructor:RingWithImage;
      private function setConstructorImage() : void
      {
         if (constructor)
         {
         }
      }
      
      
      protected override function partAdded(partName:String, instance:Object):void
      {
         super.partAdded(partName, instance);
         switch(instance)
         {
            case location:
               setLocationModel();
               break;
            
            case constructables:
               setConstructablesDataProvider();
               break;
            
            case message:
               setMessageText();
               break;
            
            case constructor:
               setConstructorImage();
               break;
         }
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function get notEnoughResources() : NotEnoughResources
      {
         return notificationPart as NotEnoughResources;
      }
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         if (fNotificationPartChange)
         {
            setConstructablesDataProvider();
            setLocationModel();
            setMessageText();
            setConstructorImage();
         }
         fNotificationPartChange = false;
      }
   }
}