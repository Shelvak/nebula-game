package models.solarsystem
{
   import config.Config;

   import controllers.alliances.AlliancesCommand;
   import controllers.alliances.actions.InviteActionParams;
   import controllers.ui.NavigationController;

   import flash.display.BitmapData;
   import flash.errors.IllegalOperationError;

   import globalevents.GResourcesEvent;

   import interfaces.ICleanable;
   import interfaces.IUpdatable;

   import models.BaseModel;
   import models.Owner;
   import models.cooldown.MCooldown;
   import models.galaxy.events.GalaxyEvent;
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.location.LocationMinimalSolarSystem;
   import models.location.LocationType;
   import models.map.IMStaticSpaceObject;
   import models.map.MMapSpace;
   import models.planet.MPlanetBoss;
   import models.player.PlayerMinimal;
   import models.resource.Resource;
   import models.resource.ResourceType;
   import models.solarsystem.events.MSSObjectEvent;
   import models.tile.TerrainType;
   import models.time.MTimeEventFixedMoment;

   import namespaces.prop_name;

   import utils.DateUtil;
   import utils.NameResolver;
   import utils.StringUtil;
   import utils.assets.AssetNames;
   import utils.locale.Localizer;


   /**
    * Dispatched when player who owns this solar system object has changed.
    */
   [Event(name="playerChange", type="models.solarsystem.events.MSSObjectEvent")]
   
   /**
    * Dispatched when <code>owner</code> property changes.
    */
   [Event(name="ownerChange", type="models.solarsystem.events.MSSObjectEvent")]
   
   /**
    * Dispatched when <code>cooldown</code> property changes.
    */
   [Event(
      name="cooldownChange",
      type="models.solarsystem.events.MSSObjectEvent")]

   /**
    * Dispatched when <code>terrain</code> property changes.
    */
   [Event(
      name="terrainChange",
      type="models.solarsystem.events.MSSObjectEvent")]

   /**
    * Dispatched when <code>spawnCounter</code> property changes.
    */
   [Event(
      name="spawnCounterChange",
      type="models.solarsystem.events.MSSObjectEvent")]

   /**
    * Dispatched when <code>nextSpawn</code> property changes.
    */
   [Event(
      name="nextSpawnChange",
      type="models.solarsystem.events.MSSObjectEvent")]

   /* when MSsObject gets updated, metal, energy and zetium properties gets overwritten.
    * The problem is, same resource reference is written to player planets list ssObject model,
    * latestPlanet ssObject model and ssMap objects list ssObject model resource...
    * so, TODO: find out the way to keep same references for ssObjects in different lists */
   public class MSSObject extends BaseModel implements IMStaticSpaceObject,
                                                       ICleanable,
                                                       IUpdatable
   {
      /**
       * Returns variation id of a solar system object of given type, terrain and with given id.
       * 
       * @param id id of an object
       * @param type type of a solar system object
       * @param terrain terrain of a solar system object
       * 
       * @return variation of a solar system object with given properties
       */
      public static function getVariation(id:int, type:String, terrain:int) : int {
         var key:String = "ui.ssObject." + StringUtil.firstToLowerCase(type);
         if (type == SSObjectType.PLANET)
            key += "." + terrain;
         key += ".variations";
         return id % Config.getValue(key);
      }
      
      /**
       * Returns image of a solar system object of given type, terrain and with given id.
       * 
       * @param id id of an object
       * @param type type of a solar system object
       * @param terrain terrain of a solar system object
       * 
       * @return image of a solar system object with given properties
       */
      public static function getImageData(id:int, type:String, terrain:int) : BitmapData {
         var key:String = "";
         if (type == SSObjectType.PLANET)
            key += terrain + "/";
         key += getVariation(id, type, terrain).toString();
         return IMG.getImage(AssetNames.getSSObjectImageName(type, key));
      }
      
      /**
       * Original width of an object image.
       */
      public static const IMAGE_WIDTH: Number = 200;
      
      /**
       * Original height of an object image.
       */
      public static const IMAGE_HEIGHT: Number = IMAGE_WIDTH;      
      
      
      private function get NAV_CTRL() : NavigationController {
         return NavigationController.getInstance();
      }
      
      
      public function MSSObject() {
         super();
         registerOtherEventHandlers();
      }

      public function cleanup(): void {
         unregisterOtherEventHandlers();
      }
      
      
      [Required]
      /**
       * Id of the solar system this object belongs to.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Required]</i></p>
       * 
       * @default 0
       */
      public var solarSystemId:int = 0;
      
      /**
       * Indicates if this <code>MSSObject</code> in a battleground solar system.
       */
      public function get inBattleground() : Boolean {
         return ML.latestGalaxy.isBattleground(solarSystemId);
      }
      
      /**
       * Indicates if this <code>MSSObject</code> in a mini-battleground solar system.
       */
      public function get inMiniBattleground() : Boolean {
         return ML.latestGalaxy.isMiniBattleground(solarSystemId);
      }
      
      private var _name:String = "";
      [Optional]
      [Bindable]
      /**
       * Name of the object.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Optional]<br/>
       * [Bindable(event="willNotChange")]</i></p>
       * 
       * @default empty string
       */
      public function set name(value:String) : void {
         if (isPlanet) _name = value;
      }
      /**
       * @private
       */
      public function get name() : String {
         if (isPlanet)   return _name;
         if (isAsteroid) return NameResolver.resolveAsteroid(id);
         return NameResolver.resolveJumpgate(id);
      }

      private var _terrain: int = TerrainType.GRASS;
      [SkipProperty]
      [Optional]
      [Bindable(event="terrainChange")]
      /**
       * Terrain type of the object (only relevant if object is a planet).
       * This property is changed only at runtime by
       * <code>MPlanetMapEditor</code>.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [SkipProperty]<br/>
       * [Optional]</i></p>
       * 
       * @default <code>TerrainType.GRASS</code>
       */
      public function set terrain(value: int): void {
         if (_terrain != value) {
            _terrain = value;
            dispatchSimpleEvent(MSSObjectEvent, MSSObjectEvent.TERRAIN_CHANGE);
         }
      }
      public function get terrain(): int {
         return _terrain;
      }
      
      [SkipProperty]
      [Required]
      /**
       * Size of the planet image in the solar system map compared with original image
       * dimensions in percents.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [SkipProperty]<br/>
       * [Required]</i></p>
       * 
       * @default 100 percent
       */
      public var size:Number = 100;
      
      [SkipProperty]
      [Optional]
      /**
       * Width of the planet's map in tiles (only relevant if object is a planet).
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [SkipProperty]<br/>
       * [Optional]</i></p>
       * 
       * @default 0
       */
      public var width:int = 0;
      
      [SkipProperty]
      [Optional]
      /**
       * Height of the planet's map in tiles (only relevant if object is a planet).
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [SkipProperty]<br/>
       * [Optional]</i></p>
       * 
       * @default 0
       */
      public var height:int = 0;
      
      [Bindable(event="willNotChange")]
      public function get isNavigable() : Boolean {
         return isJumpgate || viewable;
      }
      
      public function navigateTo() : void {
         if (isJumpgate)
            NAV_CTRL.toGalaxy();
         else if (isPlanet)
            NAV_CTRL.toPlanet(this);
         else
            throw new IllegalOperationError("Only objects of SSObjectType.PLANET and SSObjectType.JUMPGATE " +
                                            "type support this method");
      }
      
      
      /* ############ */
      /* ### TYPE ### */
      /* ############ */
      
      public function get objectType() : int {
         return MMapSpace.STATIC_OBJECT_NATURAL;
      }
      
      private var _type:String = SSObjectType.PLANET;
      [SkipProperty]
      [Required]
      [Bindable(event="willNotChange")]
      /**
       * Type of this object.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [SkipProperty]<br/>
       * [Required]<br/>
       * [Bindable(event="willNotChange")]</i></p>
       * 
       * @default <code>SSObjectType.PLANET</code>
       */
      public function set type(value: String): void {
         if (_type != value) {
            _type = value;
         }
      }
      /**
       * @private
       */
      public function get type() : String {
         return _type;
      }

      private var _nextRaidEvent: MTimeEventFixedMoment;
      
      [Optional(alias="nextRaidAt")]
      [Bindable (event="raidStateChange")]
      public function set nextRaidEvent(value: MTimeEventFixedMoment): void {
         if (_nextRaidEvent != value) {
            _nextRaidEvent = value;
            dispatchRaidStateChangeEvent();
         }
      }

      public function get nextRaidEvent(): MTimeEventFixedMoment {
         return _nextRaidEvent;
      }

      [Optional]
      [Bindable]
      public var raidArg: int;

      [Bindable (event="raidStateChange")]
      public function get apocalypseWillBeStartedBeforeRaid(): Boolean
      {
         return ML.latestGalaxy.apocalypseActive && nextRaidEvent != null
                 && ML.latestGalaxy.apocalypseStartEvent.before(nextRaidEvent);
      }
      
      [Bindable(event="willNotChange")]
      /**
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="willNotChange")]</i></p>
       * 
       * @see SSObjectType#getLocalizedName()
       */
      public function get typeName() : String {
         return SSObjectType.getLocalizedName(type);
      }
      
      private var _viewable:Boolean = false;
      [Optional]
      [Bindable]
      /**
       * Indicates if a player can open the object and look what's inside it. Default is <code>false</code>.
       * This can only be equal to <code>true</code> if the object is a planet.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Optional]<br/>
       * [Bindable]</i></p>
       */
      public function set viewable(value:Boolean) : void {
         if (_viewable != value) {
            _viewable = value;
         }
      }
      /**
       * @private
       */
      public function get viewable() : Boolean {
         return _viewable;
      }
      
      [Bindable(event="willNotChange")]
      /**
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="willNotChange")]</i></p>
       */
      public function get isPlanet() : Boolean {
         return type == SSObjectType.PLANET;
      }
      
      [Bindable(event="willNotChange")]
      /**
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="willNotChange")]</i></p>
       */
      public function get isAsteroid() : Boolean {
         return type == SSObjectType.ASTEROID;
      }
      
      [Bindable(event="willNotChange")]
      /**
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="willNotChange")]</i></p>
       */
      public function get isJumpgate() : Boolean {
         return type == SSObjectType.JUMPGATE;
      }
      
      [Bindable(event="willNotChange")]
      /**
       * Variation of solar system object.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="willNotChange")]</i></p>
       */
      public function get variation() : int {
         return getVariation(id, type, terrain);
      }
      
      [Bindable(event="willNotChange")]
      public function get imageData() : BitmapData {
         return getImageData(id, type, terrain);
      }
      
      public function get componentWidth() : int {
         return IMAGE_WIDTH * size / 100;
      }
      
      public function get componentHeight() : int {
         return IMAGE_HEIGHT * size / 100;
      }


      /* ################## */
      /* ### BOSS SPAWN ### */
      /* ################## */

      private var _spawnCounter: int = 0;
      [Bindable(event="spawnCounterChange")]
      [Optional]
      /**
       * Level of the boss-fleet to be spawned but only if this is a pulsar or battleground planet.
       */
      public function set spawnCounter(value: int): void {
         if (_spawnCounter != value) {
            _spawnCounter = value;
            dispatchSimpleEvent(MSSObjectEvent, MSSObjectEvent.SPAWN_COUNTER_CHANGE);
         }
      }
      public function get spawnCounter(): int {
         return _spawnCounter;
      }

      private var _nextSpawn: MTimeEventFixedMoment = null;
      [Bindable(event="nextSpawnChange")]
      [Optional]
      /**
       * Time until next boss can be spawned.
       */
      public function set nextSpawn(nextSpawn: MTimeEventFixedMoment): void {
         if (_nextSpawn != nextSpawn) {
            _nextSpawn = nextSpawn;
            dispatchSimpleEvent(MSSObjectEvent, MSSObjectEvent.NEXT_SPAWN_CHANGE);
         }
      }
      public function get nextSpawn(): MTimeEventFixedMoment {
         return _nextSpawn;
      }

      private var _bossCreated: Boolean = false;
      private var _boss: MPlanetBoss = null;
      /**
       * A special object for handling spawning of boss. May be <code>null</code>.
       */
      public function get boss(): MPlanetBoss {
         if (!_bossCreated) {
            _bossCreated = true;
            if (isPlanet && (inBattleground || inMiniBattleground)) {
               _boss = new MPlanetBoss(this);
            }
         }
         return _boss;
      }
      
      
      /* ################ */
      /* ### LOCATION ### */
      /* ################ */
      
      [SkipProperty]
      [Required]
      [Bindable(event="willNotChange")]
      /**
       * Number of the orbit. An orbit is just an ellipse around a star of a solar system.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Required]<br/>
       * [SkipProperty]<br/>
       * [Bindable(event="willNotChange")]</i></p>
       * 
       * @default 0
       */
      public var position: int = 0;
      
      [SkipProperty]
      [Required]
      [Bindable(event="willNotChange")]
      /**
       * Measured in degrees.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [SkipProperty]<br/>
       * [Required]<br/>
       * [Bindable(event="willNotChange")]</i></p>
       * 
       * @default 0
       */
      public var angle: int = 0;

      private var _currentLocation: LocationMinimal;
      [Bindable(event="willNotChange")]
      public function get currentLocation() : LocationMinimal {
         if (!_currentLocation) {
            var loc:LocationMinimalSolarSystem = new LocationMinimalSolarSystem();
            loc.location = new LocationMinimal();
            loc.id = solarSystemId;
            loc.type = LocationType.SOLAR_SYSTEM;
            loc.angle = angle;
            loc.position = position;
            _currentLocation = loc.location;
         }
         return _currentLocation;
      }
      
      [Bindable(event="willNotChange")]
      /**
       * Name of a solar system sector this object is located in that includes <code>angle</code> and
       * <code>position</code>.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="willNotChange")]</i></p>
       */
      public function get sectorName() : String {
         return Localizer.string("SSObjects", "location.sector", [position, angle]);
      }
      
      private var _toLocationCache:Location;
      public function toLocation(): Location {
         if (_toLocationCache == null) {
            _toLocationCache = new Location();
            with (_toLocationCache) {
               id            = this.id;
               type          = LocationType.SS_OBJECT;
               variation     = this.variation;
               solarSystemId = this.solarSystemId;
               name          = this.name;
            }
         }
         if (isOwned)
            _toLocationCache.player = player;
         else if (isPlanet)
            _toLocationCache.player = PlayerMinimal.NPC_PLAYER;
         return _toLocationCache;
      }
      
      
      /* ############# */
      /* ### OWNER ### */
      /* ############# */
      
      prop_name static const owner:String = "owner";
      private var _owner:int = Owner.NPC;
      [Optional(alias="status")]
      [Bindable(event="ownerChange")]
      /**
       * Owner type of this planet. Possible values can be found in <code>Owner</code> class.
       * Default values is <code>Owner.UNDEFINED</code>.
       * 
       * <p>Metadata:<br/>
       * [Optional]<br/>
       * [Bindable(event="ownerChange")]
       * </p>
       */
      public function set owner(value: int): void {
         if (_owner != value) {
            _owner = value;
            dispatchSimpleEvent(MSSObjectEvent, MSSObjectEvent.OWNER_CHANGE);
            dispatchPropertyUpdateEvent(prop_name::owner, _owner);
            dispatchPropertyUpdateEvent(prop_name::isOwned, isOwned);
            dispatchPropertyUpdateEvent(prop_name::ownerIsPlayer, ownerIsPlayer);
         }
      }
      /**
       * @private
       */
      public function get owner() : int {
         return _owner;
      }
      
      
      private var _player:PlayerMinimal = null;
      [Optional]
      [Bindable(event="playerChange")]
      /**
       * Player that owns this object.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Optional]<br/>
       * [Bindable(event="playerChange")]</i></p>
       * 
       * @default null
       */
      public function set player(value:PlayerMinimal) : void {
         if (_player != value) {
            _player = value;
            dispatchSimpleEvent(MSSObjectEvent, MSSObjectEvent.PLAYER_CHANGE);
            dispatchPropertyUpdateEvent("player", player);
         }
      }
      /**
       * @private
       */
      public function get player() : PlayerMinimal {
         return _player;
      }
      
      
      prop_name static const isOwned:String = "isOwned";
      [Bindable(event="ownerChange")]
      /**
       * Indicates if a planet is owned by someone.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="ownerChange")]</i></p>
       * 
       * @default false 
       */
      public function get isOwned() : Boolean {
         return _owner != Owner.NPC;
      }
      
      
      prop_name static const ownerIsPlayer:String = "ownerIsPlayer";
      [Bindable(event="ownerChange")]
      /**
       * Indicates if a planet belongs to the player.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="ownerChange")]</i></p>
       */
      public function get ownerIsPlayer() : Boolean {
         return _owner == Owner.PLAYER;
      }
      
      
      [Bindable(event="playerChange")]
      /**
       * <p>Metadata:</br>
       * [Bindable(event="playerChange")]
       * </p>
       */
      public function get canInviteOwnerToAlliance() : Boolean {
         return isOwned &&
               !inBattleground &&
               !ownerIsAlly &&
               !ownerIsPlayer &&
                ML.player.canInviteToAlliance;
      }
      
      
      [Bindable(event="ownerChange")]
      public function get ownerIsAlly() : Boolean {
         return _owner == Owner.ALLY;
      }
      
      
      /**
       * Sends invitation to join players alliance if this is possible.
       */
      public function inviteOwnerToAlliance() : void {
         if (canInviteOwnerToAlliance)
            new AlliancesCommand(AlliancesCommand.INVITE, 
               new InviteActionParams(player.id)).dispatch();
      }
      
      
      /* ################# */
      /* ### RESOURCES ### */
      /* ################# */
      
      [Bindable]
      [Optional(alias="metal")]
      /**
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]<br/>
       * [Optional(alias="metal")]</i></p>
       */
      public var metalAfterLastUpdate:Number;
      
      [Bindable]
      [Optional(alias="energy")]
      /**
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]<br/>
       * [Optional(alias="energy")]</i></p>
       */
      public var energyAfterLastUpdate:Number;
      
      [Bindable]
      [Optional(alias="zetium")]
      /**
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]<br/>
       * [Optional(alias="zetium")]</i></p>
       */
      public var zetiumAfterLastUpdate:Number;
      
      [Optional]
      /**
       * Last time resources have been updated.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Optional]</i></p>
       */
      public function set lastResourcesUpdate(value: Date): void {
         _lastResourcesUpdate = value;
      }

      public function get lastResourcesUpdate (): Date
      {
         return _lastResourcesUpdate;
      }
      private var _lastResourcesUpdate:Date;

      [Bindable]
      public var metal:Resource;
      
      [Bindable]
      public var energy:Resource;
      
      [Bindable]
      public var zetium:Resource;

      private function registerOtherEventHandlers(): void {
         if (ML.latestGalaxy != null) {
            registerApocalypseEventListener();
         }
         else {
            ML.addEventListener(
               GalaxyEvent.GALAXY_READY,
               registerApocalypseEventListener, false, 0, true
            );
         }
      }

      private function registerApocalypseEventListener(e: GalaxyEvent = null): void {
         if (e != null) {
            ML.removeEventListener(
               GalaxyEvent.GALAXY_READY, registerApocalypseEventListener, false
            );
         }
         ML.latestGalaxy.addEventListener(
            GalaxyEvent.APOCALYPSE_START_EVENT_CHANGE,
            dispatchRaidStateChangeEvent, false, 0, true
         );
      }

      private function unregisterOtherEventHandlers(): void {
         if (ML.latestGalaxy != null) {
            ML.latestGalaxy.removeEventListener(
               GalaxyEvent.APOCALYPSE_START_EVENT_CHANGE,
               dispatchRaidStateChangeEvent, false
            );
         }
         else {
            ML.removeEventListener(
               GalaxyEvent.GALAXY_READY,
               registerApocalypseEventListener, false
            );
         }
      }

      private function recalculateResources() : void {
         if (!isPlanet || lastResourcesUpdate == null) {
            return;
         }
         const timeDiff: Number =
                  Math.floor((DateUtil.now - lastResourcesUpdate.time) / 1000);
         var resourceIncreased: Boolean = false;
         var resourceDecreased: Boolean = false;
         for each (var type: String in
            [ResourceType.ENERGY, ResourceType.METAL, ResourceType.ZETIUM]) {
            const resource: Resource = this[type];
            resource.boost.refreshBoosts();
            const oldStock: Number = resource.currentStock;
            resource.currentStock = Math.max(0, Math.min(
               resource.maxStock,
               this[type + "AfterLastUpdate"] + resource.rate * timeDiff
            ));
            if (oldStock > resource.currentStock) {
               resourceDecreased = true;
            }
            else if (oldStock < resource.currentStock) {
               resourceIncreased = true;
            }
         }
         /* CHECKING FOR SS OBJECT BY ID, NOT REFERENCE, READ MSsObject DOCUMENTATION FOR REASONS */
         if ((resourceDecreased || resourceIncreased) && ML.latestPlanet && ML.latestPlanet.ssObject
                && this.id == ML.latestPlanet.ssObject.id) {
            new GResourcesEvent(GResourcesEvent.RESOURCES_CHANGE,
                                resourceIncreased, resourceDecreased);
         }
      }
      
      [Bindable]
      public var raidTime: String = null;
      
      
      /* ######################## */
      /* ### SELF DESTRUCTION ### */
      /* ######################## */
      
      [Bindable]
      [Optional]
      /**
       * Time when player will be able to destroy his own building.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]<br/>
       * [Optional]</i></p>
       */      
      public var canDestroyBuildingAt: Date = null;
      
      public function get canDestroyBuilding(): Boolean {
         return (!canDestroyBuildingAt || (canDestroyBuildingAt.time < (new Date().time)));
      }

      /* ################### */
      /* ### EXPLORATION ### */
      /* ################### */

      prop_name static const explorationEndEvent: String = "explorationEndEvent";
      private var _explorationEndEvent: MTimeEventFixedMoment = null;
      [Bindable]
      [Optional(alias="explorationEndsAt")]
      /**
       * Time when exploration (if underway) will end.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]<br/>
       * [Optional]</i></p>
       */
      public function set explorationEndEvent(value: MTimeEventFixedMoment): void {
         if (_explorationEndEvent != value) {
            _explorationEndEvent = value;
            if (_explorationEndEvent == null) {
               explorationX = -1;
               explorationY = -1;
            }
         }
      }
      /**
       * @private
       */
      public function get explorationEndEvent() : MTimeEventFixedMoment {
         return _explorationEndEvent;
      }
      
      prop_name static const explorationX:String = "explorationX";
      [Bindable]
      [Optional]
      /**
       * X coordinate of the bottom-left corner of the foliage beeing explored.
       */
      public var explorationX:int = -1;
      
      prop_name static const explorationY:String = "explorationY";
      [Bindable]
      [Optional]
      /**
       * Y coordinate of the bottom-left corner of the foliage beeing explored.
       */
      public var explorationY:int = -1;
      
      
      /* ################ */
      /* ### COOLDOWN ### */
      /* ################ */
      
      private var _cooldown:MCooldown;
      [SkipProperty]
      [Bindable(event="cooldownChange")]
      /**
       * Cooldown after a battle in a planet. <code>null</code> means there is no cooldown.
       * Default is <code>null</code>.
       * 
       * <p>Metadata:<br/>
       * [Bindable(event="cooldownChange")]
       * </p>
       */
      public function set cooldown(value:MCooldown) : void {
         if (_cooldown != value) {
            _cooldown = value;
            dispatchSimpleEvent(MSSObjectEvent, MSSObjectEvent.COOLDOWN_CHANGE);
         }
      }
      /**
       * @private
       */
      public function get cooldown() : MCooldown {
         return _cooldown;
      }
      
      /* ############## */
      /* ### BOOSTS ### */
      /* ############## */
      
      [Bindable]
      [Optional]
      /**
       * Time when metal rate boost will end.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]<br/>
       * [Optional]</i></p>
       */
      public function set metalRateBoostEndsAt(value:Date) : void {
         if (metal == null)
            metal = new Resource();
         metal.boost.rateBoostEndsAt = value;
         metal.boost.refreshBoosts();
      }
      
      public function get metalRateBoostEndsAt() : Date {
         if (metal == null)
            metal = new Resource();
         return metal.boost.rateBoostEndsAt;
      }
      
      [Bindable]
      [Optional]
      /**
       * Time when energy rate boost will end.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]<br/>
       * [Optional]</i></p>
       */
      public function set energyRateBoostEndsAt(value:Date) : void {
         if (energy == null) {
            energy = new Resource();
         }
         energy.boost.rateBoostEndsAt = value;
         energy.boost.refreshBoosts();
      }
      
      public function get energyRateBoostEndsAt() : Date {
         if (energy == null)
            energy = new Resource();
         return energy.boost.rateBoostEndsAt;
      }
      
      [Bindable]
      [Optional]
      /**
       * Time when zetium rate boost will end.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]<br/>
       * [Optional]</i></p>
       */
      public function set zetiumRateBoostEndsAt(value:Date) : void {
         if (zetium == null)
            zetium = new Resource();
         zetium.boost.rateBoostEndsAt = value;
         zetium.boost.refreshBoosts();
      }
      
      public function get zetiumRateBoostEndsAt() : Date {
         if (zetium == null)
            zetium = new Resource();
         return zetium.boost.rateBoostEndsAt;
      }
      
      [Bindable]
      [Optional]
      /**
       * Time when metal storage boost will end.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]<br/>
       * [Optional]</i></p>
       */
      public function set metalStorageBoostEndsAt(value:Date) : void {
         if (metal == null)
            metal = new Resource();
         metal.boost.storageBoostEndsAt = value;
         metal.boost.refreshBoosts();
      }
      
      public function get metalStorageBoostEndsAt() : Date {
         if (metal == null)
            metal = new Resource();
         return metal.boost.storageBoostEndsAt;
      }
      
      [Bindable]
      [Optional]
      /**
       * Time when energy storage boost will end.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]<br/>
       * [Optional]</i></p>
       */
      public function set energyStorageBoostEndsAt(value:Date) : void {
         if (energy == null)
            energy = new Resource();
         energy.boost.storageBoostEndsAt = value;
         energy.boost.refreshBoosts();
      }
      
      public function get energyStorageBoostEndsAt() : Date {
         if (energy == null)
            energy = new Resource();
         return energy.boost.storageBoostEndsAt;
      }
      
      [Bindable]
      [Optional]
      /**
       * Time when zetium storage boost will end.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]<br/>
       * [Optional]</i></p>
       */
      public function set zetiumStorageBoostEndsAt(value:Date) : void {
         if (zetium == null)
            zetium = new Resource();
         zetium.boost.storageBoostEndsAt = value;
         zetium.boost.refreshBoosts();
      }
      
      public function get zetiumStorageBoostEndsAt() : Date {
         if (zetium == null)
            zetium = new Resource();
         return zetium.boost.storageBoostEndsAt;
      }
      
      /* ##################### */
      /* ### OWNER_CHANGED ### */
      /* ##################### */
      
      [Bindable]
      [Optional]
      /**
       * Time when this planet was undertaken by current owner.
       *  
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]<br/>
       * [Optional]</i></p>
       */
      public var ownerChanged: Date;

      private function dispatchRaidStateChangeEvent(e: GalaxyEvent = null): void {
         dispatchSimpleEvent(MSSObjectEvent, MSSObjectEvent.RAID_STATE_CHANGE);
      }


      /* ################## */
      /* ### IUpdatable ### */
      /* ################## */


      public function update(): void {
         recalculateResources();
         updateItem(nextRaidEvent);
         updateItem(explorationEndEvent);
         if (nextSpawn != null) {
            nextSpawn.update();
            if (nextSpawn.hasOccurred) {
               nextSpawn = null;
            }
         }
         if (cooldown != null) {
            cooldown.update();
            if (cooldown.endsEvent.hasOccurred) {
               cooldown = null;
            }
         }
         raidTime = nextRaidEvent != null ? nextRaidEvent.occursInString() : null;
         dispatchUpdateEvent();
      }

      public function resetChangeFlags(): void {
         resetChangeFlagsOf(nextRaidEvent);
         resetChangeFlagsOf(explorationEndEvent);
         resetChangeFlagsOf(cooldown);
         resetChangeFlagsOf(nextSpawn);
      }
   }
}
