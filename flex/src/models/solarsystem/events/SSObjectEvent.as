package models.solarsystem.events
{
   import flash.events.Event;
   
   public class SSObjectEvent extends Event
   {
      /**
       * @see models.solarsystem.MSSObject
       *  
       * @eventType playerChange
       */
      public static const PLAYER_CHANGE:String = "playerChange";
      
      
      /**
       * @see models.solarsystem.MSSObject
       * 
       * @evet type ownerChange
       */
      public static const OWNER_CHANGE:String = "ownerChange";
      
      
      public function SSObjectEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type, bubbles, cancelable);
      }
   }
}