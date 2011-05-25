package controllers.players.actions
{
   import components.popups.ErrorPopup;
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.galaxies.GalaxiesCommand;
   import controllers.screens.MainAreaScreens;
   import controllers.screens.MainAreaScreensSwitch;
   import controllers.screens.Screens;
   import controllers.screens.ScreensSwitch;
   import controllers.startup.StartupInfo;
   
   import utils.locale.Localizer;
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Performs a login operation.
    */
   public class LoginAction extends CommunicationAction
   {
      private function get STARTUP_INFO() : StartupInfo
      {
         return StartupInfo.getInstance();
      }
      
      
      public function LoginAction()
      {
         super ();
      }
      
      
      public override function applyClientAction(cmd:CommunicationCommand) : void
      {         
         sendMessage(new ClientRMO({
            "galaxyId":  STARTUP_INFO.galaxyId,
            "authToken": STARTUP_INFO.authToken
         }));
      }
      
      
      public override function applyServerAction(cmd:CommunicationCommand) : void
      {
         if (cmd.parameters.success)
         {
            ML.player.loggedIn = true;
            ScreensSwitch.getInstance().showScreen(Screens.MAIN);
         }
         else
         {
            var popup:ErrorPopup = new ErrorPopup();
            popup.title = Localizer.string("Popups", "title.loginFailed");
            popup.message = Localizer.string("Popups", "message.loginFailed");
            popup.cancelButtonLabel = Localizer.string("Popups", "label.ok");
            popup.showRetryButton = false;
            popup.show();
         }
      }
   }
}