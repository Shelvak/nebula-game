package models.notification.parts
{
   import models.BaseModel;
   import models.location.Location;
   import models.notification.INotificationPart;
   import models.notification.Notification;
   import models.unit.UnitBuildingEntry;
   
   import mx.collections.ArrayCollection;
   
   import utils.locale.Localizer;
   
   
   public class NotEnoughResources extends BaseModel implements INotificationPart
   {
      public function NotEnoughResources(notif:Notification = null)
      {
         super();
         if (notif != null)
         {
            var params: Object = notif.params;
            location = BaseModel.createModel(Location, params.location);
            constructorType = params.constructorType;
            constructables = new ArrayCollection();
            for (var type:String in params.constructables)
            {
               constructables.addItem(new UnitBuildingEntry(
                  type, params.constructables[type], location.terrain
               ));
            }
         }
      }
      
      
      public function get title() : String
      {
         return Localizer.string("Notifications", "title.notEnoughResources");
      }
      
      
      public function get message() : String
      {
         return Localizer.string("Notifications", "message.notEnoughResources");
      }
      
      
      public var constructables:ArrayCollection;
      public var location:Location;
      public var constructorType:String;
   }
}