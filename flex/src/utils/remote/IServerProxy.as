package utils.remote
{
   import flash.events.IEventDispatcher;
   
   import utils.remote.rmo.ClientRMO;
   import utils.remote.rmo.ServerRMO;
   
   
   /**
    * Defines interface for a proxy-to-server implementation. Implementation also must dispatch these
    * events:
    * <ul>
    *    <li><code>ServerProxyEvent.CONNECTION_ESTABLISHED</code> - see <code>connect()</code>.</li>
    *    <li><code>ServerProxyEvent.CONNECTION_TIMEOUT</code> - see <code>connect()</code>.</li>
    *    <li><code>ServerProxyEvent.CONNECTION_LOST</code> - dispatched when connection has been lost or
    *        closed by the server.</li>
    *    <li><code>ServerProxyEvent.IO_ERROR</code> - dispatched when and IOError occures.</li>
    * </ul>
    * 
    * @see #connect()
    */
   public interface IServerProxy extends IEventDispatcher
   {      
      /**
       * Tries to connect to the server. Once the connection has been established, dispatches
       * <code>ServerProxyEvent.CONNECTION_ESTABLISHED</code> event. If connection could not be
       * established during a certain period of time, <code>ServerProxyEvent.CONNECTION_TIMEOUT</code>
       * event will be dispatched.
       * 
       * @param host IP or DNS of the server to connect to
       * @param port TCP/IP port to connect to
       */
      function connect(host:String, port:int) : void;
      
      
      /**
       * Disconnects from the server. This operation is synchronous and no events are dispatched.
       */
      function disconnect() : void;
      
      
      /**
       * Clears history.<br/>
       * Removes all received messages (if any).<br/>
       * Disconnects from the server, if connected.
       */
      function reset() : void;
      
      
      /**
       * Sends a message to the server.
       */
      function sendMessage(rmo:ClientRMO) : void;
      
      
      /**
       * Indicates if a proxy is connected to the server.
       */
      function get connected() : Boolean;
      
      
      /**
       * Returns messages received from the server that have not been processed yet. Clears internal list
       * that was used for holding those messages. You get a copy of that list first.
       */
      function getUnprocessedMessages() : Vector.<ServerRMO>;
      
      
      /**
       * Returns a reference to an internal list of unprocessed messages. Normally you should always use
       * <code>getUnprocessedMessages()</code> instead.
       */
      function get unprocessedMessages() : Vector.<ServerRMO>;
   }
}