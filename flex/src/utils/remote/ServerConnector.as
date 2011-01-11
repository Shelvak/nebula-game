package utils.remote
{
   import com.developmentarc.core.utils.EventBroker;
   import com.developmentarc.core.utils.SingletonFactory;
   
   import controllers.messages.MessageCommand;
   import controllers.messages.ResponseMessagesTracker;
   
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.Socket;
   
   import globalevents.GConnectionEvent;
   
   import models.ModelLocator;
   
   import utils.DateUtil;
   import utils.remote.proxy.ServerProxy;
   import utils.remote.rmo.*;
   
   
   
   
   /**
    * Dispatched through <code>EventBroker</code> when connection has been established.
    * 
    * @eventType globalevents.GConnectionCommand.CONNECTION_ESTABLISHED
    */
   [Event (name="connectionEstablished",
           type="globalevents.GConnectionEvent")]
   
   /**
    * Dispatched through <code>EventBroker</code> when server has closed the connection.
    * 
    * @eventType globalevents.GConnectionCommand.CONNECTION_CLOSED
    */
   [Event (name="connectionClosed",
           type="globalevents.GConnectionEvent")]

   /**
    * Dispatched through <code>EventBroker</code> when a message has been received from
    * the server. This message was initiated by the server and was not a response to a
    * message sent to the server.
    * 
    * @eventType utils.remote.commands.MessageCommand.MESSAGE_RECIEVED 
    */   
   [Event (name="messageReceived",
           type="controllers.messages.commands.MessageCommand")]

   /**
    * Dispached through <code>EventBroker</code> when a response message has been
    * recieved from the server. Here reponse message is a message sent by the server to
    * a response to a message that has been sent to the server by the client.
    * 
    * @eventType utils.remote.commands.MessageCommand.RESPONSE_RECIEVED
    */ 
   [Event (name="responseReceived",
           type="controllers.messages.commands.MessageCommand")]
   
   
   
   
   /**
    * This singleton class is responsible for establishing and closing
    * connection with the server as well as sending and recieving messages.
    * Commands (events) are bordcasted using <code>EventBroker</code> form
    * DevelopmentArc Core library.
    */
   public class ServerConnector implements IServerProxy
   {
      private static const GAME_PORT:int = 55345;
      
      
      private var _modelLocator: ModelLocator = ModelLocator.getInstance();
      private var _socket: Socket = new Socket ();
      
      
      private var _connecting: Boolean = false;
      /**
       * Proxy to <code>XMLSocket.connected</code>. 
       */
      public function get connected () :Boolean
      {
         return _socket.connected;
      }
      
      
      /**
       * How many messages are stored in <code>communicationHistory</code> array.
       */
      private static const HISTORY_SIZE:int = 20;
      
      
      private var _communicationHistory:Vector.<String> = new Vector.<String>();
      /**
       * A list of last <code>HISTORY_SIZE</code> messages (incoming and outgoing). Used for
       * debugging purposes.
       */
      public function get communicationHistory() : Vector.<String>
      {
         return _communicationHistory;
      }
      private function addHistoryRecord(value:String) : void
      {
         _communicationHistory.push(value);
         if (_communicationHistory.length > HISTORY_SIZE)
         {
            _communicationHistory.shift();
         }
      }
      
      
      /**
       * Don't use constructor. Use <code>SingletonFactory</code> from
       * DevelopmentArc Core library in order to get instance of this class.
       * <b>Only one instance of the class should be used throughout the
       * application</b>.
       * 
       * @see com.developmentarc.core.utils.SingletonFactory
       */
      public function ServerConnector ()
      {         
         _socket.addEventListener(Event.CLOSE, connectionClosed);
         _socket.addEventListener(Event.CONNECT, connectionEstablished);
         _socket.addEventListener(ProgressEvent.SOCKET_DATA, messageReceived);
         _socket.addEventListener(IOErrorEvent.IO_ERROR, gotSocketError);
         _socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, gotSecurityError);
         _socket.timeout = ResponseMessagesTracker.MAX_WAIT_TIME * 1000;
      }
      
      
      /**
       * Clears history.
       */
      public function reset() : void
      {
         _communicationHistory.splice(0, _communicationHistory.length);
      }
      
      
      
      
      // ############################# //
      // ### socket event handlers ### //
      // ############################# //
      
      
      private function connectionEstablished (event: Event) :void 
      {
         _connecting = false;
         new GConnectionEvent(GConnectionEvent.CONNECTION_ESTABLISHED);
      }
      
      
      private function connectionClosed (event: Event) :void
      {
         _connecting = false;
         new GConnectionEvent(GConnectionEvent.CONNECTION_CLOSED);
      }
      
      
      /**
       * Since messages may be very long (galaxies|show for example)
       * needed to implement a buffer. 
       */
      private var buffer: String = "";
      
      
      private function messageReceived (event: ProgressEvent) :void
      {         
         buffer += _socket.readUTFBytes (_socket.bytesAvailable);
         
         var index:int = buffer.indexOf("\n");
         while (index != -1)
         {
            var msg: String = buffer.substring (0, index);
            processMessage (msg);
            
            buffer = buffer.substr (index + 1);
            index = buffer.indexOf ("\n");
         }
      }
      
      
      private function processMessage(msg:String) : void
      {
         if (msg.length > 0)
         {
            msg = msg.replace(ServerProxy.SERVER_MESSAGE_ID_KEY, ServerProxy.CLIENT_MESSAGE_ID_KEY);
            addHistoryRecord(" ~->| Incoming message: " + msg);
            trace(_communicationHistory[_communicationHistory.length - 1]);
            var clientTime:Date = new Date();
            var rmo:ServerRMO = ServerRMO.parse(msg);
            DateUtil.updateTimeDiff(rmo.id, clientTime);
            if (rmo.isReply)
            {
               new MessageCommand(MessageCommand.RESPONSE_RECEIVED, rmo).dispatch();
            }
            else
            {
               new MessageCommand(MessageCommand.MESSAGE_RECEIVED, rmo).dispatch();
            }
         }
      }
      
      
      private function gotSocketError (event: IOErrorEvent) :void
      {
         EventBroker.broadcast (event);
      }
      
      private function gotSecurityError (event: SecurityErrorEvent) :void
      {
         // This will be thrown when timout is reached and connection
         // could not be established
         if (connected || _connecting)
         {
            EventBroker.broadcast (event);
         }
         
         // Apparently the famous #2048 error is thrown every time connection
         // is closed so just ignore it.
         else
         {
            trace ("Expected security error after disconnect: " + event.text);
         }
      }
      
      
      
      
      // ###################### //
      // ### public methods ### //
      // ###################### //
      
      
      /**
       * Tries to establish a socket connection with a remote server.
       * <code>ConnectionEstablisedCommand</code> is dispatched when connection
       * has been established.
       */
      public function connect () :void
      {
         _connecting = true;
         _socket.connect (_modelLocator.startupInfo.server, GAME_PORT);
      }
      
      
      /**
       * Disconnects from the server. <code>ConnectionClosedCommand</code> is
       * dispached when connection has been closed.
       */      
      public function disconnect () :void
      {
         _connecting = false;
         
         // In case I need to call this method when socket is not connected.
         try {
            _socket.close ();
         }
         catch (e: Error)
         {
            new GConnectionEvent(GConnectionEvent.CONNECTION_CLOSED);
            
            // Just in case something weird beggins
            trace (e.message);
         }
      }
      
      
      /**
       * Sends a message to remote server using socket connection.
       * 
       * <p>Note: <i><code>MessageReceivedCommand</code> is dispatched when either
       * the server sends a response message or a command (here "command" is a
       * message that has been <b>initiated by the server</b> and is not a
       * response to a message sent by the client).</i></p>
       * 
       * @param rmo A message that has to be sent to the server.
       */
      public function sendMessage(rmo:ClientRMO) : void
      {
         if (_socket.connected)
         {
            var msg:String = rmo.toJSON();
            addHistoryRecord("<-~ | Outgoing message: " + msg);
            trace(_communicationHistory[_communicationHistory.length - 1]);
            _socket.writeUTFBytes(msg + "\n");
            _socket.flush();
         }
      }
   }
}