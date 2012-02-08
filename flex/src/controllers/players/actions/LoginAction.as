package controllers.players.actions
{
   import application.Version;

   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import utils.ApplicationLocker;
   import controllers.players.AuthorizationManager;
   import controllers.startup.StartupInfo;
   
   import utils.remote.rmo.ClientRMO;
   import utils.remote.rmo.ServerRMO;


   /**
    * Performs a login operation.
    */
   public class LoginAction extends CommunicationAction
   {
      private function get SI() : StartupInfo {
         return StartupInfo.getInstance();
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
               AM.versionTooOld(cmd.parameters["requiredVersion"]);
            }
            else {
               cancel(null, null);
            }
         }
      }
      
      public override function cancel(rmo:ClientRMO, srmo: ServerRMO) : void {
         super.cancel(rmo, srmo);
         AM.loginFailed();
      }
   }
}