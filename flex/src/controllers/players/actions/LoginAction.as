package controllers.players.actions
{
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.navigation.MCTopLevel;
   import controllers.players.AuthorizationManager;
   import controllers.screens.Screens;
   import controllers.startup.StartupInfo;
   
   import utils.remote.rmo.ClientRMO;
   
   
   // TODO: new authentication mechanism: authentication with game server
   /**
    * Performs a login operation.
    */
   public class LoginAction extends CommunicationAction
   {
      private function get STARTUP_INFO() : StartupInfo {
         return StartupInfo.getInstance();
      }
      
      private function get GF() : GlobalFlags {
         return GlobalFlags.getInstance();
      }
      
      
      public function LoginAction() {
         super ();
      }
      
      
      public override function applyClientAction(cmd:CommunicationCommand) : void {
         sendMessage(new ClientRMO({
            "webPlayerId": STARTUP_INFO.webPlayerId,
            "serverPlayerId": STARTUP_INFO.serverPlayerId
         }));
      }
      
      public override function applyServerAction(cmd:CommunicationCommand) : void {
         var authManager:AuthorizationManager = AuthorizationManager.getInstance();
         if (cmd.parameters["success"])
            authManager.loginSuccessful();
         else {
            GF.lockApplication = false;
            authManager.loginFailed();
//            var popup:ErrorPopup = new ErrorPopup();
//            popup.title = Localizer.string("Popups", "title.loginFailed");
//            popup.message = Localizer.string("Popups", "message.loginFailed");
//            popup.cancelButtonLabel = Localizer.string("Popups", "label.ok");
//            popup.showRetryButton = false;
//            popup.show();
         }
      }
   }
}