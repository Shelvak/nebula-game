package models.solarsystem
{
   import config.Config;
   
   import controllers.ui.NavigationController;
   
   import flash.display.BitmapData;
   
   import models.IMSelfUpdating;
   import models.IMStaticSpaceObject;
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.location.LocationMinimalGalaxy;
   import models.location.LocationMinimalSolarSystem;
   import models.location.LocationType;
   import models.map.MMapSpace;
   import models.map.MapType;
   import models.solarsystem.events.SolarSystemEvent;
   
   import namespaces.change_flag;
   
   import utils.DateUtil;
   import utils.Localizer;
   import utils.NameResolver;
   import utils.assets.AssetNames;
   import utils.datastructures.Collections;
   
   
   /**
    * Dispatched when <code>shieldOwnerId</code> property changes.
    * 
    * @eventType models.solarSystem.events.SolarSystemEvent.SHIELD_OWNER_CHANGE
    */
   [Event(name="shieldOwnerChange", type="models.solarSystem.events.SolarSystemEvent")]
   
   
   /**
    * Dispatched when <code>shieldEndsAt</code> property changes.
    * 
    * @eventType models.solarSystem.events.SolarSystemEvent.SHIELD_ENDS_AT_CHANGE
    */
   [Event(name="shieldEndsAtChange", type="models.solarSystem.events.SolarSystemEvent")]
   
   
   /**
    * Dispatched when <code>shieldEndsIn</code> property changes.
    * 
    * @eventType models.solarSystem.events.SolarSystemEvent.SHIELD_ENDS_IN_CHANGE
    */
   [Event(name="shieldEndsInChange", type="models.solarSystem.events.SolarSystemEvent")]
   
   
   [Bindable]
   public class SolarSystem extends MMapSpace implements IMStaticSpaceObject, IMSelfUpdating
   {
      public static const IMAGE_WIDTH: Number = 64;
      public static const IMAGE_HEIGHT: Number = IMAGE_WIDTH;
      public static const COMPONENT_WIDTH:int = 96;
      public static const COMPONENT_HEIGHT:int = COMPONENT_WIDTH;
      
      
      private var NAV_CTRL:NavigationController = NavigationController.getInstance();
      
      
      public override function get cached() : Boolean
      {
         if (ML.latestSolarSystem == null)
         {
            return false;
         }
         if (ML.latestSolarSystem != null && !ML.latestSolarSystem.fake)
         {
            if (id == ML.latestSolarSystem.id)
            {
               return true;
            }
            // check if both solar systems are wormholes
            if (ML.latestGalaxy.hasWormholes && (wormhole || isBattleground) &&
                ML.latestSolarSystem.isBattleground)
            {
               return true;
            }
         }
         return false;
      }      
      
      
      [Bindable(event="willNotChange")]
      /**
       * Name of this solar system.
       * 
       * <p>Metadata:<br/>
       * [Bindable(event="willNotChange")]
       * </p>
       */
      public function get name() : String
      {
         if (!wormhole && !isBattleground)
         {
            return NameResolver.resolveSolarSystem(id);
         }
         else
         {
            return Localizer.string("Galaxy", "label.wormhole");
         }
      }
      
      
      [Required]
      /**
       * Horizontal coordinate (in tiles) of a solar system in galaxy map.
       */	   
      public var x:Number = 0;
      
      
      [Required]
      /**
       * Vertical coordinate (in tiles) of a solar system in galaxy map.
       */
      public var y:Number = 0;
      
      
      public function get galaxyId(): int
      {
         return ML.player.galaxyId;
      }
      
      
      /* ###################### */
      /* ### IMSelfUpdating ### */
      /* ###################### */
      
      
      public function update() : void
      {
         if (isShielded)
         {
            change_flag::shieldEndsIn = true;
            dispatchSimpleEvent(SolarSystemEvent, SolarSystemEvent.SHIELD_ENDS_IN_CHANGE);
         }
      }
      
      
      public function resetChangeFlags() : void
      {
         change_flag::shieldEndsIn  = false;
         change_flag::shieldEndsAt  = false;
         change_flag::shieldOwnerId = false;
      }
      
      
      /* ######################## */
      /* ### IStaticMAPObject ### */
      /* ######################## */
      
      
      /**
       * Location of the solar system in a galaxy.
       */
      public override function get currentLocation() : LocationMinimal
      {
         var loc:LocationMinimal = new LocationMinimal();
         loc.type = LocationType.GALAXY;
         loc.id = galaxyId;
         loc.x = x;
         loc.y = y;
         return loc;
      }
      
      
      [Bindable(event="shieldOwnerChange")]
      /**
       * <p>Metadata:<br/>
       * [Bindable(event="shieldOwnerChange")]
       * </p>
       * 
       * @inheritDoc
       */
      public function get isNavigable() : Boolean
      {
         return !isShielded || _shieldOwnerId == ML.player.id;
      }
      
      
      public function navigateTo() : void
      {
         NAV_CTRL.toSolarSystem(id);
      }
      
      
      public function get objectType() : int
      {
         return MMapSpace.STATIC_OBJECT_NATURAL;
      }
      
      
      [Bindable(event="willNotChange")]
      /**
       * <p>Metadata:<br/>
       * [Bindable(event="willNotChange")]
       * </p>
       *  
       * @inheritDoc
       */
      public function get componentWidth() : int
      {
         return COMPONENT_WIDTH;
      }
      
      
      [Bindable(event="willNotChange")]
      /**
       * <p>Metadata:<br/>
       * [Bindable(event="willNotChange")]
       * </p>
       *  
       * @inheritDoc
       */
      public function get componentHeight() : int
      {
         return COMPONENT_HEIGHT;
      }
      
      
      /* ############## */
      /* ### SHIELD ### */
      /* ############## */
      
      
      [Bindable(event="shieldOwnerChange")]
      /**
       * Returns <code>true</code> if this solar system is shielded.
       * 
       * <p>Metadata:<br/>
       * [Bindable(event="shieldOwnerChange")]
       * </p>
       */
      public function get isShielded() : Boolean
      {
         return _shieldOwnerId > 0;
      }
      
      
      change_flag var shieldOwnerId:Boolean = true;
      private var _shieldOwnerId:int = 0;
      [Bindable(event="shieldOwnerChange")]
      [Optional]
      /**
       * Id of a shield owner. <code>0</code> if this solar system is not shielded.
       * Default is <code>0</code>.
       * 
       * <p>Metadata:<br/>
       * [Bindable(event="shieldOwnerChange")]
       * [Optional]
       * </p>
       */
      public function set shieldOwnerId(value:int) : void
      {
         if (_shieldOwnerId != value)
         {
            _shieldOwnerId = value;
            dispatchSimpleEvent(SolarSystemEvent, SolarSystemEvent.SHIELD_OWNER_CHANGE);
         }
      }
      /**
       * @private
       */
      public function get shieldOwnerId() : int
      {
         return _shieldOwnerId;
      }
      
      
      change_flag var shieldEndsAt:Boolean = true;
      private var _shieldEndsAt:Date = null;
      [Bindable(event="shieldEndsAtChange")]
      [Optional]
      /**
       * Time when the shield expires if the shield is preset at all. If solar system is not shielded, this
       * property is <code>null</code>. Default is <code>null</code>.
       */
      public function set shieldEndsAt(value:Date) : void
      {
         if (_shieldEndsAt != value)
         {
            _shieldEndsAt = value;
            dispatchSimpleEvent(SolarSystemEvent, SolarSystemEvent.SHIELD_ENDS_AT_CHANGE);
         }
      }
      /**
       * @private
       */
      public function get shieldEndsAt() : Date
      {
         return _shieldEndsAt;
      }
      
      
      change_flag var shieldEndsIn:Boolean = true;
      [Bindable(event="shieldEndsInChange")]
      /**
       * Number of seconds this solar system will be shielded for. <code>0</code> if solar system is
       * not shielded.
       * 
       * <p>Metadata:<br/>
       * [Bindable(event="shieldEndsInChange")]
       * </p>
       */
      public function get shieldEndsIn() : int
      {
         if (!isShielded || _shieldEndsAt == null)
         {
            return 0
         }
         return Math.max(0, (shieldEndsAt.time - DateUtil.currentTime) / 1000); 
      }
      
      
      /* ################ */
      /* ### WORMHOLE ### */
      /* ################ */
      
      
      [Optional]
      /**
       * Indicates if this is actually a wormhole to a BattleGround solar system (one in whole galaxy).
       * Default is <code>false</code>.
       */
      public var wormhole:Boolean = false;
      
      
      /**
       * Indicates if this solar systems is a battleground system. Wormholes are not battlegrounds: just
       * gates to battleground. 
       */
      public function get isBattleground() : Boolean
      {
         return id == ML.latestGalaxy.battlegroundId;
      }
      
      
      [Bindable(event="willNotChange")]
      /**
       * Variation of an icon that visualizes a solar system in a galaxy.
       */
      public function get variation() : int
      {
         return id % Config.getSolarSystemVariations();
      }
      
      
      [Bindable(event="willNotChange")]
      public function get imageData() : BitmapData
      {
         if (!wormhole)
         {
            return IMG.getImage(AssetNames.getSSImageName(variation));
         }
         else
         {
            return IMG.getImage(AssetNames.WORMHOLE_IMAGE_NAME);
         }
      }
      
      
      /**
       * Returns total number of orbits (this might be greater than number of planets).
       */
      public function get orbitsTotal() : int
      {
         var orbits:int = 0;
         for each (var ssObject:MSSObject in naturalObjects)
         {
            orbits = Math.max(orbits, ssObject.position);
         }
         return orbits + 1;
      }
      
      
      public function getSSObjectById(id:int) : MSSObject
      {
         return Collections.findFirst(naturalObjects,
            function(ssObject:MSSObject) : Boolean
            {
               return ssObject.id == id;
            }
         );
      }
      
      
      /**
       * Metadata of the solar system.
       * 
       * @default default instance of <code>SSMetadata</code>.
       * 
       * @see models.solarsystem.SSMetadata
       */
      public var metadata:SSMetadata = new SSMetadata();
      
      
      [Bindable(event="willNotChange")]
      /**
       * Returns <code>MapType.GALAXY</code>.
       * 
       * @see models.map.Map#mapType
       */
      override public function get mapType() : int
      {
         return MapType.SOLAR_SYSTEM;
      };
      
      
      protected override function get definedLocationType() : int
      {
         return LocationType.SOLAR_SYSTEM;
      }
      
      
      protected override function setCustomLocationFields(location : Location) : void
      {
         location.variation = variation;
      }
      
      
      protected override function definesLocationImpl(location:LocationMinimal) : Boolean
      {
         var locWrapper:LocationMinimalSolarSystem = new LocationMinimalSolarSystem(location);
         return locWrapper.type == LocationType.SOLAR_SYSTEM && locWrapper.id == id &&
                locWrapper.position >= 0 && locWrapper.position <= orbitsTotal;
      }
   }
}