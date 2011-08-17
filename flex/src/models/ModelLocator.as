package models
{
   import controllers.battle.BattleController;
   import controllers.screens.MainAreaScreens;
   import controllers.ui.NavigationController;
   
   import flash.events.EventDispatcher;
   
   import globalevents.GPlanetEvent;
   
   import models.building.Building;
   import models.folliage.BlockingFolliage;
   import models.galaxy.Galaxy;
   import models.map.MapType;
   import models.movement.SquadronsList;
   import models.notification.NotificationsCollection;
   import models.planet.Planet;
   import models.player.Player;
   import models.quest.QuestsCollection;
   import models.resource.ResourcesMods;
   import models.solarsystem.SolarSystem;
   import models.technology.TechnologiesModel;
   import models.technology.Technology;
   import models.unit.UnitsList;
   
   import mx.collections.ArrayCollection;
   
   import namespaces.prop_name;
   
   import utils.SingletonFactory;
   import utils.datastructures.Collections;
   
   /**
    * @eventType mx.events.PropertyChangeEvent.PROPERTY_CHANGE
    */
   [Event(name="propertyChange", type="mx.events.PropertyChangeEvent")]
   
   /**
    * A class that implements "model locator" pattern (idea more precisely) from the
    * Cairngom microarchitecture framework. 
    * 
    * <p>This class should be treaded as a singleton and instance of it should
    * be retrieved either using static method <code>getInstance()</code> or
    * using <code>utils.SingletonFactory</code>.</p>
    */   
   [Bindable]
   public class ModelLocator extends EventDispatcher
   {
      public static function getInstance() : ModelLocator
      {
         return SingletonFactory.getSingletonInstance(ModelLocator);
      }
      
      
      private function get NAV_CTRL() : NavigationController
      {
         return NavigationController.getInstance();
      }
      
      
      public function ModelLocator()
      {
         super();
         reset();
      }
      
      
      /**
       * Resets all properties to their default values. Needed when user ends
       * the game and logs out.
       */      
      public function reset() : void
      {
         player.reset();
         notifications.removeAll();
         notificationAlerts.removeAll();
         quests.removeAll();
         Collections.cleanListOfICleanables(squadrons);
         Collections.cleanListOfICleanables(routes);
         Collections.cleanListOfICleanables(units);
         selectedTechnology = null;
         technologies.clean();
         battleController = null;
         activeMapType = MapType.GALAXY;
         latestPlanet = null;
         latestSolarSystem = null;
         latestGalaxy = null;
         infoModel = null;
         if (selectedBuilding)
         {
            selectedBuilding.cleanup();
            selectedBuilding = null;
         }
      }
      
      
      private var _infoModel:*;
      public function set infoModel(value:*) : void
      {
         if (_infoModel != value)
         {
            _infoModel = value;
         }
      }
      public function get infoModel() : *
      {
         return _infoModel;
      }
      
      
      /**
       * Technologies container
       * 
       * items are models.Technology
       * 
       * @see models.TechnologiesModel
       */
      public var technologies:TechnologiesModel = new TechnologiesModel();
      
      public var notificationAlerts: ArrayCollection = new ArrayCollection();
      
      
      [Bindable(event="willNotChange")]
      /**
       * A player. One instance only for the whole application.
       * 
       * @default empty <code>Player</code> instance
       */
      public const player:Player = new Player();
      
      
      /**
       * Type of currently active (visible) map.
       * 
       * @default default <code>MapType.GALAXY</code> instance
       */      
      public var activeMapType:int;
      
      
      private var _latestGalaxy:Galaxy;
      /**
       * Current galaxy that user is acting in.
       */
      public function set latestGalaxy(value:Galaxy) : void
      {
         if (_latestGalaxy != value)
         {
            if (_latestGalaxy)
            {
               NAV_CTRL.destroyOldMap(MainAreaScreens.GALAXY);
               _latestGalaxy.setFlag_destructionPending();
               _latestGalaxy.cleanup();
            }
            _latestGalaxy = value;
         }
      }
      /**
       * @private
       */
      public function get latestGalaxy() : Galaxy
      {
         return _latestGalaxy;
      }
      
      
      private var _latestSolarSystem:SolarSystem;
      /**
       * A solar system that user is acting in at the time (or recently was). 
       */
      public function set latestSolarSystem(value:SolarSystem) : void {
         if (_latestSolarSystem != value) {
            if (_latestSolarSystem) {
               NAV_CTRL.destroyOldMap(MainAreaScreens.SOLAR_SYSTEM);
               _latestSolarSystem.setFlag_destructionPending();
               _latestSolarSystem.cleanup();
            }
            _latestSolarSystem = value;
         }
      }
      /**
       * @private
       */
      public function get latestSolarSystem() : SolarSystem {
         return _latestSolarSystem;
      }
      
      
      prop_name static const latestPlanet:String = "latestPlanet"; 
      private var _latestPlanet:Planet = null;
      /**
       * A solar system that user is acting in at the time (or recently was).
       * 
       * @default null
       */
      public function set latestPlanet(value:Planet) : void {
         if (_latestPlanet != value) {
            if (_latestPlanet) {
               NAV_CTRL.destroyOldMap(MainAreaScreens.PLANET);
               _latestPlanet.setFlag_destructionPending()
               _latestPlanet.cleanup();
            }
            _latestPlanet = value;
            new GPlanetEvent(GPlanetEvent.PLANET_CHANGE);
         }
      }
      /**
       * @private
       */
      public function get latestPlanet() : Planet {
         return _latestPlanet;
      }
      
      
      public var resourcesMods:ResourcesMods = new ResourcesMods();
      
      
      /**
       * List of buildings player is alowed to construct.
       * 
       * @default null 
       */      
      public var constructable:ArrayCollection = null;
      
      
      /**
       * Collection of notifications.
       * 
       * @default empty collection
       */
      public var notifications:NotificationsCollection = new NotificationsCollection();
      
      
      /**
       * Collection of quests.
       * 
       * @default empty collection
       */
      public var quests:QuestsCollection = new QuestsCollection();
      
      
      public var battleController:BattleController;
      
      
      /**
       * List of all units visible for the player.
       * 
       * @default empty collection
       */
      public var units:UnitsList = new UnitsList();
      
      public var ratings: ArrayCollection;
      
      public var allyRatings: ArrayCollection;
      
      
      /**
       * List of all routes visible by the player. Each instance is referenced by a moving friendly
       * squadron instance form <code>squadrons</code> list.
       * 
       * @default empty collection
       */
      public var routes:ModelsCollection = new ModelsCollection();
      
      
      /**
       * List of all squadrons visible for the player.
       * 
       * @default empty collection
       */
      public var squadrons:SquadronsList = new SquadronsList();
      
      
      /* ###################### */
      /* ### USER SELECTION ### */
      /* ###################### */
      
      
      /**
       * Selected technology for info at sidebar and upgrading.
       * 
       * @default null
       */
      public var selectedTechnology:Technology = null;
      
      
      /**
       * A building which is selected on a planet. <code>selectedBuilding</code> and
       * <code>selectedBlockingFolliage</code> are mutually exclusive.
       */
      public var selectedBuilding:Building = null;
      
      
      prop_name static const selectedFoliage:String = "selectedFoliage";
      /**
       * A blocking foliage currently selected. <code>selectedBuilding</code> and
       * <code>selectedBlockingFolliage</code> are mutually exclusive.
       */
      public var selectedFoliage:BlockingFolliage;
   }
}