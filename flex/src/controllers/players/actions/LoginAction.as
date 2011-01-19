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
   
   import utils.Localizer;
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Performs a login operation.
    */
   public class LoginAction extends CommunicationAction
   {
      public function LoginAction()
      {
         super ();
      }
      
      
      public override function applyClientAction(cmd:CommunicationCommand) : void
      {         
         sendMessage(new ClientRMO({
            "galaxyId":  ML.startupInfo.galaxyId,
            "authToken": ML.startupInfo.authToken
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