package utils.remote
{
   import controllers.messages.MessagesProcessor;
   import controllers.messages.ResponseMessagesTracker;
   import controllers.startup.StartupInfo;
   import controllers.startup.StartupManager;
   import controllers.startup.StartupMode;

   import flash.errors.IOError;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.external.ExternalInterface;
   import flash.net.Socket;

   import models.ModelLocator;

   import mx.logging.ILogger;
   import mx.logging.Log;

   import namespaces.client_internal;

   import utils.ApplicationLocker;

   import utils.Events;
   import utils.Objects;
   import utils.logging.MessagesLogger;
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
      private function get log() : ILogger {
         return Log.getLogger(Objects.getClassName(this, true));
      }
      
      private function get msgLog() : MessagesLogger {
         return MessagesLogger.getInstance();
      }

      private const _timeSynchronizer:TimeSynchronizer = new TimeSynchronizer();
      private var _socket: Socket = new Socket();
      private var _connecting: Boolean = false;

      client_internal function get lowestObservedLatency(): int {
         return _timeSynchronizer.lowestObservedLatency;
      }
      
      /**
       * Don't instantiate this class. Use <code>ServerProxyInstance.getInstance()</code>.
       */
      public function ServerConnector() {
         _socket.timeout = ResponseMessagesTracker.MAX_WAIT_TIME;
         addSocketEventHandlers();
      }
      
      
      // ############################# //
      // ### SOCKET EVENT HANDLERS ### //
      // ############################# //

      private function addSocketEventHandlers(): void {
         if (!socketEventsRegistered)
         {
            with (_socket) {
               addEventListener(Event.CLOSE, socket_closeHandler);
               addEventListener(Event.CONNECT, socket_connectHandler);
               addEventListener(ProgressEvent.SOCKET_DATA, socket_socketDataHandler);
               addEventListener(IOErrorEvent.IO_ERROR, socket_ioErrorHandler);
               if (!hasEventListener(SecurityErrorEvent.SECURITY_ERROR))
               {
                  addEventListener(SecurityErrorEvent.SECURITY_ERROR, socket_securityErrorHandler);
               }
               socketEventsRegistered = true;
            }
         }
      }

      private function removeSocketEventHandlers(): void {
         if (socketEventsRegistered)
         {
            with (_socket) {
               removeEventListener(Event.CLOSE, socket_closeHandler);
               removeEventListener(Event.CONNECT, socket_connectHandler);
               removeEventListener(ProgressEvent.SOCKET_DATA, socket_socketDataHandler);
               removeEventListener(IOErrorEvent.IO_ERROR, socket_ioErrorHandler);
               //removeEventListener(SecurityErrorEvent.SECURITY_ERROR, socket_securityErrorHandler);
               socketEventsRegistered = false;
            }
         }
      }

      private function socket_connectHandler(event: Event): void {
         // normally there should not be anything in the buffer when
         // connection has been established but clear it just in case
         _buffer = "";
         _connecting = false;
         dispatchServerProxyEvent(ServerProxyEvent.CONNECTION_ESTABLISHED);
      }

      private function socket_closeHandler(event: Event): void {
         _buffer = "";
         _connecting = false;
         if (StartupInfo.getInstance().mode != StartupMode.MAP_EDITOR) {
            dispatchServerProxyEvent(ServerProxyEvent.CONNECTION_LOST);
         }
      }
      
      /**
       * As messages may be very long (<code>galaxies|show</code> for example) needed to implement a buffer. 
       */
      private var _buffer:String = "";

      private function socket_socketDataHandler(event: ProgressEvent): void {
         _buffer += _socket.readUTFBytes(_socket.bytesAvailable);
         var index: int = _buffer.indexOf("\n");
         while (index != -1) {
            const msg: String = _buffer.substring(0, index);
            msgLog.logMessage(msg, " ~->| Incoming message: {0}", [msg]);
            const rmo: ServerRMO = ServerRMO.parse(msg);
            _timeSynchronizer.synchronize(rmo);
            _unprocessedMessages.push(rmo);
            _buffer = _buffer.substr(index + 1);
            index = _buffer.indexOf("\n");
         }
      }

      private function socket_ioErrorHandler(event: IOErrorEvent): void {
         log.error(event.text);
         dispatchServerProxyEvent(ServerProxyEvent.IO_ERROR);
      }

      private function socket_securityErrorHandler(event: SecurityErrorEvent): void {
         // This will be thrown when timeout is reached and connection could
         // not be established
         if (connected || _connecting) {
            dispatchServerProxyEvent(ServerProxyEvent.CONNECTION_TIMEOUT);
         }
         // Apparently the famous #2048 error is thrown every time connection is closed so just ignore it.
         else {
            log.debug("Expected security error after disconnect: {0}", event.text);
         }
      }


      // ################# //
      // ## PROPERTIES ### //
      // ################# //

      public function get connected(): Boolean {
         return _socket.connected;
      }

      private var socketEventsRegistered: Boolean = false;
      
      // ######################### //
      // ### INTERFACE METHODS ### //
      // ######################### //

      public function connect(host: String, port: int): void {
         _connecting = true;
         if (!socketEventsRegistered)
         {
            addSocketEventHandlers();
         }
         _socket.connect(host, port);
      }

      public function disconnect(): void {
         _connecting = false;
         // the method might be called event if the socket is not open
         try {
            _socket.close();
         }
            // well we can't do much about the error, can we?
         catch (error: Error) {
         }
      }

      public function reset(): void {
         _timeSynchronizer.reset();
         getUnprocessedMessages();
      }


      private function get ML(): ModelLocator
      {
         return ModelLocator.getInstance();
      }

      private function get SI(): StartupInfo
      {
         return StartupInfo.getInstance();
      }

      public function sendMessage(rmo: ClientRMO): void {
         if (_socket.connected) {
            var msg: String = rmo.toJSON();
            msgLog.logMessage(msg, "<-~ | Outgoing message: {0}", [msg]);
            _socket.writeUTFBytes(msg + "\n");
            _socket.flush();
         }
      }

      private var _unprocessedMessages: Vector.<ServerRMO> = new Vector.<ServerRMO>();

      public function getUnprocessedMessages(): Vector.<ServerRMO> {
         if (_unprocessedMessages.length == 0) {
            return null;
         }
         return _unprocessedMessages.splice(0, _unprocessedMessages.length);
      }

      public function get unprocessedMessages(): Vector.<ServerRMO> {
         return _unprocessedMessages;
      }


      /* ############### */
      /* ### HELPERS ### */
      /* ############### */

      private function dispatchServerProxyEvent(type: String): void {
         Events.dispatchSimpleEvent(this, ServerProxyEvent, type);
      }
   }
}

import utils.DateUtil;
import utils.remote.rmo.ServerRMO;


class TimeSynchronizer
{
   public function TimeSynchronizer(): void {
      reset();
   }

   private var _lowestObservedLatency: int;
   public function get lowestObservedLatency(): int {
      return _lowestObservedLatency;
   }

   public function synchronize(rmo:ServerRMO): void {
      if (!rmo.isReply) {
         return;
      }
      const requestTime: Number = Number(rmo.replyTo);
      const serverTime: Number = Number(rmo.id);
      const currentTime: Number = new Date().time;
      const latency: int = Math.round((currentTime - requestTime) / 2);
      if (latency < _lowestObservedLatency) {
         _lowestObservedLatency = latency;
         DateUtil.timeDiff = serverTime - currentTime + latency;
      }
   }

   public function reset(): void {
      DateUtil.timeDiff = 0;
      _lowestObservedLatency = int.MAX_VALUE;
   }
}