package utils.remote.proxy
{
   import flash.errors.IOError;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   import models.ModelLocator;
   
   import utils.remote.IServerProxy;
   import utils.remote.events.ServerProxyEvent;
   import utils.remote.rmo.ClientRMO;
   import utils.remote.rmo.ServerRMO;

   
   /**
    * @see IServerProxy#connect()
    * 
    * @eventType utils.remote.events.ServerProxyEvent.CONNECTION_ESTABLISHED
    */
   [Event(name="connectionEstablished", type="utils.remote.events.ServerProxyEvent")]
   
   
   /**
    * @see IServerProxy#connect()
    * 
    * @eventType utils.remote.events.ServerProxyEvent.CONNECTION_TIMEOUT
    */
   [Event(name="connectionTimeout", type="utils.remote.events.ServerProxyEvent")]
   
   
   /**
    * @see IServerProxy
    * 
    * @eventType utils.remote.events.ServerProxyEvent.CONNECTION_LOST
    */
   [Event(name="connectionLost", type="utils.remote.events.ServerProxyEvent")]
   
   
   /**
    * @see IServerProxy
    * 
    * @eventType utils.remote.events.ServerProxyEvent.IO_ERROR
    */
   [Event(name="ioError", type="utils.remote.events.ServerProxyEvent")]
   
   
   /**
    * Responsible for:
    * <ul>
    *    <li>accepting messages that come form <code>ServerProxy</code></li>
    *    <li>sending messages to <code>ServerProxy</code> wich will deliver them to the server</li>
    * </ul>
    * Compiled into <code>SpaceGame</code> application.
    */
   public dynamic class ClientProxy extends EventDispatcher implements IServerProxy
   {
      internal static const CONN_SERVER_TO_CLIENT:String = "server-client";
      internal static const CONN_CLIENT_TO_SERVER:String = "client-server"; 
      
      
      private var ML:ModelLocator = ModelLocator.getInstance();
      private var _sender:LargeMessageSender;
      private var _receiver:LargeMessageReceiver;
      
      
      include "receiverAndSenderFunctions.as";
      
      
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
         dispatchConnectionTimeoutEvent();
      }
      
      
      internal static const METHOD_NAME_CONNECTION_ESTABLISHED:String = "invoked_connectionEstablished";
      /**
       * Invoked when <code>ServerProxy</code> establishes connection with the server.
       */
      public function invoked_connectionEstablished() : void
      {
         _connected = true;
         _timer.start();
         dispatchConnectionEstablishedEvent();
      }
      
      
      internal static const METHOD_NAME_CONNECTION_CLOSED:String = "invoked_connectionClosed";
      /**
       * Invoked when <code>ServerProxy</code> has closed connection with the server.
       */
      public function invoked_connectionClosed() : void
      {
         _timer.stop();
         _connected = false;
         dispatchConnectionLostEvent();
      }
      
      
      internal static const METHOD_NAME_SOCKET_IO_ERROR:String = "invoked_socketIOError";
      /**
       * Invoked when a socket on <code>ServerProxy</code> gets IOErrorEvent.
       */
      public function invoked_socketIOError(event:IOErrorEvent) : void
      {
         trace(event.text);
         dispatchIOErrorEvent();
      }
      
      
      public function connect(host:String, port:int) : void
      {
         _sender.sendSimple(ServerProxy.METHOD_NAME_CONNECT, [host, port], sendSimple_completeHandler);
      }
      
      
      public function disconnect() : void
      {
         
      }
      
      
      public function reset() : void
      {
         
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
            _sender.sendLarge(ServerProxy.METHOD_NAME_SEND_MESSAGE, message, sendLarge_completeHandler);
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
         if (!_waitingForNewMessages)
         {
            _waitingForNewMessages = true;
            _sender.sendSimple(ServerProxy.METHOD_NAME_GET_MESSAGES, null, sendSimple_completeHandler);
         }
      }
      
      
      private var _unprocessedMessages:Vector.<ServerRMO> = new Vector.<ServerRMO>();
      public function getUnprocessedMessages() : Vector.<ServerRMO>
      {
         if (_unprocessedMessages.length == 0)
         {
            return null;
         }
         return _unprocessedMessages.splice(0, _unprocessedMessages.length);
      }
      
      
      public function get unprocessedMessages() : Vector.<ServerRMO>
      {
         return null;
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
            addHistoryRecord(" ~->| Incoming message: " + message);
            trace(_communicationHistory[_communicationHistory.length - 1]);
            _unprocessedMessages.push(ServerRMO.parse(message));
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
      
      
      /* ################################## */
      /* ### EVENTS DISPATCHING METHODS ### */
      /* ################################## */
      
      
      private function dispatchConnectionEstablishedEvent() : void
      {
         if (hasEventListener(ServerProxyEvent.CONNECTION_ESTABLISHED))
         {
            dispatchEvent(new ServerProxyEvent(ServerProxyEvent.CONNECTION_ESTABLISHED));
         }
      }
      
      
      private function dispatchConnectionTimeoutEvent() : void
      {
         if (hasEventListener(ServerProxyEvent.CONNECTION_TIMEOUT))
         {
            dispatchEvent(new ServerProxyEvent(ServerProxyEvent.CONNECTION_TIMEOUT));
         }
      }
      
      
      private function dispatchConnectionLostEvent() : void
      {
         if (hasEventListener(ServerProxyEvent.CONNECTION_LOST))
         {
            dispatchEvent(new ServerProxyEvent(ServerProxyEvent.CONNECTION_LOST));
         }
      }
      
      
      private function dispatchIOErrorEvent() : void
      {
         if (hasEventListener(ServerProxyEvent.IO_ERROR))
         {
            dispatchEvent(new ServerProxyEvent(ServerProxyEvent.IO_ERROR));
         }
      }
   }
}