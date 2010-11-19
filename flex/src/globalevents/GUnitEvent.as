package globalevents
{
   public class GUnitEvent extends GlobalEvent
   {
      public static const DELETE_APPROVED: String = "deleteApproved";
      public static const FLANK_APPROVED: String = "flankApproved";
      public static const LOAD_APPROVED: String = "loadApproved";
      public static const UNIT_BUILT: String = "unitBuilt";
      public static const UNITS_SHOWN: String = "unitsShown";
      
      public var units: Array
      
      public function GUnitEvent(type:String, _units: Array = null)
      {
         units = _units;
         super(type);
      }
   }
}