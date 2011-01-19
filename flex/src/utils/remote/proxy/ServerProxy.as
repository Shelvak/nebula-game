package utils.remote.proxy
{
   import com.adobe.utils.DateUtil;
   
   import controllers.messages.ResponseMessagesTracker;
   
   import flash.errors.IOError;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.Socket;

   /**
    * Responsible for:
    * <ul>
    *    <li>receiving messages form the server and passing them to the <code>ClientProxy</code></li>
    *    <li>sending message to the server that came form <code>ClientProxy</code></li>
    * </ul>
    * Compiled into the <code>ServerConnectionProxy</code> application.
    */
   public class ServerProxy
   {
      public static const SERVER_MESSAGE_ID_KEY:String = "|ID|";
      public static const CLIENT_MESSAGE_ID_KEY:String = "id";
      
      
      /* ################################################### */
      /* ### SERVER PROXY <-> CLIENT PROXY COMMUNICATION ### */
      /* ################################################### */
      
      
      private var _sender:LargeMessageSender;
      private var _receiver:LargeMessageReceiver;
      
      include "receiverAndSenderFunctions.as";
      
      
      public function ServerProxy()
      {
         var senderConfig:LargeMessageSenderConfig = new LargeMessageSenderConfig();
         with (senderConfig)
         {
            cancelAllCallsAfterError = false;
            retryAfterFailure = true;
            maxRetries = 3;
         }
         _sender = new LargeMessageSender(ClientProxy.CONN_SERVER_TO_CLIENT, senderConfig);
         
         _receiver = new LargeMessageReceiver();
         _receiver.client = this;
         _receiver.connect(ClientProxy.CONN_CLIENT_TO_SERVER);
         
         instantiateSocket();
      }
      
      
      internal static const METHOD_NAME_GET_MESSAGES:String = "invoked_getMessages";
      /**
       * Invoked when <code>ClientProxy</code> requests for new messages.
       */
      public function invoked_getMessages() : void
      {
         var messages:String = _messagesReceived.join("\n");
         _sender.sendLarge(ClientProxy.METHOD_NAME_RECEIVE_MESSAGES, messages, sendLarge_completeHandler);
         _messagesReceived.splice(0, _messagesReceived.length);
      }
      
      
      internal static const METHOD_NAME_SEND_MESSAGE:String = "invoked_sendMessage";
      /**
       * Invoked when <code>ClientProxy</code> needs to send a message to the server.
       */
      public function invoked_sendMessage(message:String) : void
      {
         _socket.writeUTFBytes(message + "\n");
         _socket.flush();
      }
      
      
      internal static const METHOD_NAME_CONNECT:String = "invoked_connect";
      /**
       * Invoked when <code>ClientProxy</code> requests to establish connection with the server.
       * 
       * @param host host name
       * @param port port to connect to
       */
      public function invoked_connect(host:String, port:int) : void
      {
         _socket.connect(host, port);
      }
      
      
      /* ############################################# */
      /* ### SERVER PROXY <-> SERVER COMMUNICATION ### */
      /* ############################################# */
      
      
      private var _connecting:Boolean = false;
      private var _socket:Socket;
      
      
      private function instantiateSocket() : void
      {
         _socket = new Socket();
         with (_socket)
         {
            addEventListener(Event.CLOSE, socket_closeHandler);
            addEventListener(Event.CONNECT, socket_connectHandler);
            addEventListener(ProgressEvent.SOCKET_DATA, socket_socketDataHandler);
            addEventListener(IOErrorEvent.IO_ERROR, socket_ioErrorHandler);
            addEventListener(SecurityErrorEvent.SECURITY_ERROR, socket_securityErrorHandler);
            timeout = ResponseMessagesTracker.MAX_WAIT_TIME;
         }
      }
      
      
      // ############################# //
      // ### SOCKET EVENT HANDLERS ### //
      // ############################# //
      
      
      private function socket_connectHandler(event:Event) : void 
      {
         _sender.sendSimple(ClientProxy.METHOD_NAME_CONNECTION_ESTABLISHED, null, sendSimple_completeHandler);
      }
      
      
      private function socket_closeHandler(event:Event) : void
      {
         _sender.sendSimple(ClientProxy.METHOD_NAME_CONNECTION_CLOSED, null, sendSimple_completeHandler);
      }
      
      
      /**
       * Since messages may be very long (galaxies|show for example)
       * needed to implement a buffer. 
       */
      private var _buffer:String = "";
      private var _messagesReceived:Vector.<String> = new Vector.<String>();
      private function socket_socketDataHandler(event:ProgressEvent) : void
      {
         _buffer += _socket.readUTFBytes(_socket.bytesAvailable);
         var index:int = _buffer.indexOf("\n");
         while (index != -1)
         {
            var message:String = _buffer.substring(0, index);
            processMessage(message);
            _buffer = _buffer.substr(index + 1);
            index = _buffer.indexOf("\n");
         }
      }
      
      
      private var _idRegExp:RegExp =
         new RegExp('"\\|ID\\|":"\\d+"');
      private var _timeRegExp:RegExp =
         new RegExp('\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}[+-]\\d{2}:\\d{2}', "g");
      private function processMessage(message:String) : void
      {
         var messageId:String = _idRegExp.exec(message)[0];
         messageId = messageId.substring(SERVER_MESSAGE_ID_KEY.length + 4, messageId.length - 1);
         var timeDiff:Number = new Number(messageId) - new Date().time;
         
         // replace |ID| with id since that is simpler than to change client code 
         message = message.replace(SERVER_MESSAGE_ID_KEY, CLIENT_MESSAGE_ID_KEY);
         
         // update all dateTime fields
         _timeRegExp.lastIndex = 0;
         var timeSearchResult:Object;
         while (timeSearchResult = _timeRegExp.exec(message))
         {
            var serverTime:Date = DateUtil.parseW3CDTF(timeSearchResult[0]);
            var clientTime:Date = new Date(Math.floor((serverTime.time - timeDiff) / 1000) * 1000);
            message = message.replace(_timeRegExp.source, DateUtil.toW3CDTF(clientTime));
         }
         
         _messagesReceived.push(message);
      }
      
      
      private function socket_ioErrorHandler(event:IOErrorEvent) : void
      {
         _sender.sendSimple(ClientProxy.METHOD_NAME_SOCKET_IO_ERROR, [event], sendSimple_completeHandler);
      }
      
      
      private function socket_securityErrorHandler(event:SecurityErrorEvent) : void
      {
         // This will be thrown when timeout is reached and connection
         // could not be established
         if (_socket.connected || _connecting)
         {
            _sender.sendSimple(ClientProxy.METHOD_NAME_CONNECTION_TIMEOUT,
                               [event], sendSimple_completeHandler);
         }
         // Apparently the famous #2048 error is thrown every time connection
         // is closed so just ignore it.
         else
         {
            trace("Expected security error after disconnect: " + event.text);
         }
      }
   }
}