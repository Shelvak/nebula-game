package components.exploration.events
{
   import flash.events.Event;
   
   public class ExplorationStatusEvent extends Event
   {
      /**
       * @see components.exploration.ExplorationStatus
       * @eventType statusChange
       */
      public static const STATUS_CHANGE:String = "statusChange";
      
      
      public function ExplorationStatusEvent(type:String)
      {
         super(type, false, false);
      }
   }
}