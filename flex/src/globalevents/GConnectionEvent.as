package globalevents
{
   /**
    * Represents connection-related events and defines different event
    * constants for different connection events. 
    */   
   public class GConnectionEvent extends GlobalEvent
   {
      /**
       * This event is dispached when connection has been established
       * between the server and the client.
       * 
       * @eventType connectionEstablished
       */
      public static const CONNECTION_ESTABLISHED:String="connectionEstablished";
      
      /**
       * This event is dispached when connection has been closed intentionally
       * by the client.
       * 
       * @eventType connectionClosed
       */
      public static const CONNECTION_CLOSED:String="connectionClosed";
      
      
      
      
      /**
       * Constructor.
       * 
       * @param type Type of the event.
       * @param eagerDispatch If <code>true</code>, the event will be dispatched once
       * it has been crated.
       */
      public function GConnectionEvent(type:String, eagerDispatch:Boolean=true)
      {
         super(type, eagerDispatch);
      }
   }
}