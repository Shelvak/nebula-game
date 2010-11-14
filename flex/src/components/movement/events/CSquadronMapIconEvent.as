package components.movement.events
{
   import flash.events.Event;
   
   public class CSquadronMapIconEvent extends Event
   {
      /**
       * @see components.movement.CSquadronMapIcon#locationActualChange
       */
      public static const LOCATION_ACTUAL_CHANGE:String = "locationActualChange";
      
      
      public function CSquadronMapIconEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
      {
         super(type, bubbles, cancelable);
      }
   }
}