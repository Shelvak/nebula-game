package controllers.players.actions
{
   import com.developmentarc.core.utils.EventBroker;
   
   import components.popups.ErrorPopup;
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.connection.ConnectionCommand;
   import controllers.galaxies.GalaxiesCommand;
   import controllers.game.events.GameEvent;
   import controllers.screens.Screens;
   import controllers.screens.ScreensSwitch;
   
   import globalevents.GConnectionEvent;
   
   import utils.Localizer;
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Performs a login operation. Connects with the server and then logs in. 
    */
   public class LoginAction extends CommunicationAction
   {
      public function LoginAction()
      {
         super ();
         
         EventBroker.subscribe(
            GConnectionEvent.CONNECTION_ESTABLISHED,
            proceedWithLogin
         );
         
         EventBroker.subscribe(
            GameEvent.CONFIG_SET,
            function(e:GameEvent) : void
            {
               dispatchGalaxiesShowCommand();
            }
         );
      }
      
      
      /**
       * @private
       */      
      public override function applyClientAction(cmd:CommunicationCommand) : void
      {         
         GlobalFlags.getInstance().lockApplication = true;
         new ConnectionCommand(ConnectionCommand.CONNECT).dispatch();
      }
      
      
      /**
       * When connection has been established with the server this method
       * sends a login message to the server.
       */
      private function proceedWithLogin(event:GConnectionEvent) :void
      {
         sendMessage(new ClientRMO(
            {"galaxyId": ML.startupInfo.galaxyId,
             "authToken": ML.startupInfo.authToken}
         ));
      }
      
      
      /**
       * @private 
       */
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         if (cmd.parameters.success)
         {
            ML.player.loggedIn = true;
            if (!GlobalFlags.getInstance().reconnecting)
            {
               ScreensSwitch.getInstance().showScreen(Screens.MAIN);
            }
         }
         else
         {
            var popup: ErrorPopup = new ErrorPopup ();
            popup.title = Localizer.string ("Popups", "title.loginFailed");
            popup.message = Localizer.string ("Popups", "message.loginFailed");
            popup.cancelButtonLabel = Localizer.string ("Popups", "label.ok");
            popup.showRetryButton = false;
            popup.show();
         }
      }
      
      private function dispatchGalaxiesShowCommand() : void
      {
         new GalaxiesCommand(GalaxiesCommand.SHOW).dispatch();
      }
   }
}