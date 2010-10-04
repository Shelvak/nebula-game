package components.notifications.parts
{
   import components.location.CLocation;
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
      
      
      /* ############ */
      /* ### SKIN ### */
      /* ############ */
      
      
      [SkinPart(required="true")]
      public var location:CLocation;
      private function setLocationModel() : void
      {
         if (location)
         {
            location.location = buildingsDeactivated.location;
         }
      };
      
      
      [SkinPart(required="true")]
      public var buildings:DataGroup;
      private function setBuildingsDataProvider() : void
      {
         if (buildings)
         {
            buildings.dataProvider = buildingsDeactivated.buildings;
         }
      };
      
      
      [SkinPart(required="true")]
      public var message:Label;
      private function setMessageText() : void
      {
         if (message)
         {
            message.text = buildingsDeactivated.message;
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
            
            case buildings:
               setBuildingsDataProvider();
               break;
            
            case message:
               setMessageText();
               break;
         }
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function get buildingsDeactivated() : BuildingsDeactivated
      {
         return notificationPart as BuildingsDeactivated;
      }
      
      
      protected override function commitProperties() : void
      {
         super.commitProperties();
         if (fNotificationPartChange)
         {
            setBuildingsDataProvider();
            setLocationModel();
            setMessageText();
         }
         fNotificationPartChange = false;
      }
   }
}