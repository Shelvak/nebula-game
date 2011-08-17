package globalevents
{
   import models.resource.Resource;
   
   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;
   
   public class GLoadUnloadScreenEvent extends GlobalEvent
   {
      public static const DESELECT_UNITS: String = "loadUnitsDeselect";
      
      public static const SELECT_ALL: String = "selectAllLoadUnits";
      
      public static const SELECT_ALL_RESOURCES: String = "selectAllLoadResources";
      
      public static const DESELECT_ALL_RESOURCES: String = "deselectAllLoadResources";
      
      public static const REFRESH_SIDEBAR: String = "refreshLoadUnloadSidebar";
      
      public static const TRANSFER_CONFIRMED: String = "transferConfirmed";
      
      public var units: Array;
      
      public var unitsCollection: ListCollectionView;
      
      public var destination: *;
      
      public var location: *;
      
      public var storedResources: Resource;
      
      public var storedItems: ArrayCollection;
      public var storingResources: Boolean;
      
      public function GLoadUnloadScreenEvent(type:String, params: * = null, eagerDispatch:Boolean=true)
      {
         switch (type)
         {
            case (REFRESH_SIDEBAR):
               location = params.location;
               destination = params.target;
               storingResources = params.transferingResources;
               break;
         }
         super(type, eagerDispatch);
      }
   }
}