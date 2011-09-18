package controllers.players
{
   import controllers.connection.ConnectionManager;
   import controllers.navigation.MCTopLevel;
   import controllers.screens.Screens;
   import controllers.startup.StartupInfo;
   
   import flash.external.ExternalInterface;
   
   import models.ModelLocator;
   
   import utils.Objects;
   import utils.SingletonFactory;
   import utils.locale.Localizer;

   public class AuthorizationManager
   {
      private static const JSFN_AUTHORIZE:String = "authorize";
      private static const JSFN_AUTHORIZATION_FAIL:String = "authorizationFailed";
      private static const ASFN_AUTHORIZATION_SUCCESS:String = "authorizationSuccessful";
      
      private function get ML() : ModelLocator {
         return ModelLocator.getInstance();
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
         ExternalInterface.call(JSFN_AUTHORIZE, StartupInfo.getInstance().webPlayerId);
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
      
      public function loginFailed() : void {
         ExternalInterface.call(JSFN_AUTHORIZATION_FAIL);
         resetStatusVars();
      }
      
      public function loginSuccessful() : void {
         ML.player.loggedIn = true;
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