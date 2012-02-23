package components.movement.speedup
{
   public class BaseTripValues
   {
      public function BaseTripValues(tripTime: int, hopCount: int) {
         _tripTime = tripTime;
         _hopCount = hopCount;
      }

      private var _tripTime: int;
      public function get tripTime(): int {
         return _tripTime;
      }

      private var _hopCount: int;
      public function get hopCount(): int {
         return _hopCount;
      }
   }
}
