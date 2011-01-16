package utils.remote.events
{
   import flash.events.Event;
   
   
   /**
    * These events are dispatched by <code>IServerProxy</code> objects.
    */
   public class ServerProxyEvent extends Event
   {
      /**
       * @see utils.remote.IServerProxy#connect()
       */
      public static const CONNECTION_ESTABLISHED:String = "connectionEstablished";
      
      
      /**
       * @see utils.remote.IServerProxy#connect()
       */
      public static const CONNECTION_TIMEOUT:String = "connectionTimeout";
      
      
      /**
       * @see utils.remote.IServerProxy
       */
      public static const CONNECTION_LOST:String = "connectionLost";
      
      
      /**
       * @see utils.remote.IServerProxy
       */
      public static const IO_ERROR:String = "ioError";
      
      
      public function ServerProxyEvent(type:String)
      {
         super(type, false, false);
      }
   }
}