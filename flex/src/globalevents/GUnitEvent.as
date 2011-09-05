package globalevents
{
   public class GUnitEvent extends GlobalEvent
   {
      public static const DELETE_APPROVED: String = "deleteApproved";
      public static const UNITS_SHOWN: String = "unitsShown";
      
      public function GUnitEvent(type:String)
      {
         super(type);
      }
   }
}