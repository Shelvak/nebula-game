package components.movement.speedup
{
   import config.Config;

   import models.unit.Unit;

   import utils.Objects;


   public class SpeedupValues
   {
      private var _baseValues: BaseTripValues;

      public function SpeedupValues(baseValues: BaseTripValues) {
         _baseValues = Objects.paramNotNull("baseValues", baseValues);
      }

      public function get cost(): int {
         return speedModifier < 1
                   ? Unit.getMovementSpeedUpCredsCost
                        (1.0 - speedModifier, _baseValues.hopCount)
                   : 0;
      }

      private var _speedModifier: Number = 1;
      public function set speedModifier(value: Number): void {
         if (_speedModifier != value) {
            if (value < speedModifierMin) {
               value = speedModifierMin;
            }
            else if (value > speedModifierMax) {
               value = speedModifierMax;
            }
            _speedModifier = value;
         }
      }
      public function get speedModifier(): Number {
         return _speedModifier;
      }

      public function get speedModifierMin(): Number {
         return Config.getMinMovementSpeedModifier();
      }

      public function get speedModifierMax(): Number {
         return Config.getMaxMovementSpeedModifier();
      }

      public function reset() {
         speedModifier = 1;
      }
   }
}
