package controllers.combatlogs.actions
{
   
   import com.adobe.serialization.json.JSON;
   import com.developmentarc.core.utils.EventBroker;
   
   import config.Config;
   
   import controllers.CommunicationAction;
   import controllers.CommunicationCommand;
   import controllers.GlobalFlags;
   import controllers.battle.BattleController;
   import controllers.connection.ConnectionManager;
   import controllers.screens.Screens;
   import controllers.screens.ScreensSwitch;
   
   import utils.PropertiesTransformer;
   import utils.remote.rmo.ClientRMO;
   
   
   public class ShowAction extends CommunicationAction
   {
      public override function applyClientAction(cmd:CommunicationCommand) : void
      {
         sendMessage(new ClientRMO({"id": ML.startupInfo.logId}));
      }
      
      
      override public function applyServerAction(cmd:CommunicationCommand) : void
      {
         EventBroker.clearAllSubscriptions();
         ConnectionManager.getInstance().disconnect();
         ScreensSwitch.getInstance().showScreen(Screens.BATTLE);
         var log:Object = PropertiesTransformer.objectToCamelCase(JSON.decode(cmd.parameters.log));
         Config.setConfig(log.config);
         BattleController.showBattle(ML.startupInfo.logId, log);
         GlobalFlags.getInstance().lockApplication = false;
      }
   }
}