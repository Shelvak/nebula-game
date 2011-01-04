package controllers.ui
{
   import animation.AnimationTimer;
   
   import com.developmentarc.core.utils.SingletonFactory;
   
   import components.base.viewport.ViewportZoomable;
   import components.battle.BattleMap;
   import components.factories.MapFactory;
   import components.map.controllers.IMapViewportController;
   import components.screens.MainAreaContainer;
   
   import controllers.battle.BattleController;
   import controllers.combatlogs.CombatLogsCommand;
   import controllers.planets.PlanetsCommand;
   import controllers.screens.MainAreaScreens;
   import controllers.screens.MainAreaScreensSwitch;
   import controllers.screens.SidebarScreens;
   import controllers.screens.SidebarScreensSwitch;
   import controllers.solarsystems.SolarSystemsCommand;
   
   import flash.errors.IllegalOperationError;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   
   import globalevents.GLoadUnloadScreenEvent;
   import globalevents.GUnitsScreenEvent;
   
   import models.ModelLocator;
   import models.Owner;
   import models.battle.Battle;
   import models.building.Building;
   import models.events.ScreensSwitchEvent;
   import models.factories.BattleFactory;
   import models.galaxy.Galaxy;
   import models.location.Location;
   import models.map.MMap;
   import models.map.MapType;
   import models.planet.Planet;
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
   import utils.SyncUtil;
   
   
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
    * <p>
    * This constroller is a singleton and therefore instance should be retrieved using
    * <code>getInstance()</code> method.
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
      
      private var ML:ModelLocator = ModelLocator.getInstance();
      
      
      private var _screenProperties:Object = {
         (String (MainAreaScreens.GALAXY)): new ScreenProperties(
            MainAreaScreens.GALAXY, null, false, true, MapType.GALAXY, "latestGalaxy"
         ),
         (String (MainAreaScreens.SOLAR_SYSTEM)): new ScreenProperties(
            MainAreaScreens.SOLAR_SYSTEM, null, false, true, MapType.SOLAR_SYSTEM, "latestSolarSystem"
         ),
         (String (MainAreaScreens.PLANET)): new ScreenProperties(
            MainAreaScreens.PLANET, SidebarScreens.CONSTRUCTION, true, true, MapType.PLANET, "latestPlanet",
            function() : void { AnimationTimer.forPlanet.start() },
            function() : void { AnimationTimer.forPlanet.stop() }
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
            MainAreaScreens.NOTIFICATIONS, null, false
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
         (String (MainAreaScreens.BATTLE)): new ScreenProperties(
            MainAreaScreens.BATTLE, null, false
         ),
         (String (MainAreaScreens.RATINGS)): new ScreenProperties(
            MainAreaScreens.RATINGS, null, false
         )
      };
      
      
      private var _currentScreenProps:ScreenProperties = null;
      
      
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
               showUnits(ML.latestPlanet.getActiveUnits(Owner.PLAYER), ML.latestPlanet.toLocation());
               resetActiveButton(button);
               break;
            case MainAreaScreens.UNITS + Owner.ALLY + UnitKind.GROUND:
               showUnits(ML.latestPlanet.getActiveUnits(Owner.ALLY), ML.latestPlanet.toLocation());
               resetActiveButton(button);
               break;
            case MainAreaScreens.UNITS + Owner.NAP + UnitKind.GROUND:
               showUnits(ML.latestPlanet.getActiveUnits(Owner.NAP), ML.latestPlanet.toLocation());
               resetActiveButton(button);
               break;
            case MainAreaScreens.UNITS + Owner.ENEMY + UnitKind.GROUND:
               showUnits(ML.latestPlanet.getActiveUnits(Owner.ENEMY), ML.latestPlanet.toLocation());
               resetActiveButton(button);
               break;
            case MainAreaScreens.UNITS + Owner.PLAYER + UnitKind.SPACE:
               showUnits(ML.latestPlanet.getActiveUnits(Owner.PLAYER), ML.latestPlanet.toLocation(), null,
                  UnitKind.SPACE);
               resetActiveButton(button);
               break;
            case MainAreaScreens.UNITS + Owner.ALLY + UnitKind.SPACE:
               showUnits(ML.latestPlanet.getActiveUnits(Owner.ALLY), ML.latestPlanet.toLocation(), null,
                  UnitKind.SPACE);
               resetActiveButton(button);
               break;
            case MainAreaScreens.UNITS + Owner.NAP + UnitKind.SPACE:
               showUnits(ML.latestPlanet.getActiveUnits(Owner.NAP), ML.latestPlanet.toLocation(), null,
                  UnitKind.SPACE);
               resetActiveButton(button);
               break;
            case MainAreaScreens.UNITS + Owner.ENEMY + UnitKind.SPACE:
               showUnits(ML.latestPlanet.getActiveUnits(Owner.ENEMY), ML.latestPlanet.toLocation(), null,
                  UnitKind.SPACE);
               resetActiveButton(button);
               break;
            default:
               resetToNonMapScreen(_screenProperties[button.name]);
         }
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      public function toGalaxy() : void
      {
         if (_mainAreaSwitch.currentScreenName != MainAreaScreens.GALAXY)
         {
            showGalaxy();
         }
      }
      
      
      public function toSolarSystem(id:int) : void
      {
         if (_mainAreaSwitch.currentScreenName != MainAreaScreens.SOLAR_SYSTEM)
         {
            if (ML.latestSolarSystem == null ||
               ML.latestSolarSystem.fake ||
               ML.latestSolarSystem.id != id)
            {
               new SolarSystemsCommand(SolarSystemsCommand.SHOW, {"id": id}).dispatch();
            }
            else
            {
               showSolarSystem();
            }
         }
      }
      
      
      /**
       * If given planet is acually a jumgate, will open a galaxy instead.
       */
      public function toPlanet(planet:MSSObject) : void
      {
         if (planet.isJumpgate)
         {
            toGalaxy();
            ML.latestGalaxy.zoomObject(ML.latestSolarSystem);
            return;
         }
         if (ML.latestPlanet == null || ML.latestPlanet.fake || ML.latestPlanet.id != planet.id)
         {
            new PlanetsCommand(PlanetsCommand.SHOW, {"planet": planet}).dispatch();
         }
         else
         {
            showPlanet();
         }
      }
      
      
      public function selectBuilding(building:Building) : void
      {
         function mapLoadHandler(event:MapLoadEvent) : void
         {
            removeEventListener(MapLoadEvent.LOAD, mapLoadHandler);
            event.map.selectObject(building);
         };
         addEventListener(MapLoadEvent.LOAD, mapLoadHandler);
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
      
      private var createdScreens: Object = {};
      
      public function showStorage(transporter: Unit): void
      {
         var setTransporter: Function = function(e: Event): void
         {
            if (createdScreens[MainAreaScreens.STORAGE])
            {
               _mainAreaSwitch.removeEventListener(ScreensSwitchEvent.SCREEN_CREATED, setTransporter);
               new GUnitsScreenEvent(GUnitsScreenEvent.OPEN_STORAGE_SCREEN, {'location': transporter});
            }
            else
            {
               createdScreens[MainAreaScreens.STORAGE] = true;
            }
         }
         _mainAreaSwitch.addEventListener(ScreensSwitchEvent.SCREEN_CREATED, setTransporter);
         showNonMapScreen(_screenProperties[MainAreaScreens.STORAGE]);
         
      }
      
      public function showLoadUnload(location: *, target: *, units: ListCollectionView): void
      {
         var setData: Function = function(e: Event): void
         {
            if (createdScreens[MainAreaScreens.LOAD_UNLOAD])
            {
               _mainAreaSwitch.removeEventListener(ScreensSwitchEvent.SCREEN_CREATED, setData);
               new GLoadUnloadScreenEvent(GLoadUnloadScreenEvent.OPEN_SCREEN, {
                  'location': location,
                  'target': target,
                  'units': units});
            }
            else
            {
               createdScreens[MainAreaScreens.LOAD_UNLOAD] = true;
            }
         }
         _mainAreaSwitch.addEventListener(ScreensSwitchEvent.SCREEN_CREATED, setData);
         showNonMapScreen(_screenProperties[MainAreaScreens.LOAD_UNLOAD]);
         
      }
      
      public function showUnits(units:ListCollectionView, location: Location = null, target: Building = null,
                                kind: String = null) : void
      {
         var selectNpcForAttack: Function = function(e: Event): void
         {
            if (createdScreens[MainAreaScreens.UNITS])
            {
               _mainAreaSwitch.removeEventListener(ScreensSwitchEvent.SCREEN_CREATED, selectNpcForAttack);
               new GUnitsScreenEvent(GUnitsScreenEvent.OPEN_SCREEN, {'location': location,
                  'target': target,
                  'units': units,
                  'kind': kind});
            }
            else
            {
               createdScreens[MainAreaScreens.UNITS] = true;
            }
         }
         if (_mainAreaSwitch.currentScreenName != MainAreaScreens.UNITS)
         {
            _mainAreaSwitch.addEventListener(ScreensSwitchEvent.SCREEN_CREATED, selectNpcForAttack);
            resetToNonMapScreen(_screenProperties[MainAreaScreens.UNITS]);
         }
         else
         {
            new GUnitsScreenEvent(GUnitsScreenEvent.OPEN_SCREEN, {'location': location,
               'target': target,
               'units': units,
               'kind': kind});
         }
      }
      
      private var facilitiesCreated: Boolean = false;
      
      public function showFacilities(facilityId: int) : void
      {
         var openFacilityWithId: Function = function(e: Event): void
         {
            if (facilitiesCreated)
            {
               new GUnitsScreenEvent(GUnitsScreenEvent.FACILITY_OPEN, facilityId);
               _mainAreaSwitch.removeEventListener(ScreensSwitchEvent.SCREEN_CREATED, openFacilityWithId);
            }
            else
            {
               facilitiesCreated = true;
            }
         }
         _mainAreaSwitch.addEventListener(ScreensSwitchEvent.SCREEN_CREATED, openFacilityWithId);
         resetToNonMapScreen(_screenProperties[MainAreaScreens.FACILITIES]);
      }
      
      
      public function showNotifications() :void
      {
         resetToNonMapScreen(_screenProperties[MainAreaScreens.NOTIFICATIONS]);
      }
      
      
      public function showQuests() :void
      {
         resetToNonMapScreen(_screenProperties[MainAreaScreens.QUESTS]);
      }
      
      
      public function showSquadrons() :void
      {
         resetToNonMapScreen(_screenProperties[MainAreaScreens.SQUADRONS]);
      }
      
      
      public function showRatings() :void
      {
         resetToNonMapScreen(_screenProperties[MainAreaScreens.RATINGS]);
      }
      
      
      public function toBattle(logId: String) : void
      {
         battleLogId = logId;
         new CombatLogsCommand(CombatLogsCommand.SHOW, {"id": logId}).dispatch ();
      }
      
      private var battleLogId: String = null;
      
      public function showBattle(logHash: Object) : void
      {
         resetToNonMapScreen(_screenProperties[MainAreaScreens.BATTLE]);
         var seed: uint = battleLogId == null
            ? 0xfeff34bc
            : uint('0x'+battleLogId.slice(battleLogId.length-9, battleLogId.length-1));
         var battle:Battle = BattleFactory.fromObject(logHash, seed);
         displayBattle(battle);
      }
      
      public function displayBattle(battle: Battle): void
      {
         if (ML.battleController)
         {
            ML.battleController.cleanup();
         }
         var viewport:ViewportZoomable = MapFactory.getViewportWithMap(battle);
         var controller:IMapViewportController = MapFactory.getViewportController(battle);
         if (controller != null)
         {
            controller.setViewport(viewport);
         }
         
         ML.battleController = new BattleController(battle, viewport.content as BattleMap);
         
         var content:NavigatorContent = _mainAreaSwitch.currentScreenContent;
         if (content.numElements > 0)
         {
            ViewportZoomable(content.getElementAt(0)).cleanup();
         }
         if (content.numElements > 1)
         {
            IMapViewportController(content.getElementAt(1)).cleanup();
         }
         content.removeAllElements();
         
         content.addElement(viewport);
         if (controller != null)
         {
            content.addElement(controller);
         }
      }
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
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
      private function showMap(screenProps:ScreenProperties, newMap:MMap = null) : void
      {
         if (!screenProps.holdsMap)
         {
            throw new IllegalOperationError(
               "screen '" + screenProps.screenName + "' is not " + "supposed to hold a map"
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
         _mainAreaSwitch.resetToScreen(screenProps.screenName);
         resetActiveButton(screenProps.button);
         resetSidebarToCurrentScreenDefault();
         updateContainerState();
         if (newMap == null)
         {
            dispatchEvent(new MapLoadEvent(ML[screenProps.mapPropInModelLoc]));
         }
         else
         {
            ML[screenProps.mapPropInModelLoc] = newMap;
            SyncUtil.waitFor(_mainAreaSwitch, 'viewStack',
               function(viewStack:ViewStack) : void
               {
                  SyncUtil.waitFor(viewStack, [viewStack, "getChildByName", screenProps.screenName],
                     function(content:NavigatorContent) : void
                     {
                        if (content.numElements > 0)
                        {
                           ViewportZoomable(content.getElementAt(0)).cleanup();
                        }
                        if (content.numElements > 1)
                        {
                           IMapViewportController(content.getElementAt(1)).cleanup();
                        }
                        content.removeAllElements();
                        
                        var viewport:ViewportZoomable = MapFactory.getViewportWithMap(newMap);
                        var controller:IMapViewportController = MapFactory.getViewportController(newMap);
                        controller.setViewport(viewport);
                        function contentCreationCompleteHandler(event:FlexEvent) : void
                        {
                           viewport.removeEventListener(FlexEvent.CONTENT_CREATION_COMPLETE, contentCreationCompleteHandler);
                           dispatchEvent(new MapLoadEvent(newMap));
                        };
                        viewport.addEventListener(FlexEvent.CONTENT_CREATION_COMPLETE, contentCreationCompleteHandler);
                        content.addElement(viewport);
                        content.addElement(controller);
                     }
                  );
               }
            );
         }
         afterScreenChange();
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
            _activeButton = oldActiveButton;
            oldActiveButton = null;
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
      
      private var oldActiveButton: Button = null;
      
      public function enableActiveButton(): void
      {
         if (_activeButton)
         {
            _activeButton.enabled = true;
            oldActiveButton = _activeButton;
         }
      }
      
      public function disableActiveButton(): void
      {
         if (oldActiveButton)
         {
            oldActiveButton.enabled = false;
         }
      }
      
      private function resetActiveButton(newButton:Button = null) : void
      {
         if (_activeButton == newButton)
         {
            return;
         }
         if (_activeButton)
         {
            _activeButton.enabled = true;
            _activeButton = null;
         }
         else if (oldActiveButton)
         {
            oldActiveButton.enabled = true;
            oldActiveButton = null;
         }
         if (newButton)
         {
            if (oldActiveButton)
            {
               oldActiveButton.enabled = true;
               oldActiveButton = null;
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
      
      public function dispatchMainAreaScreenSwitchEvent(): void
      {
         _mainAreaSwitch.dispatchEvent(new ScreensSwitchEvent(ScreensSwitchEvent.SCREEN_CREATED));
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