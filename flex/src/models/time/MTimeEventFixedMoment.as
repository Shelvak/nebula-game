package models.time
{
   import models.time.events.MTimeEventEvent;

   import namespaces.change_flag;

   import utils.DateUtil;
   import utils.Objects;


   [Event(name="occurredBeforeChange", type="models.time.events.MTimeEventEvent")]

   /**
    * Marks a fixed moment in time.
    * 
    * <p>You set <code>occursAt</code> to some <code>Date</code>
    * (<code>null</code> is not allowed) and this values remains the same
    * until you set it again. Meanwhile <code>occursIn</code> and
    * <code>occurredBefore</code> is updated when time advances.
    */
   public class MTimeEventFixedMoment extends MTimeEvent
   {
      /**
       * Type processor function for <code>Objects</code>.
       */
      public static function autoCreate(currValue: MTimeEventFixedMoment,
                                        value: String): MTimeEventFixedMoment {
         var event: MTimeEventFixedMoment = null;
         event = currValue != null ? currValue : new MTimeEventFixedMoment();
         event.occursAt = DateUtil.parseServerDTF(value);
         return event;
      }
      
      
      /* ################### */
      /* ### IMTimeEvent ### */
      /* ################### */

      [Bindable(event="occursInChange")]
      public override function get occursIn(): Number {
         var diff: Number = _occursAt.time - DateUtil.now;
         return diff < 0 ? 0 : Math.floor(diff / 1000);
      }

      private var _occursAt: Date = new Date(0);
      [Bindable(event="occursAtChange")]
      /**
       * A fixed moment in time.  This property does not change over time but
       * <code>occursIn</code> and <code>hasOccurred</code> does. You can't set
       * this property to <code>null</code>: error will be thrown.
       * 
       * @see #occursIn
       * @see #hasOccurred
       */
      public function set occursAt(value: Date): void {
         Objects.paramNotNull("value", value);
         if (_occursAt != value) {
            _occursAt = value;
            occursAtUpdated();
            occursInUpdated();
            hasOccurredUpdated();
            occurredBeforeUpdated();
            _hasOccurredDispatched = false;
         }
      }
      public override function get occursAt(): Date {
         return _occursAt;
      }
      
      
      [Bindable(event="hasOccurredChange")]
      public override function get hasOccurred(): Boolean {
         return _occursAt.time <= DateUtil.now;
      }

      change_flag var occurredBefore: Boolean = true;
      /**
       * Number of seconds the event has occurred before or 0 if event has not
       * yet occurred.
       */
      [Bindable(event="occurredBeforeChange")]
      public function get occurredBefore(): Number {
         var diff: Number = DateUtil.now - _occursAt.time;
         return diff < 0 ? 0 : Math.floor(diff / 1000);
      }

      [Bindable(event="occurredBeforeChange")]
      public function occurredBeforeString(timeParts: int = 2): String {
         return DateUtil.secondsToHumanString(occurredBefore, timeParts);
      }
      
      
      /* ###################### */
      /* ### IMSelfUpdating ### */
      /* ###################### */


      private var _hasOccurredDispatched: Boolean = false;

      public override function update(): void {
         if (!hasOccurred) {
            occursInUpdated();
         }
         if (!_hasOccurredDispatched && hasOccurred) {
            _hasOccurredDispatched = true;
            hasOccurredUpdated();
            occursInUpdated();
         }
         if (_occursAt.time <= DateUtil.now) {
            occurredBeforeUpdated();
         }
      }

      public override function resetChangeFlags(): void {
         super.resetChangeFlags();
         change_flag::occurredBefore = false;
      }


      /* ############### */
      /* ### HELPERS ### */
      /* ############### */

      private function occurredBeforeUpdated(): void {
         change_flag::occurredBefore = true;
         dispatchSimpleEvent(
            MTimeEventEvent,
            MTimeEventEvent.OCCURRED_BEFORE_CHANGE
         );
      }
   }
}