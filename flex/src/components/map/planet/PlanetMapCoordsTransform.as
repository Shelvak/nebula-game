package components.map.planet
{
   import components.map.IMapCoordsTransform;
   
   import flash.geom.Point;
   
   import models.tile.Tile;
   
   public class PlanetMapCoordsTransform implements IMapCoordsTransform
   {
      /**
       * @param logicalWidth logical width of a planet map
       * @param logicalHeight logical height of a planet map
       * @param borderSize width of a border around the actual planet map (number of tiles)
       */
      public function PlanetMapCoordsTransform(logicalWidth:int = 0,
                                               logicalHeight:int = 0,
                                               borderSize:int = 0)
      {
         super();
         _logicalWidth  = logicalWidth;
         _logicalHeight = logicalHeight;
         _borderSize = borderSize;
      }
      
      
      private var _borderSize:int = 0;
      /**
       * Width of a border (number of tiles) around the actual planet map. Positive integer, including 0.
       */
      public function set borderSize(value:int) : void
      {
         if (value < 0)
         {
            throw new ArgumentError("Positive integer expected: was " + value);
         }
         _borderSize = value;
      }
      /**
       * @private
       */
      public function get borderSize() : int
      {
         return _borderSize;
      }
      
      
      private var _logicalWidth:int = 0;
      public function set logicalWidth(value:int) : void
      {
         _logicalWidth = value;
      }
      public function get logicalWidth():int
      {
         return _logicalWidth;
      }
      
      
      /**
       * Logical width of a planet map including borders.
       */
      public function get logicalWidthWithBorders() : int
      {
         return _logicalWidth + _borderSize * 2;
      }
      
      
      private var _logicalHeight:int = 0;
      public function set logicalHeight(value:int) : void
      {
         _logicalHeight = value;
      }
      public function get logicalHeight() : int
      {
         return _logicalHeight;
      }
      
      
      /**
       * Logical height of a planet map including borders.
       */
      public function get logicalHeightWithBorders() : int
      {
         return _logicalHeight + _borderSize * 2;
      }
      
      
      public function get realWidth() : Number
      {
         return getRealSideLength(Tile.IMAGE_WIDTH) + extraWidthPixels;;
      }
      
      
      public function get realHeight() : Number
      {
         return getRealSideLength(Tile.IMAGE_HEIGHT);
      }
      
      
      /**
       * Calculates real length of one map side.
       */ 
      private function getRealSideLength(tileDimension:Number) : Number
      {
         return (logicalHeightWithBorders + logicalWidthWithBorders) * tileDimension / 2;
      }
      
      
      public function logicalToReal(logical:Point) : Point
      {
         return new Point(
            logicalToReal_X(logical.x, logical.y),
            logicalToReal_Y(logical.x, logical.y)
         );
      }
      
      
      /**
       * <p>Returns X coordinate of top-left corner of a tile at the given logical coordinates.</p>
       * 
       * @inheritDoc
       */
      public function logicalToReal_X(logicalX:int, logicalY:int) : Number
      {
         logicalX += _borderSize;
         logicalY += _borderSize;
         return (extraYPixels + logicalX - logicalY) * Tile.IMAGE_WIDTH / 2 + logicalX - logicalY + extraYPixels;
      }
      
      
      /**
       * <p>Returns Y coordinate of top-left corner of a tile at the given logical coordinates.</p>
       * 
       * @inheritDoc
       */
      public function logicalToReal_Y(logicalX:int, logicalY:int) : Number
      {
         logicalX += _borderSize;
         logicalY += _borderSize;
         return (logicalHeightWithBorders + logicalWidthWithBorders - logicalX - logicalY - 2)
                * Tile.IMAGE_HEIGHT / 2;
      }
      
      
      /**
       * Calculates and returns logical tile coordinates under the given point.
       *  
       * @param realX Actual x coordinate of a point (in pixels)
       * @param realY Actual y coordinate of a point (in pixels)
       * @param nullForNoTile if <code>false</code>, will return corrdinates of a tile even if
       * given real coordinates are not within bounds of a map
       * 
       * @return Instance of <code>Point</code> where <code>x</code> is a logical x and <code>y</code> is a
       * logical y of a tile under the given point or <code>null</code> if there is no tile under the point
       * (unless <code>nullForNoTile</code> is <code>false</code>). 
       */      
      public function realToLogicalTileCoords(realX:Number, realY:Number, nullForNoTile:Boolean = true) : Point
      {
         var x:int = realToLogical_X(realX, realY);
         var y:int = realToLogical_Y(realX, realY);
         if (nullForNoTile && (x < 0 || y < 0 || x > logicalWidth - 1 || y > logicalHeight - 1))
         {
            return null;
         }
         return new Point(x, y);
      }
      
      
      public function realToLogical(real:Point) : Point
      {
         return new Point(
            realToLogical_X(real.x, real.y),
            realToLogical_Y(real.x, real.y)
         );
      }
      
      
      public function realToLogical_X(realX:Number, realY:Number) : int
      {
         realX = recalculateRealX(realX);
         realY = recalculateRealY(realY);
         return Math.floor((realY - Math.floor((1 - realX) / 2)) / Tile.IMAGE_HEIGHT) - _borderSize;;
      }
      
      
      public function realToLogical_Y(realX:Number, realY:Number) : int
      {
         realX = recalculateRealX(realX);
         realY = recalculateRealY(realY);
         return Math.floor((realY - Math.floor(realX / 2)) / Tile.IMAGE_HEIGHT) - _borderSize;;
      }
      
      
      private function recalculateRealX(realX:Number) : Number
      {
         return realX - logicalHeightWithBorders * Tile.IMAGE_WIDTH / 2 - extraYPixels;
      }
      
      
      private function recalculateRealY(realY:Number) : Number
      {
         return realHeight - realY;
      }
      
      
      private function get extraXPixels() : int
      {
         return logicalWidthWithBorders - 1;
      }
      
      
      private function get extraYPixels() : int
      {
         return logicalHeightWithBorders - 1;
      }
      
      
      private function get extraWidthPixels() : int
      {
         return extraYPixels + extraXPixels;
      }
   }
}