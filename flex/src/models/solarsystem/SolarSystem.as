package models.solarsystem
{
   import config.Config;
   
   import flash.display.BitmapData;
   
   import models.ModelsCollection;
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.location.LocationMinimalGalaxy;
   import models.location.LocationMinimalSolarSystem;
   import models.location.LocationType;
   import models.map.Map;
   import models.map.MapType;
   import models.planet.Planet;
   
   import mx.collections.ArrayCollection;
   import mx.collections.ListCollectionView;
   
   import utils.NameResolver;
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   
   
   /**
    * A solar system. 
    */
   [Bindable]
   public class SolarSystem extends Map
   {
      /**
       * Width of solar system tile image in pixels. 
       */
      public static const IMAGE_WIDTH: Number = 64;
      
      /**
       * Width of solar system tile image in pixels. 
       */
      public static const IMAGE_HEIGHT: Number = IMAGE_WIDTH;
      
      
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
         return NameResolver.resolveSolarSystem(id);
      }
      
      
      /**
       * WTF???
       * 
       * @default 0 
       */	   
      public var groupId: int = 0;
      
      
      [Required]
      /**
       * Horizontal coordinate (in tiles) of a solar system in galaxy map.
       */	   
      public var x: Number = 0;
      
      
      [Required]
      /**
       * Vertical coordinate (in tiles) of a solar system in galaxy map.
       */
      public var y: Number = 0;
      
      
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
      
      
      /**
       * Type of this solar system.
       * 
       * @default SSType.HOMEWORLD
       */	   
      public var type:String = SSType.HOMEWORLD;
      
      
      [Bindable(event="willNotChange")]
      /**
       * Variation of an icon that visualizes a solar system in a galaxy.
       */
      public function get variation() : int
      {
         return id % Config.getSolarSystemVariations();
      }
      
      
      [Bindable(event="willNotChange")]
      /**
       * Image of this solar system.
       */
      public function get imageData() : BitmapData
      {
         return ImagePreloader.getInstance().getImage(AssetNames.getSSImageName(variation));
      }
      
      
      /**
       * Returns total number of orbits (this might be greater than number of planets).
       */
      public function get orbitsTotal() : int
      {
         var orbits:int = 0;
         for each (var object:SSObject in objects)
         {
            orbits = Math.max(orbits, object.position);
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
      
      
      /**
       * Adds a given object to this solar system.
       * 
       * @param object an object that needs to be added to this solar system.
       */
      public function addObject(object:SSObject):void
      {
         objects.addItem(object);
      }
      
      
      /**
       * Removes an object form this solar system.
       * 
       * @param object an object to be removed form the solar system.
       */
      public function removePlanet(object:SSObject) : void
      {
         var index:int = objects.getItemIndex(object);
         if (index != -1)
         {
            objects.removeItemAt (index);
         }
      }
      
      
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
      
      
      public override function definesLocation(location:LocationMinimal) : Boolean
      {
         var locWrapper:LocationMinimalSolarSystem = new LocationMinimalSolarSystem(location);
         return locWrapper.type == LocationType.SOLAR_SYSTEM && locWrapper.id == id &&
                locWrapper.position >= 0 && locWrapper.position <= orbitsTotal;
      }
   }
}