package models
{
   import com.developmentarc.core.utils.SingletonFactory;
   
   import controllers.battle.BattleController;
   import controllers.startup.StartupInfo;
   
   import models.building.Building;
   import models.map.MapType;
   import models.notification.NotificationsCollection;
   import models.planet.Planet;
   import models.quest.QuestsCollection;
   import models.resource.Resource;
   import models.resource.ResourceType;
   import models.resource.ResourcesMods;
   import models.solarsystem.SolarSystem;
   import models.technology.TechnologiesModel;
   import models.technology.Technology;
   
   import mx.collections.ArrayCollection;
   import models.galaxy.Galaxy;
   
   
   
   
   
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
      /**
       * @return instance of <code>ModelLocator</code> for application wide use.
       */
      public static function getInstance () :ModelLocator
      {
         return SingletonFactory.getSingletonInstance (ModelLocator);
      }
      
      
      /**
       * Holds startup and login information when application load completes.
       * 
       * @default null
       */
      public var startupInfo:StartupInfo = null;
      
      
      /**
       * resources models
       * 
       * @see models.Resource
       */
      public var metal: Resource;
      public var energy: Resource;
      public var zetium: Resource;
      
      public var infoModel: *;
      
      /**
       * Technologies container
       * 
       * items are models.Technology
       * 
       * @see models.TechnologiesModel
       */
      public var technologies: TechnologiesModel;
	   
      /**
      * selected technology, for info at sidebar and upgrading
      */
      public var selectedTechnology: Technology;
      
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
       * List of all planets that belong to the player.
       */
      public var playerPlanets:ModelsCollection;
      
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
      
      /**
       * A solar system that user is acting in at the time (or recently was). 
       */ 
      public var latestSolarSystem:SolarSystem;
      
      
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
               _latestPlanet = null;
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
       * A planet that is selected right now.
       * 
       * @default null
       */
      public var selectedPlanet:Planet = null;
      
      
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
       * List of all squadrons visible for the player.
       * 
       * @default empty collection
       */
      public var squadrons:ModelsCollection;
      
      
      /**
       * Resets all properties to their default values. Needed when user ends
       * the game and logs out.
       */      
      public function reset():void
      {
         metal = new Resource(ResourceType.METAL);
         energy = new Resource(ResourceType.ENERGY);
         zetium = new Resource(ResourceType.ZETIUM);
         
         
         technologies = new TechnologiesModel();
         squadrons = new ModelsCollection();
         player = new Player();
         playerPlanets = new ModelsCollection();
         latestGalaxy = null;
         latestSolarSystem = null;
         latestPlanet = null;
         selectedPlanet = null;
         selectedTechnology = null;
         notifications = new NotificationsCollection();
         battleController = null;
         server = "nebula44.com";
         serverIndex = 1;
         activeMapType = MapType.GALAXY;
      }
      
      
      /**
       * Constructor.
       */ 
      public function ModelLocator ()
      {
         reset ();
      }
   }
}