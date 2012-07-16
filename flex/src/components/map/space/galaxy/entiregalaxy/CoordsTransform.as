package components.map.space.galaxy.entiregalaxy
{
   import components.map.BaseMapCoordsTransform;

   import flash.geom.Point;


   public class CoordsTransform extends BaseMapCoordsTransform
   {
      private static const SECTOR_SIZE: int = EntireGalaxyRenderer.SECTOR_SIZE;
      private static const GAP_SIZE: int = EntireGalaxyRenderer.GAP_SIZE;

      private var _offset: Point;

      public function CoordsTransform(coordsOffset: Point) {
         super();
         _offset = coordsOffset;
      }

      override public function get realWidth(): Number {
         return realCoord(logicalWidth);
      }

      override public function get realHeight(): Number {
         return realCoord(logicalHeight);
      }

      /**
       * Return x coordinate of a top-left pixel of a sector.
       *
       * @param logicalY not used
       */
      override public function logicalToReal_X(logicalX: int, logicalY: int): Number {
         return realCoord(logicalX + _offset.x);
      }

      /**
       * Return y coordinate of a top-left pixel of a sector.
       *
       * @param logicalX not used
       */
      override public function logicalToReal_Y(logicalX: int, logicalY: int): Number {
         return realHeight - realCoord(logicalY + _offset.y);
      }

      private function realCoord(logicalCoord: int): Number {
         return logicalCoord * (SECTOR_SIZE + GAP_SIZE) + GAP_SIZE;
      }

      /**
       * @param realY not used
       */
      override public function realToLogical_X(realX: Number, realY: Number): int {
         return int ((realX - GAP_SIZE / 2) / (SECTOR_SIZE + GAP_SIZE)) - _offset.x;
      }

      /**
       * @param realX not used
       */
      override public function realToLogical_Y(realX: Number, realY: Number): int {
         return int ((realHeight - realY + GAP_SIZE / 2) / (SECTOR_SIZE + GAP_SIZE)) - _offset.y;
      }
   }
}
