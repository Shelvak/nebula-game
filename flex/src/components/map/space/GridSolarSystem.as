package components.map.space
{
   import com.developmentarc.core.datastructures.utils.HashTable;
   
   import components.gameobjects.planet.SSObjectTile;
   import components.gameobjects.solarsystem.Star;
   
   import ext.flex.mx.collections.ArrayCollection;
   
   import flash.geom.Point;
   
   import models.ModelsCollection;
   import models.location.LocationMinimal;
   import models.location.LocationMinimalSolarSystem;
   import models.location.LocationType;
   import models.solarsystem.SolarSystem;
   
   import mx.core.IVisualElement;
   
   
   public class GridSolarSystem extends Grid
   {
      private var _locWrapper:LocationMinimalSolarSystem = new LocationMinimalSolarSystem();
      private var _map:CMapSolarSystem;
      private var _solarSystem:SolarSystem;
      private var _orbitsTotal:int;
      
      
      /**
       * Cached list of all sectors in the map. All items are of <code>Sector</code> type.
       */
      private var _sectorsCache:ArrayCollection = new ArrayCollection();
      private var f_sectorsCached:Boolean = false;
      
      
      public function GridSolarSystem(map:CMapSolarSystem)
      {
         super(map);
         _map = map;
         _solarSystem = map.getSolarSystem();
         _orbitsTotal = _solarSystem.orbitsTotal;
         
         // Cache all sectors
         for each (var location:LocationMinimal in getAllSectors())
         {
            _sectorsCache.addItem(new Sector(location, getSectorRealCoordinates(location)));
         }
         f_sectorsCached = true;
      }
      
      
      public override function getSectorRealCoordinates(location:LocationMinimal) : Point
      {
         var mapSize:Point = getRealMapSize();
         _locWrapper.location = location;
         
         // Orbit and planet radius
         var radius:Number = Star.WIDTH / 2 + CMapSolarSystem.ORBIT_SUN_GAP + _locWrapper.position * CMapSolarSystem.ORBIT_GAP;
         // Offset to make perspective look
         var offset:Number = Math.pow(_locWrapper.position, 1.05) * CMapSolarSystem.ORBIT_GAP * 0.15;
         
         var orbitWidth:Number = 2 * radius;
         var orbitHeight:Number = orbitWidth * CMapSolarSystem.HEIGHT_WIDHT_RATIO;
         var x:Number = Math.cos(_locWrapper.angleRadians) * orbitWidth / 2 + mapSize.x / 2;
         var y:Number = Math.sin(_locWrapper.angleRadians) * orbitHeight / 2 + mapSize.y / 2 + offset;
         return new Point(x, y);
      }
      
      
      private static const _SECTOR_SEARCH_RADIUS:Number = 200;
      public override function getSectorLocation(coordinates:Point) : LocationMinimal
      {
         // Define the area around our target point
         var left:Number = coordinates.x - _SECTOR_SEARCH_RADIUS;
         var right:Number = coordinates.x + _SECTOR_SEARCH_RADIUS;
         var top:Number = coordinates.y - _SECTOR_SEARCH_RADIUS;
         var bottom:Number = coordinates.y + _SECTOR_SEARCH_RADIUS;
         
         // Get all sectors in this area
         var sectors:ArrayCollection = _sectorsCache.filterItems(function(sector:Sector) : Boolean
         {
            var coords:Point = sector.coordinates;
            return coords.x > left && coords.x < right && coords.y > top && coords.y < bottom;
         });
         
         // Find the closest sector to the given point
         var closestSector:Sector = null;
         var closestSectorDistance:Number = Number.MAX_VALUE;
         for each (var sector:Sector in sectors)
         {
            var distance:Number = coordinates.subtract(sector.coordinates).length;
            if (distance < closestSectorDistance)
            {
               closestSector = sector;
               closestSectorDistance = distance;
            }
         }
         
         return closestSector ? closestSector.location : null;
      }
      
      
      public override function getRealMapSize() : Point
      {
         var width:Number = Star.WIDTH + (CMapSolarSystem.ORBIT_SUN_GAP + CMapSolarSystem.ORBIT_GAP * _orbitsTotal) * 2;
         var height:Number = width * CMapSolarSystem.HEIGHT_WIDHT_RATIO + _orbitsTotal * 200;
         return new Point(width, height);
      }
      
      
      internal override function getAllSectors() : ModelsCollection
      {
         var sectors:Array = new Array();
         // If we have all sectors cached (chaching is carried out by constructor), just add
         // locations to the collection
         if (f_sectorsCached)
         {
            for each (var sector:Sector in _sectorsCache)
            {
               sectors.push(sector.location);
            }
         }
         // Otherwise create all locations
         else
         {
            for (var position:int = 0; position < _orbitsTotal; position++)
            {
               var quarterPoints:int = position + 1;
               var quarterPointStep:int = 90 / quarterPoints;
               for (var quarter:int = 0; quarter < 4; quarter++)
               {
                  for (var quarterPoint:int = 0; quarterPoint < quarterPoints; quarterPoint++)
                  {
                     _locWrapper.location = new LocationMinimal();
                     _locWrapper.type = LocationType.SOLAR_SYSTEM;
                     _locWrapper.id = _solarSystem.id;
                     _locWrapper.position = position;
                     _locWrapper.angle = quarter * 90 + quarterPoint * quarterPointStep;
                     sectors.push(_locWrapper.location);
                  }
               }
            }
         }
         return new ModelsCollection(sectors);
      }
   }
}


import flash.geom.Point;
import models.location.LocationMinimal;
class Sector
{
   public function Sector(location:LocationMinimal = null, coordinates:Point = null)
   {
      this.location = location;
      this.coordinates = coordinates;
   }
   public var location:LocationMinimal;
   public var coordinates:Point;
}