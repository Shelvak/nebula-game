package components.movement.speedup
{
   import components.movement.speedup.events.SpeedControlEvent;

   import config.Config;

   import flash.events.EventDispatcher;

   import models.unit.Unit;

   import utils.Events;
   import utils.Objects;


   [Event(
      name="speedModifierChange",
      type="components.movement.speedup.events.SpeedControlEvent")]

   public class SpeedupValues extends EventDispatcher
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
      [Bindable(event="speedModifierChange")]
      public function set speedModifier(value: Number): void {
         if (value < speedModifierMin) {
            value = speedModifierMin;
         }
         else if (value > speedModifierMax) {
            value = speedModifierMax;
         }
         if (_speedModifier != value) {
            _speedModifier = value;
            Events.dispatchSimpleEvent(
               this, SpeedControlEvent, SpeedControlEvent.SPEED_MODIFIER_CHANGE
            );
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

      public function reset(): void {
         speedModifier = 1;
      }
   }
}
