package utils.remote
{
   import controllers.connection.ConnectionManager;
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
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.net.Socket;
   import flash.utils.Timer;

   import models.ModelLocator;

   import mx.logging.ILogger;
   import mx.logging.Log;

   import namespaces.client_internal;

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
         with (_socket) {
            addEventListener(Event.CLOSE, socket_closeHandler);
            addEventListener(Event.CONNECT, socket_connectHandler);
            addEventListener(ProgressEvent.SOCKET_DATA, socket_socketDataHandler);
            addEventListener(IOErrorEvent.IO_ERROR, socket_ioErrorHandler);
            addEventListener(SecurityErrorEvent.SECURITY_ERROR, socket_securityErrorHandler);
         }
      }

      private function removeSocketEventHandlers(): void {
         with (_socket) {
            removeEventListener(Event.CLOSE, socket_closeHandler);
            removeEventListener(Event.CONNECT, socket_connectHandler);
            removeEventListener(ProgressEvent.SOCKET_DATA, socket_socketDataHandler);
            removeEventListener(IOErrorEvent.IO_ERROR, socket_ioErrorHandler);
            removeEventListener(SecurityErrorEvent.SECURITY_ERROR, socket_securityErrorHandler);
         }
      }

      private function socket_connectHandler(event: Event): void {
         // normally there should not be anything in the buffer when
         // connection has been established but clear it just in case
         _buffer = "";
         _connecting = false;
         dispatchServerProxyEvent(ServerProxyEvent.CONNECTION_ESTABLISHED);
         startPingTimer();
      }

      private function socket_closeHandler(event: Event): void {
         _buffer = "";
         _connecting = false;
         if (StartupInfo.getInstance().mode != StartupMode.MAP_EDITOR) {
            dispatchServerProxyEvent(ServerProxyEvent.CONNECTION_LOST)
         }
         killPingTimer();
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
            if (!isPong(msg))
            {
               msgLog.logMessage(msg, " ~->| Incoming message: {0}", [msg]);
               const rmo: ServerRMO = ServerRMO.parse(msg);
               _timeSynchronizer.synchronize(rmo);
               _unprocessedMessages.push(rmo);
            }
            _buffer = _buffer.substr(index + 1);
            index = _buffer.indexOf("\n");
         }
         killResponseTimer();
         startPingTimer();
      }

      private var errorReceived: Boolean = false;

      private function socket_ioErrorHandler(event: IOErrorEvent): void {
         log.error(event.text);
         errorReceived = true;
         reestablishConnection(true);
         //dispatchServerProxyEvent(ServerProxyEvent.IO_ERROR);
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
      
      
      // ######################### //
      // ### INTERFACE METHODS ### //
      // ######################### //

      public function connect(host: String, port: int): void {
         _connecting = true;
         _socket.connect(host, port);
      }

      public function disconnect(): void {
         _connecting = false;
         killPingTimer();
         killResponseTimer();
         // the method might be called event if the socket is not open
         try {
            _socket.close();
         }
            // well we can't do much about the error, can we?
         catch (error: IOError) {
         }
      }

      public function reset(): void {
         _timeSynchronizer.reset();
         getUnprocessedMessages();
      }

      /* Delay before keep-alive message is sent. */
      public static const PING_DELAY: int = 5000;
      /* Delay before connection reestablishment is tried after keep-alive
         message has been sent. */
      public static const CHECK_RESPONSE_TIME: int = 15000;

      private var pingTimer: Timer;
      private var responseTimer: Timer;

      private function get isDev(): Boolean
      {
         return ExternalInterface.call('inDeveloperMode');
      }

      private function startResponseTimer(): void
      {
         if (isDev)
         {
            return;
         }
         killResponseTimer();
         responseTimer = new Timer(CHECK_RESPONSE_TIME, 1);
         responseTimer.addEventListener(TimerEvent.TIMER, noResponse);
         responseTimer.start();
      }

      private function startPingTimer(): void
      {
         if (isDev)
         {
            return;
         }
         killPingTimer();
         pingTimer = new Timer(PING_DELAY, 1);
         pingTimer.addEventListener(TimerEvent.TIMER, ping);
         pingTimer.start();
      }

      private function killPingTimer(): void
      {
         if (pingTimer != null)
         {
            pingTimer.removeEventListener(TimerEvent.TIMER, ping);
            pingTimer.stop();
            pingTimer = null;
         }
      }

      private function killResponseTimer(): void
      {
         if (responseTimer != null)
         {
            responseTimer.removeEventListener(TimerEvent.TIMER, noResponse);
            responseTimer.stop();
            responseTimer = null;
         }
      }

      private function noResponse(e: TimerEvent): void
      {
         reestablishConnection(false);
      }

      private function ping(e: TimerEvent): void
      {
         if (_socket.connected) {
            _socket.writeUTFBytes('?\n');
            startResponseTimer();
         }
      }

      private function isPong(msg: String): Boolean
      {
         return msg == '!';
      }

      private function get ML(): ModelLocator
      {
         return ModelLocator.getInstance();
      }

      private function get SI(): StartupInfo
      {
         return StartupInfo.getInstance();
      }

      private function reestablish_connectHandler(event: Event): void {
         // normally there should not be anything in the buffer when
         // connection has been established but clear it just in case
         log.info('reestablishment socket connected');
         _buffer = "";
         _connecting = false;
         removeSocketEventHandlers();
         requestReestablish();
      }

      private function reestablishment_data(event: ProgressEvent): void
      {
         if (_socket != null)
         {
            disconnect();
         }
         log.info('reestablishment socket received data, switching to reestablished socket');
         _socket = reestablishmentSocket;
         removeReestablishmentSocketHandlers();
         reestablishmentSocket = null;
         addSocketEventHandlers();
         socket_socketDataHandler(event);
         errorReceived = false;
      }

      private function reestablish_closeHandler(event: Event): void {
         log.info('reestablishment failed');
         if (_killOldSocket)
         {
            disconnect();
            _buffer = "";
            _connecting = false;
            if (StartupInfo.getInstance().mode != StartupMode.MAP_EDITOR
               && errorReceived) {
               dispatchServerProxyEvent(ServerProxyEvent.CONNECTION_LOST);
            }
         }
         else
         {
            startResponseTimer();
         }
         if (reestablishmentSocket != null)
         {
            removeReestablishmentSocketHandlers();
            reestablishmentSocket = null;
         }
         if (!errorReceived)
         {
            errorReceived = false;
            log.info("Resetting due to failed reestablishment.");
            StartupManager.resetApp();
            StartupManager.connectAndAuthorize();
         }
      }

      private var reestablishmentSocket: Socket;
      private var _killOldSocket: Boolean = false;

      public function reestablishConnection(killOldSocket: Boolean): void
      {
         if (isDev)
         {
            if (killOldSocket)
            {
               log.info("Resetting...");
               StartupManager.resetApp();
               StartupManager.connectAndAuthorize();
            }
            return;
         }
         log.info('creating reestablish socket');
         _killOldSocket = killOldSocket;
         killPingTimer();
         killResponseTimer();
         if (reestablishmentSocket != null)
         {
            removeReestablishmentSocketHandlers();
         }
         reestablishmentSocket = new Socket();
         addReestablishmentSocketHandlers();
         reestablishmentSocket.connect(SI.server, SI.port);
      }

      private function addReestablishmentSocketHandlers(): void
      {
         with (reestablishmentSocket)
         {
            addEventListener(Event.CLOSE, reestablish_closeHandler);
            addEventListener(Event.CONNECT, reestablish_connectHandler);
            addEventListener(ProgressEvent.SOCKET_DATA, reestablishment_data);
            addEventListener(IOErrorEvent.IO_ERROR, reestablish_closeHandler);
            addEventListener(SecurityErrorEvent.SECURITY_ERROR, reestablish_closeHandler);
         }
      }

      private function removeReestablishmentSocketHandlers(): void
      {
         with (reestablishmentSocket)
         {
            removeEventListener(Event.CLOSE, reestablish_closeHandler);
            removeEventListener(Event.CONNECT, reestablish_connectHandler);
            removeEventListener(ProgressEvent.SOCKET_DATA, reestablishment_data);
            removeEventListener(IOErrorEvent.IO_ERROR, reestablish_closeHandler);
            removeEventListener(SecurityErrorEvent.SECURITY_ERROR, reestablish_closeHandler);
         }
      }

      private function requestReestablish(): void
      {
         if (reestablishmentSocket.connected) {
            var reestablishMsg: String = 'reestablish:' + ML.player.id + ':' +
               MessagesProcessor.getInstance().lastProcessedMessage + ':'
               + StartupInfo.getInstance().reestablishmentToken + '\n';
            log.info('requesting reestablish: '
            + ' >>> ' + reestablishMsg);
            reestablishmentSocket.writeUTFBytes(reestablishMsg);
         }
      }

      public function sendMessage(rmo: ClientRMO): void {
         if (_socket.connected) {
            startResponseTimer();
            killPingTimer();
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