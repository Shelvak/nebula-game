package controllers.ui
{
   import com.developmentarc.core.utils.EventBroker;
   
   import components.base.viewport.ViewportZoomable;
   import components.defensiveportal.DefensivePortalScreen;
   import components.factories.MapFactory;
   import components.map.controllers.IMapViewportController;
   import components.map.planet.PlanetMap;
   import components.map.space.CMapGalaxy;
   import components.map.space.CMapSolarSystem;
   import components.player.PlayerScreen;
   import components.screens.MainAreaContainer;
   
   import controllers.GlobalFlags;
   import controllers.market.MarketCommand;
   import controllers.navigation.MCMainArea;
   import controllers.navigation.MCSidebar;
   import controllers.planets.PlanetsCommand;
   import controllers.planets.actions.ShowActionParams;
   import controllers.players.PlayersCommand;
   import controllers.screens.MainAreaScreens;
   import controllers.screens.SidebarScreens;
   import controllers.solarsystems.SolarSystemsCommand;
   import controllers.solarsystems.actions.ShowActionParams;
   
   import flash.errors.IllegalOperationError;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   
   import globalevents.GRatingsEvent;
   import globalevents.GUnitsScreenEvent;
   import globalevents.GlobalEvent;
   
   import models.ModelLocator;
   import models.Owner;
   import models.building.Building;
   import models.chat.MChat;
   import models.events.ScreensSwitchEvent;
   import models.galaxy.Galaxy;
   import models.healing.MCHealingScreen;
   import models.infoscreen.MCInfoScreen;
   import models.map.MMap;
   import models.map.MapType;
   import models.market.MCMarketScreen;
   import models.planet.Planet;
   import models.player.MRatingPlayer;
   import models.quest.Quest;
   import models.ratings.MCRatingsScreen;
   import models.solarsystem.MSSObject;
   import models.solarsystem.SolarSystem;
   import models.unit.MCLoadUnloadScreen;
   import models.unit.MCUnitScreen;
   import models.unit.MCUnitsBuild;
   import models.unit.Unit;
   import models.unit.UnitKind;
   
   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;
   import mx.events.FlexEvent;
   
   import spark.components.Button;
   import spark.components.Group;
   
   import utils.Objects;
   import utils.SingletonFactory;
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
      
      private function get ML() : ModelLocator
      {
         return ModelLocator.getInstance();
      }
      
      
      private var _screenProperties:Object = {};
      
      
      private var _currentScreenProps:ScreenProperties = null;
      
      
      public function NavigationController()
      {
         // IntelliJ IDEA does not recognize dynamic key/value object definition
         // so we're reverting to setting it by hand here.
         _screenProperties[String (MainAreaScreens.GALAXY)] = new ScreenProperties(
            MainAreaScreens.GALAXY, null, false, true, MapType.GALAXY, "latestGalaxy",
            CMapGalaxy.screenShowHandler,
            CMapGalaxy.screenHideHandler
         )
         _screenProperties[String (MainAreaScreens.SOLAR_SYSTEM)] = new ScreenProperties(
            MainAreaScreens.SOLAR_SYSTEM, null, false, true, MapType.SOLAR_SYSTEM, "latestSolarSystem",
            CMapSolarSystem.screenShowHandler,
            CMapSolarSystem.screenHideHandler
         )
         _screenProperties[String (MainAreaScreens.PLANET)] = new ScreenProperties(
            MainAreaScreens.PLANET, SidebarScreens.CONSTRUCTION, true, true, MapType.PLANET, "latestPlanet",
            PlanetMap.screenShowHandler,
            PlanetMap.screenHideHandler
         )
         _screenProperties[String (MainAreaScreens.TECH_TREE)] = new ScreenProperties(
            MainAreaScreens.TECH_TREE, SidebarScreens.TECH_TREE_BASE
         )
         _screenProperties[String (MainAreaScreens.STORAGE)] = new ScreenProperties(
            MainAreaScreens.STORAGE, null, false
         )
         _screenProperties[String (MainAreaScreens.UNITS)] = new ScreenProperties(
            MainAreaScreens.UNITS, SidebarScreens.UNITS_ACTIONS
         )
         _screenProperties[String (MainAreaScreens.LOAD_UNLOAD)] = new ScreenProperties(
            MainAreaScreens.LOAD_UNLOAD, SidebarScreens.LOAD_UNLOAD
         )
         _screenProperties[String (MainAreaScreens.HEAL)] = new ScreenProperties(
            MainAreaScreens.HEAL, SidebarScreens.HEAL
         )
         _screenProperties[String (MainAreaScreens.MARKET)] = new ScreenProperties(
            MainAreaScreens.MARKET, SidebarScreens.MARKET
         )
         _screenProperties[String (MainAreaScreens.UNITS+Owner.PLAYER+UnitKind.GROUND)] = new ScreenProperties(
            MainAreaScreens.UNITS, SidebarScreens.UNITS_ACTIONS
         )
         _screenProperties[String (MainAreaScreens.UNITS+Owner.ALLY+UnitKind.GROUND)] = new ScreenProperties(
            MainAreaScreens.UNITS, SidebarScreens.UNITS_ACTIONS
         )
         _screenProperties[String (MainAreaScreens.UNITS+Owner.ENEMY+UnitKind.GROUND)] = new ScreenProperties(
            MainAreaScreens.UNITS, SidebarScreens.UNITS_ACTIONS
         )
         _screenProperties[String (MainAreaScreens.UNITS+Owner.NAP+UnitKind.GROUND)] = new ScreenProperties(
            MainAreaScreens.UNITS, SidebarScreens.UNITS_ACTIONS
         )
         _screenProperties[String (MainAreaScreens.UNITS+Owner.PLAYER+UnitKind.SPACE)] = new ScreenProperties(
            MainAreaScreens.UNITS, SidebarScreens.UNITS_ACTIONS
         )
         _screenProperties[String (MainAreaScreens.UNITS+Owner.ALLY+UnitKind.SPACE)] = new ScreenProperties(
            MainAreaScreens.UNITS, SidebarScreens.UNITS_ACTIONS
         )
         _screenProperties[String (MainAreaScreens.UNITS+Owner.ENEMY+UnitKind.SPACE)] = new ScreenProperties(
            MainAreaScreens.UNITS, SidebarScreens.UNITS_ACTIONS
         )
         _screenProperties[String (MainAreaScreens.UNITS+Owner.NAP+UnitKind.SPACE)] = new ScreenProperties(
            MainAreaScreens.UNITS, SidebarScreens.UNITS_ACTIONS
         )
         _screenProperties[String (MainAreaScreens.NOTIFICATIONS)] = new ScreenProperties(
            MainAreaScreens.NOTIFICATIONS, null, false, false, 0, null, function (): void
            {
               if (ExternalInterface.available)
               {
                  ExternalInterface.call("notificationsOpened");
               }
            }
         )
         _screenProperties[String (MainAreaScreens.QUESTS)] = new ScreenProperties(
            MainAreaScreens.QUESTS, null, false
         )
         _screenProperties[String (MainAreaScreens.SQUADRONS)] = new ScreenProperties(
            MainAreaScreens.SQUADRONS, null, false
         )
         _screenProperties[String (MainAreaScreens.INFO)] = new ScreenProperties(
            MainAreaScreens.INFO, null, false
         )
         _screenProperties[String (MainAreaScreens.FACILITIES)] = new ScreenProperties(
            MainAreaScreens.FACILITIES, null, false
         )
         _screenProperties[String (MainAreaScreens.RATINGS)] = new ScreenProperties(
            MainAreaScreens.RATINGS, null, false
         )
         _screenProperties[String (MainAreaScreens.PLAYER)] = new ScreenProperties(
            MainAreaScreens.PLAYER, null, false
         )
         _screenProperties[String (MainAreaScreens.DEFENSIVE_PORTAL)] = new ScreenProperties(
            MainAreaScreens.DEFENSIVE_PORTAL, null, false
         )
         _screenProperties[String (MainAreaScreens.VIP)] = new ScreenProperties(
            MainAreaScreens.VIP, null, false
         )
         _screenProperties[String (MainAreaScreens.ALLY_RATINGS)] = new ScreenProperties(
            MainAreaScreens.ALLY_RATINGS, null, false
         )
         _screenProperties[String(MainAreaScreens.ALLIANCE)] = new ScreenProperties(
            MainAreaScreens.ALLIANCE, null, false
         )
         _screenProperties[String(MainAreaScreens.WELCOME)] = new ScreenProperties(
            MainAreaScreens.WELCOME, null, false
         )
         _screenProperties[String (MainAreaScreens.CHAT)] = new ScreenProperties(
            MainAreaScreens.CHAT, null, false, false, 0, null,
            MChat.getInstance().screenShowHandler,
            MChat.getInstance().screenHideHandler
         )
         
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
         _mainAreaContainer = Objects.paramNotNull("container", container);
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
            case MainAreaScreens.NOTIFICATIONS:
               showNonMapScreen(_screenProperties[button.name]);
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
      public function toSolarSystem(id:int, completeHandler:Function = null) : void {
         callAfterMapLoaded(completeHandler);
         var ss:SolarSystem;
         if (ML.latestGalaxy.isBattleground(id))
            ss = SolarSystem(ML.latestGalaxy.wormholes.getItemAt(0));
         else {
            ss = Collections.findFirst(ML.latestGalaxy.wormholes,
               function (wormhole:SolarSystem) : Boolean {
                  return wormhole.id == id;
               }
            );
            if (ss == null) {
               ss = new SolarSystem();
               ss.id = id;
            }
         }
         if (ss.cached)
            showSolarSystem();
         else
            new SolarSystemsCommand(
               SolarSystemsCommand.SHOW,
               new controllers.solarsystems.actions.ShowActionParams(ss.id, false)
            ).dispatch();
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
            showPlanet();
         else
            new PlanetsCommand(
               PlanetsCommand.SHOW,
               new controllers.planets.actions.ShowActionParams(planet.id, false)
            ).dispatch();
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
         function loadMap(e: ScreensSwitchEvent = null): void
         {
            showMap(_screenProperties[MainAreaScreens.GALAXY], newGalaxy);
            MA.removeEventListener(ScreensSwitchEvent.CONTAINER_LOADED, loadMap);
         }
         if (!MA.containerLoaded)
         {
            MA.addEventListener(ScreensSwitchEvent.CONTAINER_LOADED, loadMap);
         }
         else
         {
            loadMap();
         }
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
      
      
      public function showInfo(obj: *) : void
      {
         MCInfoScreen.getInstance().infoModel = obj;
         showNonMapScreen(_screenProperties[MainAreaScreens.INFO]);
      }
      
      public var createdScreens: Object = {};
      
      public function showHealing(location: *, units: ListCollectionView): void
      {
         MCHealingScreen.getInstance().prepare(units, location);
         showNonMapScreen(_screenProperties[MainAreaScreens.HEAL]);
      }
      
      public function showStorage(transporter: Unit, oldUnits: ListCollectionView, oldLocation: *): void
      {
         var setTransporter: Function = function(e: Event): void
         {
            createdScreens[MainAreaScreens.STORAGE] = true;
            MA.removeEventListener(ScreensSwitchEvent.SCREEN_CHANGED, setTransporter);
            MA.removeEventListener(ScreensSwitchEvent.SCREEN_CONSTRUCTION_COMPLETED, setTransporter);
            new GUnitsScreenEvent(GUnitsScreenEvent.OPEN_STORAGE_SCREEN, {'location': transporter,
               'oldLocation': oldLocation, 'oldUnits': oldUnits});
         }
         if (createdScreens[MainAreaScreens.STORAGE])
         {
            MA.addEventListener(ScreensSwitchEvent.SCREEN_CHANGED, setTransporter);
         }
         else
         {
            MA.addEventListener(ScreensSwitchEvent.SCREEN_CONSTRUCTION_COMPLETED, setTransporter);
         }
         showNonMapScreen(_screenProperties[MainAreaScreens.STORAGE]);
         
      }
      
      public function showLoadUnload(location: *, target: *, units: ListCollectionView): void
      {
         MCLoadUnloadScreen.getInstance().prepare(units, location, target);
         showNonMapScreen(_screenProperties[MainAreaScreens.LOAD_UNLOAD]);
      }
      
      public function showUnits(units:ListCollectionView, location: * = null, target: Building = null,
                                kind: String = null, owner: int = Owner.PLAYER) : void
      {
         MCUnitScreen.getInstance().prepare(units, location, target, kind, owner);
         showNonMapScreen(_screenProperties[MainAreaScreens.UNITS]);
      }
      
      public function showFacilities(facilityId: int, 
                                     cancelState: Boolean = false) : void
      {
         var openFacilityWithId: Function = function(e: Event): void
         {
            createdScreens[MainAreaScreens.FACILITIES] = true;
            MA.removeEventListener(ScreensSwitchEvent.SCREEN_CHANGED, openFacilityWithId);
            MA.removeEventListener(ScreensSwitchEvent.SCREEN_CONSTRUCTION_COMPLETED, openFacilityWithId);
            var BS: MCUnitsBuild = MCUnitsBuild.getInstance();
            BS.facilityId = facilityId;
            if (cancelState)
            {
               BS.cancelId = facilityId;
            }
            else
            {
               BS.cancelId = -1;
            }
            BS.openFacility();
         }
         if (createdScreens[MainAreaScreens.FACILITIES])
         {
            MA.addEventListener(ScreensSwitchEvent.SCREEN_CHANGED, openFacilityWithId);
         }
         else
         {
            MA.addEventListener(ScreensSwitchEvent.SCREEN_CONSTRUCTION_COMPLETED, openFacilityWithId);
         }
         resetToNonMapScreen(_screenProperties[MainAreaScreens.FACILITIES]);
      }
      
      
      public function showNotifications() :void
      {
         showNonMapScreen(_screenProperties[MainAreaScreens.NOTIFICATIONS]);
      }
      
      public function showVip() :void
      {
         showNonMapScreen(_screenProperties[MainAreaScreens.VIP]);
      }
      
      public function showMarket(market: Building) :void
      {
         var mScreen: MCMarketScreen = MCMarketScreen.getInstance();
         mScreen.market = market;
         mScreen.planetId = ML.latestPlanet.id;
         GlobalFlags.getInstance().lockApplication = true;
         showNonMapScreen(_screenProperties[MainAreaScreens.MARKET], false);
         new MarketCommand(MarketCommand.INDEX, {
            'planetId': mScreen.planetId}).dispatch();
      }
      
      public function showAllianceScreen() :void
      {
         showNonMapScreen(_screenProperties[MainAreaScreens.ALLIANCE]);
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
      
      public function showPlayer(playerId: int) :void
      {
         GlobalFlags.getInstance().lockApplication = true;
         new PlayersCommand(PlayersCommand.SHOW_PROFILE, {'id': playerId}).dispatch();
      }
      
      public function openPlayerScreen(player: MRatingPlayer, 
                                       achievements: ArrayCollection): void
      {
         function setData(): void
         {
            GlobalFlags.getInstance().lockApplication = false;
            PlayerScreen(getScreen(MainAreaScreens.PLAYER)).player = player;
            PlayerScreen(getScreen(MainAreaScreens.PLAYER)).achievements = achievements;
         }
         if (isCreated(MainAreaScreens.PLAYER))
         {
            setData();
         }
         else
         {
            createdHandler = setData;
         }
         showNonMapScreen(_screenProperties[MainAreaScreens.PLAYER], false);
      }
      
      public function showDefensivePortal(planetId: int) :void
      {
         GlobalFlags.getInstance().lockApplication = true;
         new PlanetsCommand(PlanetsCommand.PORTAL_UNITS, {'id': planetId}).dispatch();
      }
      
      public function openDefensivePortal(units: Array, maxVolume: int): void
      {
         function setData(): void
         {
            GlobalFlags.getInstance().lockApplication = false;
            DefensivePortalScreen(getScreen(
               MainAreaScreens.DEFENSIVE_PORTAL)).allUnits = units;
            DefensivePortalScreen(getScreen(
               MainAreaScreens.DEFENSIVE_PORTAL)).maxVolume = maxVolume;
         }
         if (isCreated(MainAreaScreens.DEFENSIVE_PORTAL))
         {
            setData();
         }
         else
         {
            createdHandler = setData;
         }
         showNonMapScreen(_screenProperties[MainAreaScreens.DEFENSIVE_PORTAL]);
      }
      
      public function showQuests() :void
      {
         showNonMapScreen(_screenProperties[MainAreaScreens.QUESTS]);
         createdScreens[MainAreaScreens.QUESTS] = true;
         ML.quests.applyCompletedFilter(false);
         if (ML.quests.selectedQuest == null)
         {
            var quest: Quest = Quest(ML.quests.getFirst());
            // We might not have any quests left.
            if (quest != null) {
               ML.quests.select(quest.id);
            }
         }
         if (ML.player.firstTime)
         {
            ML.quests.select(Quest(ML.quests.getFirst()).id);
            new PlayersCommand(PlayersCommand.EDIT).dispatch();
         }
      }
      
      
      public function showSquadrons() :void
      {
         showNonMapScreen(_screenProperties[MainAreaScreens.SQUADRONS]);
      }
      
      
      public function showRatings(playerName: String = null) :void
      {
         var RS: MCRatingsScreen = MCRatingsScreen.getInstance();
         var filterPlayer: Function = function(e: Event): void
         {
            createdScreens[MainAreaScreens.RATINGS] = true;
            MA.removeEventListener(ScreensSwitchEvent.SCREEN_CHANGED, filterPlayer);
            MA.removeEventListener(ScreensSwitchEvent.SCREEN_CONSTRUCTION_COMPLETED, filterPlayer);
            RS.filterPlayer(playerName);
         }
         if (createdScreens[MainAreaScreens.RATINGS])
         {
            MA.addEventListener(ScreensSwitchEvent.SCREEN_CHANGED, filterPlayer);
         }
         else
         {
            MA.addEventListener(ScreensSwitchEvent.SCREEN_CONSTRUCTION_COMPLETED, filterPlayer);
         }
         showNonMapScreen(_screenProperties[MainAreaScreens.RATINGS]);
      }
      
      
      public function showAllyRatings() :void
      {
         createdScreens[MainAreaScreens.ALLY_RATINGS] = true;
         showNonMapScreen(_screenProperties[MainAreaScreens.ALLY_RATINGS]);
         new GRatingsEvent(GRatingsEvent.ALLIANCE_RATINGS_REFRESH);
      }
      
      
      public function showWelcomeScreen() : void
      {
         resetToNonMapScreen(_screenProperties[MainAreaScreens.WELCOME]);
         ML.activeMapType = MapType.GALAXY;
      }
      
      
      public function showChat() : void {
         showNonMapScreen(_screenProperties[MainAreaScreens.CHAT]);
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
      
      private var MA: MCMainArea = MCMainArea.getInstance();
      
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
            throw new IllegalOperationError(
               "Screen '" + screenProps.screenName + "' is not " + "supposed to hold a map"
            );
         if (newMap != null && screenProps.heldMapType != newMap.mapType)
            throw new IllegalOperationError(
               "Screen '" + screenProps.screenName + "' is not " + "supposed to hold map of type " + newMap.mapType
            );
         beforeScreenChange();
         ML.activeMapType = screenProps.heldMapType;
         if (newMap != null)
            ML[screenProps.mapPropInModelLoc] = newMap;
         MA.resetToScreen(screenProps.screenName);
         resetActiveButton(screenProps.button);
         resetSidebarToCurrentScreenDefault();
         updateContainerState();
         if (newMap == null) {
            afterScreenChange();
            dispatchMapLoadEvent(ML[screenProps.mapPropInModelLoc]);
         }
         else {
            recreateMap(
               newMap,
               function mapCreationCompleteHandler(event:FlexEvent) : void {
                  dispatchMapLoadEvent(newMap);
               }
            );
            afterScreenChange();
         }
      }
      
      /**
       * Forces recreation of a given map.
       * 
       * @param map model of a map that needs to be recreated.
       * <ul><b>
       *    <li>Not null.</li>
       * </b></ul>
       * @param completeHandler handler of <code>FlexEvent.CREATION_COMPLETE</code> event of viewport's content.
       */
      public function recreateMap(map:MMap, completeHandler:Function = null) : void {
         Objects.paramNotNull("map", map);
         var screenName:String;
         switch (map.mapType) {
            case MapType.GALAXY: screenName = MainAreaScreens.GALAXY; break;
            case MapType.SOLAR_SYSTEM: screenName = MainAreaScreens.SOLAR_SYSTEM; break;
            case MapType.PLANET: screenName = MainAreaScreens.PLANET; break;
         }
         destroyOldMap(screenName);
         
         var viewport:ViewportZoomable = MapFactory.getViewportWithMap(map);
         var controller:IMapViewportController = MapFactory.getViewportController(map);
         controller.setViewport(viewport);
         if (completeHandler != null) {
            var content:Group = viewport.content;
            function content_creationCompleteHandler(event:FlexEvent) : void {
               content.removeEventListener(FlexEvent.CREATION_COMPLETE, content_creationCompleteHandler);
               completeHandler.call(null, event);
            }
            content.addEventListener(FlexEvent.CREATION_COMPLETE, content_creationCompleteHandler);
         }
         MA.addMapElements(screenName, viewport, controller);
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
         if (!ScreenProperties(_screenProperties[screenName]).holdsMap) {
            throw new IllegalOperationError("Screen '" + screenName + "' is not " + "supposed to hold a map");
         }
         try {
            MA.destroyScreenMap(screenName);
         }
         catch (error:Error) {
            return;
         }
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
               "Screen '" + screenProps.screenName + "' is a map screen. " +
               "Use showMapScreen() or resetToMapScreen() instead."
            );
         }
         beforeScreenChange();
         MA.resetToScreen(screenProps.screenName);
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
      private function showNonMapScreen(screenProps:ScreenProperties, unlockAfter: Boolean = true) : void
      {
         if (screenProps.holdsMap)
         {
            throw new IllegalOperationError(
               "Screen '" + screenProps.screenName + "' is a map screen. Use showMapScreen() or resetToMapScreen() " +
               "instead."
            );
         }
         
         if (_currentScreenProps != null && _currentScreenProps.screenName == screenProps.screenName)
            return;
         
         beforeScreenChange();
         MA.showScreen(screenProps.screenName, unlockAfter);
         resetActiveButton(screenProps.button);
         resetSidebarToCurrentScreenDefault();
         updateContainerState();
         afterScreenChange();
      }
      
      public function showPreviousScreen(): void
      {
         beforeScreenChange();
         MA.showPrevious();
         resetActiveButton(_screenProperties[MA.currentName].button);
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
         _currentScreenProps = _screenProperties[MA.currentName];
         _currentScreenProps.callShowHandler();
      }
      
      
      /**
       * Resets sidebar to currently active screen default sidebar,
       */
      private function resetSidebarToCurrentScreenDefault() : void
      {
         if (MA.currentName != null)
         {
            resetSidebarTo(
               (_screenProperties[MA.currentName] as ScreenProperties).defaultSidebar
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
            SD.resetToScreen(name);
         }
         else
         {
            SD.resetToDefault();
         }
      }
      
      private function get SD(): MCSidebar
      {
         return MCSidebar.getInstance();
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
         if (MA.currentName == null || _mainAreaContainer == null)
         {
            return;
         }
         if ((_screenProperties[MA.currentName] as ScreenProperties).sidebarVisible)
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
         MA.dispatchEvent(new ScreensSwitchEvent(ScreensSwitchEvent.SCREEN_CONSTRUCTION_COMPLETED));
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
