package globalevents
{
   import models.building.Building;
   import models.resource.Resource;
   import models.unit.HealPrice;
   
   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;
   
   public class GHealingScreenEvent extends GlobalEvent
   {
      public static const DESELECT_UNITS: String = "healingUnitsDeselect";
      
      public static const SELECT_ALL: String = "selectAllHealingUnits";
      
      public static const OPEN_SCREEN: String = "openHealingUnloadScreen";
      
      public static const REFRESH_SIDEBAR: String = "refreshHealingSidebar";
      
      public static const HEALING_CONFIRMED: String = "healingConfirmed";
      
      public static const HEALING_MAX_CHANGE: String = "healingMaxChange";
      
      public static const HEAL_APPROVED: String = "healingApproved";
      
      public var units: Array;
      
      public var unitsCollection: ListCollectionView;
      
      public var location: Building;
      
      public var freeStorage: int;
      
      public var price: HealPrice;
      
      public function GHealingScreenEvent(type:String, params: * = null, eagerDispatch:Boolean=true)
      {
         switch (type)
         {
            case (OPEN_SCREEN):
               location = params.location;
               unitsCollection = params.units;
               break;
            case (REFRESH_SIDEBAR):
               location = params.location;
               price = params.price;
               break;
            case (HEALING_MAX_CHANGE):
               freeStorage = params;
               break;
         }
         super(type, eagerDispatch);
      }
   }
}