package globalevents
{
   import models.resource.Resource;
   
   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;
   
   public class GUnitsScreenEvent extends GlobalEvent
   {
      public static const FACILITY_OPEN: String = "facilityOpen";
      
      public static const SET_STANCE: String = "unitsStanceSet";
      
      public static const DESELECT_UNITS: String = "unitsDeselect";
      
      public static const SELECT_ALL: String = "selectAllUnits";
      
      public static const OPEN_STORAGE_SCREEN: String = "openStorageScreen";
      
      public static const REFRESH_SIDEBAR: String = "refreshSidebar";
      
      
      public var facilityId: int;
      
      public var unitsHash: Object;
      
      public var stance: int;
      
      public var units: Array;
      
      public var unitsCollection: ListCollectionView;
      
      public var landUnitsCollection: ListCollectionView;
      
      public var storedUnitsCollection: ListCollectionView;
      
      public var destination: *;
      
      public var location: *;
      
      public var hasChanges: Boolean;
      
      public var currentKind: String;
      
      public var storedResources: Resource;
      
      public var storedItems: ArrayCollection;
      
      public var owner: int;
      
      public var avoid: Boolean;
      
      public function GUnitsScreenEvent(type:String, params: * = null, eagerDispatch:Boolean=true)
      {
         switch (type)
         {
            case (FACILITY_OPEN):
               facilityId = params;
               break;
            case (SET_STANCE):
               stance = params;
               break;
            case (OPEN_STORAGE_SCREEN):
               location = params.location;
               destination = params.oldLocation;
               unitsCollection = params.oldUnits;
               break;
         }
         super(type, eagerDispatch);
      }
   }
}