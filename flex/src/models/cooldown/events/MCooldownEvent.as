package models.cooldown.events
{
   import flash.events.Event;
   
   
   public class MCooldownEvent extends Event
   {
      /**
       * @see models.cooldown.MCooldown
       * 
       * @eventType endsInChange
       */
      public static const ENDS_IN_CHANGE:String = "endsInChange";
      
      
      public function MCooldownEvent(type:String)
      {
         super(type);
      }
   }
}