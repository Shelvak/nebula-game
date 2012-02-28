package components.movement.speedup
{
   import components.movement.speedup.events.SpeedControlEvent;

   import flash.events.EventDispatcher;

   import models.time.IMTimeEvent;
   import models.time.MTimeEventFixedInterval;
   import models.time.MTimeEventFixedMoment;

   import utils.DateUtil;
   import utils.Events;
   import utils.Objects;
   import utils.locale.Localizer;


   [Event(
      name="speedModifierChange",
      type="components.movement.speedup.events.SpeedControlEvent")]

   [Event(
      name="arrivalTimeChange",
      type="components.movement.speedup.events.SpeedControlEvent"
      )]

   public class TimeBasedSpeedControl extends EventDispatcher implements ISpeedControl
   {
      public const YEAR_MIN: int = 2000;
      public const YEAR_MAX: int = 2999;
      public const MONTH_MIN: int = 1;
      public const MONTH_MAX: int = 12;
      public const DAY_MIN: int = 1;
      public const DAY_MAX: int = 31;
      public const HOURS_MIN: int = 0;
      public const HOURS_MAX: int = 23;
      public const MINUTES_MIN: int = 0;
      public const MINUTES_MAX: int = 59;
      public const SECONDS_MIN: int = 0;
      public const SECONDS_MAX: int = 59;

      private var _baseValues: BaseTripValues;
      private var _speedupValues: SpeedupValues;

      public function TimeBasedSpeedControl(baseValues: BaseTripValues,
                                            speedupValues: SpeedupValues) {
         _baseValues = Objects.paramNotNull("baseValues", baseValues);
         _speedupValues = Objects.paramNotNull("speedupValues", speedupValues);
         _speedupValues.addEventListener(
            SpeedControlEvent.SPEED_MODIFIER_CHANGE,
            speedupValues_speedModifierChange, false, 0, true
         );
         recalculateTripTime();
      }

      private function speedupValues_speedModifierChange(event: SpeedControlEvent): void {
         dispatchSpeedControlEvent (SpeedControlEvent.SPEED_MODIFIER_CHANGE);
         recalculateTripTime();
      }

      private const _arrivalEventFixedInterval: MTimeEventFixedInterval =
                       new MTimeEventFixedInterval();
      private function recalculateTripTime(): void {
         _arrivalEventFixedInterval.occuresIn =
            _baseValues.tripTime * speedModifier;
         const oldDate: Date = _arrivalEvent.occuresAt;
         oldDate.milliseconds = 0;
         const newDate: Date = _arrivalEventFixedInterval.occuresAt;
         newDate.milliseconds = 0;
         if (oldDate.time != newDate.time) {
            _arrivalEvent.occuresAt = newDate;
            dispatchSpeedControlEvent(SpeedControlEvent.ARRIVAL_TIME_CHANGE);
         }
      }

      [Bindable(event="speedModifierChange")]
      public function set speedModifier(value: Number): void {
         _speedupValues.speedModifier = value;
      }
      public function get speedModifier(): Number {
         return _speedupValues.speedModifier;
      }

      private function setSpeedModifier(newTripTime: Number): void {
         if (newTripTime < 1) {
            newTripTime = 1;
         }
         speedModifier = newTripTime / _baseValues.tripTime;
      }

      private function recalculateModifier(newArrivalDate: Date): void {
         const newTripTime: Number = (newArrivalDate.time - DateUtil.now) / 1000;
         setSpeedModifier(newTripTime);
      }

      private function timeAdvanced(): void {
         const tripTime: Number = Math.floor(arrivalDate.time / 1000)
                                     - Math.floor(DateUtil.now / 1000);
         const oldSpeedModifier: Number = speedModifier;
         setSpeedModifier(tripTime);
         // SpeedupValues does not dispatch any events if speed modifier does
         // not change.
         if (oldSpeedModifier == speedModifier) {
            recalculateTripTime();
         }
      }

      private function cloneArrivalDate(): Date {
         return new Date(arrivalDate.time);
      }

      private function get arrivalDate(): Date {
         return _arrivalEvent.occuresAt;
      }

      [Bindable(event="arrivalTimeChange")]
      public function set arrivalYear(value: int): void {
         timePartParamInRange(YEAR_MIN, YEAR_MAX, value);
         const date: Date = cloneArrivalDate();
         date.fullYear = value;
         recalculateModifier(date);
      }
      public function get arrivalYear(): int {
         return arrivalDate.fullYear;
      }

      [Bindable(event="arrivalTimeChange")]
      public function set arrivalMonth(value: int): void {
         timePartParamInRange(MONTH_MIN, MONTH_MAX, value);
         const date: Date = cloneArrivalDate();
         date.month = value - 1;
         recalculateModifier(date);
      }
      public function get arrivalMonth(): int {
         return arrivalDate.month + 1;
      }

      [Bindable(event="arrivalTimeChange")]
      public function set arrivalDay(value: int): void {
         timePartParamInRange(DAY_MIN, DAY_MAX, value);
         const date: Date = cloneArrivalDate();
         date.date = value;
         recalculateModifier(date);
      }
      public function get arrivalDay(): int {
         return arrivalDate.date;
      }

      [Bindable(event="arrivalTimeChange")]
      public function set arrivalHours(value: int): void {
         timePartParamInRange(HOURS_MIN, HOURS_MAX, value);
         const date: Date = cloneArrivalDate();
         date.hours = value;
         recalculateModifier(date);
      }
      public function get arrivalHours(): int {
         return arrivalDate.hours;
      }

      [Bindable(event="arrivalTimeChange")]
      public function set arrivalMinutes(value: int): void {
         timePartParamInRange(MINUTES_MIN, MINUTES_MAX, value);
         const date: Date = cloneArrivalDate();
         date.minutes = value;
         recalculateModifier(date);
      }
      public function get arrivalMinutes(): int {
         return arrivalDate.minutes;
      }

      [Bindable(event="arrivalTimeChange")]
      public function set arrivalSeconds(value: int): void {
         timePartParamInRange(SECONDS_MIN, SECONDS_MAX, value);
         const date: Date = cloneArrivalDate();
         date.seconds = value;
         recalculateModifier(date);
      }
      public function get arrivalSeconds(): int {
         return arrivalDate.seconds;
      }

      [Bindable(event="speedModifierChange")]
      public function get label_speedModifier(): String {
         return Localizer.string(
            "Movement", "speedup.label.speedupValue",
            [(speedModifier * 100).toFixed(1)]
         );
      }


      /* ##################### */
      /* ### ISpeedControl ### */
      /* ##################### */

      private const _arrivalEvent: MTimeEventFixedMoment =
                       new MTimeEventFixedMoment();
      public function get arrivalEvent(): IMTimeEvent {
         return _arrivalEvent;
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
         timeAdvanced();
      }

      public function resetChangeFlags(): void {
         _arrivalEvent.resetChangeFlags();
      }


      /* ############### */
      /* ### HELPERS ### */
      /* ############### */

      private function dispatchSpeedControlEvent(type: String): void {
         Events.dispatchSimpleEvent(this, SpeedControlEvent, type);
      }

      private static function timePartParamInRange(low: int,
                                                   hight: int,
                                                   value: int): void {
         Objects.paramInRangeNumbers("value", low, hight, value, true, true);
      }
   }
}
