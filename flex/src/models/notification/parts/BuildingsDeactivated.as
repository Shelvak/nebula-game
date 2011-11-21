package models.notification.parts
{
   import controllers.objects.ObjectClass;
   
   import models.BaseModel;
   import models.location.Location;
   import models.notification.INotificationPart;
   import models.notification.Notification;
   import models.unit.UnitBuildingEntry;
   
   import mx.collections.ArrayCollection;
   
   import utils.ModelUtil;
   import utils.Objects;
   import utils.locale.Localizer;
   
   
   public class BuildingsDeactivated extends BaseModel implements INotificationPart
   {
      /**
       * Constructor.
       * 
       * @param params <pre>
       * {
       * &nbsp;&nbsp;location: {models.Location},
       * &nbsp;&nbsp;buildings: {
       * &nbsp;&nbsp;&nbsp;&nbsp;// type => count
       * &nbsp;&nbsp;&nbsp;&nbsp;"ZetiumExtractor": 1,
       * &nbsp;&nbsp;&nbsp;&nbsp;"MetalExtractor": 3
       * &nbsp;&nbsp;}
       * }
       * </pre>
       */
      public function BuildingsDeactivated(notif:Notification = null)
      {
         super();
         if (notif != null)
         {
            var params: Object = notif.params;
            location = Objects.create(Location, params.location);
            buildings = new ArrayCollection();
            for (var type:String in params.buildings)
            {
               buildings.addItem(
                  new UnitBuildingEntry(
                     ModelUtil.getModelType(ObjectClass.BUILDING, type),
                     params.buildings[type]
                  )
               );
            }
         }
      }
      
      
      public function get title() : String
      {
         return Localizer.string("Notifications", "title.buildingsDeactivated");
      }
      
      
      public function get message() : String
      {
         return Localizer.string("Notifications", "message.buildingsDeactivated");
      }
      
      
      public var location:Location;
      public var buildings:ArrayCollection;
      
      public function updateLocationName(id:int, name:String) : void {
         Location.updateName(location, id, name);
      }
   }
}