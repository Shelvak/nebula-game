package globalevents
{
   import models.resource.Resource;
   
   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;
   
   public class GLoadUnloadScreenEvent extends GlobalEvent
   {
      public static const DESELECT_UNITS: String = "loadUnitsDeselect";
      
      public static const SELECT_ALL: String = "selectAllLoadUnits";
      
      public static const OPEN_SCREEN: String = "openLoadUnloadScreen";
      
      public static const REFRESH_SIDEBAR: String = "refreshLoadUnloadSidebar";
      
      public static const TRANSFER_CONFIRMED: String = "transferConfirmed";
      
      public static const CLOSE_REQUESTED: String = "closeLoadRequested";
      
      public static const FREE_STORAGE_CHANGE: String = "freeStorageChange";
      
      public var units: Array;
      
      public var unitsCollection: ListCollectionView;
      
      public var destination: *;
      
      public var location: *;
      
      public var storedResources: Resource;
      
      public var storedItems: ArrayCollection;
      
      public var freeStorage: int;
      
      public function GLoadUnloadScreenEvent(type:String, params: * = null, eagerDispatch:Boolean=true)
      {
         switch (type)
         {
            case (OPEN_SCREEN):
               location = params.location;
               destination = params.target;
               unitsCollection = params.units;
               break;
            case (REFRESH_SIDEBAR):
               location = params.location;
               destination = params.target;
               break;
            case (FREE_STORAGE_CHANGE):
               freeStorage = params;
               break;
         }
         super(type, eagerDispatch);
      }
   }
}