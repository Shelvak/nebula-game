package components.map.space
{
   import components.movement.CSquadronMapIcon;
   
   import flash.geom.Point;
   
   import models.ModelsCollection;
   import models.galaxy.Galaxy;
   import models.location.LocationMinimal;
   import models.location.LocationMinimalGalaxy;
   import models.location.LocationType;
   
   import utils.Objects;
   
   
   public class GridGalaxy extends Grid
   {
      internal static const SECTOR_WIDTH:Number = CSquadronMapIcon.WIDTH * 4 + SquadronsLayout.GAP * 3;
      internal static const SECTOR_HEIGHT:Number = CSquadronMapIcon.HEIGHT * 4 + SquadronsLayout.GAP * 3;
      
      
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
         Objects.paramNotNull("location", location);
         return new Point(
            (location.x + _galaxy.offset.x + 0.5) * SECTOR_WIDTH,
            (_galaxy.bounds.height - (location.y + _galaxy.offset.y) - 0.5) * SECTOR_HEIGHT
         );
      }
      
      
      /**
       * X and Y offsets of galaxy are compensated for the results returned. Returns <code>null</code>
       * for invisible (from player perspective) sectors.
       *  
       * @copy Grid#getSectorLocation()
       */
      public override function getSectorLocation(coordinates:Point) : LocationMinimal
      {
         _locWrapper.location = new LocationMinimal();
         _locWrapper.type = LocationType.GALAXY;
         _locWrapper.id = _galaxy.id;
         _locWrapper.x = Math.round(coordinates.x / SECTOR_WIDTH - _galaxy.offset.x - 0.5);
         _locWrapper.y = Math.round(_galaxy.bounds.height - 0.5 - coordinates.y / SECTOR_HEIGHT - _galaxy.offset.y);
         if (_galaxy.locationIsVisible(_locWrapper.location))
         {
            return _locWrapper.location;
         }
         return null;
      }
      
      
      public override function getRealMapSize():Point
      {
         return new Point(SECTOR_WIDTH * _galaxy.bounds.width, SECTOR_HEIGHT * _galaxy.bounds.height);
      }
      
      
      internal override function getAllSectors() : ModelsCollection
      {
         var sectors:Array = new Array();
         for (var x:int = _galaxy.bounds.left + 2; x < _galaxy.bounds.right - 2; x++)
         {
            for (var y:int = _galaxy.bounds.top + 2; y < _galaxy.bounds.bottom - 2; y++)
            {
               _locWrapper.location = new LocationMinimal();
               _locWrapper.type = LocationType.GALAXY;
               _locWrapper.id = _galaxy.id;
               _locWrapper.x = x;
               _locWrapper.y = y;
               sectors.push(_locWrapper.location);
            }
         }
         return new ModelsCollection(sectors);
      }
   }
}