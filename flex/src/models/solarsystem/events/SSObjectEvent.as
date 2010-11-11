package models.solarsystem.events
{
   import flash.events.Event;
   
   public class SSObjectEvent extends Event
   {
      /**
       * Dispatched when palyer who owns a solar system object has changed.
       *  
       * @eventType playerChange
       */
      public static const PLAYER_CHANGE:String = "playerChange";
      
      
      public function SSObjectEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type, bubbles, cancelable);
      }
   }
}