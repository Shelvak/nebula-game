package globalevents
{
   import models.resource.Resource;
   
   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;
   
   public class GUnitsScreenEvent extends GlobalEvent
   {
      public static const MANAGE_UNITS: String = 'manageUnits';
      
      public static const FACILITY_OPEN: String = "facilityOpen";
      
      public static const UNITS_UPDATED: String = "unitsUpdated";
      
      public static const SET_STANCE: String = "unitsStanceSet";
      
      public static const DESELECT_UNITS: String = "unitsDeselect";
      
      public static const SELECT_ALL: String = "selectAllUnits";
      
      public static const DESTROY_UNIT: String = "unitDestroy";
      
      public static const OPEN_SCREEN: String = "openScreen";
      
      public static const OPEN_STORAGE_SCREEN: String = "openStorageScreen";
      
      public static const ORDER_CONFIRMED: String = "orderConfirmed";
      
      public static const FORMATION_CONFIRMED: String = "formationConfirmed";
      
      public static const FORMATION_CANCELED: String = "formationCanceled";
      
      public static const REFRESH_SIDEBAR: String = "refreshSidebar";
      
      public static const SELECTION_PRECHANGE: String = "selectionWillChange";
      
      public static const SWITCH_TO_STORAGE_SCREEN: String = "switchToStorageInitiated";
      
      
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
            case (UNITS_UPDATED):
               unitsHash = params;
               break;
            case (SET_STANCE):
               stance = params;
               break;
            case (DESTROY_UNIT):
               units = params;
               break;
            case (OPEN_SCREEN):
               destination = params.target;
               location = params.location;
               unitsCollection = params.units;
               currentKind = params.kind;
               owner = params.owner;
               break;
            case (OPEN_STORAGE_SCREEN):
               location = params.location;
               destination = params.oldLocation;
               unitsCollection = params.oldUnits;
               break;
            case (REFRESH_SIDEBAR):
               units = params.selection;
               hasChanges = params.hasChanges;
               currentKind = params.currentKind;
               location = params.location;
               destination = params.target;
               owner = params.owner;
               break;
            case (SWITCH_TO_STORAGE_SCREEN):
               location = params;
               break;
            case (MANAGE_UNITS):
               unitsCollection = params;
               break;
            case (ORDER_CONFIRMED):
               avoid = params;
               break;
         }
         super(type, eagerDispatch);
      }
   }
}