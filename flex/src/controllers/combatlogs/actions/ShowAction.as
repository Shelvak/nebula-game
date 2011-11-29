package controllers.combatlogs.actions
{

   import com.adobe.serialization.json.JSON;
   import com.developmentarc.core.utils.EventBroker;

   import config.Config;

   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.battle.BattleController;
   import controllers.connection.ConnectionManager;
   import controllers.navigation.MCTopLevel;
   import controllers.screens.Screens;
   import controllers.startup.StartupInfo;

   import utils.PropertiesTransformer;
   import utils.remote.rmo.ClientRMO;

   public class ShowAction extends CommunicationAction
   {
      private function get STARTUP_INFO() : StartupInfo
      {
         return StartupInfo.getInstance();
      }
      
      
      public override function applyClientAction(cmd:CommunicationCommand) : void
      {
         sendMessage(new ClientRMO({"id": STARTUP_INFO.logId}));
      }
      
      
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         EventBroker.clearAllSubscriptions();
         ConnectionManager.getInstance().disconnect();
         MCTopLevel.getInstance().showScreen(Screens.BATTLE);
         var log:Object = PropertiesTransformer.objectToCamelCase(JSON.decode(cmd.parameters.log));
         Config.setConfig(log.config);
         BattleController.showBattle(STARTUP_INFO.logId, log);
      }
   }
}