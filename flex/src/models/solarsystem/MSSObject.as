package models.solarsystem
{
   import config.Config;
   
   import controllers.ui.NavigationController;
   
   import flash.display.BitmapData;
   import flash.errors.IllegalOperationError;
   
   import globalevents.GResourcesEvent;
   import globalevents.GlobalEvent;
   
   import interfaces.ICleanable;
   
   import models.BaseModel;
   import models.IMStaticSpaceObject;
   import models.Owner;
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.location.LocationMinimalSolarSystem;
   import models.location.LocationType;
   import models.map.MMapSpace;
   import models.player.Player;
   import models.player.PlayerId;
   import models.resource.Resource;
   import models.resource.ResourceType;
   import models.solarsystem.events.SSObjectEvent;
   import models.tile.TerrainType;
   
   import utils.Localizer;
   import utils.MathUtil;
   import utils.NameResolver;
   import utils.StringUtil;
   import utils.assets.AssetNames;
   
   
   /**
    * Dispatched when player who owns this solar system object has changed.
    * 
    * @eventType models.solarsystem.events.SSObjectEvent.PLAYER_CHANGE
    */
   [Event(name="playerChange", type="models.solarsystem.events.SSObjectEvent")]
   
   
   /**
    * Dispatched when <code>owner</code> property changes.
    * 
    * @eventType models.solarsystem.events.SSObjectEvent.OWNER_CHANGE
    */
   [Event(name="ownerChange", type="models.solarsystem.events.SSObjectEvent")]
   
   
   public class MSSObject extends BaseModel implements IMStaticSpaceObject, ICleanable
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
      public static function getVariation(id:int, type:String, terrain:int) : int
      {
         var key:String = "ui.ssObject." + StringUtil.firstToLowerCase(type);
         if (type == SSObjectType.PLANET)
         {
            key += "." + terrain;
         }
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
      public static function getImageData(id:int, type:String, terrain:int) : BitmapData
      {
         var key:String = "";
         if (type == SSObjectType.PLANET)
         {
            key += terrain + "/";
         }
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
      
      
      private var NAV_CTRL:NavigationController = NavigationController.getInstance();
      
      
      public function MSSObject()
      {
         super();
         registerOrUnregisterTimedUpdateHandler();
      }
      
      
      public function cleanup() : void
      {
         unregisterTimedUpdateHandler();
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
       * Idicates if this <code>MSSObject</code> in a battleground solar system.
       */
      public function get inBattleground() : Boolean
      {
         return ML.latestGalaxy.battlegroundId == solarSystemId;
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
      public function set name(value:String) : void
      {
         if (isPlanet)
         {
            _name = value;
         }
      }
      /**
       * @private
       */
      public function get name() : String
      {
         if (isPlanet)
         {
            return _name;
         }
         if (isAsteroid)
         {
            return NameResolver.resolveAsteroid(id);
         }
         return NameResolver.resolveJumpgate(id);
      }
      
      
      [SkipProperty]
      [Optional]
      [Bindable(event="willNotChange")]
      /**
       * Terrain type of the object (only relevant if object is a planet).
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [SkipProperty]<br/>
       * [Optional]<br/>
       * [Bindable(event="willNotChange")]</i></p>
       * 
       * @default <code>TerrainType.GRASS</code>
       */
      public var terrain:int = TerrainType.GRASS;
      
      
      [SkipProperty]
      [Required]
      /**
       * Size of the planet image in the solar system map compared with original image
       * dimentions in percents.
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
      public function get isNavigable() : Boolean
      {
         return isJumpgate || viewable;
      }
      
      
      public function navigateTo() : void
      {
         if (isJumpgate)
         {
            NAV_CTRL.toGalaxy();
         }
         else if (isPlanet)
         {
            NAV_CTRL.toPlanet(this);
         }
         else
         {
            throw new IllegalOperationError("Only objects of SSObjectType.PLANET and SSObjectType.JUMPGATE " +
                                            "type support this method");
         }
      }
      
      
      /* ############ */
      /* ### TYPE ### */
      /* ############ */
      
      
      public function get objectType() : int
      {
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
      public function set type(value:String) : void
      {
         if (_type != value)
         {
            _type = value;
            registerOrUnregisterTimedUpdateHandler();
         }
      }
      /**
       * @private
       */
      public function get type() : String
      {
         return _type;
      }
      
      [Optional]
      [Bindable]
      public var nextRaidAt: Date;
      
      [Bindable(event="willNotChange")]
      /**
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="willNotChange")]</i></p>
       * 
       * @see SSObjectType#getLocalizedName()
       */
      public function get typeName() : String
      {
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
      public function set viewable(value:Boolean) : void
      {
         if (_viewable != value)
         {
            _viewable = value;
         }
      }
      /**
       * @private
       */
      public function get viewable() : Boolean
      {
         return _viewable;
      }
      
      
      [Bindable(event="willNotChange")]
      /**
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="willNotChange")]</i></p>
       */
      public function get isPlanet() : Boolean
      {
         return type == SSObjectType.PLANET;
      }
      
      
      [Bindable(event="willNotChange")]
      /**
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="willNotChange")]</i></p>
       */
      public function get isAsteroid() : Boolean
      {
         return type == SSObjectType.ASTEROID;
      }
      
      
      [Bindable(event="willNotChange")]
      /**
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="willNotChange")]</i></p>
       */
      public function get isJumpgate() : Boolean
      {
         return type == SSObjectType.JUMPGATE;
      }
      
      
      [Bindable(event="willNotChange")]
      /**
       * Variation of solar system object.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="willNotChange")]</i></p>
       */
      public function get variation() : int
      {
         return getVariation(id, type, terrain);
      }
      
      
      [Bindable(event="willNotChange")]
      public function get imageData() : BitmapData
      {
         return getImageData(id, type, terrain);
      }
      
      
      public function get componentWidth() : int
      {
         return IMAGE_WIDTH * size / 100;
      }
      
      
      public function get componentHeight() : int
      {
         return IMAGE_HEIGHT * size / 100;
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
      public var position:int = 0;
      
      
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
      public var angle:Number = 0;
      
      
      private var _currentLocation:LocationMinimal
      [Bindable(event="willNotChange")]
      public function get currentLocation() : LocationMinimal
      {
         if (!_currentLocation)
         {
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
      
      
      /**
       * Same as <code>angle</code> just measured in radians. 
       */	   
      public function get angleRadians() : Number
      {
         return MathUtil.degreesToRadians(angle);
      }
      
      
      [Bindable(event="willNotChange")]
      /**
       * Name of a solar system sector this object is located in that includes <code>angle</code> and
       * <code>position</code>.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="willNotChange")]</i></p>
       */
      public function get sectorName() : String
      {
         return Localizer.string("SSObjects", "location.sector", [position, angle]);
      }
      
      
      private var _toLocationCache:Location;
      public function toLocation(): Location
      {
         if (_toLocationCache == null)
         {
            _toLocationCache = new Location();
            with (_toLocationCache)
            {
               id            = this.id;
               type          = LocationType.SS_OBJECT;
               x             = position;
               y             = angle;
               variation     = this.variation;
               name          = this.name;
               playerId      = isOwned ? player.id : PlayerId.NO_PLAYER;
               solarSystemId = this.solarSystemId;
            }
         }
         return _toLocationCache;
      }
      
      
      /* ############# */
      /* ### OWNER ### */
      /* ############# */
      
      
      private var _owner:int = Owner.UNDEFINED;
      [Optional(alias="status")]
      [Bindable(event="ownerChange")]
      /**
       * Owner type of this planet. Possible values can be found in <code>Owner</code> class.
       * Default values is <code>Owner.UNDEFINED</code>.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Optional]<br/>
       * [Bindable(event="ownerChange")]</i></p>
       */
      public function set owner(value:int) : void
      {
         if (_owner != value)
         {
            _owner = value;
            dispatchOwnerChangeEvent();
            dispatchPropertyUpdateEvent("owner", _owner);
            dispatchPropertyUpdateEvent("isOwned", isOwned);
            dispatchPropertyUpdateEvent("belongsToPlayer", belongsToPlayer);
            registerOrUnregisterTimedUpdateHandler();
         }
      }
      /**
       * @private
       */
      public function get owner() : int
      {
         return _owner;
      }
      
      
      private var _player:Player = null;
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
      public function set player(value:Player) : void
      {
         if (_player != value)
         {
            _player = value;
            dispatchPlayerChangeEvent();
            dispatchPropertyUpdateEvent("player", player);
         }
      }
      /**
       * @private
       */
      public function get player() : Player
      {
         return _player;
      }
      
      
      [Bindable(event="ownerChange")]
      /**
       * Indicates if a planet is owned by someone.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="ownerChange")]</i></p>
       * 
       * @default false 
       */
      public function get isOwned() : Boolean
      {
         return _owner != Owner.UNDEFINED;
      }
      
      
      [Bindable(event="ownerChange")]
      /**
       * Indicates if a planet belongs to the player.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="ownerChange")]</i></p>
       */
      public function get belongsToPlayer() : Boolean
      {
         return _owner == Owner.PLAYER;
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
      public var lastResourcesUpdate:Date;
      
      
      [Bindable]
      public var metal:Resource;
      
      
      [Bindable]
      public var energy:Resource;
      
      
      [Bindable]
      public var zetium:Resource;
      
      
      private var timedUpdateHandlerRegistered:Boolean = false;
      private function registerOrUnregisterTimedUpdateHandler() : void
      {
         if (isPlanet && belongsToPlayer)
         {
            registerTimedUpdateHandler();
         }
         else
         {
            unregisterTimedUpdateHandler();
         }
      }
      private function registerTimedUpdateHandler() : void
      {
         if (!timedUpdateHandlerRegistered)
         {
            timedUpdateHandlerRegistered = true;
            GlobalEvent.subscribe_TIMED_UPDATE(recalculateResources);
         }
      }
      private function unregisterTimedUpdateHandler() : void
      {
         if (timedUpdateHandlerRegistered)
         {
            timedUpdateHandlerRegistered = false;
            GlobalEvent.unsubscribe_TIMED_UPDATE(recalculateResources);
         }
      }
      
      
      private function recalculateResources(event:GlobalEvent) : void
      {
         var timeDiff:Number = Math.floor((new Date().time - lastResourcesUpdate.time) / 1000);
         for each (var type:String in [ResourceType.ENERGY, ResourceType.METAL, ResourceType.ZETIUM])
         {
            var resource:Resource = this[type];
            resource.currentStock = Math.max(0, Math.min(
               resource.maxStock,
               this[type + "AfterLastUpdate"] + resource.rate * timeDiff
            ));
         }
         if (ML.latestPlanet && this == ML.latestPlanet.ssObject)
         {
            new GResourcesEvent(GResourcesEvent.RESOURCES_CHANGE);
         }
      }
      
      /* ######################## */
      /* ### SELF_DESTRUCTION ### */
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
      
      public function get canDestroyBuilding(): Boolean
      {
         return (!canDestroyBuildingAt || (canDestroyBuildingAt.time < (new Date().time)));
      }
      
      public function get timeLeftToDestroyBuilding(): int
      {
         return 0;
      }
      
      /* ################### */
      /* ### EXPLORATION ### */
      /* ################### */
      
      
      [Bindable]
      [Optional]
      /**
       * Time when exploration (if underway) will end.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable]<br/>
       * [Optional]</i></p>
       */
      public var explorationEndsAt:Date = null;
      
      /* ################################## */
      /* ### EVENTS DISPATCHING METHODS ### */
      /* ################################## */
      
      
      private function dispatchPlayerChangeEvent() : void
      {
         if (hasEventListener(SSObjectEvent.PLAYER_CHANGE))
         {
            dispatchEvent(new SSObjectEvent(SSObjectEvent.PLAYER_CHANGE));
         }
      }
      
      
      private function dispatchOwnerChangeEvent() : void
      {
         if (hasEventListener(SSObjectEvent.OWNER_CHANGE))
         {
            dispatchEvent(new SSObjectEvent(SSObjectEvent.OWNER_CHANGE));
         }
      }
   }
}