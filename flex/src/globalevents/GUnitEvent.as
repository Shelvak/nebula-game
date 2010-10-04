package globalevents
{
   import ext.flex.mx.collections.IList;
   
   import models.location.LocationMinimal;
   
   
   public class GUnitEvent extends GlobalEvent
   {
      
      /**
       * Dispatched when server responds to UNITS|ATTACK 
       */
      public static const ATTACK_APPROVED: String = "attackApproved";
      
      public static const DELETE_APPROVED: String = "deleteApproved";
      
      public static const FLANK_APPROVED: String = "flankApproved";
      
      public static const UNIT_BUILT: String = "unitBuilt";
      
      
      public function GUnitEvent(type:String, eagerDispatch:Boolean = true)
      {
         super(type, eagerDispatch);
      }
   }
}