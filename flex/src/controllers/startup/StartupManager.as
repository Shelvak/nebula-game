package controllers.startup
{
   import animation.AnimationTimer;
   
   import com.developmentarc.core.actions.ActionDelegate;
   import com.developmentarc.core.actions.actions.AbstractAction;
   import com.developmentarc.core.utils.EventBroker;
   
   import controllers.alliances.AlliancesCommand;
   import controllers.alliances.actions.EditAction;
   import controllers.alliances.actions.KickAction;
   import controllers.alliances.actions.LeaveAction;
   import controllers.alliances.actions.NewAction;
   import controllers.alliances.actions.RatingsAction;
   import controllers.alliances.actions.ShowAction;
   import controllers.buildings.BuildingsCommand;
   import controllers.buildings.actions.*;
   import controllers.chat.ChatCommand;
   import controllers.chat.actions.*;
   import controllers.combatlogs.CombatLogsCommand;
   import controllers.combatlogs.actions.*;
   import controllers.connection.ConnectionManager;
   import controllers.constructionqueues.ConstructionQueuesCommand;
   import controllers.constructionqueues.actions.*;
   import controllers.galaxies.GalaxiesCommand;
   import controllers.galaxies.actions.*;
   import controllers.game.GameCommand;
   import controllers.game.actions.*;
   import controllers.notifications.NotificationsCommand;
   import controllers.notifications.actions.*;
   import controllers.objects.ObjectsCommand;
   import controllers.objects.actions.*;
   import controllers.planets.PlanetsCommand;
   import controllers.planets.actions.*;
   import controllers.players.PlayersCommand;
   import controllers.players.actions.*;
   import controllers.quests.QuestsCommand;
   import controllers.quests.actions.*;
   import controllers.routes.RoutesCommand;
   import controllers.routes.actions.*;
   import controllers.screens.Screens;
   import controllers.screens.ScreensSwitch;
   import controllers.solarsystems.SolarSystemsCommand;
   import controllers.solarsystems.actions.*;
   import controllers.technologies.TechnologiesCommand;
   import controllers.technologies.actions.*;
   import controllers.timedupdate.MasterUpdateTrigger;
   import controllers.units.UnitsCommand;
   import controllers.units.actions.*;
   
   import flash.external.ExternalInterface;
   
   import globalevents.GlobalEvent;
   
   import models.BaseModel;
   import models.ModelLocator;
   import models.chat.MChat;
   
   import mx.logging.ILoggingTarget;
   import mx.logging.Log;
   import mx.logging.LogEventLevel;
   import mx.logging.targets.TraceTarget;
   import mx.managers.ToolTipManager;
   
   import utils.DateUtil;
   import utils.SingletonFactory;
   
   
   public final class StartupManager
   {
      // One ActionDelegate is needed for whole application
      // Is directly tampered with only during command-to-action binding process  
      private static var delegate:ActionDelegate = SingletonFactory.getSingletonInstance(ActionDelegate);
      
      
      // Just to keep reference to this      
      private static var masterTrigger:MasterUpdateTrigger;
      
      
      /**
       * Loads startup information information into <code>ModelLocator.startupInfo</code>.
       */
      public static function loadStartupInfo() : Boolean
      {
         var ML:ModelLocator = ModelLocator.getInstance();
         if (!ExternalInterface.available)
         {
            ML.startupInfo = new StartupInfo();
            return false;
         }
         ML.startupInfo = BaseModel.createModel(StartupInfo, ExternalInterface.call("getGameOptions"));
         if (ML.startupInfo == null)
         {
            ML.startupInfo = new StartupInfo();
            return false;
         }
         ML.startupInfo.loadSuccessful = true;
         if (ML.startupInfo.mode == StartupMode.BATTLE)
         {
            ML.player.id = ML.startupInfo.playerId;
         }
         return true;
      }
      
      
      /**
       * Call this once during application startup. This method will bind commands to appropriate actions as
       * well as initialize any classes that need special treatment.
       */	   
      public static function initializeApp() : void
      {
         initializeLogging();
         AnimationTimer.forUi.start();
         AnimationTimer.forMovement.start();
         ToolTipManager.showDelay = 0;
         ToolTipManager.hideDelay = int.MAX_VALUE;
         initializeFreeSingletons();
         bindCommandsToActions();
         setupBaseModel();
         var ML:ModelLocator = ModelLocator.getInstance();
         ML.player.galaxyId = ML.startupInfo.galaxyId;
         ConnectionManager.getInstance().connect();
         masterTrigger = new MasterUpdateTrigger();
      }
      
      
      /**
       * Resets the application: clears the state and switches login screen.
       */
      public static function resetApp() : void
      {
         EventBroker.broadcast(new GlobalEvent(GlobalEvent.APP_RESET));
         ModelLocator.getInstance().reset();
         MChat.getInstance().reset();
         ScreensSwitch.getInstance().showScreen(Screens.LOGIN);
      }
      
      
      private static function initializeLogging() : void
      {
         var target:ILoggingTarget = new TraceTarget();
         target.level = LogEventLevel.ALL;
         //         target.level = LogEventLevel.WARN;
         Log.addTarget(target);
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
      
      
      /**
       * Creates and registers singletons with SingletonFactory that aren't used by any other classes
       * (STILL EMTPY).
       */      
      private static function initializeFreeSingletons () :void
      {
      }
      
      
      /**
       * Just and agregate function for all bindings: makes the whole process more understandable.
       */      
      private static function bindCommandsToActions () :void
      {
         bindPlayerCommands();
         bindAlliancesCommands();
         bindGalaxiesCommands();
         bindSolarSystemsCommands();
         bindPlanetCommands();
         bindGameCommands();
         bindBuildingsCommands();
         bindTechnologiesCommands();
         bindConstructionQueuesCommands();
         bindUnitsCommands();
         bindNotificationsCommands();
         bindCombatLogsCommands();
         bindObjectsCommands();
         bindRoutesCommands();
         bindQuestsCommands();
         bindChatCommands();
      }
      private static function bindChatCommands() : void
      {
         with (ChatCommand)
         {
            bindPair(INDEX, new controllers.chat.actions.IndexAction());
            bindPair(CHANNEL_JOIN, new ChannelJoinAction());
            bindPair(CHANNEL_LEAVE, new ChannelLeaveAction());
            bindPair(MESSAGE_PUBLIC, new MessagePublicAction());
            bindPair(MESSAGE_PRIVATE, new MessagePrivateAction());
         }
      }
      private static function bindQuestsCommands() : void
      {
         bindPair(QuestsCommand.INDEX, new controllers.quests.actions.IndexAction());
         bindPair(QuestsCommand.CLAIM_REWARDS, new controllers.quests.actions.ClaimRewardsAction());
      }
      private static function bindRoutesCommands() : void
      {
         bindPair(RoutesCommand.INDEX, new controllers.routes.actions.IndexAction());
         bindPair(RoutesCommand.DESTROY, new controllers.routes.actions.DestroyAction());
      }
      private static function bindCombatLogsCommands() : void
      {
         bindPair(CombatLogsCommand.SHOW, new controllers.combatlogs.actions.ShowAction());
      }
      private static function bindNotificationsCommands() : void
      {
         bindPair(NotificationsCommand.INDEX, new controllers.notifications.actions.IndexAction());
         bindPair(NotificationsCommand.STAR, new StarAction());
         bindPair(NotificationsCommand.READ, new ReadAction());
      }
      private static function bindUnitsCommands() : void
      {
         bindPair(UnitsCommand.HEAL, new controllers.units.actions.HealAction());
         bindPair(UnitsCommand.LOAD, new controllers.units.actions.LoadAction());
         bindPair(UnitsCommand.UNLOAD, new controllers.units.actions.UnloadAction());
         bindPair(UnitsCommand.TRANSFER_RESOURCES, new controllers.units.actions.TransferResourcesAction());
         bindPair(UnitsCommand.SHOW, new controllers.units.actions.ShowAction());
         bindPair(UnitsCommand.NEW, new controllers.units.actions.NewAction());
         bindPair(UnitsCommand.UPDATE, new controllers.units.actions.UpdateAction());
         bindPair(UnitsCommand.DEPLOY, new controllers.units.actions.DeployAction());
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
      private static function bindBuildingsCommands() : void
      {
         bindPair(BuildingsCommand.NEW, new controllers.buildings.actions.NewAction());
         bindPair(BuildingsCommand.UPGRADE, new controllers.buildings.actions.UpgradeAction());
         bindPair(BuildingsCommand.SELF_DESTRUCT, new controllers.buildings.actions.SelfDestructAction());
         bindPair(BuildingsCommand.ACTIVATE, new controllers.buildings.actions.ActivateAction());
         bindPair(BuildingsCommand.DEACTIVATE, new controllers.buildings.actions.DeactivateAction());
         bindPair(BuildingsCommand.ACCELERATE_CONSTRUCTOR, new controllers.buildings.actions.AccelerateConstructorAction());
         bindPair(BuildingsCommand.ACCELERATE_UPGRADE, new controllers.buildings.actions.AccelerateUpgradeAction());
         bindPair(BuildingsCommand.MOVE, new controllers.buildings.actions.MoveAction());
      }
      private static function bindTechnologiesCommands() : void
      {
         bindPair(TechnologiesCommand.INDEX, new controllers.technologies.actions.IndexAction());
         bindPair(TechnologiesCommand.NEW, new controllers.technologies.actions.NewAction());
         bindPair(TechnologiesCommand.UPGRADE, new controllers.technologies.actions.UpgradeAction());
         bindPair(TechnologiesCommand.UPDATE, new controllers.technologies.actions.UpdateAction());
         bindPair(TechnologiesCommand.PAUSE, new controllers.technologies.actions.PauseAction());
         bindPair(TechnologiesCommand.RESUME, new controllers.technologies.actions.ResumeAction());
         bindPair(TechnologiesCommand.ACCELERATE_UPGRADE, new controllers.technologies.actions.AccelerateAction());
      }
      private static function bindConstructionQueuesCommands() : void
      {
         bindPair(ConstructionQueuesCommand.INDEX, new controllers.constructionqueues.actions.IndexAction());
         bindPair(ConstructionQueuesCommand.MOVE, new controllers.constructionqueues.actions.MoveAction());
         bindPair(ConstructionQueuesCommand.REDUCE, new controllers.constructionqueues.actions.ReduceAction());
         bindPair(ConstructionQueuesCommand.SPLIT, new controllers.constructionqueues.actions.SplitAction());
      }
      private static function bindGameCommands() : void
      {
         bindPair(GameCommand.CONFIG, new ConfigAction());
      }
      private static function bindPlayerCommands() : void
      {
         bindPair(PlayersCommand.LOGIN, new LoginAction());
         bindPair(PlayersCommand.DISCONNECT, new DisconnectAction());
         bindPair(PlayersCommand.RATINGS, new controllers.players.actions.RatingsAction());
         bindPair(PlayersCommand.SHOW, new controllers.players.actions.ShowAction());
         bindPair(PlayersCommand.EDIT, new controllers.players.actions.EditAction());
         bindPair(PlayersCommand.VIP, new controllers.players.actions.VipAction());
      }
      private static function bindAlliancesCommands() : void
      {
         bindPair(AlliancesCommand.RATINGS, new controllers.alliances.actions.RatingsAction());
         bindPair(AlliancesCommand.NEW, new controllers.alliances.actions.NewAction());
         bindPair(AlliancesCommand.SHOW, new controllers.alliances.actions.ShowAction());
         bindPair(AlliancesCommand.KICK, new controllers.alliances.actions.KickAction());
         bindPair(AlliancesCommand.LEAVE, new controllers.alliances.actions.LeaveAction());
         bindPair(AlliancesCommand.EDIT, new controllers.alliances.actions.EditAction());
         bindPair(AlliancesCommand.EDIT_DESCRIPTION, new controllers.alliances.actions.EditDescriptionAction());
      }
      private static function bindGalaxiesCommands() : void
      {
         bindPair(
            GalaxiesCommand.SHOW,
            new controllers.galaxies.actions.ShowAction()
         );
      }
      private static function bindSolarSystemsCommands() : void
      {
         bindPair(
            SolarSystemsCommand.SHOW,
            new controllers.solarsystems.actions.ShowAction()
         );
      }
      private static function bindPlanetCommands() : void
      {
         bindPair(PlanetsCommand.SHOW, new controllers.planets.actions.ShowAction());
         bindPair(PlanetsCommand.EDIT, new controllers.planets.actions.EditAction());
         bindPair(PlanetsCommand.BOOST, new controllers.planets.actions.BoostAction());
         bindPair(PlanetsCommand.PLAYER_INDEX, new PlayerIndexAction());
         bindPair(PlanetsCommand.EXPLORE, new ExploreAction());
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