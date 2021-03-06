package controllers.connection
{
   import com.developmentarc.core.utils.EventBroker;

   import components.announcement.AnnouncementPopup;
   import components.popups.ErrorPopUp;

   import controllers.combatlogs.CombatLogsCommand;
   import controllers.game.GameCommand;
   import controllers.messages.ResponseMessagesTracker;
   import controllers.players.PlayersCommand;
   import controllers.startup.StartupInfo;
   import controllers.startup.StartupManager;
   import controllers.startup.StartupMode;

   import globalevents.GlobalEvent;

   import models.ModelLocator;

   import spark.components.Button;

   import utils.SingletonFactory;
   import utils.locale.Localizer;
   import utils.logging.Log;
   import utils.remote.IServerProxy;
   import utils.remote.ServerProxyInstance;
   import utils.remote.events.ServerProxyEvent;
   import utils.remote.rmo.ServerRMO;


   public class ConnectionManager
   {
      public static function getInstance(): ConnectionManager {
         return SingletonFactory.getSingletonInstance(ConnectionManager);
      }

      private function get ML(): ModelLocator {
         return ModelLocator.getInstance();
      }

      private function get RESP_MSG_TRACKER(): ResponseMessagesTracker {
         return ResponseMessagesTracker.getInstance();
      }

      private function get SERVER_PROXY(): IServerProxy {
         return ServerProxyInstance.getInstance();
      }

      private function get STARTUP_INFO(): StartupInfo {
         return StartupInfo.getInstance();
      }

      private var _reconnectLabelText: String = null;
      private function get reconnectLabelText(): String {
         if (_reconnectLabelText == null) {
            _reconnectLabelText = Localizer.string("Popups", "label.reconnect");
         }
         return _reconnectLabelText;
      }

      public function ConnectionManager() {
         with (SERVER_PROXY) {
            addEventListener(ServerProxyEvent.CONNECTION_ESTABLISHED,
                             serverProxy_connectionEstablishedHandler);
            addEventListener(ServerProxyEvent.CONNECTION_LOST, serverProxy_connectionLostHandler);
            addEventListener(ServerProxyEvent.CONNECTION_TIMEOUT,
                             serverProxy_connectionTimeoutHandler);
            addEventListener(ServerProxyEvent.IO_ERROR, serverProxy_ioErrorHandler);
         }
         EventBroker.subscribe(GlobalEvent.APP_RESET, global_appResetHandler);
      }

      private function global_appResetHandler(event: GlobalEvent): void {
         disconnect();
         _gotDisconnectWarning = false;
      }


      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */

      /**
       * Connects to the server.
       */
      public function connect(): void {
         SERVER_PROXY.connect(STARTUP_INFO.server, STARTUP_INFO.port);
      }

      /**
       * Disconnects from the server.
       */
      public function disconnect(): void {
         SERVER_PROXY.disconnect();
      }

      private var _gotDisconnectWarning: Boolean = false;

      /**
       * Called by <code>controllers.players.action.DisconnectAction</code> when a message warning about
       * upcoming disconnection is received or by <code>controllers.players.MultiAccountController</code>
       * when player using same computer logs in to the same galaxy.
       */
      public function serverWillDisconnect(reason: String, showRetryButton: Boolean = true): void {
         _gotDisconnectWarning = true;

         if (reason == "unhandledMessage") {
            throw new Error("Unhandled message error");
         }
         else if (reason == "notAMessage") {
            throw new Error("A malformed message has been sent to the server");
         }

         var popup: ErrorPopUp = new ErrorPopUp();
         popup.showCancelButton = false;
         popup.retryButtonLabel = reconnectLabelText;
         popup.retryButtonClickHandler = retryButton_clickHandler;
         popup.showRetryButton = showRetryButton;

         var title: String = popup.title = Localizer.string("Popups", "title.disconnect." + reason);
         if (title != null) {
            popup.title = title;
         }
         else {
            popup.title = Localizer.string("Popups", "title.disconnect.default");
         }

         var message: String = Localizer.string(
            "Popups", "message.disconnect." + reason, [reconnectLabelText]);
         if (message != null) {
            popup.message = message;
         }
         else {
            popup.message = Localizer.string("Popups", "message.disconnect.default");
         }

         popup.show();
         popup = null;

         var announcementPopup: AnnouncementPopup = AnnouncementPopup.getInstance();
         if (announcementPopup.isShown) {
            announcementPopup.show();
         }

         RESP_MSG_TRACKER.reset();
      }

      /**
       * Called by <code>ResponseMessagesTracker</code> when response message has not been received in time.
       */
      public function responseTimeout(): void {
         serverProxy_connectionTimeoutHandler(null);
      }


      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */

      /**
       * @see utils.remote.IServerProxy#connected
       */
      public function get connected(): Boolean {
         return SERVER_PROXY.connected;
      }


      /* ############################# */
      /* ### POPUPS CLOSE HANDLERS ### */
      /* ############################# */

      private function retryButton_clickHandler(button: Button): void {
         Log.getMethodLogger(ConnectionManager, "retryButton_clickHandler")
            .info("Resetting due to reconnect.");
         StartupManager.resetApp();
         StartupManager.connectAndAuthorize();
      }


      /* ################################### */
      /* ### SERVER PROXY EVENT HANDLERS ### */
      /* ################################### */

      private function serverProxy_connectionEstablishedHandler(event: ServerProxyEvent): void {
         switch (STARTUP_INFO.mode) {

            case StartupMode.GAME:
               new PlayersCommand(PlayersCommand.LOGIN).dispatch();
               break;

            case StartupMode.BATTLE:
               new CombatLogsCommand(CombatLogsCommand.SHOW).dispatch();
               break;

            case StartupMode.MAP_EDITOR:
               new GameCommand(GameCommand.CONFIG).dispatch();
               break;
         }
      }

      private function serverProxy_connectionLostHandler(event: ServerProxyEvent): void {
         // check if we have a unprocessed players|disconnect messages from the server
         // if we do, don't show the message here: soon serverWillDisconnect() will be called
         // and the user will be notified
         for each (var rmo: ServerRMO in SERVER_PROXY.unprocessedMessages) {
            if (rmo.action == PlayersCommand.DISCONNECT) {
               return;
            }
         }
         // do not process any leftover messages after disconnect
         SERVER_PROXY.getUnprocessedMessages();
         showNoConnectionPopup();
      }

      private function serverProxy_connectionTimeoutHandler(event: ServerProxyEvent): void {
         showNoConnectionPopup();
      }

      private function serverProxy_ioErrorHandler(event: ServerProxyEvent): void {
         showNoConnectionPopup();
         disconnect();
      }

      private function showNoConnectionPopup(): void {
         showErrorPopup("noConnection", "noConnection", [reconnectLabelText]);
      }

      private function showErrorPopup(titleKey: String, messageKey: String,
                                      messageParams: Array): void {
         if (_gotDisconnectWarning) {
            _gotDisconnectWarning = false;
            return;
         }

         ML.player.pending = false;

         var popup: ErrorPopUp = new ErrorPopUp();
         popup.title = Localizer.string("Popups", "title." + titleKey);
         popup.message = Localizer.string("Popups", "message." + messageKey, messageParams);
         popup.showCancelButton = false;
         popup.retryButtonLabel = reconnectLabelText;
         popup.retryButtonClickHandler = retryButton_clickHandler;
         popup.show();

         RESP_MSG_TRACKER.reset();
      }
   }
}