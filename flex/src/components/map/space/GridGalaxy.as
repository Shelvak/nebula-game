package components.map.space
{
   import components.gameobjects.solarsystem.SolarSystemTile;
   
   import flash.geom.Point;
   
   import models.Galaxy;
   import models.ModelsCollection;
   import models.location.LocationMinimal;
   import models.location.LocationMinimalGalaxy;
   import models.location.LocationType;
   
   import mx.core.IVisualElement;
   
   
   public class GridGalaxy extends Grid
   {
      private var _locWrapper:LocationMinimalGalaxy = new LocationMinimalGalaxy();
      private var _map:CMapGalaxy;
      private var _galaxy:Galaxy;
      
      
      public function GridGalaxy(map:CMapGalaxy)
      {
         super(map);
         _map = map;
         _galaxy = map.getGalaxy();
      }
      
      
      /**
       * X and Y offsets of galaxy are compensated for the results returned.
       *  
       * @copy Grid#getSectorRealCoordinates()
       */
      public override function getSectorRealCoordinates(location:LocationMinimal) : Point
      {
         return new Point(
            (location.x + _galaxy.xOffset + 0.5) * SolarSystemTile.WIDTH,
            (location.y + _galaxy.yOffset + 0.5) * SolarSystemTile.HEIGHT
         );
      }
      
      
      /**
       * X and Y offsets of galaxy are compensated for the results returned.
       *  
       * @copy Grid#getSectorLocation()
       */
      public override function getSectorLocation(coordinates:Point) : LocationMinimal
      {
         _locWrapper.location = new LocationMinimal();
         _locWrapper.type = LocationType.GALAXY;
         _locWrapper.id = _galaxy.id;
         _locWrapper.x = Math.round(coordinates.x / SolarSystemTile.WIDTH - _galaxy.xOffset - 0.5);
         _locWrapper.y = Math.round(coordinates.y / SolarSystemTile.HEIGHT - _galaxy.yOffset - 0.5);
         return _locWrapper.location;
      }
      
      
      public override function getRealMapSize():Point
      {
         return new Point(SolarSystemTile.WIDTH * _galaxy.width, SolarSystemTile.HEIGHT * _galaxy.height);
      }
      
      
      protected override function getAllSectors() : ModelsCollection
      {
         var sectors:ModelsCollection = new ModelsCollection();
         for (var x:int = _galaxy.minX; x <= _galaxy.maxX; x++)
         {
            for (var y:int = _galaxy.minY; y <= _galaxy.maxY; y++)
            {
               _locWrapper.location = new LocationMinimal();
               _locWrapper.type = LocationType.GALAXY;
               _locWrapper.id = _galaxy.id;
               _locWrapper.x = x;
               _locWrapper.y = y;
               sectors.addItem(_locWrapper.location);
            }
         }
         return sectors;
      }
   }
}