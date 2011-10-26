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
      internal static const SECTOR_WIDTH:Number =
         CSquadronMapIcon.WIDTH * 4 + SquadronsLayout.GAP * 3;
      internal static const SECTOR_HEIGHT:Number =
         CSquadronMapIcon.HEIGHT * 4 + SquadronsLayout.GAP * 3;
      
      private var _locWrapper:LocationMinimalGalaxy = new LocationMinimalGalaxy();
      private var _map:CMapGalaxy;
      private var _galaxy:Galaxy;
      private var _coordsTransform:GalaxyMapCoordsTransform;
      
      public function GridGalaxy(map:CMapGalaxy) {
         super(map);
         _map = map;
         _galaxy = map.getGalaxy();
         _coordsTransform = new GalaxyMapCoordsTransform(_galaxy);
      }
      
      /**
       * X and Y offsets of galaxy are compensated for the results returned.
       *  
       * @copy Grid#getSectorRealCoordinates()
       */
      public override function getSectorRealCoordinates(location:LocationMinimal) : Point {
         Objects.paramNotNull("location", location);
         return new Point(
            _coordsTransform.logicalToReal_X(location.x, location.y),
            _coordsTransform.logicalToReal_Y(location.x, location.y)
         );
      }
      
      /**
       * X and Y offsets of galaxy are compensated for the results returned. Returns <code>null</code>
       * for invisible (from player perspective) sectors.
       *  
       * @copy Grid#getSectorLocation()
       */
      public override function getSectorLocation(coordinates:Point) : LocationMinimal {
         _locWrapper.location = new LocationMinimal();
         _locWrapper.type = LocationType.GALAXY;
         _locWrapper.id = _galaxy.id;
         _locWrapper.x = _coordsTransform.realToLogical_X(coordinates.x, coordinates.y);
         _locWrapper.y = _coordsTransform.realToLogical_Y(coordinates.x, coordinates.y);
         if (_galaxy.locationIsVisible(_locWrapper.location)) {
            return _locWrapper.location;
         }
         return null;
      }
      
      
      public override function getRealMapSize():Point {
         return new Point(SECTOR_WIDTH * _galaxy.bounds.width, SECTOR_HEIGHT * _galaxy.bounds.height);
      }
      
      public override function getStaticObjectInSector(location:LocationMinimal)
            : CStaticSpaceObjectsAggregator {
         return _map.getStaticObjectInSector(location.x, location.y);
      }
      
      
      internal override function getAllSectors() : ModelsCollection {
         return new ModelsCollection(_map.getLocationsInVisibleArea());
      }
   }
}