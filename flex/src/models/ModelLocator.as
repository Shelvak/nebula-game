package models
{
   import com.developmentarc.core.utils.SingletonFactory;
   
   import controllers.battle.BattleController;
   import controllers.startup.StartupInfo;
   
   import flash.events.EventDispatcher;
   
   import interfaces.ICleanable;
   
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
   
   import utils.datastructures.Collections;
   
   
   /**
    * A class that implements "model locator" pattern (idea more precisely) from the
    * Cairngom microarchitecture framework. 
    * 
    * <p>This class should be treaded as a singleton and instance of it should
    * be retrieved either using static method <code>getInstance()</code> or
    * using <code>com.developmentarc.core.utils.SingletonFactory</code>.</p>
    */   
   [Bindable]
   public class ModelLocator extends EventDispatcher
   {
      public static function getInstance() : ModelLocator
      {
         return SingletonFactory.getSingletonInstance(ModelLocator);
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
         notifications.removeAll();
         notificationAlerts.removeAll();
         Collections.cleanListOfICleanables(squadrons);
         Collections.cleanListOfICleanables(routes);
         Collections.cleanListOfICleanables(units);
         technologies.clean();
         battleController = null;
         activeMapType = MapType.GALAXY;
         latestPlanet = null;
         latestSolarSystem = null;
         latestGalaxy = null;
         selectedTechnology = null;
         infoModel = null;
         if (selectedBuilding)
         {
            selectedBuilding.cleanup();
            selectedBuilding = null;
         }
      }
      
      
      /**
       * Holds startup and login information when application load completes.
       * 
       * @default null
       */
      public var startupInfo:StartupInfo = null;
      
      
      private var _infoModel:*;
      public function set infoModel(value:*) : void
      {
         if (_infoModel != value)
         {
            if (_infoModel is ICleanable)
            {
               ICleanable(_infoModel).cleanup();
            }
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
      
      
      /**
       * A player. One instance only for the whole application.
       * 
       * @default empty <code>Player</code> instance
       */      
      public var player:Player = new Player();
      
      
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
      public function set latestSolarSystem(value:SolarSystem) : void
      {
         if (_latestSolarSystem != value)
         {
            if (_latestSolarSystem)
            {
               _latestSolarSystem.setFlag_destructionPending();
               _latestSolarSystem.cleanup();
            }
            _latestSolarSystem = value;
         }
      }
      /**
       * @private
       */
      public function get latestSolarSystem() : SolarSystem
      {
         return _latestSolarSystem;
      }
      
      
      private var _latestPlanet:Planet = null;
      /**
       * A solar system that user is acting in at the time (or recently was).
       * 
       * @default null
       */
      public function set latestPlanet(value:Planet) : void
      {
         if (_latestPlanet != value)
         {
            if (_latestPlanet)
            {
               _latestPlanet.setFlag_destructionPending()
               _latestPlanet.cleanup();
            }
            _latestPlanet = value;
         }
      }
      /**
       * @private
       */
      public function get latestPlanet() : Planet
      {
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
      
      public var ratings: ArrayCollection = new ArrayCollection();
      
      
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
      
      
      /**
       * A blocking folliage currently selected. <code>selectedBuilding</code> and
       * <code>selectedBlockingFolliage</code> are mutually exclusive.
       */
      public var selectedFolliage:BlockingFolliage;
   }
}