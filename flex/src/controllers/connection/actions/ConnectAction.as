package controllers.connection.actions
{
   import com.developmentarc.core.utils.EventBroker;
   
   import components.popups.ErrorPopup;
   import components.popups.PopupCommand;
   
   import controllers.BaseAction;
   import controllers.GlobalFlags;
   import controllers.players.PlayersCommand;
   
   import flash.events.Event;
   import flash.events.SecurityErrorEvent;
   
   import globalevents.GConnectionEvent;
   
   import utils.Localizer;
   import utils.remote.ServerConnector;
   
   
   
   
   [ResourceBundle ("Popups")]
   /**
    * Tries to establish a connection between the server and the client.
    * In addition if connection has been lost shows alert screen for user
    * who may then choose to reconnect or quit.
    */ 
   public class ConnectAction extends BaseAction
   {
      public override function applyAction (command: Event) :void
      {
         ServerConnector.getInstance().connect ();
      }
      
      
      /**
       * Constructor.
       */
      public function ConnectAction ()
      {
         EventBroker.subscribe(GConnectionEvent.CONNECTION_CLOSED,connector_connectionClosedHandler);
         EventBroker.subscribe(SecurityErrorEvent.SECURITY_ERROR,serverConnector_Error);
      }
      
      
      /**
       * If connection is closed and player.loggedIn is still true, that means
       * connection has been lost and we must show alert.
       */
      private function connector_connectionClosedHandler(event:GConnectionEvent) :void
      {
         if (ML.player.loggedIn)
         {
            var popup: ErrorPopup = new ErrorPopup ();
            popup.title   = Localizer.string ("Popups", "title.connectionLost");
            popup.message = Localizer.string ("Popups", "message.connectionLost");
            popup.retryButtonLabel  = Localizer.string ("Popups", "label.reconnect");
            popup.cancelButtonLabel = Localizer.string ("Popups", "label.logout");
            popup.closeHandler =
               function (cmd: String) :void
               {
                  switch (cmd)
                  {
                     case PopupCommand.RETRY:
                        GlobalFlags.getInstance().reconnecting = true;
                        new PlayersCommand (PlayersCommand.LOGIN).dispatch ();
                        break;
                     
                     case PopupCommand.CANCEL:
                        new PlayersCommand (PlayersCommand.LOGOUT).dispatch ();
                        break;
                  }
               };
            popup.show ();
         }
      }
      
      
      /** 
      * This error should appear when socket times out while trying to connect. 
      */
      private function serverConnector_Error (event: Event) :void
      {
         ML.player.pending = false;
         
         var popup: ErrorPopup = new ErrorPopup ();
         popup.title   = Localizer.string ("Popups", "title.connectionTimeout");
         popup.message = Localizer.string ("Popups", "message.connectionTimeout");
         popup.retryButtonLabel = Localizer.string ("Popups", "label.retry");
         // If connection has been lost during the game labels are a bit different
         if (GlobalFlags.getInstance().reconnecting)
         {
            popup.cancelButtonLabel = Localizer.string ("Popups", "label.logout");
         }
         else
         {
            popup.cancelButtonLabel = Localizer.string ("Popups", "label.cancel");
         }
         
         popup.closeHandler =
            function (cmd: String) :void
            {
               switch (cmd)
               {
                  case PopupCommand.RETRY:
                     new PlayersCommand(PlayersCommand.LOGIN).dispatch ();
                     break;
                     
                  case PopupCommand.CANCEL:
                     new PlayersCommand(PlayersCommand.LOGOUT).dispatch ();
                     break;
               }
            };
         popup.show ();
      }
   }
}