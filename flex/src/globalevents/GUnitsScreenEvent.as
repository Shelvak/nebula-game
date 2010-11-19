package globalevents
{
   import mx.collections.ListCollectionView;
   
   public class GUnitsScreenEvent extends GlobalEvent
   {
      public static const FACILITY_OPEN: String = "facilityOpen";
      
      public static const UNITS_UPDATED: String = "unitsUpdated";
      
      public static const SET_STANCE: String = "unitsStanceSet";
      
      public static const DESELECT_UNITS: String = "unitsDeselect";
      
      public static const SELECT_ALL: String = "selectAllUnits";
      
      public static const DESTROY_UNIT: String = "unitDestroy";
      
      public static const OPEN_SCREEN: String = "openScreen";
      
      public static const OPEN_LOAD_SCREEN: String = "openLoadScreen";
      
      public static const ORDER_CONFIRMED: String = "orderConfirmed";
      
      public static const FORMATION_CONFIRMED: String = "formationConfirmed";
      
      public static const FORMATION_CANCELED: String = "formationCanceled";
      
      public static const SWITCH_ATTACK: String = "switchAttack";
      
      public static const SWITCH_FORMATION: String = "switchFormation";
      
      public static const SWITCH_EMPTY: String = "switchEmpty";
      
      public static const SWITCH_NO_SELECTION: String = "switchNoSelection";
      
      public static const SWITCH_LOAD: String = "switchLoad";
      
      public static const SWITCH_LOAD_NOT_ENOUGH: String = "switchLoadNotEnough";
      
      public static const SWITCH_UNLOAD: String = "switchUnload";
      
      public static const SWITCH_EMPTY_LOAD: String = "switchEmptyLoad";
      
      public static const SWITCH_EMPTY_UNLOAD: String = "switchEmptyUnload";
      
      public static const SELECTION_PRECHANGE: String = "selectionWillChange";
      
      public static const TRANSFER_CONFIRMED: String = "transferConfirmed";
      
      public static const CLOSE_LOAD_REQUESTED: String = "closeLoadRequested";
      
      
      public var facilityId: int;
      
      public var unitsHash: Object;
      
      public var stance: int;
      
      public var units: Array;
      
      public var unitsCollection: ListCollectionView;
      
      public var landUnitsCollection: ListCollectionView;
      
      public var storedUnitsCollection: ListCollectionView;
      
      public var destination: *;
      
      public var location: *;
      
      public var volume: int = 0;
      
      public var storage: int = 0;
      
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
               break;
            case (OPEN_LOAD_SCREEN):
               location = params.location;
               destination = params.target;
               landUnitsCollection = params.landUnits;
               storedUnitsCollection = params.storedUnits;
               break;
            case (SWITCH_LOAD):
            case (SWITCH_EMPTY_LOAD):
            case (SWITCH_LOAD_NOT_ENOUGH):
            case (SWITCH_UNLOAD):
            case (SWITCH_EMPTY_UNLOAD):
               storage = params.storage;
               volume = params.volume;
               break;
         }
         super(type, eagerDispatch);
      }
   }
}