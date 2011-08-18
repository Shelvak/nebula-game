package globalevents
{
   import models.building.Building;
   import models.resource.Resource;
   import models.healing.HealPrice;
   
   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;
   
   public class GHealingScreenEvent extends GlobalEvent
   {
      public static const HEALING_MAX_CHANGE: String = "healingMaxChange";
      
      public var freeStorage: int;
      
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