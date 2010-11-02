package models.notification.parts
{
   import models.BaseModel;
   import models.building.Building;
   import models.location.Location;
   import models.notification.INotificationPart;
   import models.unit.UnitBuildingEntry;
   
   import mx.collections.ArrayCollection;
   
   
   [ResourceBundle("Notifications")]
   public class NotEnoughResources extends BaseModel implements INotificationPart
   {
      /**
       * Constructor.
       * 
       * @param params <pre>
       * {
       * &nbsp;&nbsp;location: {models.location.Location},
       * &nbsp;&nbsp;constructables: {
       * &nbsp;&nbsp;&nbsp;&nbsp;// constructable.type => count
       * &nbsp;&nbsp;&nbsp;&nbsp;"Unit::Trooper": 2
       * &nbsp;&nbsp;&nbsp;&nbsp;"Unit::Barracks": 1
       * &nbsp;&nbsp;}
       * &nbsp;&nbsp;constructor: {models.building.Building}
       * }
       * </pre>
       */
      public function NotEnoughResources(params:Object = null)
      {
         super();
         if (params != null)
         {
            location = BaseModel.createModel(Location, params.location);
            constructor = BaseModel.createModel(Building, params.constructor);
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
         return RM.getString("Notifications", "title.notEnoughResources");
      }
      
      
      public function get message() : String
      {
         return RM.getString("Notifications", "message.notEnoughResources");
      }
      
      
      public var constructables:ArrayCollection;
      public var location:Location;
      public var constructor:Building;
   }
}