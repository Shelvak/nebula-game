package models
{
   import com.developmentarc.core.utils.SingletonFactory;
   
   import controllers.battle.BattleController;
   import controllers.startup.StartupInfo;
   
   import models.building.Building;
   import models.galaxy.Galaxy;
   import models.map.MapType;
   import models.movement.SquadronsList;
   import models.notification.NotificationsCollection;
   import models.planet.Planet;
   import models.quest.QuestsCollection;
   import models.resource.ResourcesMods;
   import models.solarsystem.SSObject;
   import models.solarsystem.SolarSystem;
   import models.technology.TechnologiesModel;
   import models.technology.Technology;
   import models.unit.UnitsList;
   
   import mx.collections.ArrayCollection;
   
   
   /**
    * A class that implements "model locator" pattern (idea more precisely) from the
    * Cairngom microarchitecture framework. 
    * 
    * <p>This class should be treaded as a singleton and instance of it should
    * be retrieved either using static method <code>getInstance()</code> or
    * using <code>com.developmentarc.core.utils.SingletonFactory</code>.</p>
    */   
   [Bindable]
   public class ModelLocator
   {
      public static function getInstance() : ModelLocator
      {
         return SingletonFactory.getSingletonInstance(ModelLocator);
      }
      
      
      /**
       * Holds startup and login information when application load completes.
       * 
       * @default null
       */
      public var startupInfo:StartupInfo = null;
      
      
      public var infoModel: *;
      
      
      /**
       * Technologies container
       * 
       * items are models.Technology
       * 
       * @see models.TechnologiesModel
       */
      public var technologies:TechnologiesModel = new TechnologiesModel();
	   
      
      /**
      * selected technology, for info at sidebar and upgrading
      */
      public var selectedTechnology:Technology;
      
      public var notificationAlerts: ArrayCollection = new ArrayCollection();
      
      
      /**
       *  Holds address of a server to connect to. 
       * 
       * @default nebula44.com
       */
      public var server:String;
      
      
      /**
       * Holds index of a host in hosts combobox of LoginScreen.
       */
      public var serverIndex:int;
      
      
      /**
       * A player. One instance only for the whole application.
       * 
       * @default empty <code>Player</code> instance
       */      
      public var player:Player;
      
      
      /**
       * Type of currently active (visible) map.
       * 
       * @default default <code>MapType.GALAXY</code> instance
       */      
      public var activeMapType:int;
      
      
      /**
       * Current galaxy that user is acting in.
       * 
       * @default null
       */ 
      public var latestGalaxy:Galaxy;
      
      
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
      
      
      public var resourcesMods: ResourcesMods = new ResourcesMods();
      
      /**
       * A solar system object that is selected right now.
       * 
       * @default null
       */
      public var selectedSSObject:SSObject = null;
      
      
      public var selectedBuilding: Building = null;
      
      
      /**
       *list of building, player is alowed to construct 
       */      
      public var constructable: ArrayCollection;
      
      
      /**
       * Collection of notifications.
       * 
       * @default empty collection
       */
      public var notifications:NotificationsCollection;
      
      
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
      
      
      /**
       * Resets all properties to their default values. Needed when user ends
       * the game and logs out.
       */      
      public function reset():void
      {
         notificationAlerts.removeAll();
         squadrons.removeAll();
         units.removeAll();
         technologies.clean();
         player = new Player();
         latestGalaxy = null;
         latestSolarSystem = null;
         latestPlanet = null;
         selectedSSObject = null;
         selectedTechnology = null;
         notifications = new NotificationsCollection();
         battleController = null;
         server = "nebula44.com";
         serverIndex = 1;
         activeMapType = MapType.GALAXY;
      }
      
      
      public function ModelLocator ()
      {
         super();
         reset();
      }
   }
}