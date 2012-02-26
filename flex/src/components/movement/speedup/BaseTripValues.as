package components.movement.speedup
{
   import utils.Objects;


   public class BaseTripValues
   {
      /**
       * @param tripTime time in seconds | <b>&gt; 0</b>
       * @param hopCount number of hops | <b>&gt; 0</b>
       */
      public function BaseTripValues(tripTime: Number, hopCount: int) {
         _tripTime = Objects.paramPositiveNumber("tripTime", tripTime, false);
         _hopCount = Objects.paramPositiveNumber("hopCount", hopCount, false);
      }

      private var _tripTime: int;
      public function get tripTime(): Number {
         return _tripTime;
      }

      private var _hopCount: int;
      public function get hopCount(): int {
         return _hopCount;
      }
   }
}
