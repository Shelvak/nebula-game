package globalevents
{
   import models.building.Building;
   import models.location.Location;
   import models.unit.Unit;
   
   import mx.collections.ArrayCollection;
   
   public class GUnitsScreenEvent extends GlobalEvent
   {
      public static const FACILITY_OPEN: String = "facilityOpen";
      
      public static const UNITS_UPDATED: String = "unitsUpdated";
      
      public static const SET_STANCE: String = "unitsStanceSet";
      
      public static const DESELECT_UNITS: String = "unitsDeselect";
      
      public static const SELECT_ALL: String = "selectAllUnits";
      
      public static const DESTROY_UNIT: String = "unitDestroy";
      
      public static const OPEN_SCREEN: String = "openScreen";
      
      public static const ORDER_CONFIRMED: String = "orderConfirmed";
      
      public static const FORMATION_CONFIRMED: String = "formationConfirmed";
      
      public static const FORMATION_CANCELED: String = "formationCanceled";
      
      public static const SWITCH_ATTACK: String = "switchAttack";
      
      public static const SWITCH_FORMATION: String = "switchFormation";
      
      public static const SWITCH_EMPTY: String = "switchEmpty";
      
      public static const SWITCH_NO_SELECTION: String = "switchNoSelection";
      
      public static const SELECTION_PRECHANGE: String = "selectionWillChange";
      
      public var facilityId: int;
      
      public var unitsHash: Object;
      
      public var stance: int;
      
      public var units: Array;
      
      public var unitsCollection: ArrayCollection;
      
      public var destination: Building;
      
      public var location: Location;
      
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
         }
         super(type, eagerDispatch);
      }
   }
}