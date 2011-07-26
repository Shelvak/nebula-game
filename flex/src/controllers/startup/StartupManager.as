package controllers.startup
{
   import animation.AnimationTimer;
   
   import com.developmentarc.core.actions.ActionDelegate;
   import com.developmentarc.core.actions.actions.AbstractAction;
   import com.developmentarc.core.utils.EventBroker;
   
   import components.alliance.AllianceScreenM;
   
   import controllers.GlobalFlags;
   import controllers.alliances.AlliancesCommand;
   import controllers.alliances.actions.*;
   import controllers.buildings.BuildingsCommand;
   import controllers.buildings.actions.*;
   import controllers.chat.ChatCommand;
   import controllers.chat.actions.*;
   import controllers.combatlogs.CombatLogsCommand;
   import controllers.combatlogs.actions.*;
   import controllers.connection.ConnectionManager;
   import controllers.constructionqueues.ConstructionQueuesCommand;
   import controllers.constructionqueues.actions.*;
   import controllers.dailybonus.DailyBonusCommand;
   import controllers.dailybonus.actions.ClaimAction;
   import controllers.dailybonus.actions.ShowAction;
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
   
   import mx.logging.Log;
   import mx.logging.LogEventLevel;
   import mx.logging.targets.TraceTarget;
   import mx.managers.ToolTipManager;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.events.ResultEvent;
   import mx.rpc.http.HTTPService;
   
   import namespaces.client_internal;
   
   import utils.DateUtil;
   import utils.Objects;
   import utils.SingletonFactory;
   import utils.StringUtil;
   import utils.logging.targets.InMemoryTarget;
   
   
   public final class StartupManager
   {
      private static function get ML() : ModelLocator
      {
         return ModelLocator.getInstance();
      }
      
      
      // One ActionDelegate is needed for whole application
      // Is directly tampered with only during command-to-action binding process  
      private static var delegate:ActionDelegate = SingletonFactory.getSingletonInstance(ActionDelegate);
      
      
      // Just to keep reference to this      
      private static var masterTrigger:MasterUpdateTrigger;
      
      
      /**
       * Loads startup information information into <code>StartupInfo</code> singleton.
       */
      public static function loadStartupInfo() : Boolean
      {
         initializeLogging();
         var startupInfo:StartupInfo;
         if (!ExternalInterface.available)
         {
            registerStartupInfo(new StartupInfo());
            return false;
         }
         startupInfo = BaseModel.createModel(StartupInfo, ExternalInterface.call("getGameOptions"));
         if (startupInfo == null)
         {
            registerStartupInfo(new StartupInfo());
            return false;
         }
         registerStartupInfo(startupInfo);
         
         startupInfo.loadSuccessful = true;
         if (startupInfo.mode == StartupMode.BATTLE)
         {
            ML.player.id = startupInfo.playerId;
         }
         
         //=============DOWNLOADING CHECKSUM FILES===============
         var tStamp: String = (new Date().time).toString();
         var responses: int = 0;
         function checkIfDone(): void
         {
            if (responses == 2)
            {
               startupInfo.handleChecksumsDownloaded();
            }
         }
         function handleFail(e: FaultEvent): void
         {
            trace('Checksum download failed');
            responses++;
            checkIfDone();
         }
         var checksumForLocale: HTTPService = new HTTPService();
         checksumForLocale.url = 'locale/checksums?'+tStamp;
         checksumForLocale.addEventListener(ResultEvent.RESULT, 
            function (e: ResultEvent): void
            {
               trace('Content of locale checksum: ' + e.result);
               startupInfo.localeSums = StringUtil.parseChecksums(String(e.result));
               responses++;
               checkIfDone();
            });
         checksumForLocale.addEventListener(FaultEvent.FAULT, handleFail);
         checksumForLocale.send();
         var checksumForAssets: HTTPService = new HTTPService();
         checksumForAssets.url = 'assets/checksums?'+tStamp;
         checksumForAssets.addEventListener(ResultEvent.RESULT, 
            function (e: ResultEvent): void
            {
               trace('Content of assets checksum: ' + e.result);
               startupInfo.assetsSums = StringUtil.parseChecksums(String(e.result));
               responses++;
               checkIfDone();
            });
         checksumForAssets.addEventListener(FaultEvent.FAULT, handleFail);
         checksumForAssets.send();
         
         return true;
      }
      private static function registerStartupInfo(instance:StartupInfo) : void
      {
         Objects.paramNotNull("instance", instance);
         SingletonFactory.client_internal::registerSingletonInstance(StartupInfo, instance);
      }
      
      
      /**
       * Call this once during application startup. This method will bind commands to appropriate actions as
       * well as initialize any classes that need special treatment.
       */	   
      public static function initializeApp() : void
      {
         AnimationTimer.forUi.start();
         AnimationTimer.forMovement.start();
         ToolTipManager.showDelay = 0;
         ToolTipManager.hideDelay = int.MAX_VALUE;
         initializeFreeSingletons();
         bindCommandsToActions();
         setupBaseModel();
         ML.player.galaxyId = StartupInfo.getInstance().galaxyId;
         ConnectionManager.getInstance().connect();
         masterTrigger = new MasterUpdateTrigger();
      }
      
      
      /**
       * Resets the application: clears the state and switches login screen.
       */
      public static function resetApp() : void
      {
         _inMemoryLog.clear();
         EventBroker.broadcast(new GlobalEvent(GlobalEvent.APP_RESET));
         StringUtil.reset();
         ML.reset();
         MChat.getInstance().reset();
         AllianceScreenM.getInstance().reset();
         ScreensSwitch.getInstance().showScreen(Screens.LOGIN);
         GlobalFlags.getInstance().lockApplication = false;
      }
      
      
      private static function initializeLogging() : void
      {
         var traceTarget:TraceTarget = new TraceTarget();   
         traceTarget.includeCategory = true;
         traceTarget.includeLevel = true;
         traceTarget.level = LogEventLevel.ALL;
         Log.addTarget(traceTarget);
         
         _inMemoryLog = new InMemoryTarget();   
         _inMemoryLog.includeCategory = true;
         _inMemoryLog.includeLevel = true;
         _inMemoryLog.maxEntries = 100;
         _inMemoryLog.level = LogEventLevel.ALL;
         Log.addTarget(_inMemoryLog);
      }
      
      
      private static var _inMemoryLog:InMemoryTarget;
      /**
       * An <code>ILoggingTarget</code> that stores log netries in the memory.
       */
      public static function get inMemoryLog() : InMemoryTarget
      {
         return _inMemoryLog;
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
         bindDailyBonusCommands();
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
      private static function bindDailyBonusCommands() : void
      {
         bindPair(DailyBonusCommand.SHOW, new controllers.dailybonus.actions.ShowAction());
         bindPair(DailyBonusCommand.CLAIM, new controllers.dailybonus.actions.ClaimAction());
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
         bindPair(UnitsCommand.DISMISS, new controllers.units.actions.DismissAction());
         bindPair(UnitsCommand.MOVE, new controllers.units.actions.MoveAction());
         bindPair(UnitsCommand.MOVEMENT, new MovementAction());
         bindPair(UnitsCommand.MOVEMENT_PREPARE, new MovementPrepareAction());
         bindPair(UnitsCommand.MOVE_META, new MoveMetaAction());
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
         with (PlayersCommand)
         {
            bindPair(LOGIN, new LoginAction());
            bindPair(DISCONNECT, new DisconnectAction());
            bindPair(RATINGS, new controllers.players.actions.RatingsAction());
            bindPair(SHOW, new controllers.players.actions.ShowAction());
            bindPair(SHOW_PROFILE, new controllers.players.actions.ShowProfileAction());
            bindPair(CONVERT_CREDS, new controllers.players.actions.ConvertCredsAction());
            bindPair(EDIT, new controllers.players.actions.EditAction());
            bindPair(VIP, new controllers.players.actions.VipAction());
            bindPair(STATUS_CHANGE, new StatusChangeAction());
         }
      }
      private static function bindAlliancesCommands() : void
      {
         with (AlliancesCommand)
         {
            bindPair(RATINGS, new controllers.alliances.actions.RatingsAction());
            bindPair(NEW, new controllers.alliances.actions.NewAction());
            bindPair(SHOW, new controllers.alliances.actions.ShowAction());
            bindPair(KICK, new controllers.alliances.actions.KickAction());
            bindPair(LEAVE, new controllers.alliances.actions.LeaveAction());
            bindPair(EDIT, new controllers.alliances.actions.EditAction());
            bindPair(EDIT_DESCRIPTION, new controllers.alliances.actions.EditDescriptionAction());
            bindPair(INVITE, new InviteAction());
            bindPair(JOIN, new JoinAction());
         }
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
         bindPair(PlanetsCommand.TAKE, new controllers.planets.actions.TakeAction());
         bindPair(PlanetsCommand.EDIT, new controllers.planets.actions.EditAction());
         bindPair(PlanetsCommand.BOOST, new controllers.planets.actions.BoostAction());
         bindPair(PlanetsCommand.PLAYER_INDEX, new PlayerIndexAction());
         bindPair(PlanetsCommand.EXPLORE, new ExploreAction());
         bindPair(PlanetsCommand.PORTAL_UNITS, new PortalUnitsAction());
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
