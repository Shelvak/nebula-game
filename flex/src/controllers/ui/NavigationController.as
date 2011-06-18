package controllers.ui
{
   import com.developmentarc.core.utils.EventBroker;
   
   import components.alliance.AllianceScreen;
   import components.base.viewport.ViewportZoomable;
   import components.factories.MapFactory;
   import components.map.controllers.IMapViewportController;
   import components.map.planet.PlanetMap;
   import components.map.space.CMapGalaxy;
   import components.map.space.CMapSolarSystem;
   import components.player.PlayerScreen;
   import components.screens.MainAreaContainer;
   
   import controllers.GlobalFlags;
   import controllers.alliances.AlliancesCommand;
   import controllers.planets.PlanetsCommand;
   import controllers.players.PlayersCommand;
   import controllers.screens.MainAreaScreens;
   import controllers.screens.MainAreaScreensSwitch;
   import controllers.screens.SidebarScreens;
   import controllers.screens.SidebarScreensSwitch;
   import controllers.solarsystems.SolarSystemsCommand;
   
   import flash.errors.IllegalOperationError;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   
   import globalevents.GHealingScreenEvent;
   import globalevents.GLoadUnloadScreenEvent;
   import globalevents.GRatingsEvent;
   import globalevents.GUnitsScreenEvent;
   import globalevents.GlobalEvent;
   
   import models.ModelLocator;
   import models.Owner;
   import models.alliance.MAlliance;
   import models.building.Building;
   import models.chat.MChat;
   import models.events.ScreensSwitchEvent;
   import models.galaxy.Galaxy;
   import models.map.MMap;
   import models.map.MapType;
   import models.planet.Planet;
   import models.player.MRatingPlayer;
   import models.quest.Quest;
   import models.solarsystem.MSSObject;
   import models.solarsystem.SolarSystem;
   import models.unit.Unit;
   import models.unit.UnitKind;
   
   import mx.collections.ListCollectionView;
   import mx.containers.ViewStack;
   import mx.events.FlexEvent;
   
   import spark.components.Button;
   import spark.components.NavigatorContent;
   
   import utils.ClassUtil;
   import utils.SingletonFactory;
   import utils.SyncUtil;
   import utils.datastructures.Collections;
   
   
   /**
    * <p>
    * Takes care of the pain related to navigation between different main area screens (maps, info
    * screens and so forth) and sidebars. This class will dispatch any necessary commands to the
    * server. However once the response has been received the controller which received the response
    * is responsible for calling appropriate method of <code>NavigationController</code>.
    * </p>
    * <p>
    * Used by navigation buttons. They are identified by names (names are taken from <code>MainAreaScreens</code>).
    * </p>
    * <p>
    * Each button has to register itself with this controller. The button can only be created
    * once and should remain in display list for the whole lifetime of application.
    * Those buttons <b>must not</b> contain any event handlers that have some navigation
    * through different screens logic as well as logic for changing their state. This will be done
    * by the controller. You can use as many other handlers as you like. 
    * </p>
    */
   public class NavigationController extends EventDispatcher
   {
      public static function getInstance() : NavigationController
      {
         return SingletonFactory.getSingletonInstance(NavigationController);
      }
      
      
      private var _mainAreaSwitch:MainAreaScreensSwitch = MainAreaScreensSwitch.getInstance();
      private var _sidebarSwitch:SidebarScreensSwitch = SidebarScreensSwitch.getInstance();
      
      
      private function get ML() : ModelLocator
      {
         return ModelLocator.getInstance();
      }
      
      
      private var _screenProperties:Object = {
         (String (MainAreaScreens.GALAXY)): new ScreenProperties(
            MainAreaScreens.GALAXY, null, false, true, MapType.GALAXY, "latestGalaxy",
            CMapGalaxy.screenShowHandler,
            CMapGalaxy.screenHideHandler
         ),
         (String (MainAreaScreens.SOLAR_SYSTEM)): new ScreenProperties(
            MainAreaScreens.SOLAR_SYSTEM, null, false, true, MapType.SOLAR_SYSTEM, "latestSolarSystem",
            CMapSolarSystem.screenShowHandler,
            CMapSolarSystem.screenHideHandler
         ),
         (String (MainAreaScreens.PLANET)): new ScreenProperties(
            MainAreaScreens.PLANET, SidebarScreens.CONSTRUCTION, true, true, MapType.PLANET, "latestPlanet",
            PlanetMap.screenShowHandler,
            PlanetMap.screenHideHandler
         ),
         (String (MainAreaScreens.TECH_TREE)): new ScreenProperties(
            MainAreaScreens.TECH_TREE, SidebarScreens.TECH_TREE_BASE
         ),
         (String (MainAreaScreens.STORAGE)): new ScreenProperties(
            MainAreaScreens.STORAGE, null, false
         ),
         (String (MainAreaScreens.UNITS)): new ScreenProperties(
            MainAreaScreens.UNITS, SidebarScreens.UNITS_ACTIONS
         ),
         (String (MainAreaScreens.LOAD_UNLOAD)): new ScreenProperties(
            MainAreaScreens.LOAD_UNLOAD, SidebarScreens.LOAD_UNLOAD
         ),
         (String (MainAreaScreens.HEAL)): new ScreenProperties(
            MainAreaScreens.HEAL, SidebarScreens.HEAL
         ),
         (String (MainAreaScreens.UNITS+Owner.PLAYER+UnitKind.GROUND)): new ScreenProperties(
            MainAreaScreens.UNITS, SidebarScreens.UNITS_ACTIONS
         ),
         (String (MainAreaScreens.UNITS+Owner.ALLY+UnitKind.GROUND)): new ScreenProperties(
            MainAreaScreens.UNITS, SidebarScreens.UNITS_ACTIONS
         ),
         (String (MainAreaScreens.UNITS+Owner.ENEMY+UnitKind.GROUND)): new ScreenProperties(
            MainAreaScreens.UNITS, SidebarScreens.UNITS_ACTIONS
         ),
         (String (MainAreaScreens.UNITS+Owner.NAP+UnitKind.GROUND)): new ScreenProperties(
            MainAreaScreens.UNITS, SidebarScreens.UNITS_ACTIONS
         ),
         (String (MainAreaScreens.UNITS+Owner.PLAYER+UnitKind.SPACE)): new ScreenProperties(
            MainAreaScreens.UNITS, SidebarScreens.UNITS_ACTIONS
         ),
         (String (MainAreaScreens.UNITS+Owner.ALLY+UnitKind.SPACE)): new ScreenProperties(
            MainAreaScreens.UNITS, SidebarScreens.UNITS_ACTIONS
         ),
         (String (MainAreaScreens.UNITS+Owner.ENEMY+UnitKind.SPACE)): new ScreenProperties(
            MainAreaScreens.UNITS, SidebarScreens.UNITS_ACTIONS
         ),
         (String (MainAreaScreens.UNITS+Owner.NAP+UnitKind.SPACE)): new ScreenProperties(
            MainAreaScreens.UNITS, SidebarScreens.UNITS_ACTIONS
         ),
         (String (MainAreaScreens.NOTIFICATIONS)): new ScreenProperties(
            MainAreaScreens.NOTIFICATIONS, null, false, false, 0, null, function (): void
            {
               if (ExternalInterface.available)
               {
                  ExternalInterface.call("notificationsOpened");
               }
            }
         ),
         (String (MainAreaScreens.QUESTS)): new ScreenProperties(
            MainAreaScreens.QUESTS, null, false
         ),
         (String (MainAreaScreens.SQUADRONS)): new ScreenProperties(
            MainAreaScreens.SQUADRONS, null, false
         ),
         (String (MainAreaScreens.INFO)): new ScreenProperties(
            MainAreaScreens.INFO, null, false
         ),
         (String (MainAreaScreens.FACILITIES)): new ScreenProperties(
            MainAreaScreens.FACILITIES, null, false
         ),
         (String (MainAreaScreens.RATINGS)): new ScreenProperties(
            MainAreaScreens.RATINGS, null, false
         ),
         (String (MainAreaScreens.PLAYER)): new ScreenProperties(
            MainAreaScreens.PLAYER, null, false
         ),
         (String (MainAreaScreens.VIP)): new ScreenProperties(
            MainAreaScreens.VIP, null, false
         ),
         (String (MainAreaScreens.ALLY_RATINGS)): new ScreenProperties(
            MainAreaScreens.ALLY_RATINGS, null, false
         ),
         (String(MainAreaScreens.ALLIANCE)): new ScreenProperties(
            MainAreaScreens.ALLIANCE, null, false
         ),
         (String(MainAreaScreens.WELCOME)): new ScreenProperties(
            MainAreaScreens.WELCOME, null, false
         ),
         (String (MainAreaScreens.CHAT)): new ScreenProperties(
            MainAreaScreens.CHAT, null, false, false, 0, null,
            MChat.getInstance().screenShowHandler,
            MChat.getInstance().screenHideHandler
         )
      };
      
      
      private var _currentScreenProps:ScreenProperties = null;
      
      
      public function NavigationController()
      {
         EventBroker.subscribe(GlobalEvent.APP_RESET, global_appResetHandler);
      }
      
      
      public function global_appResetHandler(event:GlobalEvent) : void
      {
         destroyOldMap(MainAreaScreens.GALAXY);
         destroyOldMap(MainAreaScreens.SOLAR_SYSTEM);
         destroyOldMap(MainAreaScreens.PLANET);
      }
      
      
      
      /* ########################################### */
      /* ### MAIN AREA CONTAINER WITH TWO STATES ### */
      /* ########################################### */
      
      
      private var _mainAreaContainer:MainAreaContainer = null;
      
      
      /**
       * Registers given container with the controller.
       * @param container a <code>MainAreaContainer</code> to register with this controller.
       */
      public function registerMainAreaContainer(container:MainAreaContainer) : void
      {
         if (_mainAreaContainer != null)
         {
            throw new IllegalOperationError("MainAreaContainer has already been registered");
         }
         ClassUtil.checkIfParamNotNull("container", container);
         _mainAreaContainer = container;
      }
      
      
      /* ############### */
      /* ### BUTTONS ### */
      /* ############### */
      
      
      private var _activeButton:Button = null;
      
      
      /**
       * Registers given button with this controller.
       * @param button A <code>Button</code> or <code>ToggleButton</code> to register.
       */
      public function registerButton(button:Button) : void
      {
         var screenProps:ScreenProperties = _screenProperties[button.name]; 
         if (screenProps == null)
         {
            throw new ArgumentError("A button with name '" + button.name + "' is not supported");
         }
         if (screenProps.button != null)
         {
            throw new IllegalOperationError("The button with name '" + button.name + "' has already been registered");
         }
         
         screenProps.button = button;
         button.addEventListener(MouseEvent.CLICK, button_clickHandler);
         
         // Galaxy button is entry point so it needs special treatment
         if (button.name == MainAreaScreens.GALAXY)
         {
            resetActiveButton(button);
         }
      }
      
      
      private function button_clickHandler(event:MouseEvent) : void
      {
         var button:Button = event.target as Button;
         switch (button.name)
         {
            case MainAreaScreens.GALAXY:
               toGalaxy();
               break;
            case MainAreaScreens.SOLAR_SYSTEM:
               toSolarSystem(ML.latestSolarSystem.id);
               break;
            case MainAreaScreens.PLANET:
               toPlanet(ML.latestPlanet.ssObject);
               break;
            case MainAreaScreens.UNITS + Owner.PLAYER + UnitKind.GROUND:
               showUnits(ML.latestPlanet.getActiveUnits(Owner.PLAYER), ML.latestPlanet.toLocation(), null,
                  UnitKind.GROUND, Owner.PLAYER);
               resetActiveButton(button);
               break;
            case MainAreaScreens.UNITS + Owner.ALLY + UnitKind.GROUND:
               showUnits(ML.latestPlanet.getActiveUnits(Owner.ALLY), ML.latestPlanet.toLocation(), null,
                  UnitKind.GROUND, Owner.ALLY);
               resetActiveButton(button);
               break;
            case MainAreaScreens.UNITS + Owner.NAP + UnitKind.GROUND:
               showUnits(ML.latestPlanet.getActiveUnits(Owner.NAP), ML.latestPlanet.toLocation(), null,
                  UnitKind.GROUND, Owner.NAP);
               resetActiveButton(button);
               break;
            case MainAreaScreens.UNITS + Owner.ENEMY + UnitKind.GROUND:
               showUnits(ML.latestPlanet.getActiveUnits(Owner.ENEMY), ML.latestPlanet.toLocation(), null,
                  UnitKind.GROUND, Owner.ENEMY);
               resetActiveButton(button);
               break;
            case MainAreaScreens.UNITS + Owner.PLAYER + UnitKind.SPACE:
               showUnits(ML.latestPlanet.getActiveUnits(Owner.PLAYER), ML.latestPlanet.toLocation(), null,
                  UnitKind.SPACE, Owner.PLAYER);
               resetActiveButton(button);
               break;
            case MainAreaScreens.UNITS + Owner.ALLY + UnitKind.SPACE:
               showUnits(ML.latestPlanet.getActiveUnits(Owner.ALLY), ML.latestPlanet.toLocation(), null,
                  UnitKind.SPACE, Owner.ALLY);
               resetActiveButton(button);
               break;
            case MainAreaScreens.UNITS + Owner.NAP + UnitKind.SPACE:
               showUnits(ML.latestPlanet.getActiveUnits(Owner.NAP), ML.latestPlanet.toLocation(), null,
                  UnitKind.SPACE, Owner.NAP);
               resetActiveButton(button);
               break;
            case MainAreaScreens.UNITS + Owner.ENEMY + UnitKind.SPACE:
               showUnits(ML.latestPlanet.getActiveUnits(Owner.ENEMY), ML.latestPlanet.toLocation(), null,
                  UnitKind.SPACE, Owner.ENEMY);
               resetActiveButton(button);
               break;
            default:
               resetToNonMapScreen(_screenProperties[button.name]);
         }
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      public function toGalaxy(galaxy:Galaxy = null, completeHandler:Function = null) : void
      {
         callAfterMapLoaded(completeHandler);
         showGalaxy(galaxy);
      }
      
      
      /**
       * This handles both cases: when id is of a simple solar system or a wormhole and when its of
       * battleground system.
       */
      public function toSolarSystem(id:int, completeHandler:Function = null) : void
      {
         callAfterMapLoaded(completeHandler);
         var ss:SolarSystem;
         if (ML.latestGalaxy.isBattleground(id))
         {
            ss = SolarSystem(ML.latestGalaxy.wormholes.getItemAt(0));
         }
         else
         {
            ss = Collections.findFirst(ML.latestGalaxy.wormholes,
               function (wormhole:SolarSystem) : Boolean
               {
                  return wormhole.id == id;
               }
            );
            if (ss == null)
            {
               ss = new SolarSystem();
               ss.id = id;
            }
         }
         if (ss.cached)
         {
            showSolarSystem();
         }
         else
         {
            new SolarSystemsCommand(SolarSystemsCommand.SHOW, {"id": ss.id}).dispatch();
         }
      }
      
      
      /**
       * If given planet is acually a jumgate, will open a galaxy instead.
       */
      public function toPlanet(planet:MSSObject, completeHandler:Function = null) : void
      {
         if (planet.isJumpgate)
         {
            callAfterMapLoaded(
               function(map:MMap) : void
               {
                  map.zoomObject(ML.latestSolarSystem);
                  if (completeHandler != null)
                  {
                     completeHandler.call();
                  }
               },
               true
            );
            toGalaxy();
            return;
         }
         callAfterMapLoaded(completeHandler);
         if (new Planet(planet).cached)
         {
            showPlanet();
         }
         else
         {
            new PlanetsCommand(PlanetsCommand.SHOW, {"planet": planet}).dispatch();
         }
      }
      
      
      public function selectBuilding(building:Building) : void
      {
         callAfterMapLoaded(
            function(map:MMap) : void
            {
               map.selectObject(building);
            },
            true
         );
         var ssObject:MSSObject = ML.latestPlanet.ssObject;
         if (!ssObject || ssObject.id != building.planetId)
         {
            ssObject = new MSSObject();
            ssObject.player = ML.player;
            ssObject.id = building.planetId;
         }
         toPlanet(ssObject);
      }
      
      
      public function showGalaxy(newGalaxy:Galaxy = null) : void
      {
         showMap(_screenProperties[MainAreaScreens.GALAXY], newGalaxy);
      }
      
      
      public function showSolarSystem(newSolarSystem:SolarSystem = null) : void
      {
         showMap(_screenProperties[MainAreaScreens.SOLAR_SYSTEM], newSolarSystem);
      }
      
      
      public function showPlanet(newPlanet:Planet = null) : void
      {
         showMap(_screenProperties[MainAreaScreens.PLANET], newPlanet);
      }
      
      
      public function showTechnologies() : void
      {
         resetToNonMapScreen(_screenProperties[MainAreaScreens.TECH_TREE]);
      }
      
      
      public function showInfo() : void
      {
         showNonMapScreen(_screenProperties[MainAreaScreens.INFO]);
      }
      
      public var createdScreens: Object = {};
      
      public function showHealing(location: *, units: ListCollectionView): void
      {
         var setData: Function = function(e: Event): void
         {
            createdScreens[MainAreaScreens.HEAL] = true;
            _mainAreaSwitch.removeEventListener(ScreensSwitchEvent.SCREEN_CREATED, setData);
            _mainAreaSwitch.removeEventListener(ScreensSwitchEvent.SCREEN_CONSTRUCTION_COMPLETED, setData);
            new GHealingScreenEvent(GHealingScreenEvent.OPEN_SCREEN, {
               'location': location,
               'units': units});
         }
         if (createdScreens[MainAreaScreens.HEAL])
         {
            _mainAreaSwitch.addEventListener(ScreensSwitchEvent.SCREEN_CREATED, setData);
         }
         else
         {
            _mainAreaSwitch.addEventListener(ScreensSwitchEvent.SCREEN_CONSTRUCTION_COMPLETED, setData);
         }
         showNonMapScreen(_screenProperties[MainAreaScreens.HEAL]);
         
      }
      
      public function showStorage(transporter: Unit, oldUnits: ListCollectionView, oldLocation: *): void
      {
         var setTransporter: Function = function(e: Event): void
         {
            createdScreens[MainAreaScreens.STORAGE] = true;
            _mainAreaSwitch.removeEventListener(ScreensSwitchEvent.SCREEN_CREATED, setTransporter);
            _mainAreaSwitch.removeEventListener(ScreensSwitchEvent.SCREEN_CONSTRUCTION_COMPLETED, setTransporter);
            new GUnitsScreenEvent(GUnitsScreenEvent.OPEN_STORAGE_SCREEN, {'location': transporter,
               'oldLocation': oldLocation, 'oldUnits': oldUnits});
         }
         if (createdScreens[MainAreaScreens.STORAGE])
         {
            _mainAreaSwitch.addEventListener(ScreensSwitchEvent.SCREEN_CREATED, setTransporter);
         }
         else
         {
            _mainAreaSwitch.addEventListener(ScreensSwitchEvent.SCREEN_CONSTRUCTION_COMPLETED, setTransporter);
         }
         showNonMapScreen(_screenProperties[MainAreaScreens.STORAGE]);
         
      }
      
      public function showLoadUnload(location: *, target: *, units: ListCollectionView): void
      {
         var setData: Function = function(e: Event): void
         {
            createdScreens[MainAreaScreens.LOAD_UNLOAD] = true;
            _mainAreaSwitch.removeEventListener(ScreensSwitchEvent.SCREEN_CREATED, setData);
            _mainAreaSwitch.removeEventListener(ScreensSwitchEvent.SCREEN_CONSTRUCTION_COMPLETED, setData);
            new GLoadUnloadScreenEvent(GLoadUnloadScreenEvent.OPEN_SCREEN, {
               'location': location,
               'target': target,
               'units': units});
         }
         if (createdScreens[MainAreaScreens.LOAD_UNLOAD])
         {
            _mainAreaSwitch.addEventListener(ScreensSwitchEvent.SCREEN_CREATED, setData);
         }
         else
         {
            _mainAreaSwitch.addEventListener(ScreensSwitchEvent.SCREEN_CONSTRUCTION_COMPLETED, setData);
         }
         showNonMapScreen(_screenProperties[MainAreaScreens.LOAD_UNLOAD]);
         
      }
      
      public function showUnits(units:ListCollectionView, location: * = null, target: Building = null,
                                kind: String = null, owner: int = Owner.PLAYER) : void
      {
         function setData(e: Event): void
         {
            createdScreens[MainAreaScreens.UNITS] = true;
            _mainAreaSwitch.removeEventListener(ScreensSwitchEvent.SCREEN_CREATED, setData);
            _mainAreaSwitch.removeEventListener(ScreensSwitchEvent.SCREEN_CONSTRUCTION_COMPLETED, setData);
            new GUnitsScreenEvent(GUnitsScreenEvent.OPEN_SCREEN, {'location': location,
               'target': target,
               'units': units,
               'kind': kind,
               'owner': owner});
         }
         if (_mainAreaSwitch.currentScreenName != MainAreaScreens.UNITS)
         {
            if (createdScreens[MainAreaScreens.UNITS])
            {
               _mainAreaSwitch.addEventListener(ScreensSwitchEvent.SCREEN_CREATED, setData);
            }
            else
            {
               _mainAreaSwitch.addEventListener(ScreensSwitchEvent.SCREEN_CONSTRUCTION_COMPLETED, setData);
            }
            showNonMapScreen(_screenProperties[MainAreaScreens.UNITS]);
         }
         else
         {
            new GUnitsScreenEvent(GUnitsScreenEvent.OPEN_SCREEN, {'location': location,
               'target': target,
               'units': units,
               'kind': kind,
               'owner': owner});
         }
      }
      
      public function showFacilities(facilityId: int) : void
      {
         var openFacilityWithId: Function = function(e: Event): void
         {
            createdScreens[MainAreaScreens.FACILITIES] = true;
            _mainAreaSwitch.removeEventListener(ScreensSwitchEvent.SCREEN_CREATED, openFacilityWithId);
            _mainAreaSwitch.removeEventListener(ScreensSwitchEvent.SCREEN_CONSTRUCTION_COMPLETED, openFacilityWithId);
            new GUnitsScreenEvent(GUnitsScreenEvent.FACILITY_OPEN, facilityId);
         }
         if (createdScreens[MainAreaScreens.FACILITIES])
         {
            _mainAreaSwitch.addEventListener(ScreensSwitchEvent.SCREEN_CREATED, openFacilityWithId);
         }
         else
         {
            _mainAreaSwitch.addEventListener(ScreensSwitchEvent.SCREEN_CONSTRUCTION_COMPLETED, openFacilityWithId);
         }
         resetToNonMapScreen(_screenProperties[MainAreaScreens.FACILITIES]);
      }
      
      
      public function showNotifications() :void
      {
         resetToNonMapScreen(_screenProperties[MainAreaScreens.NOTIFICATIONS]);
      }
      
      public function showVip() :void
      {
         showNonMapScreen(_screenProperties[MainAreaScreens.VIP]);
      }
      
      public function showAlliance(allianceId: int) :void
      {
         GlobalFlags.getInstance().lockApplication = true;
         if (allianceId != 0)
         {
            new AlliancesCommand(AlliancesCommand.SHOW, {'id': allianceId}).dispatch();
         }
         else
         {
            openAlliance();
         }
      }
      
      private function isCreated(screenName: String): Boolean
      {
         return createdScreens[screenName] != null;
      }
      
      private function getScreen(screenName: String): *
      {
         return createdScreens[screenName];
      }
      
      private var createdHandler: Function;
      
      public function openAlliance(ally: MAlliance = null) :void
      {
         function setAlliance(): void
         {
            GlobalFlags.getInstance().lockApplication = false;
            AllianceScreen(getScreen(MainAreaScreens.ALLIANCE)).alliance = ally;
         }
         if (isCreated(MainAreaScreens.ALLIANCE))
         {
            setAlliance();
         }
         else
         {
            createdHandler = setAlliance;
         }
         resetToNonMapScreen(_screenProperties[MainAreaScreens.ALLIANCE]);
      }
      
      public function showPlayer(playerId: int) :void
      {
         GlobalFlags.getInstance().lockApplication = true;
         new PlayersCommand(PlayersCommand.SHOW_PROFILE, {'id': playerId}).dispatch();
      }
      
      public function openPlayerScreen(player: MRatingPlayer): void
      {
         function setPlayer(): void
         {
            GlobalFlags.getInstance().lockApplication = false;
            PlayerScreen(getScreen(MainAreaScreens.PLAYER)).player = player;
         }
         if (isCreated(MainAreaScreens.PLAYER))
         {
            setPlayer();
         }
         else
         {
            createdHandler = setPlayer;
         }
         showNonMapScreen(_screenProperties[MainAreaScreens.PLAYER]);
      }
      
      public function showQuests() :void
      {
         resetToNonMapScreen(_screenProperties[MainAreaScreens.QUESTS]);
         createdScreens[MainAreaScreens.QUESTS] = true;
         if (ML.player.firstTime)
         {
            ML.quests.select(Quest(ML.quests.getFirst()).id);
            new PlayersCommand(PlayersCommand.EDIT).dispatch();
         }
      }
      
      
      public function showSquadrons() :void
      {
         resetToNonMapScreen(_screenProperties[MainAreaScreens.SQUADRONS]);
      }
      
      
      public function showRatings(playerName: String = null) :void
      {
         var setData: Function = function(e: Event): void
         {
            createdScreens[MainAreaScreens.RATINGS] = true;
            _mainAreaSwitch.removeEventListener(ScreensSwitchEvent.SCREEN_CREATED, setData);
            _mainAreaSwitch.removeEventListener(ScreensSwitchEvent.SCREEN_CONSTRUCTION_COMPLETED, setData);
            new GRatingsEvent(GRatingsEvent.FILTER_PLAYER, playerName);
         }
         if (playerName)
         {
            if (createdScreens[MainAreaScreens.RATINGS])
            {
               _mainAreaSwitch.addEventListener(ScreensSwitchEvent.SCREEN_CREATED, setData);
            }
            else
            {
               _mainAreaSwitch.addEventListener(ScreensSwitchEvent.SCREEN_CONSTRUCTION_COMPLETED, setData);
            }
         }
         else
         {
            createdScreens[MainAreaScreens.RATINGS] = true;
         }
         resetToNonMapScreen(_screenProperties[MainAreaScreens.RATINGS]);
         new GRatingsEvent(GRatingsEvent.RATINGS_REFRESH);
      }
      
      
      public function showAllyRatings(allyName: String = null) :void
      {
         var setData: Function = function(e: Event): void
         {
            createdScreens[MainAreaScreens.ALLY_RATINGS] = true;
            _mainAreaSwitch.removeEventListener(ScreensSwitchEvent.SCREEN_CREATED, setData);
            _mainAreaSwitch.removeEventListener(ScreensSwitchEvent.SCREEN_CONSTRUCTION_COMPLETED, setData);
            new GRatingsEvent(GRatingsEvent.FILTER_ALLIANCE, allyName);
         }
         if (allyName)
         {
            if (createdScreens[MainAreaScreens.ALLY_RATINGS])
            {
               _mainAreaSwitch.addEventListener(ScreensSwitchEvent.SCREEN_CREATED, setData);
            }
            else
            {
               _mainAreaSwitch.addEventListener(ScreensSwitchEvent.SCREEN_CONSTRUCTION_COMPLETED, setData);
            }
         }
         else
         {
            createdScreens[MainAreaScreens.ALLY_RATINGS] = true;
         }
         resetToNonMapScreen(_screenProperties[MainAreaScreens.ALLY_RATINGS]);
         new GRatingsEvent(GRatingsEvent.ALLIANCE_RATINGS_REFRESH);
      }
      
      
      public function showWelcomeScreen() : void
      {
         resetToNonMapScreen(_screenProperties[MainAreaScreens.WELCOME]);
         ML.activeMapType = MapType.GALAXY;
      }
      
      
      public function showChat() : void
      {
         resetToNonMapScreen(_screenProperties[MainAreaScreens.CHAT]);
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      /**
       * sets reference to screen hash and
       * calls method that was set as creation complete handler for this screen 
       * @param screenType type of screen from MainAreaScreens
       * @param reference reference of the screen
       * 
       */      
      public function creationCompleteFunction(screenType: String, reference: *): void
      {
         createdScreens[screenType] = reference;
         if (createdHandler != null)
         {
            createdHandler();
            createdHandler = null;
         }
      }
      
      /**
       * Registers <code>MapLoadEvent.LOAD</code> handler if <code>callback</code> is not <code>null</code>
       * invokes that callback when the map has been loaded.
       * 
       * @param callback function to be called when a map has been loaded. Will not do anything if this
       * parameter is <code>null</code>
       * @param passMapModel if <code>true</code>, it means callback function has one parameter of type
       * <code>MMap</code> which will be provided
       */
      private function callAfterMapLoaded(callback:Function, passMapModel:Boolean = false) : void
      {
         if (callback == null)
         {
            return;
         }
         addEventListener(MapLoadEvent.LOAD, mapLoadHandler);
         function mapLoadHandler(event:MapLoadEvent) : void
         {
            removeEventListener(MapLoadEvent.LOAD, mapLoadHandler);
            if (passMapModel)
            {
               callback.call(null, event.map);
            }
            else
            {
               callback.call();
            }
         }
      }
      
      
      /**
       * This will switch main area to a given map screen, will create a map if the model is
       * provided and will set appropriate property on <code>ModelLocator</code> to reflect
       * this change.
       * 
       * @param screenName name of a screen that holds a map
       * @param newMap model of a map if one needs to be created
       * 
       * @throws IllegalOperationError if
       * <ul>
       *    <li>
       *       <code>screenName</code> is not one of:
       *       <ul>
       *          <li><code>MainAreaScreens.GALAXY</code></li>
       *          <li><code>MainAreaScreens.SOLAR_SYSTEM</code></li>
       *          <li><code>MainAreaScreens.PLANET</code></li>
       *       </ul>                            
       *    </li>
       *    <li>
       *       <code>newMap</code> has been provided but the type of this map does not map
       *       to given <code>screenName</code>
       *    </li>
       * </ul>
       */
      private function showMap(screenProps:ScreenProperties,
                               newMap:MMap = null,
                               completeHandler:Function = null) : void
      {
         if (!screenProps.holdsMap)
         {
            throw new IllegalOperationError(
               "Screen '" + screenProps.screenName + "' is not " + "supposed to hold a map"
            );
         }
         if (newMap != null && screenProps.heldMapType != newMap.mapType)
         {
            throw new IllegalOperationError(
               "Screen '" + screenProps.screenName + "' is not " + "supposed to hold map of type " + newMap.mapType
            );
         }
         beforeScreenChange();
         ML.activeMapType = screenProps.heldMapType;
         if (newMap != null)
         {
            ML[screenProps.mapPropInModelLoc] = newMap;
         }
         _mainAreaSwitch.resetToScreen(screenProps.screenName);
         resetActiveButton(screenProps.button);
         resetSidebarToCurrentScreenDefault();
         updateContainerState();
         if (newMap == null)
         {
            afterScreenChange();
            dispatchMapLoadEvent(ML[screenProps.mapPropInModelLoc]);
         }
         else
         {
            SyncUtil.waitFor(_mainAreaSwitch, 'viewStack',
               function(viewStack:ViewStack) : void
               {
                  SyncUtil.waitFor(viewStack, [viewStack, "getChildByName", screenProps.screenName],
                     function(content:NavigatorContent) : void
                     {
                        destroyOldMap(screenProps.screenName);
                        
                        var viewport:ViewportZoomable = MapFactory.getViewportWithMap(newMap);
                        var controller:IMapViewportController = MapFactory.getViewportController(newMap);
                        controller.setViewport(viewport);
                        function mapCreationCompleteHandler(event:FlexEvent) : void
                        {
                           viewport.content.removeEventListener(FlexEvent.CREATION_COMPLETE,
                              mapCreationCompleteHandler);
                           dispatchMapLoadEvent(newMap);
                        };
                        viewport.content.addEventListener(FlexEvent.CREATION_COMPLETE,
                           mapCreationCompleteHandler);
                        content.addElement(viewport);
                        content.addElement(controller);
                        afterScreenChange();
                     }
                  );
               }
            );
         }
      }
      
      
      /**
       * Destroys map, viewport and viewport controllers in the given screen.
       * 
       * @param screenName a screen that holds a map
       * 
       * @throws IllegalOperationError if given screen is not supposed to hold a map
       */
      public function destroyOldMap(screenName:String) : void
      {
         if (!ScreenProperties(_screenProperties[screenName]).holdsMap)
         {
            throw new IllegalOperationError("Screen '" + screenName + "' is not " + "supposed to hold a map");
         }
         try
         {
            var content:NavigatorContent =
               NavigatorContent(_mainAreaSwitch.viewStack.getChildByName(screenName));
         }
         catch (error:Error)
         {
            return;
         }
         if (content.numElements > 1)
         {
            IMapViewportController(content.getElementAt(1)).cleanup();
         }
         if (content.numElements > 0)
         {
            ViewportZoomable(content.getElementAt(0)).cleanup();
         }
         content.removeAllElements();
      }
      
      
      /**
       * Use this to <code>_mainAreaSwitch.resetToScreen()</code> to non-map screen. The method will
       * show given screen and will reset active button to appropriate one.
       * 
       * @throws IllegalOperationError if given name is of a map screen 
       */
      private function resetToNonMapScreen(screenProps:ScreenProperties) : void
      {
         if (screenProps.holdsMap)
         {
            throw new IllegalOperationError(
               "Screen '" + screenProps.screenName + "' is a map screen. Use showMapScreen() or resetToMapScreen() " +
               "instead."
            );
         }
         beforeScreenChange();
         _mainAreaSwitch.resetToScreen(screenProps.screenName);
         resetActiveButton(screenProps.button);
         resetSidebarToCurrentScreenDefault();
         updateContainerState();
         afterScreenChange();
      }
      
      public function switchActiveUnitButtonKind(kind: String): void
      {
         if (!_activeButton)
         {
            _activeButton = _oldActiveButton;
            _oldActiveButton = null;
         }
         if (_activeButton && _activeButton.name.indexOf(MainAreaScreens.UNITS) == 0)
         {
            var temp: String = _activeButton.name.replace(MainAreaScreens.UNITS, '');
            resetActiveButton(_screenProperties[MainAreaScreens.UNITS+temp.charAt()+kind].button);
         }
      }
      
      
      /**
       * Use this to <code>_mainAreaSwitch.showScreen()</code> non-map screen. The method will
       * show given screen.
       * 
       * @throws IllegalOperationError if given name is of a map screen 
       */
      private function showNonMapScreen(screenProps:ScreenProperties) : void
      {
         if (screenProps.holdsMap)
         {
            throw new IllegalOperationError(
               "Screen '" + screenProps.screenName + "' is a map screen. Use showMapScreen() or resetToMapScreen() " +
               "instead."
            );
         }
         beforeScreenChange();
         _mainAreaSwitch.showScreen(screenProps.screenName);
         resetActiveButton(screenProps.button);
         resetSidebarToCurrentScreenDefault();
         updateContainerState();
         afterScreenChange();
      }
      
      public function showPreviousScreen(): void
      {
         beforeScreenChange();
         _mainAreaSwitch.showPrevious();
         resetActiveButton(_screenProperties[_mainAreaSwitch.currentScreenName].button);
         resetSidebarToCurrentScreenDefault();
         updateContainerState();
         afterScreenChange();
      }
      
      
      private function beforeScreenChange() : void
      {
         if (_currentScreenProps)
         {
            _currentScreenProps.callHideHandler();
            _currentScreenProps = null;
         }
      }
      
      
      private function afterScreenChange() : void
      {
         _currentScreenProps = _screenProperties[_mainAreaSwitch.currentScreenName];
         _currentScreenProps.callShowHandler();
      }
      
      
      /**
       * Resets sidebar to currently active screen default sidebar,
       */
      private function resetSidebarToCurrentScreenDefault() : void
      {
         if (_mainAreaSwitch.currentScreenName != null)
         {
            resetSidebarTo(
               (_screenProperties[_mainAreaSwitch.currentScreenName] as ScreenProperties).defaultSidebar
            );
         }
         else
         {
            resetSidebarTo(null);
         }
      }
      
      
      /**
       * Resets sidebar switch to a sidebar component with a given name. If <code>name</code>
       * is <code>null</code>, resets sidebar switch to default.
       *  
       * @param name name of a sidebar
       */
      private function resetSidebarTo(name:String) : void
      {
         if (name != null)
         {
            SidebarScreensSwitch.getInstance().resetToScreen(name);
         }
         else
         {
            SidebarScreensSwitch.getInstance().resetToDefault();
         }
      }
      
      
      private var _oldActiveButton: Button = null;
      
      
      public function enableActiveButton(): void
      {
         if (_activeButton)
         {
            _activeButton.enabled = true;
            _oldActiveButton = _activeButton;
         }
      }
      
      
      public function disableActiveButton(): void
      {
         if (_oldActiveButton)
         {
            _oldActiveButton.enabled = false;
         }
      }
      
      private function resetActiveButton(newButton:Button = null) : void
      {
         if (_activeButton == newButton)
         {
            return;
         }
         if (_activeButton != null)
         {
            _activeButton.enabled = true;
            _activeButton = null;
         }
         else if (_oldActiveButton != null)
         {
            _oldActiveButton.enabled = true;
            _oldActiveButton = null;
         }
         if (newButton != null)
         {
            if (_oldActiveButton != null)
            {
               _oldActiveButton.enabled = true;
               _oldActiveButton = null;
            }
            _activeButton = newButton;
            _activeButton.enabled = false;
         }
      }
      
      
      private function updateContainerState() : void
      {
         if (_mainAreaSwitch.currentScreenName == null || _mainAreaContainer == null)
         {
            return;
         }
         if ((_screenProperties[_mainAreaSwitch.currentScreenName] as ScreenProperties).sidebarVisible)
         {
            _mainAreaContainer.expandSidebar();
         }
         else
         {
            _mainAreaContainer.collapseSidebar();
         }
      }
      
      
      private function dispatchMapLoadEvent(map:MMap) : void
      {
         if (hasEventListener(MapLoadEvent.LOAD))
         {
            dispatchEvent(new MapLoadEvent(map));
         }
      }
      
      
      public function dispatchMainAreaScreenSwitchEvent(): void
      {
         _mainAreaSwitch.dispatchEvent(new ScreensSwitchEvent(ScreensSwitchEvent.SCREEN_CONSTRUCTION_COMPLETED));
      }
   }
}


import flash.events.Event;

import models.map.MMap;

import spark.components.Button;


internal class ScreenProperties
{
   public function ScreenProperties(screenName:String,
                                    defaultSidebar:String = null,
                                    sidebarVisible:Boolean = true,
                                    holdsMap:Boolean = false,
                                    heldMapType:int = 0,
                                    mapPropInModelLoc:String = null,
                                    showHandler:Function = null,
                                    hideHandler:Function = null)
   {
      this.screenName = screenName;
      this.defaultSidebar = defaultSidebar;
      this.sidebarVisible = sidebarVisible;
      this.holdsMap = holdsMap;
      this.heldMapType = heldMapType;
      this.mapPropInModelLoc = mapPropInModelLoc;
      this.showHandler = showHandler;
      this.hideHandler = hideHandler;
   }
   public var screenName:String;
   public var defaultSidebar:String;
   public var sidebarVisible:Boolean;
   public var holdsMap:Boolean;
   public var heldMapType:int;
   public var mapPropInModelLoc:String;
   public var button:Button = null;
   public var showHandler:Function = null;
   public var hideHandler:Function = null;
   
   
   public function callShowHandler() : void
   { 
      if (showHandler != null)
      {
         showHandler();
      }
   }
   
   
   public function callHideHandler() : void
   {
      if (hideHandler != null)
      {
         hideHandler();
      }
   }
}


internal class MapLoadEvent extends Event
{
   public static const LOAD:String = "mapLoaded";
   public var map:MMap;
   public function MapLoadEvent(map:MMap)
   {
      super(LOAD);
      this.map = map;
   }
}