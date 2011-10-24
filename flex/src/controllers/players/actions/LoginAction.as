package controllers.players.actions
{
   import application.Version;

   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.players.AuthorizationManager;
   import controllers.startup.StartupInfo;
   
   import utils.remote.rmo.ClientRMO;
   
   
   /**
    * Performs a login operation.
    */
   public class LoginAction extends CommunicationAction
   {
      private function get SI() : StartupInfo {
         return StartupInfo.getInstance();
      }
      
      private function get GF() : GlobalFlags {
         return GlobalFlags.getInstance();
      }
      
      private function get AM() : AuthorizationManager {
         return AuthorizationManager.getInstance();
      }
      
      
      public function LoginAction() {
         super ();
      }
      
      
      public override function applyClientAction(cmd:CommunicationCommand) : void {
         sendMessage(new ClientRMO({
            "webPlayerId": SI.webPlayerId,
            "serverPlayerId": SI.serverPlayerId,
            "version": Version.VERSION
         }));
      }
      
      public override function applyServerAction(cmd:CommunicationCommand) : void {
         if (cmd.parameters["success"])
            AM.loginSuccessful();
         else {
            if (cmd.parameters["requiredVersion"]) {
               GF.lockApplication = false;
               AM.versionTooOld(cmd.parameters["requiredVersion"]);
            }
            else {
               cancel(null);
            }
         }
      }
      
      public override function cancel(rmo:ClientRMO) : void {
         GF.lockApplication = false;
         AM.loginFailed();
      }
   }
}