package models.solarsystem
{
   import config.Config;
   
   import controllers.ui.NavigationController;
   
   import flash.display.BitmapData;
   import flash.errors.IllegalOperationError;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   import globalevents.GResourcesEvent;
   
   import models.BaseModel;
   import models.IMStaticSpaceObject;
   import models.Owner;
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.location.LocationMinimalSolarSystem;
   import models.location.LocationType;
   import models.map.MMapSpace;
   import models.player.Player;
   import models.player.PlayerMinimal;
   import models.resource.Resource;
   import models.resource.ResourceType;
   import models.solarsystem.events.SSObjectEvent;
   import models.tile.TerrainType;
   
   import utils.Localizer;
   import utils.MathUtil;
   import utils.NameResolver;
   import utils.assets.AssetNames;
   
   
   /**
    * Dispatched when player who owns this solar system object has changed.
    * 
    * @eventType models.solarsystem.events.SSObjectEvent.PLAYER_CHANGE
    */
   [Event(name="playerChange", type="models.solarsystem.events.SSObjectEvent")]
   
   
   public class MSSObject extends BaseModel implements IMStaticSpaceObject
   {
      /**
       * Original width of an object image.
       */
      public static const IMAGE_WIDTH: Number = 200;
      
      
      /**
       * Original height of an object image.
       */
      public static const IMAGE_HEIGHT: Number = IMAGE_WIDTH;
      
      
      /**
       * Timer used for incrementing resources stock values of a planet.
       */
      private static const RESOURCES_TIMER:Timer = new Timer(1000); RESOURCES_TIMER.start();
      
      
      private var NAV_CTRL:NavigationController = NavigationController.getInstance();
      
      
      public function MSSObject()
      {
         super();
         addOrRemoveResourcesTimerEventHandler();
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
      
      
      private var _name:String = "";
      [Optional]
      [Bindable(event="willNotChange")]
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
         return isJumpgate || isPlanet;
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
            addOrRemoveResourcesTimerEventHandler();
         }
      }
      /**
       * @private
       */
      public function get type() : String
      {
         return _type;
      }
      
      
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
         var key:String = "ui.ssObject." + type.toLowerCase();
         if (isPlanet)
         {
            key += "." + terrain;
         }
         key += ".variations";
         return id % Config.getValue(key);
      }
      
      
      [Bindable(event="willNotChange")]
      public function get imageData() : BitmapData
      {
         var key:String = "";
         if (isPlanet)
         {
            key += terrain + "/";
         }
         key += variation.toString();
         return IMG.getImage(AssetNames.getSSObjectImageName(type, key));
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
      
      
      public function toLocation(): Location
      {
         var tempLocation:Location = new Location();
         tempLocation.type = LocationType.SS_OBJECT;
         tempLocation.variation = variation;
         tempLocation.name = name;
         tempLocation.playerId = isOwned ? player.id : PlayerMinimal.NO_PLAYER_ID;
         tempLocation.solarSystemId = solarSystemId;
         tempLocation.x = position;
         tempLocation.y = angle;
         tempLocation.id = id;
         return tempLocation;
      }
      
      
      /* ############# */
      /* ### OWNER ### */
      /* ############# */
      
      
      [Optional(alias="status")]
      [Bindable]
      /**
       * Owner type of this planet. Possible values can be found in <code>Owner</code> class.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Optional]<br/>
       * [Bindable]</i></p>
       * 
       * @default <code>Owner.UNDEFINED</code>
       */
      public var owner:int = Owner.UNDEFINED;
      
      
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
            dispatchPropertyUpdateEvent("isOwned", isOwned);
            dispatchPropertyUpdateEvent("isOwnedByCurrent", isOwnedByCurrent);
            addOrRemoveResourcesTimerEventHandler();
         }
      }
      public function get player() : Player
      {
         return _player;
      }
      
      
      [Bindable(event="playerChange")]
      /**
       * Indicates if a planet is owned by someone.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="playerChange")]</i></p>
       * 
       * @default false 
       */
      public function get isOwned() : Boolean
      {
         return _player != null;
      }
      
      
      /**
       * True means that this object belongs to the current player.
       * 
       * <p><i><b>Metadata</b>:<br/>
       * [Bindable(event="playerChange")]</i></p>
       * 
       * 
       * @default false 
       */      
      [Bindable(event="playerChange")]
      public function get isOwnedByCurrent() : Boolean
      {
         return isOwned && ML.player.equals(_player);
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
      
      
      private function addOrRemoveResourcesTimerEventHandler() : void
      {
         if (isPlanet && isOwnedByCurrent)
         {
            RESOURCES_TIMER.addEventListener(TimerEvent.TIMER, recalculateResources, false, 0, true);
         }
         else
         {
            RESOURCES_TIMER.removeEventListener(TimerEvent.TIMER, recalculateResources);
         }
      }
      
      
      private function recalculateResources(event:TimerEvent) : void
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
   }
}