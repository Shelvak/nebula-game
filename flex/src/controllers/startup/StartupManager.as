package controllers.startup
{
   import com.developmentarc.core.actions.ActionDelegate;
   import com.developmentarc.core.actions.actions.AbstractAction;
   import com.developmentarc.core.utils.EventBroker;
   import com.developmentarc.core.utils.SingletonFactory;
   
   import controllers.GlobalFlags;
   import controllers.buildings.BuildingsCommand;
   import controllers.buildings.actions.*;
   import controllers.combatLogs.CombatLogsCommand;
   import controllers.combatLogs.actions.ShowAction;
   import controllers.connection.ConnectionCommand;
   import controllers.connection.actions.*;
   import controllers.constructionQueues.ConstructionQueuesCommand;
   import controllers.constructionQueues.actions.IndexAction;
   import controllers.game.GameCommand;
   import controllers.game.actions.*;
   import controllers.messages.MessageCommand;
   import controllers.messages.ResponseMessagesTracker;
   import controllers.messages.actions.*;
   import controllers.notifications.NotificationsCommand;
   import controllers.notifications.actions.*;
   import controllers.objects.ObjectsCommand;
   import controllers.objects.actions.*;
   import controllers.planets.PlanetsCommand;
   import controllers.planets.actions.*;
   import controllers.players.PlayersCommand;
   import controllers.players.actions.*;
   import controllers.quests.QuestsCommand;
   import controllers.quests.actions.ClaimRewardsAction;
   import controllers.quests.actions.IndexAction;
   import controllers.resources.ResourcesCommand;
   import controllers.resources.actions.*;
   import controllers.routes.RoutesCommand;
   import controllers.routes.actions.*;
   import controllers.screens.Screens;
   import controllers.screens.ScreensSwitch;
   import controllers.solarSystems.SolarSystemsCommand;
   import controllers.solarSystems.actions.*;
   import controllers.technologies.TechnologiesCommand;
   import controllers.technologies.actions.*;
   import controllers.units.SquadronsController;
   import controllers.units.UnitsCommand;
   import controllers.units.actions.*;
   
   import flash.external.ExternalInterface;
   
   import globalevents.GlobalEvent;
   
   import models.BaseModel;
   import models.Galaxy;
   import models.ModelLocator;
   
   import mx.controls.Alert;
   
   import utils.DateUtil;
   
   
   public class StartupManager
   {
      // One ActionDelegate is needed for whole application
      // Is directly tampered with only during command-to-action binding process  
      private static var delegate:ActionDelegate = SingletonFactory.getSingletonInstance(ActionDelegate);
      
      
      /**
       * Call this once during application startup. This method will bind
       * commands to appropriate actions as well as initialize any
       * classes that need special treatment.
       */	   
      public static function initializeApp() : void
      {
         initializeFreeSingletons();
         bindCommandsToActions();
         setupBaseModel();
         
         EventBroker.subscribe(GlobalEvent.APP_RESET, resetApp);
         
         if (loadStartupInfo())
         {
            var ML:ModelLocator = ModelLocator.getInstance();
            ML.player.galaxyId = ML.startupInfo.galaxyId;
            SquadronsController.getInstance().startMovementTimer();
            new PlayersCommand(PlayersCommand.LOGIN).dispatch();
         }
      }
      
      
      private static function setupBaseModel() : void
      {
         BaseModel.setTypePostProcessor(Date,
            function(instance:BaseModel, property:String, value:Date) : void
            {
               instance[property] = DateUtil.getLocalTime(value);
            }
         );
      }
      
      
      private static function loadStartupInfo() : Boolean
      {
         if (!ExternalInterface.available)
         {
            Alert.show("ExternalInterface not available: please upgrade your browser.", "Error!");
            return false;
         }
         ModelLocator.getInstance().startupInfo = BaseModel.createModel(StartupInfo, ExternalInterface.call("getGameOptions"));
         return true;
      }
      
      
      /**
       * Resets some of singletons and static classes to their initial state.
       * Switches login screen.
       */
      private static function resetApp(event:GlobalEvent) : void
      {
         ResponseMessagesTracker.getInstance().reset();
         ModelLocator.getInstance().reset();
         GlobalFlags.reset();
         ScreensSwitch.getInstance().showScreen(Screens.LOGIN);
      }
      
      
      /**
       * Creates and registers singletons with SingletonFactory that aren't used
       * by any other classes (STILL EMTPY).
       */      
      private static function initializeFreeSingletons () :void
      {
      }
      
      
      /**
       * Just and agregate function for all bindings: makes the whole process
       * more understandable.
       */      
      private static function bindCommandsToActions () :void
      {
         bindConnectionCommands ();
         bindMessagesCommands ();
         bindPlayerCommands ();
         bindSolarSystemsCommands ();
         bindPlanetCommands ();
         bindGameCommands ();
         bindResourcesCommands();
         bindBuildingsCommands();
         bindTechnologiesCommands();
         bindConstructionQueuesCommands();
         bindUnitsCommands();
         bindNotificationsCommands();
         bindCombatLogsCommands();
         bindObjectsCommands();
         bindRoutesCommands();
         bindQuestsCommands();
      }
      
      private static function bindQuestsCommands() : void
      {
         bindPair(QuestsCommand.INDEX, new controllers.quests.actions.IndexAction());
         bindPair(QuestsCommand.CLAIM_REWARDS, new controllers.quests.actions.ClaimRewardsAction());
      }
      
      private static function bindRoutesCommands() : void
      {
         bindPair(RoutesCommand.INDEX, new controllers.routes.actions.IndexAction());
      }
      private static function bindCombatLogsCommands() : void
      {
         bindPair(CombatLogsCommand.SHOW, new controllers.combatLogs.actions.ShowAction());
      }
      private static function bindNotificationsCommands() : void
      {
         bindPair(NotificationsCommand.INDEX, new controllers.notifications.actions.IndexAction());
         bindPair(NotificationsCommand.STAR, new StarAction());
         bindPair(NotificationsCommand.READ, new ReadAction());
      }
      private static function bindUnitsCommands() : void
      {
         bindPair(UnitsCommand.NEW, new controllers.units.actions.NewAction());
         bindPair(UnitsCommand.UPDATE, new controllers.units.actions.UpdateAction());
         bindPair(UnitsCommand.ATTACK, new controllers.units.actions.AttackAction());
         bindPair(UnitsCommand.MOVE, new controllers.units.actions.MoveAction());
         bindPair(UnitsCommand.MOVEMENT, new MovementAction());
         bindPair(UnitsCommand.MOVEMENT_PREPARE, new MovementPrepareAction());
      }
      private static function bindObjectsCommands() : void
      {
         bindPair(ObjectsCommand.DESTROYED, new controllers.objects.actions.DestroyedAction());
         bindPair(ObjectsCommand.UPDATED, new controllers.objects.actions.UpdatedAction());
         bindPair(ObjectsCommand.CREATED, new controllers.objects.actions.CreatedAction());
      }
      private static function bindResourcesCommands() : void
      {
         bindPair(ResourcesCommand.INDEX, new controllers.resources.actions.IndexAction());
      }
      private static function bindBuildingsCommands() : void
      {
         bindPair(BuildingsCommand.NEW, new controllers.buildings.actions.NewAction());
         bindPair(BuildingsCommand.UPGRADE, new controllers.buildings.actions.UpgradeAction());
         bindPair(BuildingsCommand.ACTIVATE, new controllers.buildings.actions.ActivateAction());
         bindPair(BuildingsCommand.DEACTIVATE, new controllers.buildings.actions.DeactivateAction());
      }
      private static function bindTechnologiesCommands() : void
      {
         bindPair(TechnologiesCommand.INDEX, new controllers.technologies.actions.IndexAction());
         bindPair(TechnologiesCommand.NEW, new controllers.technologies.actions.NewAction());
         bindPair(TechnologiesCommand.UPGRADE, new controllers.technologies.actions.UpgradeAction());
         bindPair(TechnologiesCommand.UPDATE, new controllers.technologies.actions.UpdateAction());
         bindPair(TechnologiesCommand.PAUSE, new controllers.technologies.actions.PauseAction());
         bindPair(TechnologiesCommand.RESUME, new controllers.technologies.actions.ResumeAction());
      }
      private static function bindConstructionQueuesCommands() : void
      {
         bindPair(ConstructionQueuesCommand.INDEX, new controllers.constructionQueues.actions.IndexAction());
         bindPair(ConstructionQueuesCommand.MOVE, new controllers.constructionQueues.actions.MoveAction());
         bindPair(ConstructionQueuesCommand.REDUCE, new controllers.constructionQueues.actions.ReduceAction());
         bindPair(ConstructionQueuesCommand.SPLIT, new controllers.constructionQueues.actions.SplitAction());
      }
      private static function bindGameCommands() : void
      {
         bindPair(GameCommand.CONFIG, new ConfigAction());
      }
      private static function bindConnectionCommands() : void
      {
         bindPair(ConnectionCommand.CONNECT, new ConnectAction());
      }
      private static function bindMessagesCommands() : void
      {
         bindPair(MessageCommand.MESSAGE_RECEIVED, new MessageReceivedAction());
         bindPair(MessageCommand.RESPONSE_RECEIVED, new ResponseReceivedAction());
         bindPair(MessageCommand.SEND_MESSAGE, new SendMessageAction());
      }
      private static function bindPlayerCommands() : void
      {
         bindPair(PlayersCommand.LOGIN, new LoginAction());
         bindPair(PlayersCommand.LOGOUT, new LogoutAction());
         bindPair(PlayersCommand.DISCONNECT, new DisconnectAction());
         bindPair(PlayersCommand.SHOW, new controllers.players.actions.ShowAction());
      }
      private static function bindSolarSystemsCommands() : void
      {
         bindPair(
            SolarSystemsCommand.INDEX,
            new controllers.solarSystems.actions.IndexAction()
         );
      }
      private static function bindPlanetCommands() : void
      {
         bindPair(PlanetsCommand.INDEX, new controllers.planets.actions.IndexAction());
         bindPair(PlanetsCommand.SHOW, new controllers.planets.actions.ShowAction());
         bindPair(PlanetsCommand.PLAYER_INDEX, new PlayerIndexAction());
      }
      
      /**
       * Binds single command to a single action. 
       */      
      private static function bindPair(command:String, action:AbstractAction) : void
      {
         action.addCommand(command);
         delegate.addAction(action);
      }
   }
}