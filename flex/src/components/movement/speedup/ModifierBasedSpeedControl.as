package components.movement.speedup
{
   import components.movement.speedup.events.SpeedControlEvent;

   import flash.events.EventDispatcher;

   import models.time.IMTimeEvent;
   import models.time.MTimeEventFixedInterval;

   import utils.Events;

   import utils.Objects;
   import utils.locale.Localizer;


   [Event(
      name="speedModifierChange",
      type="components.movement.speedup.events.SpeedControlEvent")]

   [Event(
         name="arrivalEventChange",
         type="components.movement.speedup.events.SpeedControlEvent")]

   public class ModifierBasedSpeedControl extends EventDispatcher implements ISpeedControl
   {
      private var _baseValues: BaseTripValues;
      private var _speedupValues: SpeedupValues;

      public function ModifierBasedSpeedControl(baseValues: BaseTripValues,
                                                speedupValues: SpeedupValues) {
         _baseValues = Objects.paramNotNull("baseValues", baseValues);
         _speedupValues = Objects.paramNotNull("speedupValues", speedupValues);
         _speedupValues.addEventListener(
            SpeedControlEvent.SPEED_MODIFIER_CHANGE,
            speedupValues_speedModifierChangeHandler, false, 0, true
         );
         recalculateActualTripTime();
      }

      private function speedupValues_speedModifierChangeHandler(event: SpeedControlEvent): void {
         recalculateActualTripTime();
         dispatchArrivalTimeChangeEvent();
         dispatchSpeedControlEvent(SpeedControlEvent.SPEED_MODIFIER_CHANGE);
      }

      public function get speedModifierMin(): Number {
         return _speedupValues.speedModifierMin;
      }

      public function get speedModifierMax(): Number {
         return _speedupValues.speedModifierMax;
      }

      [Bindable(event="speedModifierChange")]
      public function set speedModifier(value: Number): void {
         _speedupValues.speedModifier = value;
      }
      public function get speedModifier(): Number {
         return _speedupValues.speedModifier;
      }

      [Bindable(event="arrivalTimeChange")]
      public function get label_arrivesAt(): String {
         return Localizer.string(
            "Movement", "speedup.label.arrivesAt", [arrivalEvent.occursAtString(true)]
         );
      }


      /* ##################### */
      /* ### ISpeedControl ### */
      /* ##################### */

      private const _arrivalEvent: MTimeEventFixedInterval
                       = new MTimeEventFixedInterval();
      public function get arrivalEvent(): IMTimeEvent {
         return _arrivalEvent;
      }

      private function recalculateActualTripTime(): void {
         _arrivalEvent.occursIn = _baseValues.tripTime * speedModifier;
      }

      public function reset(): void {
         _speedupValues.reset();
      }

      [Bindable(event="speedModifierChange")]
      public function get speedupCost(): int {
         return _speedupValues.cost;
      }


      /* ################## */
      /* ### IUpdatable ### */
      /* ################## */

      public function update(): void {
         _arrivalEvent.update();
         dispatchArrivalTimeChangeEvent();
      }

      public function resetChangeFlags(): void {
         _arrivalEvent.resetChangeFlags();
      }


      /* ############### */
      /* ### HELPERS ### */
      /* ############### */

      private function dispatchArrivalTimeChangeEvent(): void {
         dispatchSpeedControlEvent(SpeedControlEvent.ARRIVAL_TIME_CHANGE);
      }

      private function dispatchSpeedControlEvent(type: String): void {
         Events.dispatchSimpleEvent(this, SpeedControlEvent, type);
      }
   }
}
