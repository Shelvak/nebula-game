package controllers.startup
{
   import animation.AnimationTimer;

   import com.developmentarc.core.actions.ActionDelegate;
   import com.developmentarc.core.actions.actions.AbstractAction;

   import components.alliance.AllianceScreenM;
   import components.popups.PopUpManager;

   import controllers.alliances.AlliancesCommand;
   import controllers.alliances.actions.*;
   import controllers.announcements.AnnouncementsCommand;
   import controllers.announcements.actions.*;
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
   import controllers.dailybonus.actions.*;
   import controllers.galaxies.GalaxiesCommand;
   import controllers.galaxies.actions.*;
   import controllers.game.GameCommand;
   import controllers.game.actions.*;
   import controllers.market.MarketCommand;
   import controllers.market.actions.*;
   import controllers.messages.MessagesProcessor;
   import controllers.messages.ResponseMessagesTracker;
   import controllers.notifications.NotificationsCommand;
   import controllers.notifications.actions.*;
   import controllers.objects.ObjectsCommand;
   import controllers.objects.actions.*;
   import controllers.planets.PlanetsCommand;
   import controllers.planets.actions.*;
   import controllers.playeroptions.PlayerOptionsCommand;
   import controllers.playeroptions.actions.SetAction;
   import controllers.playeroptions.actions.ShowAction;
   import controllers.players.AuthorizationManager;
   import controllers.players.PlayersCommand;
   import controllers.players.actions.*;
   import controllers.quests.QuestsCommand;
   import controllers.quests.actions.*;
   import controllers.routes.RoutesCommand;
   import controllers.routes.actions.*;
   import controllers.solarsystems.SolarSystemsCommand;
   import controllers.solarsystems.actions.*;
   import controllers.technologies.TechnologiesCommand;
   import controllers.technologies.actions.*;
   import controllers.timedupdate.MasterUpdateTrigger;
   import controllers.ui.NavigationController;
   import controllers.units.UnitsCommand;
   import controllers.units.actions.*;

   import flash.external.ExternalInterface;
   import flash.system.Security;

   import globalevents.GlobalEvent;

   import models.ModelLocator;
   import models.announcement.MAnnouncement;
   import models.chat.MChat;
   import models.quest.MainQuestSlideFactory;
   import models.time.MTimeEventFixedMoment;

   import mx.logging.LogEventLevel;
   import mx.logging.targets.TraceTarget;
   import mx.managers.ToolTipManager;

   import namespaces.client_internal;

   import utils.ApplicationLocker;
   import utils.DateUtil;
   import utils.Objects;
   import utils.SingletonFactory;
   import utils.StringUtil;
   import utils.execution.JobExecutorsManager;
   import utils.logging.InMemoryTarget;
   import utils.logging.Log;
   import utils.logging.MessagesLogger;
   import utils.remote.ServerProxyInstance;


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
         if (!ExternalInterface.available) {
            registerStartupInfo(new StartupInfo());
            return false;
         }
         startupInfo = Objects.create(StartupInfo, ExternalInterface.call("getGameOptions"));
         if (startupInfo == null) {
            registerStartupInfo(new StartupInfo());
            return false;
         }
         registerStartupInfo(startupInfo);
         
         startupInfo.loadSuccessful = true;
         if (startupInfo.mode == StartupMode.BATTLE) {
            ML.player.id = startupInfo.playerId;
         }

         // TODO
         // We need to find correct domain to allow staging.nebula44.lt
         // to access flash. Setting it to * for now. arturaz.
         Security.allowDomain("*");//startupInfo.webHost);
         JavascriptController.registerCallbacks();
         
         // LoadingScreen takes over from this point forward
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
      public static function initializeAppAfterLoad():void {
         ToolTipManager.showDelay = 0;
         ToolTipManager.hideDelay = int.MAX_VALUE;
         initializeFreeSingletons();
         bindCommandsToActions();
         setupObjects();
         masterTrigger = new MasterUpdateTrigger();
         switch (StartupInfo.getInstance().mode) {
            case StartupMode.GAME:
               AnimationTimer.forUi.start();
               AnimationTimer.forMovement.start();
            
            case StartupMode.BATTLE:
               AnimationTimer.forUi.start();
         }
         connectAndAuthorize();
      }
      
      
      /**
       * Connects and optionally performs player authorization in case the game is running in COMBAT mode.
       */
      public static function connectAndAuthorize() : void {
         if (StartupInfo.getInstance().mode == StartupMode.GAME) {
            AuthorizationManager.getInstance().authorizeLoginAndProceed();
         }
         else {
            ConnectionManager.getInstance().connect();
         }
      }
      
      
      /**
       * Resets the application: clears the state and switches login screen.
       */
      public static function resetApp() : void {
         Log.getMethodLogger(StartupManager, "resetApp")
            .info("-------------- APPLICATION RESET --------------");
         StartupInfo.getInstance().initializationComplete = false;
         new GlobalEvent(GlobalEvent.APP_RESET);
         JobExecutorsManager.getInstance().stopAll();
         ServerProxyInstance.getInstance().reset();
         ResponseMessagesTracker.getInstance().reset();
         MessagesProcessor.getInstance().reset();
         PopUpManager.getInstance().reset();
         StringUtil.reset();
         ML.reset();
         MChat.getInstance().reset();
         MAnnouncement.getInstance().reset();
         AllianceScreenM.getInstance().reset();
         ApplicationLocker.reset();
         MainQuestSlideFactory.getInstance().reset();

         // in case there is some screen or sidebar with old state
         // so that user won't click on any buttons while server pushes all necessary messages
         NavigationController.getInstance().showGalaxy();
      }
      
      
      private static function initializeLogging() : void
      {
         MessagesLogger.getInstance().disableLogging([
            ChatCommand.MESSAGE_PRIVATE,
            ChatCommand.MESSAGE_PUBLIC,
            GameCommand.CONFIG,
            "reply_to"
         ]);
         
         var traceTarget:TraceTarget = new TraceTarget();   
         traceTarget.includeCategory = true;
         traceTarget.includeLevel = true;
         traceTarget.includeDate = true;
         traceTarget.includeTime = true;
         traceTarget.level = LogEventLevel.ALL;
         Log.addTarget(traceTarget);
         
         _inMemoryLog = new InMemoryTarget();   
         _inMemoryLog.includeCategory = true;
         _inMemoryLog.includeLevel = true;
         _inMemoryLog.includeDate = true;
         _inMemoryLog.includeTime = true;
         _inMemoryLog.maxEntries = 1000;
         _inMemoryLog.level = LogEventLevel.ALL;
         Log.addTarget(_inMemoryLog);
      }
      
      
      private static var _inMemoryLog:InMemoryTarget;
      /**
       * An <code>ILoggingTarget</code> that stores log entries in the memory.
       */
      public static function get inMemoryLog() : InMemoryTarget {
         return _inMemoryLog;
      }
      
      
      private static function setupObjects() : void {
         Objects.setTypeProcessors(
            Date,
            DateUtil.autoCreate,
            DateUtil.sameDataCheck
         );
         Objects.setTypeProcessors(
            MTimeEventFixedMoment,
            MTimeEventFixedMoment.autoCreate,
            MTimeEventFixedMoment.sameDataCheck
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
         bindPlayersCommands();
         bindPlayerOptionsCommands();
         bindAlliancesCommands();
         bindGalaxiesCommands();
         bindSolarSystemsCommands();
         bindPlanetsCommands();
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
         bindMarketCommands();
         bindAnnouncementsCommands();
      }
      private static function bindChatCommands() : void
      {
         bindPair(ChatCommand.INDEX, new controllers.chat.actions.IndexAction());
         bindPair(ChatCommand.CHANNEL_JOIN, new ChannelJoinAction());
         bindPair(ChatCommand.CHANNEL_LEAVE, new ChannelLeaveAction());
         bindPair(ChatCommand.MESSAGE_PUBLIC, new MessagePublicAction());
         bindPair(ChatCommand.MESSAGE_PRIVATE, new MessagePrivateAction());
         bindPair(ChatCommand.SILENCE, new SilenceAction());
      }
      private static function bindMarketCommands() : void
      {
         bindPair(MarketCommand.INDEX, new controllers.market.actions.IndexAction());
         bindPair(MarketCommand.NEW, new controllers.market.actions.NewAction());
         bindPair(MarketCommand.BUY, new BuyAction());
         bindPair(MarketCommand.CANCEL, new CancelAction());
         bindPair(MarketCommand.AVG_RATE, new AvgRateAction());
      }
      private static function bindQuestsCommands() : void
      {
         bindPair(QuestsCommand.INDEX, new controllers.quests.actions.IndexAction());
         bindPair(QuestsCommand.CLAIM_REWARDS, new ClaimRewardsAction());
      }
      private static function bindDailyBonusCommands() : void
      {
         bindPair(DailyBonusCommand.SHOW, new controllers.dailybonus.actions.ShowAction());
         bindPair(DailyBonusCommand.CLAIM, new controllers.dailybonus.actions.ClaimAction());
      }
      private static function bindRoutesCommands() : void
      {
         bindPair(RoutesCommand.INDEX, new controllers.routes.actions.IndexAction());
         bindPair(RoutesCommand.DESTROY, new DestroyAction());
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
         bindPair(UnitsCommand.HEAL, new HealAction());
         bindPair(UnitsCommand.LOAD, new LoadAction());
         bindPair(UnitsCommand.UNLOAD, new UnloadAction());
         bindPair(UnitsCommand.TRANSFER_RESOURCES, new TransferResourcesAction());
         bindPair(UnitsCommand.SHOW, new controllers.units.actions.ShowAction());
         bindPair(UnitsCommand.NEW, new controllers.units.actions.NewAction());
         bindPair(UnitsCommand.UPDATE, new controllers.units.actions.UpdateAction());
         bindPair(UnitsCommand.SET_HIDDEN, new SetHiddenAction());
         bindPair(UnitsCommand.DEPLOY, new DeployAction());
         bindPair(UnitsCommand.ATTACK, new AttackAction());
         bindPair(UnitsCommand.DISMISS, new DismissAction());
         bindPair(UnitsCommand.MOVE, new controllers.units.actions.MoveAction());
         bindPair(UnitsCommand.MOVEMENT, new MovementAction());
         bindPair(UnitsCommand.MOVEMENT_PREPARE, new MovementPrepareAction());
         bindPair(UnitsCommand.MOVE_META, new MoveMetaAction());
         bindPair(UnitsCommand.POSITIONS, new PositionsAction());
         bindPair(UnitsCommand.CLAIM, new controllers.units.actions.ClaimAction());
      }
      private static function bindObjectsCommands() : void
      {
         bindPair(ObjectsCommand.DESTROYED, new DestroyedAction());
         bindPair(ObjectsCommand.UPDATED, new UpdatedAction());
         bindPair(ObjectsCommand.CREATED, new CreatedAction());
      }
      private static function bindBuildingsCommands() : void
      {
         bindPair(BuildingsCommand.NEW, new controllers.buildings.actions.NewAction());
         bindPair(BuildingsCommand.UPGRADE, new controllers.buildings.actions.UpgradeAction());
         bindPair(BuildingsCommand.REPAIR, new RepairAction());
         bindPair(BuildingsCommand.MASS_REPAIR, new MassRepairAction());
         bindPair(BuildingsCommand.SELF_DESTRUCT, new SelfDestructAction());
         bindPair(BuildingsCommand.ACTIVATE, new ActivateAction());
         bindPair(BuildingsCommand.DEACTIVATE, new DeactivateAction());
         bindPair(BuildingsCommand.ACTIVATE_OVERDRIVE, new ActivateOverdriveAction());
         bindPair(BuildingsCommand.DEACTIVATE_OVERDRIVE, new DeactivateOverdriveAction());
         bindPair(BuildingsCommand.ACCELERATE_CONSTRUCTOR, new AccelerateConstructorAction());
         bindPair(BuildingsCommand.CONSTRUCT_ALL, new ConstructAllAction());
         bindPair(BuildingsCommand.ACCELERATE_UPGRADE, new AccelerateUpgradeAction());
         bindPair(BuildingsCommand.CANCEL_CONSTRUCTOR, new CancelConstructorAction());
         bindPair(BuildingsCommand.CANCEL_UPGRADE, new CancelUpgradeAction());
         bindPair(BuildingsCommand.MOVE, new controllers.buildings.actions.MoveAction());
         bindPair(BuildingsCommand.SET_BUILD_IN_2ND_FLANK, new SetBuildIn2ndFlankAction());
         bindPair(BuildingsCommand.SET_BUILD_HIDDEN, new SetBuildHiddenAction());
         bindPair(BuildingsCommand.SHOW_GARRISON, new ShowGarrisonAction());
         bindPair(BuildingsCommand.SHOW_GARRISON_GROUPS, new ShowGarrisonGroupsAction());
         bindPair(BuildingsCommand.TRANSPORT_RESOURCES, new TransportResourcesAction());
      }
      private static function bindTechnologiesCommands() : void
      {
         bindPair(TechnologiesCommand.INDEX, new controllers.technologies.actions.IndexAction());
         bindPair(TechnologiesCommand.NEW, new controllers.technologies.actions.NewAction());
         bindPair(TechnologiesCommand.UPGRADE, new controllers.technologies.actions.UpgradeAction());
         bindPair(TechnologiesCommand.UPDATE, new controllers.technologies.actions.UpdateAction());
         bindPair(TechnologiesCommand.UNLEARN, new UnlearnAction());
         bindPair(TechnologiesCommand.PAUSE, new PauseAction());
         bindPair(TechnologiesCommand.RESUME, new ResumeAction());
         bindPair(TechnologiesCommand.ACCELERATE_UPGRADE, new AccelerateAction());
      }
      private static function bindConstructionQueuesCommands() : void
      {
         bindPair(ConstructionQueuesCommand.INDEX, new controllers.constructionqueues.actions.IndexAction());
         bindPair(ConstructionQueuesCommand.MOVE, new controllers.constructionqueues.actions.MoveAction());
         bindPair(ConstructionQueuesCommand.REDUCE, new ReduceAction());
         bindPair(ConstructionQueuesCommand.SPLIT, new SplitAction());
      }
      private static function bindGameCommands() : void
      {
         bindPair(GameCommand.CONFIG, new ConfigAction());
      }
      private static function bindPlayersCommands() : void
      {
         bindPair(PlayersCommand.LOGIN, new LoginAction());
         bindPair(PlayersCommand.DISCONNECT, new DisconnectAction());
         bindPair(PlayersCommand.RATINGS, new controllers.players.actions.RatingsAction());
         bindPair(PlayersCommand.RENAME, new RenameAction());
         bindPair(PlayersCommand.SHOW, new controllers.players.actions.ShowAction());
         bindPair(PlayersCommand.SHOW_PROFILE, new ShowProfileAction());
         bindPair(PlayersCommand.BATTLE_VPS_MULTIPLIER, new BattleVpsMultiplierAction());
         bindPair(PlayersCommand.CONVERT_CREDS, new ConvertCredsAction());
         bindPair(PlayersCommand.EDIT, new controllers.players.actions.EditAction());
         bindPair(PlayersCommand.VIP, new VipAction());
         bindPair(PlayersCommand.VIP_STOP, new VipStopAction());
         bindPair(PlayersCommand.STATUS_CHANGE, new StatusChangeAction());
      }
      private static function bindPlayerOptionsCommands() : void
      {
         bindPair(PlayerOptionsCommand.SHOW, new controllers.playeroptions.actions.ShowAction());
         bindPair(PlayerOptionsCommand.SET, new SetAction());
      }
      private static function bindAlliancesCommands() : void
      {
         bindPair(AlliancesCommand.RATINGS, new controllers.alliances.actions.RatingsAction());
         bindPair(AlliancesCommand.NEW, new controllers.alliances.actions.NewAction());
         bindPair(AlliancesCommand.SHOW, new controllers.alliances.actions.ShowAction());
         bindPair(AlliancesCommand.KICK, new KickAction());
         bindPair(AlliancesCommand.LEAVE, new LeaveAction());
         bindPair(AlliancesCommand.EDIT, new controllers.alliances.actions.EditAction());
         bindPair(AlliancesCommand.EDIT_DESCRIPTION, new EditDescriptionAction());
         bindPair(AlliancesCommand.INVITE, new InviteAction());
         bindPair(AlliancesCommand.JOIN, new JoinAction());
         bindPair(AlliancesCommand.GIVE_AWAY, new GiveAwayAction());
         bindPair(AlliancesCommand.TAKE_OVER, new TakeOverAction());
      }
      private static function bindGalaxiesCommands() : void
      {
         bindPair(GalaxiesCommand.SHOW, new controllers.galaxies.actions.ShowAction());
         bindPair(GalaxiesCommand.APOCALYPSE, new ApocalypseAction());
         bindPair(GalaxiesCommand.MAP, new MapAction());
      }
      private static function bindSolarSystemsCommands() : void
      {
         bindPair(
            SolarSystemsCommand.SHOW,
            new controllers.solarsystems.actions.ShowAction()
         );
      }
      private static function bindPlanetsCommands() : void {
         bindPair(PlanetsCommand.SHOW, new controllers.planets.actions.ShowAction());
         bindPair(PlanetsCommand.EDIT, new controllers.planets.actions.EditAction());
         bindPair(PlanetsCommand.BOOST, new BoostAction());
         bindPair(PlanetsCommand.TAKE, new TakeAction());
         bindPair(PlanetsCommand.PLAYER_INDEX, new PlayerIndexAction());
         bindPair(PlanetsCommand.EXPLORE, new ExploreAction());
         bindPair(PlanetsCommand.FINISH_EXPLORATION, new FinishExplorationAction());
         bindPair(PlanetsCommand.REMOVE_FOLIAGE, new RemoveFoliageAction());
         bindPair(PlanetsCommand.PORTAL_UNITS, new PortalUnitsAction());
         bindPair(PlanetsCommand.BG_SPAWN, new BgSpawnAction());
         bindPair(PlanetsCommand.REINITIATE_COMBAT, new ReinitiateCombatAction());
      }
      private static function bindAnnouncementsCommands() : void {
         bindPair(AnnouncementsCommand.NEW, new controllers.announcements.actions.NewAction());
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
