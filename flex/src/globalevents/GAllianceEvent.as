package globalevents
{
   public class GAllianceEvent extends GlobalEvent
   {
      public static const ALLIANCE_CONFIRMED: String = 'allianceConfirmed';
      public static const ALLIANCE_FAILED: String = 'allianceFailed';
      public function GAllianceEvent(type:String, eagerDispatch:Boolean=true)
      {
         super(type, eagerDispatch);
      }
   }
}