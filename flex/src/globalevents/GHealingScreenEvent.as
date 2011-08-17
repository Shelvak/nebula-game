package globalevents
{
   import models.building.Building;
   import models.resource.Resource;
   import models.healing.HealPrice;
   
   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;
   
   public class GHealingScreenEvent extends GlobalEvent
   {
      public static const DESELECT_UNITS: String = "HealingUnitsDeselect";
      
      public static const HEALING_MAX_CHANGE: String = "healingMaxChange";
      
      public static const SELECTION_UPDATED: String = "healingSelectionUpdated";
      
      public var units: Array;
      
      public var unitsCollection: ListCollectionView;
      
      public var location: Building;
      
      public var freeStorage: int;
      
      public var price: HealPrice;
      
      public function GHealingScreenEvent(type:String, params: * = null, eagerDispatch:Boolean=true)
      {
         switch (type)
         {
            case (HEALING_MAX_CHANGE):
               freeStorage = params;
               break;
         }
         super(type, eagerDispatch);
      }
   }
}