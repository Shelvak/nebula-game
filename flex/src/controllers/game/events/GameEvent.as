package controllers.game.events
{
   import flash.events.Event;
   
   
   
   
   public class GameEvent extends Event
   {
      /**
       * This event is dispatched through <code>EventBroker</code> when configuration
       * has been set.
       * 
       * @eventType configSet 
       */      
      public static const CONFIG_SET:String = "configSet";
      
      
      /**
       * Constructor. 
       */      
      public function GameEvent(type:String)
      {
         super(type, false, false);
      }
   }
}