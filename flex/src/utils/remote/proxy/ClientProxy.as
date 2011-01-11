package utils.remote.proxy
{
   import com.developmentarc.core.utils.EventBroker;
   
   import controllers.messages.MessageCommand;
   
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   import globalevents.GConnectionEvent;
   
   import models.ModelLocator;
   
   import utils.remote.IServerProxy;
   import utils.remote.rmo.ClientRMO;
   import utils.remote.rmo.ServerRMO;

   
   /**
    * Dispatched through <code>EventBroker</code> when connection has been established.
    * 
    * @eventType globalevents.GConnectionCommand.CONNECTION_ESTABLISHED
    */
   [Event(name="connectionEstablished", type="globalevents.GConnectionEvent")]
   
   /**
    * Dispatched through <code>EventBroker</code> when server has closed the connection.
    * 
    * @eventType globalevents.GConnectionCommand.CONNECTION_CLOSED
    */
   [Event(name="connectionClosed", type="globalevents.GConnectionEvent")]
   
   /**
    * Dispatched through <code>EventBroker</code> when a message has been received from
    * the server. This message was initiated by the server and was not a response to a
    * message sent to the server.
    * 
    * @eventType utils.remote.commands.MessageCommand.MESSAGE_RECIEVED 
    */   
   [Event(name="messageReceived", type="controllers.messages.commands.MessageCommand")]
   
   /**
    * Dispached through <code>EventBroker</code> when a response message has been
    * recieved from the server. Here reponse message is a message sent by the server to
    * a response to a message that has been sent to the server by the client.
    * 
    * @eventType utils.remote.commands.MessageCommand.RESPONSE_RECIEVED
    */ 
   [Event(name="responseReceived", type="controllers.messages.commands.MessageCommand")]
   
   
   /**
    * Responsible for:
    * <ul>
    *    <li>accepting messages that come form <code>ServerProxy</code></li>
    *    <li>sending messages to <code>ServerProxy</code> wich will deliver them to the server</li>
    * </ul>
    * Compiled into <code>SpaceGame</code> application.
    */
   public dynamic class ClientProxy implements IServerProxy
   {
      private static const GAME_PORT:int = 55345;
      
      
      internal static const CONN_SERVER_TO_CLIENT:String = "server-client";
      internal static const CONN_CLIENT_TO_SERVER:String = "client-server"; 
      
      
      private var ML:ModelLocator = ModelLocator.getInstance();
      private var _sender:LargeMessageSender;
      private var _receiver:LargeMessageReceiver;
      include "receivePacketFunction.as";
      
      
      private var _connected:Boolean = false;
      /**
       * <code>true</code> if connection with the server is alive or <code>false</code> otherwise.
       */
      public function get connected() : Boolean
      {
         return _connected;
      }
      
      
      public function ClientProxy()
      {
         var senderConfig:LargeMessageSenderConfig = new LargeMessageSenderConfig();
         with (senderConfig)
         {
            cancelAllCallsAfterError = false;
            retryAfterFailure = true;
            maxRetries = 3;
         }
         _sender = new LargeMessageSender(CONN_CLIENT_TO_SERVER, senderConfig);
         
         _receiver = new LargeMessageReceiver();
         _receiver.client = this;
         _receiver.connect(CONN_SERVER_TO_CLIENT);
         
         _timer = new Timer(250);
         _timer.addEventListener(TimerEvent.TIMER, timer_timerHandler);
      }
      
      
      internal static const METHOD_NAME_CONNECTION_TIMEOUT:String = "invoked_connectionTimeout";
      /**
       * Invoked when <code>ServerProxy</code> got <code>SecurityErrorEvent</code> while trying to
       * establish connection with the server.
       */
      public function invoked_connectionTimeout(event:SecurityErrorEvent) : void
      {
         EventBroker.broadcast(event);
      }
      
      
      internal static const METHOD_NAME_CONNECTION_ESTABLISHED:String = "invoked_connectionEstablished";
      /**
       * Invoked when <code>ServerProxy</code> establishes connection with the server.
       */
      public function invoked_connectionEstablished() : void
      {
         _connected = true;
         new GConnectionEvent(GConnectionEvent.CONNECTION_ESTABLISHED);
         _timer.start();
      }
      
      
      internal static const METHOD_NAME_CONNECTION_CLOSED:String = "invoked_connectionClosed";
      /**
       * Invoked when <code>ServerProxy</code> has closed connection with the server.
       */
      public function invoked_connectionClosed() : void
      {
         _timer.stop();
         _connected = false;
         new GConnectionEvent(GConnectionEvent.CONNECTION_CLOSED);
      }
      
      
      internal static const METHOD_NAME_SOCKET_IO_ERROR:String = "invoked_socketIOError";
      /**
       * Invoked when a socket on <code>ServerProxy</code> gets IOErrorEvent.
       */
      public function invoked_socketIOError(event:IOErrorEvent) : void
      {
         EventBroker.broadcast(event);
      }
      
      
      /**
       * Will try to establish connection with a remote server.
       * <code>GConnectionCommand.CONNECTION_ESTABLISHED</code> event is broadcasted when connection has
       * been established.
       */
      public function connect() : void
      {
         _sender.sendSimple(ServerProxy.METHOD_NAME_CONNECT, [ML.startupInfo.server, GAME_PORT]);
      }
      
      
      /**
       * Sends a message to remote server.
       * 
       * <p>Note: <i><code>MessageReceivedCommand</code> is dispatched when either the server sends a
       * response message or a command (here "command" is a message that has been <b>initiated by the
       * server</b> and is not a response to a message sent by the client).</i></p>
       * 
       * @param rmo A message that has to be sent to the server.
       */
      public function sendMessage(rmo:ClientRMO) : void
      {
         if (_connected)
         {
            var message:String = rmo.toJSON();
            addHistoryRecord("<-~ | Outgoing message: " + message);
            trace(_communicationHistory[_communicationHistory.length - 1]);
            _sender.sendLarge(ServerProxy.METHOD_NAME_SEND_MESSAGE, message);
         }
      }
      
      
      /* ################################## */
      /* ### SERVER MESSAGES PROCESSING ### */
      /* ################################## */
      
      
      private var _timer:Timer;
      private var _waitingForNewMessages:Boolean = false;
      
      
      /**
       * Periodically processes new messages and sends a request to <code>ServerProxy</code> to get another
       * batch of new messages.
       */
      private function timer_timerHandler(event:TimerEvent) : void
      {
         processMessages();
         if (!_waitingForNewMessages)
         {
            _waitingForNewMessages = true;
            _sender.sendSimple(ServerProxy.METHOD_NAME_GET_MESSAGES, null);
         }
      }
      
      
      private var _unprocessedMessages:Vector.<String> = new Vector.<String>();
      /**
       * Processes all unprocessed messages.
       */
      private function processMessages() : void
      {
         if (_unprocessedMessages.length == 0)
         {
            return;
         }
         for each (var message:String in _unprocessedMessages)
         {
            var rmo:ServerRMO = ServerRMO.parse(message);
            if (rmo.isReply)
            {
               new MessageCommand(MessageCommand.RESPONSE_RECEIVED, rmo).dispatch();
            }
            else
            {
               new MessageCommand(MessageCommand.MESSAGE_RECEIVED, rmo).dispatch();
            }
         }
         _unprocessedMessages.splice(0, _unprocessedMessages.length);
      }
      
      
      internal static const METHOD_NAME_RECEIVE_MESSAGES:String = "invoked_receiveMessages";
      /**
       * Invoked when new messages have been received from <code>ServerProxy</code>. They are added to
       * the <code>_unprocessedMessages</code> list and later will be processed. This approach lets us
       * to avoid additional <code>AsyncError</code> in the <code>ServerProxy</code>.
       */
      public function invoked_receiveMessages(messages:String) : void
      {
         _waitingForNewMessages = false;
         // ignore empty responses from SreverProxy 
         if (messages.length == 0)
         {
            return;
         }
         for each (var message:String in messages.split("\n"))
         {
            _unprocessedMessages.push(message);
            addHistoryRecord(" ~->| Incoming message: " + message);
            trace(_communicationHistory[_communicationHistory.length - 1]);
         }
      }
      
      
      /* ############################# */
      /* ### COMMUNICATION HISTORY ### */
      /* ############################# */
      
      
      /**
       * How many messages are stored in <code>communicationHistory</code> array.
       */
      private static const HISTORY_SIZE:int = 20;
      
      
      private var _communicationHistory:Vector.<String> = new Vector.<String>();
      /**
       * Returns a list of at most <code>HISTORY_SIZE</code> last messages received from the server.
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
   }
}