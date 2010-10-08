package models.galaxy
{
   import flash.geom.Point;
   import flash.geom.Rectangle;

   internal class FOWMatrixBuilder
   {
      private var _fowEntries:Vector.<Rectangle>,
                  _matrix:Vector.<Vector.<Boolean>>,
                  _left:int,
                  _right:int,
                  _top:int,
                  _bottom:int;
      
      
      public function FOWMatrixBuilder(fowEntries:Vector.<Rectangle>)
      {
         _fowEntries = fowEntries;
         build();
      }
      
      
      private function build() : void
      {
         findBounds();
         initializeMatrix();
         setVisibleTiles();
      }
      
      
      /**
       * O(_fowEntries.length)
       */
      private function findBounds() : void
      {
         _left = _top = int.MAX_VALUE;
         _right = _bottom = int.MIN_VALUE;
         for each (var entry:Rectangle in _fowEntries)
         {
            if (entry.left   < _left)   _left   = entry.left;
            if (entry.top    < _top)    _top    = entry.top;
            if (entry.right  > _right)  _right  = entry.right;
            if (entry.bottom > _bottom) _bottom = entry.bottom;
         }
         
         // additional rows and columns as edges of the FOW matrix and map to avoid checking map
         // boundaries in the components.maps.space.FOWRenderer
         _left -= 2; _top -= 2;
         _right += 2; _bottom += 2;
      }
      
      
      /**
       * O(width * height)
       */
      private function initializeMatrix() : void
      {
         var bounds:Rectangle = getBounds();
         _matrix = new Vector.<Vector.<Boolean>>(bounds.width, true);
         for (var x:int = 0; x < bounds.width; x++)
         {
            _matrix[x] = new Vector.<Boolean>(bounds.height, true);
         }
      }
      
      
      /**
       * O(_fowEntries.length)
       */
      private function setVisibleTiles() : void
      {
         var offset:Point = getCoordsOffset();
         for each (var entry:Rectangle in _fowEntries)
         {
            for (var x:int = entry.left + offset.x; x < entry.right + offset.x; x++)
            {
               for (var y:int = entry.top + offset.y; y < entry.bottom + offset.y; y++)
               {
                  _matrix[x][y] = true;
               }
            }
         }
      }
      
      
      private var _offset:Point;
      public function getCoordsOffset() : Point
      {
         if (!_offset)
         {
            _offset = new Point(-_left, -_top);
         }
         return _offset;
      }
      
      
      private var _bounds:Rectangle;
      public function getBounds() : Rectangle
      {
         if (!_bounds)
         {
            _bounds = new Rectangle(_left, _top, _right - _left, _bottom - _top);
         }
         return _bounds;
      }
      
      
      public function getMatrix() : Vector.<Vector.<Boolean>>
      {
         return _matrix;
      }
   }
}