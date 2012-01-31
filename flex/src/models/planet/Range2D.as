package models.planet
{
   public class Range2D
   {
      public function Range2D(x: int, xEnd: int, y: int, yEnd: int) {
         _x = x; _xEnd = xEnd;
         _y = y; _yEnd = yEnd;
      }

      private var _x: int;
      public function get x(): int {
         return _x;
      }

      private var _xEnd: int;
      public function get xEnd(): int {
         return _xEnd;
      }

      private var _y: int;
      public function get y(): int {
         return _y;
      }

      private var _yEnd: int;
      public function get yEnd(): int {
         return _yEnd;
      }
   }
}
