package controllers.combatlogs.actions
{
   import com.developmentarc.core.utils.EventBroker;

   import config.Config;

   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.battle.BattleController;
   import controllers.connection.ConnectionManager;
   import controllers.navigation.MCTopLevel;
   import controllers.screens.Screens;
   import controllers.startup.StartupInfo;

   import mx.controls.Alert;
   import mx.utils.ObjectUtil;

   import utils.remote.rmo.ClientRMO;
   import utils.remote.rmo.ServerRMO;

   public class ShowAction extends CommunicationAction
   {
      private function get STARTUP_INFO() : StartupInfo
      {
         return StartupInfo.getInstance();
      }
      
      
      public override function applyClientAction(cmd:CommunicationCommand) : void
      {
         MCTopLevel.getInstance().showScreen(Screens.CREATING_MAP);
         sendMessage(new ClientRMO({"id": STARTUP_INFO.logId}));
      }
      
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         EventBroker.clearAllSubscriptions();
         ConnectionManager.getInstance().disconnect();
         MCTopLevel.getInstance().showScreen(Screens.BATTLE);
         var log:Object = cmd.parameters.log;
         Config.setConfig(log.config);
         BattleController.showBattle(STARTUP_INFO.logId, log);
      }


      override public function cancel(rmo: ClientRMO, srmo: ServerRMO): void {
         super.cancel(rmo, srmo);
         Alert.show("Error while fetching combat log! Server said:\n\n" +
            ObjectUtil.toString(srmo.error));
      }
   }
}