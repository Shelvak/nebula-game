package models.galaxy
{
   import flash.geom.Point;
   
   import models.location.LocationMinimal;
   import models.map.MapArea;
   import models.solarsystem.MSolarSystem;
   import models.unit.Unit;
   
   import mx.collections.IList;

   internal class FOWMatrixBuilder
   {
      private static const INVISIBLE_BORDER_SIZE:int = 2;
      
      private var _fowEntries:Vector.<MapArea>,
                  _solarSystems:IList,
                  _units:IList,
                  _matrix:Vector.<Vector.<Boolean>>,
                  _xMin:int,
                  _xMax:int,
                  _yMax:int,
                  _yMin:int;
      
      
      public function FOWMatrixBuilder(fowEntries:Vector.<MapArea>, solarSystems:IList, units:IList) {
         _fowEntries = fowEntries;
         _solarSystems = solarSystems;
         _units = units;
         build();
      }
      
      
      private function build() : void {
         findBounds();
         initializeMatrix();
         setVisibleTiles();
      }
      
      
      /**
       * O(_fowEntries.length + _solarSystems.length)
       */
      private function findBounds() : void
      {
         _xMin = _yMin = int.MAX_VALUE;
         _xMax = _yMax = int.MIN_VALUE;
         for each (var entry:MapArea in _fowEntries) {
            if (entry.xMin < _xMin) _xMin = entry.xMin;
            if (entry.xMax > _xMax) _xMax = entry.xMax;
            if (entry.yMin < _yMin) _yMin = entry.yMin;
            if (entry.yMax > _yMax) _yMax = entry.yMax;
         }
         for each (var ss:MSolarSystem in _solarSystems.toArray()) {
            updateBounds(ss.currentLocation);
         }
         for each (var unit:Unit in _units.toArray()) {
            updateBounds(unit.location);
         }
         
         // support for empty galaxy map here
         if (_fowEntries.length == 0 && _solarSystems.length == 0 && _units.length == 0) {
            _xMin = _yMax = _xMax = _yMin = 0;
         }
         
         // additional rows and columns as edges of the FOW matrix and map to avoid checking map
         // boundaries in the components.maps.space.FOWRenderer
         _xMin -= INVISIBLE_BORDER_SIZE; _xMax += INVISIBLE_BORDER_SIZE; 
         _yMin -= INVISIBLE_BORDER_SIZE; _yMax += INVISIBLE_BORDER_SIZE;
      }
      
      
      private function updateBounds(loc:LocationMinimal) : void {
         if (loc.x < _xMin) _xMin = loc.x;
         if (loc.x > _xMax) _xMax = loc.x;
         if (loc.y < _yMin) _yMin = loc.y;
         if (loc.y > _yMax) _yMax = loc.y;
      }
      
      
      /**
       * O(width * height)
       */
      private function initializeMatrix() : void
      {
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
      
      public function getMatrix() : Vector.<Vector.<Boolean>> {
         return _matrix;
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
   }
}