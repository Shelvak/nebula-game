package models.galaxy
{
   import flash.geom.Point;

   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.map.MapArea;
   import models.unit.Unit;

   import mx.collections.IList;


   public class FOWMatrix
   {
      private static const INVISIBLE_BORDER_SIZE: int = 2;

      private var _fowEntries: Vector.<MapArea>;
      private var _fowBorderList: Vector.<FOWBorderElement>;
      private var _solarSystemLocations: Array;
      private var _units: IList;
      private var _matrix: Vector.<Vector.<Boolean>>;
      private var _xMin: int;
      private var _xMax: int;
      private var _yMax: int;
      private var _yMin: int;
      private var _galaxyId: int;

      public function FOWMatrix(
         galaxyId: int, fowEntries: Vector.<MapArea>, solarSystemLocations: Array, units: IList)
      {
         _galaxyId = galaxyId;
         _fowEntries = fowEntries;
         _solarSystemLocations = solarSystemLocations;
         _units = units;
         rebuild();
      }

      public function rebuild() : void {
         findBounds();
         initializeMatrix();
         setVisibleTiles();
         buildFowBorderList();
      }

      /**
       * O(_fowEntries.length + _solarSystemLocations.length)
       */
      private function findBounds() : void {
         _xMin = _yMin = int.MAX_VALUE;
         _xMax = _yMax = int.MIN_VALUE;
         for each (var entry: MapArea in _fowEntries) {
            if (entry.xMin < _xMin) _xMin = entry.xMin;
            if (entry.xMax > _xMax) _xMax = entry.xMax;
            if (entry.yMin < _yMin) _yMin = entry.yMin;
            if (entry.yMax > _yMax) _yMax = entry.yMax;
         }
         for each (var loc: LocationMinimal in _solarSystemLocations) {
            updateBounds(loc);
         }
         for each (var unit:Unit in _units.toArray()) {
            updateBounds(unit.location);
         }
         
         // support for empty galaxy map here
         if (_fowEntries.length == 0 && _solarSystemLocations.length == 0 && _units.length == 0) {
            _xMin = _yMax = _xMax = _yMin = 0;
         }
         
         // additional rows and columns as edges of the FOW matrix and map to avoid checking map
         // boundaries in the components.maps.space.FOWRenderer
         _xMin -= INVISIBLE_BORDER_SIZE; _xMax += INVISIBLE_BORDER_SIZE;
         _yMin -= INVISIBLE_BORDER_SIZE; _yMax += INVISIBLE_BORDER_SIZE;
      }

      private function updateBounds(loc: LocationMinimal): void {
         if (loc.x < _xMin) _xMin = loc.x;
         if (loc.x > _xMax) _xMax = loc.x;
         if (loc.y < _yMin) _yMin = loc.y;
         if (loc.y > _yMax) _yMax = loc.y;
      }

      /**
       * O(width * height)
       */
      private function initializeMatrix() : void {
         var bounds:MapArea = getBounds();
         _matrix = new Vector.<Vector.<Boolean>>(bounds.width, true);
         for (var x:int = 0; x < bounds.width; x++) {
            _matrix[x] = new Vector.<Boolean>(bounds.height, true);
         }
      }
      
      /**
       * O(_fowEntries.length)
       */
      private function setVisibleTiles() : void {
         var offset:Point = getCoordsOffset();
         for each (var entry:MapArea in _fowEntries) {
            for (var x:int = entry.xMin + offset.x; x <= entry.xMax + offset.x; x++) {
               for (var y:int = entry.yMin + offset.y; y <= entry.yMax + offset.y; y++) {
                  _matrix[x][y] = true;
               }
            }
         }
      }

      /**
       * O(width * height)
       */
      private function buildFowBorderList(): void {
         _fowBorderList = new Vector.<FOWBorderElement>();
         var bounds: MapArea = getBounds();
         var matrix: Vector.<Vector.<Boolean>> = _matrix;
         // since we added two additional rows and columns in the edges of the matrix, we work with
         // the inner rectangle. Without those additional columns
         // and rows we would have to run boundary checks in each iteration
         for (var x:int = bounds.xMin + 1; x <= bounds.xMax - 1; x++)
         {
            var xx:int = x + _offset.x;
            for (var y:int = bounds.yMin + 1; y <= bounds.yMax - 1; y++)
            {
               var yy:int = y + _offset.y;
               if (!matrix[xx][yy] && (matrix[xx - 1][yy] || matrix[xx + 1][yy] ||
                  matrix[xx][yy - 1] || matrix[xx][yy + 1]))
               {
                  _fowBorderList.push(new FOWBorderElement(
                     new LocationMinimal(LocationType.GALAXY, _galaxyId, x, y),
                     matrix[xx - 1][yy], matrix[xx + 1][yy],
                     matrix[xx][yy + 1], matrix[xx][yy - 1]
                  ));
               }
            }
         }
      }

      public function getFowEntries(): Vector.<MapArea> {
         return _fowEntries;
      }

      private var _offset:Point;
      public function getCoordsOffset() : Point {
         if (!_offset) {
            _offset = new Point(-_xMin, -_yMin);
         }
         return _offset;
      }

      private var _bounds:MapArea;
      public function getBounds() : MapArea {
         if (_bounds == null) {
            _bounds = new MapArea(_xMin, _xMax, _yMin, _yMax);
         }
         return _bounds;
      }
      
      private var _visibleBounds:MapArea;
      public function getVisibleBounds() : MapArea {
         if (_visibleBounds == null) {
            _visibleBounds = new MapArea(
               _xMin + INVISIBLE_BORDER_SIZE, _xMax - INVISIBLE_BORDER_SIZE,
               _yMin + INVISIBLE_BORDER_SIZE, _yMax - INVISIBLE_BORDER_SIZE
            );
         }
         return _visibleBounds;
      }
      
      public function locationIsVisible(x: int, y: int): Boolean {
         return _matrix[x][y];
      }
      
      public function get matrixHasVisibleTiles() : Boolean {
         return _matrix.some(
            function(row:Vector.<Boolean>, index:*, matrix:*) : Boolean {
               return row.some(
                  function(tile:Boolean, index:*, row:*) : Boolean {
                     return tile;
                  }
               );
            }
         );
      }

      public function getFOWBorderList(): Vector.<FOWBorderElement> {
         return _fowBorderList;
      }
   }
}