package models.solarsystem.events
{
   import flash.events.Event;
   
   public class SSObjectEvent extends Event
   {
      /**
       * Dispatched when owner of solar system object has changed.
       *  
       * @eventType ownerChange
       */
      public static const OWNER_CHANGE:String = "ownerChange";
      
      
      public function SSObjectEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type, bubbles, cancelable);
      }
   }
}