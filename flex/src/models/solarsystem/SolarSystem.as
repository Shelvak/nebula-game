package models.solarsystem
{
   import config.Config;
   
   import controllers.ui.NavigationController;
   
   import flash.display.BitmapData;
   
   import models.IMStaticSpaceObject;
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.location.LocationMinimalGalaxy;
   import models.location.LocationMinimalSolarSystem;
   import models.location.LocationType;
   import models.map.MMapSpace;
   import models.map.MapType;
   
   import utils.Localizer;
   import utils.NameResolver;
   import utils.assets.AssetNames;
   import utils.datastructures.Collections;
   
   
   [Bindable]
   public class SolarSystem extends MMapSpace implements IMStaticSpaceObject
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
      
      
      [Required]
      /**
       * Id of a galaxy this solar system belongs to.
       * 
       * @default 0 
       */
      public var galaxyId:int = 0;
      
      
      [Bindable(event="willNotChange")]
      /**
      * solar system name
      */
      public function get name(): String
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
      
      
      public function get objectType() : int
      {
         return MMapSpace.STATIC_OBJECT_NATURAL;
      }
      
      
      /**
       * Location of the solar system in a galaxy.
       */
      public override function get currentLocation() : LocationMinimal
      {
         var loc:LocationMinimal = new LocationMinimal();
         var locWrapper:LocationMinimalGalaxy = new LocationMinimalGalaxy(loc);
         locWrapper.type = LocationType.GALAXY;
         locWrapper.id = galaxyId;
         locWrapper.x = x;
         locWrapper.y = y;
         return loc;
      }
      
      
      public function get isNavigable() : Boolean
      {
         return true;
      }
      
      
      public function navigateTo() : void
      {
         NAV_CTRL.toSolarSystem(id);
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
      
      
      [Optional]
      /**
       * Indicates if this is actually a wormhole to a BattleGround solar system (one in whole galaxy).
       * 
       * @default false
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
      
      
      [Bindable(event="willNotChange")]
      public function get componentWidth() : int
      {
         return COMPONENT_WIDTH;
      }
      
      
      [Bindable(event="willNotChange")]
      public function get componentHeight() : int
      {
         return COMPONENT_HEIGHT;
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