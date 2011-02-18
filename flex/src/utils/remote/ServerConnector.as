package utils.remote
{
   import controllers.messages.ResponseMessagesTracker;
   
   import flash.errors.IOError;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.Socket;
   
   import utils.DateUtil;
   import utils.remote.events.ServerProxyEvent;
   import utils.remote.rmo.*;
   
   
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
    * Implementation of <code>IServerProxy</code> wich communicates with a server through
    * TCP/IP socket connection.
    */
   public class ServerConnector extends EventDispatcher implements IServerProxy
   {
      /**
       * How many messages are stored in <code>communicationHistory</code> array.
       */
      private static const HISTORY_SIZE:int = 10;
      
      
      private var _socket: Socket = new Socket ();
      private var _connecting: Boolean = false;
      
      
      /**
       * Don't instansiate this class. Use <code>ServerProxyInstance.getInstance()</code>.
       */
      public function ServerConnector()
      {
         _socket.timeout = ResponseMessagesTracker.MAX_WAIT_TIME;
         addSocketEventHandlers();
      }
      
      
      // ############################# //
      // ### SOCKET EVENT HANDLERS ### //
      // ############################# //
      
      
      private function addSocketEventHandlers() : void
      {
         with (_socket)
         {
            addEventListener(Event.CLOSE,                       socket_closeHandler);
            addEventListener(Event.CONNECT,                     socket_connectHandler);
            addEventListener(ProgressEvent.SOCKET_DATA,         socket_socketDataHandler);
            addEventListener(IOErrorEvent.IO_ERROR,             socket_ioErrorHandler);
            addEventListener(SecurityErrorEvent.SECURITY_ERROR, socket_securityErrorHandler);
         }
      }
      
      
      private function socket_connectHandler(event:Event) : void 
      {
         _connecting = false;
         dispatchConnectionEstablishedEvent();
      }
      
      
      private function socket_closeHandler(event:Event) : void
      {
         _connecting = false;
         dispatchConnectionLostEvent();
      }
      
      
      /**
       * As messages may be very long (<code>galaxies|show</code> for example) needed to implement a buffer. 
       */
      private var _buffer:String = "";
      
      
      private function socket_socketDataHandler(event:ProgressEvent) : void
      {
         _buffer += _socket.readUTFBytes(_socket.bytesAvailable);
         
         var index:int = _buffer.indexOf("\n");
         while (index != -1)
         {
            var msg:String = _buffer.substring(0, index);
            var rmo:ServerRMO = ServerRMO.parse(msg);
            DateUtil.updateTimeDiff(rmo.id, new Date());
            _unprocessedMessages.push(rmo);
            addHistoryRecord(" ~->| Incoming message: " + msg);
            _buffer = _buffer.substr(index + 1);
            index   = _buffer.indexOf("\n");
         }
      }
      
      
      private function socket_ioErrorHandler(event:IOErrorEvent) : void
      {
         trace(event.text);
         dispatchIOErrorEvent();
      }
      
      private function socket_securityErrorHandler(event:SecurityErrorEvent) : void
      {
         // This will be thrown when timout is reached and connection could not be established
         if (connected || _connecting)
         {
            dispatchConnectionTimeoutEvent();
         }
         
         // Apparently the famous #2048 error is thrown every time connection is closed so just ignore it.
         else
         {
            trace("Expected security error after disconnect: " + event.text);
         }
      }
      
      
      // ################# //
      // ## PROPERTIES ### //
      // ################# //
      
      
      public function get connected() : Boolean
      {
         return _socket.connected;
      }
      
      
      private var _communicationHistory:Vector.<String> = new Vector.<String>();
      public function get communicationHistory() : Vector.<String>
      {
         return _communicationHistory;
      }
      private function addHistoryRecord(value:String) : void
      {
         if (value.indexOf("game|config") >= 0)
         {
            return;
         }
         _communicationHistory.push(value);
         if (_communicationHistory.length > HISTORY_SIZE)
         {
            _communicationHistory.shift();
         }
         trace(value);
      }
      
      
      // ######################### //
      // ### INTERFACE METHODS ### //
      // ######################### //
      
      
      public function connect(host:String, port:int) : void
      {
         _connecting = true;
         _socket.connect(host, port);
      }
      
      
      public function disconnect() : void
      {
         _connecting = false;
         // the method migh be called event if the socket is not open
         try
         {
            _socket.close();
         }
         // well we can't do much about the error, can we?
         catch (error:IOError) {}
      }
      
      
      public function reset() : void
      {
         _communicationHistory.splice(0, _communicationHistory.length);
      }
      
      
      public function sendMessage(rmo:ClientRMO) : void
      {
         if (_socket.connected)
         {
            var msg:String = rmo.toJSON();
            addHistoryRecord("<-~ | Outgoing message: " + msg);
            _socket.writeUTFBytes(msg + "\n");
            _socket.flush();
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