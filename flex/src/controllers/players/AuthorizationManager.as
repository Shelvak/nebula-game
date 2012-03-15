package controllers.players
{
   import application.Version;

   import controllers.connection.ConnectionManager;
   import controllers.navigation.MCTopLevel;
   import controllers.screens.Screens;
   import controllers.startup.StartupInfo;

   import flash.external.ExternalInterface;

   import utils.SingletonFactory;
   import utils.locale.Localizer;


   public class AuthorizationManager
   {
      private static const JSFN_LOGIN_SUCCESSFUL:String = "loginSuccessful";
      private static const JSFN_AUTHORIZE:String = "authorize";
      private static const JSFN_VERSION_TOO_OLD:String = "versionTooOld";
      private static const JSFN_AUTHORIZATION_FAIL:String = "authorizationFailed";
      private static const ASFN_AUTHORIZATION_SUCCESS:String = "authorizationSuccessful";
      
      private function get SI() : StartupInfo {
         return StartupInfo.getInstance();
      }

      private function get SCREEN_SWITCH() : MCTopLevel {
         return MCTopLevel.getInstance();
      }
      
      
      public static function getInstance() : AuthorizationManager {
         return SingletonFactory.getSingletonInstance(AuthorizationManager);
      }
      
      
      public function AuthorizationManager() {
         ExternalInterface.addCallback(ASFN_AUTHORIZATION_SUCCESS, authorizationSuccess);
      }
      
      [Bindable]
      public var statusText:String = "";
      
      [Bindable]
      public var working:Boolean = false;
      
      
      /* ################################# */
      /* ### AUTHORIZE WITH WEB SERVER ### */
      /* ################################# */
      
      public function authorizeLoginAndProceed() : void {
         SCREEN_SWITCH.resetToScreen(Screens.AUTHORIZATION);
         working = true;
         initiateAuthorization();
      }
      
      private function initiateAuthorization() : void {
         statusText = getString("authorization");
         ExternalInterface.call(JSFN_AUTHORIZE, SI.webPlayerId);
      }
      
      private function authorizationSuccess() : void {
         initiateConnectionAndLogin();
      }
      
      
      /* ########################### */
      /* ### LOGIN TO THE SERVER ### */
      /* ########################### */
      
      private function initiateConnectionAndLogin() : void {
         statusText = getString("login");
         ConnectionManager.getInstance().connect();
      }

      public function versionTooOld(required: String) : void {
         ExternalInterface.call(JSFN_VERSION_TOO_OLD, required,
            Version.VERSION);
         resetStatusVars();
      }
      
      public function loginFailed() : void {
         try {
            ExternalInterface.call(JSFN_AUTHORIZATION_FAIL);
         }
         catch (error: Error) {
            // there is nothing to do here if JS throws an error
            // we got one error here in ~3 weeks:
            // 0001281: 2012-0302-2041|Error (error id 0):
            //
            // [Exception... "prompt aborted by user" nsresult: "0x80040111
            // (NS_ERROR_NOT_AVAILABLE)|jkwcwn
         }
         resetStatusVars();
      }
      
      public function loginSuccessful() : void {
         ExternalInterface.call(JSFN_LOGIN_SUCCESSFUL);
         SCREEN_SWITCH.showScreen(Screens.MAIN);
         resetStatusVars();
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      private function resetStatusVars() : void {
         statusText = "";
         working = false;
      }
      
      private function getString(property:String) : String {
         return Localizer.string("Authorization", "status." + property);
      }
   }
}
