package controllers.connection
{
   import com.developmentarc.core.utils.EventBroker;
   import com.developmentarc.core.utils.SingletonFactory;
   
   import components.popups.ErrorPopup;
   
   import controllers.GlobalFlags;
   import controllers.messages.ResponseMessagesTracker;
   import controllers.players.PlayersCommand;
   import controllers.startup.StartupManager;
   
   import globalevents.GlobalEvent;
   
   import models.ModelLocator;
   
   import utils.Localizer;
   import utils.remote.IServerProxy;
   import utils.remote.ServerProxyInstance;
   import utils.remote.events.ServerProxyEvent;
   
   
   public class ConnectionManager
   {
      public static function getInstance() : ConnectionManager
      {
         return SingletonFactory.getSingletonInstance(ConnectionManager);
      }
      
      
      private function get ML() : ModelLocator
      {
         return ModelLocator.getInstance();
      }
      
      
      private function get RESP_MSG_TRACKER() : ResponseMessagesTracker
      {
         return ResponseMessagesTracker.getInstance();
      }
      
      
      private function get SERVER_PROXY() : IServerProxy
      {
         return ServerProxyInstance.getInstance();
      }
      
      
      private function get G_FLAGS() : GlobalFlags
      {
         return GlobalFlags.getInstance();
      }
      
      
      private var _reconnectLabelText:String = Localizer.string("Popups", "label.reconnect");
      
      
      public function ConnectionManager()
      {
         with (SERVER_PROXY)
         {
            addEventListener(ServerProxyEvent.CONNECTION_ESTABLISHED, serverProxy_connectionEstablishedHandler);
            addEventListener(ServerProxyEvent.CONNECTION_LOST,        serverProxy_connectionLostHandler);
            addEventListener(ServerProxyEvent.CONNECTION_TIMEOUT,     serverProxy_connectionTimeoutHandler);
            addEventListener(ServerProxyEvent.IO_ERROR,               serverProxy_ioErrorHandler);
         }
         EventBroker.subscribe(GlobalEvent.APP_RESET, global_appResetHandler);
      }
      
      
      private function global_appResetHandler(event:GlobalEvent) : void
      {
         disconnect();
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      /**
       * Connects to the server.
       */
      public function connect() : void
      {
         G_FLAGS.lockApplication = true;
         SERVER_PROXY.connect(ML.startupInfo.server, ML.startupInfo.port);
      }
      
      
      /**
       * Disconnects from the server.
       */
      public function disconnect() : void
      {
         SERVER_PROXY.disconnect();
      }
      
      
      private var _gotDisconnectWarning:Boolean = false;
      /**
       * Called by <code>controllers.players.action.DisconnectAction</code> when a message warning about
       * upcomming disconnection is received.
       */
      public function serverWillDisconnect(reason:String) : void
      {
         _gotDisconnectWarning = true;
         
         var popup:ErrorPopup = new ErrorPopup();
         popup.retryButtonLabel = _reconnectLabelText
         popup.showCancelButton = false;
         popup.closeHandler = errorPopup_closeHandler;
         
         var title:String = popup.title = Localizer.string("Popups", "title.disconnect." + reason);
         if (title != null)
         {
            popup.title = title;
         }
         else
         {
            popup.title = Localizer.string("Popups", "title.disconnect.default");
         }
         
         var message:String = Localizer.string("Popups", "message.disconnect." + reason, [_reconnectLabelText]); 
         if (message != null)
         {
            popup.message = message;
         }
         else
         {
            popup.message = Localizer.string("Popups", "message.disconnect.default");
         }
         
         popup.show();
         popup = null;
         
         RESP_MSG_TRACKER.reset();
         G_FLAGS.lockApplication = false;
      }
      
      
      /**
       * Called by <code>ResponseMessagesTracker</code> when response message has not been received in time.
       */
      public function responseTimeout() : void
      {
         serverProxy_connectionTimeoutHandler(null);
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      /**
       * @see utils.remote.IServerProxy#connected
       */
      public function get connected() : Boolean
      {
         return SERVER_PROXY.connected;
      }
      
      
      /* ############################# */
      /* ### POPUPS CLOSE HANDLERS ### */
      /* ############################# */
      
      
      private function errorPopup_closeHandler(command:String) : void
      {
         StartupManager.resetApp();
         connect();
      }
      
      
      /* ################################### */
      /* ### SERVER PROXY EVENT HANDLERS ### */
      /* ################################### */
      
      
      private function serverProxy_connectionEstablishedHandler(event:ServerProxyEvent) : void
      {
         new PlayersCommand(PlayersCommand.LOGIN).dispatch();
      }
      
      
      private function serverProxy_connectionLostHandler(event:ServerProxyEvent) : void
      {
         showErrorPopup("connectionLost", "connectionLost", [_reconnectLabelText]);
      }
      
      
      private function serverProxy_connectionTimeoutHandler(event:ServerProxyEvent) : void
      {
         showErrorPopup("connectionTimeout", "connectionTimeout",
                        [ResponseMessagesTracker.MAX_WAIT_TIME / 1000, _reconnectLabelText]); 
      }
      
      
      private function serverProxy_ioErrorHandler(event:ServerProxyEvent) : void
      {
         showErrorPopup("ioError", "ioError", [_reconnectLabelText]);
         disconnect();
      }
      
      
      private function showErrorPopup(titleKey:String, messageKey:String, messageParams:Array) : void
      {
         if (_gotDisconnectWarning)
         {
            _gotDisconnectWarning = false;
            return;
         }
         
         ML.player.pending = false;
         
         var popup:ErrorPopup = new ErrorPopup();
         popup.title   = Localizer.string("Popups", "title." + titleKey);
         popup.message = Localizer.string("Popups", "message." + messageKey, messageParams);
         popup.retryButtonLabel = _reconnectLabelText;
         popup.showCancelButton = false;
         popup.closeHandler = errorPopup_closeHandler;
         popup.show();
         
         RESP_MSG_TRACKER.reset();
         G_FLAGS.lockApplication = false;
      }
   }
}