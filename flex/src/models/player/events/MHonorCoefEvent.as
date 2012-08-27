package models.player.events
{
   import flash.events.Event;


   public class MHonorCoefEvent extends Event
   {
      public static const CHANGE: String = "CHANGE";

      public function MHonorCoefEvent(type: String) {
         super(type, false, false)
      }
   }
}
